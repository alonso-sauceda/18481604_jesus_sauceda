# Actividad 7: Cambios de privilegios: el límite más importante

## Evidencia ejecutada (Sesión DBA)

### 1. Toma de instantánea inicial de privilegios
```text
comercial> db.getSiblingDB("auditoria").instantaneas_privilegios.insertOne({ momento: new Date(), tomada_por: db.runCommand({ connectionStatus: 1 }).authInfo.authenticatedUsers, usuarios: db.getUsers().users.map(u => ({ user: u.user, db: u.db, roles: u.roles })) })
{
  acknowledged: true,
  insertedId: ObjectId('6af777b46bbc9afa44f4589b')
}
```

### 2. Otorgamiento de rol adicional y búsqueda en perfilador y bitácora
```text
comercial> db.setProfilingLevel(2)
{
  was: 1,
  slowms: 100,
  sampleRate: 1,
  filter: { op: { '$in': [ 'insert', 'remove', 'update' ] } },
  note: 'When a filter expression is set, slowms and sampleRate are not used for profiling and slow-query log lines.',
  ok: 1
}

comercial> db.grantRolesToUser("app_ventas", [{ role: "dbAdmin", db: "comercial" }])
{ ok: 1 }

comercial> db.system.profile.countDocuments({ "command.grantRolesToUser": { $exists: true } })
0

comercial> bitacora().filter(e => JSON.stringify(e).includes("grantRoles")).length
0
```

### 3. Segunda instantánea, comparación y revocación del rol
```text
comercial> db.getSiblingDB("auditoria").instantaneas_privilegios.insertOne({ momento: new Date(), tomada_por: db.runCommand({ connectionStatus: 1 }).authInfo.authenticatedUsers, usuarios: db.getUsers().users.map(u => ({ user: u.user, db: u.db, roles: u.roles })) })
{
  acknowledged: true,
  insertedId: ObjectId('6af7781d6bbc9afa44f4589c')
}

comercial> db.getSiblingDB("auditoria").instantaneas_privilegios.find({}, { _id: 0 }).sort({ momento: 1 })
[
  {
    momento: ISODate('2026-11-13T20:48:52.487Z'),
    tomada_por: [ { user: 'admin', db: 'admin' } ],
    usuarios: [
      {
        user: 'app_ventas',
        db: 'comercial',
        roles: [ { role: 'readWrite', db: 'comercial' } ]
      }
    ]
  },
  {
    momento: ISODate('2026-11-13T20:50:37.720Z'),
    tomada_por: [ { user: 'admin', db: 'admin' } ],
    usuarios: [
      {
        user: 'app_ventas',
        db: 'comercial',
        roles: [
          { role: 'readWrite', db: 'comercial' },
          { role: 'dbAdmin', db: 'comercial' }
        ]
      }
    ]
  }
]

comercial> db.revokeRolesFromUser("app_ventas", [{ role: "dbAdmin", db: "comercial" }])
{ ok: 1 }

comercial> db.setProfilingLevel(1, { filter: { op: { $in: ["insert", "update", "remove"] } } })
{
  was: 2,
  slowms: 100,
  sampleRate: 1,
  filter: { op: { '$in': [ 'insert', 'remove', 'update' ] } },
  note: 'When a filter expression is set, slowms and sampleRate are not used for profiling and slow-query log lines.',
  ok: 1
}
```

## Evaluación de alcance del control compensatorio

| Pregunta | ¿La instantánea responde? | Explicación |
|---|---|---|
| ¿Cambiaron los privilegios de `app_ventas`? | **Sí** | Al comparar ambas instantáneas se detecta una modificación en el arreglo `roles`. |
| ¿Qué rol se agregó? | **Sí** | Se identifica la adición de `{ role: 'dbAdmin', db: 'comercial' }`. |
| ¿Quién lo agregó? | **No** | **No hay evidencia con esta edición.** La instantánea captura el estado de los permisos, no el usuario que ejecutó `grantRolesToUser`. |
| ¿Cuándo exactamente? | **No** | Solo permite acotar una ventana de tiempo entre ambas capturas (entre `2026-11-13T20:48:52.487Z` y `2026-11-13T20:50:37.720Z`). |

## Respuestas

1. **¿Por qué un cambio de privilegios es uno de los eventos auditables más importantes?**
   Porque representa una **escalada de privilegios** directa sobre la seguridad de la base de datos. Si una cuenta de aplicación o usuario obtiene roles administrativos (`dbAdmin`, `userAdmin` o `root`), puede leer, modificar o eliminar cualquier colección, crear usuarios y desactivar el perfilador para ocultar su actividad.

2. **¿Con qué frecuencia tomarías instantáneas? ¿Qué factores influyen?**
   En producción sin auditoría nativa, tomaría instantáneas **cada 15 a 60 minutos** mediante una tarea programada y **antes y después de cada ventana de mantenimiento**. Influyen la criticidad de los datos, los requisitos regulatorios, el intervalo máximo de exposición tolerable y la frecuencia habitual de cambios administrativos.

3. **¿Quién debería poder escribir en `auditoria.instantaneas_privilegios`?**
   Únicamente una **cuenta de servicio dedicada y automatizada** encargada de ejecutar la tarea de respaldo de privilegios (con permiso exclusivo `insert` sobre esa colección, sin permisos `update` ni `delete`), o en su defecto el administrador principal (`admin`). Las cuentas de aplicación y desarrolladores no deben tener acceso de lectura ni escritura para preservar la integridad de la evidencia.

4. **Redacta en tres líneas cómo comunicarías esta limitación a Dirección.**
   MongoDB Community Edition no registra de forma nativa quién otorga o revoca permisos ni el instante exacto del cambio, ya que esta capacidad pertenece exclusivamente a las ediciones Enterprise y Atlas. Como control compensatorio implementamos instantáneas periódicas de privilegios que permiten detectar qué permisos cambiaron y en qué intervalo de tiempo ocurrió. Si la normativa exige atribución individual exacta en tiempo real sobre cambios de seguridad, se recomienda evaluar la migración a MongoDB Enterprise o Atlas.
   