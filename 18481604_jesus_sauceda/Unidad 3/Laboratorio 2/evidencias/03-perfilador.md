# Actividad 3: Activar el perfilador y registrar operaciones

## Evidencia ejecutada

### 1. Activación del perfilador en nivel 2 (Sesión DBA)
```text
comercial> db.setProfilingLevel(2)
{ was: 0, slowms: 100, sampleRate: 1, ok: 1 }

comercial> db.getProfilingStatus()
{ was: 2, slowms: 100, sampleRate: 1, ok: 1 }
```

### 2. Ejecución de consulta, actualización y eliminación desde la aplicación
```text
mongosh "mongodb://app_ventas:<REDACTED>@127.0.0.1:27017/comercial?appName=app-ventas-web" --quiet --eval 'db.clientes.find({ ciudad: "Culiacán" }, { nombre: 1, ciudad: 1 }).toArray(); db.clientes.updateOne({ _id: 3 }, { $set: { rfc: "GAMA780912XYZ" } }); db.clientes.deleteOne({ _id: 2 });'
{ acknowledged: true, deletedCount: 1 }
```

### 3. Consulta de registros en `system.profile` (Sesión DBA)
```text
comercial> db.system.profile.find({ ns: "comercial.clientes" }, { op: 1, ns: 1, command: 1, user: 1, client: 1, appName: 1, ts: 1, millis: 1, nreturned: 1, docsExamined: 1, nModified: 1, ndeleted: 1 }).sort({ ts: 1 })
[
  {
    op: 'query',
    ns: 'comercial.clientes',
    command: {
      find: 'clientes',
      filter: { ciudad: 'Culiacán' },
      projection: { nombre: 1, ciudad: 1 },
      lsid: { id: UUID('f6e6718e-3af5-4930-bc8f-0eadf71b30b4') },
      '$db': 'comercial'
    },
    docsExamined: 5,
    nreturned: 3,
    millis: 2,
    ts: ISODate('2026-11-13T20:08:18.464Z'),
    client: '127.0.0.1',
    appName: 'app-ventas-web',
    user: 'app_ventas@comercial'
  },
  {
    op: 'update',
    ns: 'comercial.clientes',
    command: {
      q: { _id: 3 },
      u: { '$set': { rfc: 'GAMA780912XYZ' } },
      multi: false,
      upsert: false
    },
    docsExamined: 1,
    nModified: 1,
    millis: 1,
    ts: ISODate('2026-11-13T20:08:18.470Z'),
    client: '127.0.0.1',
    appName: 'app-ventas-web',
    user: 'app_ventas@comercial'
  },
  {
    op: 'remove',
    ns: 'comercial.clientes',
    command: { q: { _id: 2 }, limit: 1 },
    docsExamined: 1,
    ndeleted: 1,
    millis: 1,
    ts: ISODate('2026-11-13T20:08:18.479Z'),
    client: '127.0.0.1',
    appName: 'app-ventas-web',
    user: 'app_ventas@comercial'
  }
]
```

## 9.1 Interpretación de los documentos

| # | op | Documentos afectados | Usuario | Cliente | Aplicación | Momento (UTC) | Qué hizo |
|---|---|---|---|---|---|---|---|
| 1 | `query` | `nreturned: 3` (`docsExamined: 5`) | `app_ventas@comercial` | `127.0.0.1` | `app-ventas-web` | `2026-11-13T20:08:18.464Z` | Consultó `nombre` y `ciudad` de clientes en Culiacán |
| 2 | `update` | `nModified: 1` (`docsExamined: 1`) | `app_ventas@comercial` | `127.0.0.1` | `app-ventas-web` | `2026-11-13T20:08:18.470Z` | Actualizó el campo `rfc` a `"GAMA780912XYZ"` del cliente `_id: 3` |
| 3 | `remove` | `ndeleted: 1` (`docsExamined: 1`) | `app_ventas@comercial` | `127.0.0.1` | `app-ventas-web` | `2026-11-13T20:08:18.479Z` | Eliminó el documento del cliente con `_id: 2` |

## Respuestas

1. **¿Puedes saber cuál era el RFC antes del cambio con la información de `system.profile`?**
   **No hay evidencia con esta edición.** El perfilador únicamente registra la instrucción recibida (`command.u: { '$set': { rfc: 'GAMA780912XYZ' } }`), pero no guarda una imagen previa del documento antes de ser modificado (a diferencia de un disparador `BEFORE/AFTER UPDATE` en PostgreSQL).

2. **¿Puedes saber qué datos tenía el documento eliminado?**
   **No hay evidencia con esta edición.** En una operación `remove`, `system.profile` solo registra el criterio de filtrado utilizado (`command.q: { _id: 2 }`) y la cantidad eliminada (`ndeleted: 1`), pero no respalda el contenido del documento borrado.

3. **A diferencia de `log_statement = 'mod'` en PostgreSQL, el nivel 2 sí registró la consulta. ¿Qué ventaja y qué riesgo tiene eso?**
   - **Ventaja:** Permite detectar accesos indebidos de lectura o exfiltración de información confidencial (saber quién consultó datos personales como RFC o correos, cuándo y bajo qué filtros), además de diagnosticar consultas lentas.
   - **Riesgo:** Genera una fuerte degradación de rendimiento y llena rápidamente la colección limitada `system.profile` (1 MB por defecto), provocando que la evidencia más antigua se sobrescriba; además, expone datos sensibles presentes dentro de los filtros de búsqueda (`command.filter`) a cualquiera que pueda leer `system.profile`.

4. **¿Por qué el campo `user` incluye `@comercial`?**
   Porque en MongoDB la identidad de un usuario está vinculada a su base de datos de autenticación (`authSource`). El usuario `app_ventas` fue creado dentro de la base `comercial` (a diferencia de `admin`, que existe en `admin`), por lo que su identificador completo se expresa como `usuario@base_autenticacion`.
   