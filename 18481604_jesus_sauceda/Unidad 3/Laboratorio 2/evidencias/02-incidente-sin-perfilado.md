# Actividad 2: El incidente sin perfilado

## Evidencia ejecutada

### 1. Operación ejecutada desde la sesión de aplicación (`app_ventas` / `app-ventas-web`)
```text
comercial> db.clientes.updateOne({ rfc: "GAMA780912XXX" }, { $set: { limite_credito: 95000 } })
{
  acknowledged: true,
  insertedId: null,
  matchedCount: 1,
  modifiedCount: 1,
  upsertedCount: 0
}
```

### 2. Verificación en perfilador y bitácora desde la sesión DBA
```text
comercial> db.getProfilingStatus()
{ was: 0, slowms: 100, sampleRate: 1, ok: 1 }

comercial> db.system.profile.countDocuments()
0

comercial> bitacora().filter(e => JSON.stringify(e).includes("GAMA780912XXX")).length
0

comercial> bitacora().filter(e => JSON.stringify(e).includes("app-ventas-web")).map(e => ({ t: e.t, c: e.c, ctx: e.ctx, msg: e.msg })).slice(-8)
[
  {
    t: { '$date': '2026-11-13T12:57:21.105-07:00' },
    c: 'NETWORK',
    ctx: 'conn38',
    msg: 'client metadata'
  },
  {
    t: { '$date': '2026-11-13T12:57:21.111-07:00' },
    c: 'ACCESS',
    ctx: 'conn38',
    msg: 'Successfully authenticated'
  }
]
```

## Respuestas

1. **¿Qué se puede demostrar con certeza a partir de la evidencia disponible?**
   Únicamente se puede demostrar que el usuario **`app_ventas`**, utilizando la aplicación **`app-ventas-web`**, abrió la conexión **`conn38`** y se autenticó exitosamente el `2026-11-13T12:57:21.111-07:00`.

2. **¿Qué NO se puede demostrar y por qué?**
   **No hay evidencia con esta edición** en su configuración predeterminada sobre qué colección fue consultada o modificada, qué documento (`rfc: "GAMA780912XXX"`) se alteró ni qué valores cambiaron. Esto ocurre porque el perfilador está desactivado por defecto (`was: 0`) y la bitácora `mongod.log` en nivel estándar no registra operaciones de lectura ni escritura de datos.

3. **¿Cuál es el riesgo operativo de mantener el perfilador apagado en producción?**
   Ante una modificación no autorizada, un borrado accidental o una fuga de información, resulta imposible determinar qué registros fueron afectados o atribuir la operación a una sesión específica, dejando a la organización sin evidencia forense ni capacidad de auditoría sobre sus datos.