# Actividad 4: Reducir el volumen con un filtro

## Evidencia ejecutada

### 1. Configuración del filtro en el perfilador (Sesión DBA)
```text
comercial> db.setProfilingLevel(0)
{ was: 2, slowms: 100, sampleRate: 1, ok: 1 }

comercial> db.system.profile.drop()
true

comercial> db.setProfilingLevel(1, { filter: { op: { $in: ["insert", "update", "remove"] } } })
{
  was: 0,
  slowms: 100,
  sampleRate: 1,
  note: 'When a filter expression is set, slowms and sampleRate are not used for profiling and slow-query log lines.',
  ok: 1
}

comercial> db.getProfilingStatus()
{
  was: 1,
  slowms: 100,
  sampleRate: 1,
  filter: { op: { '$in': [ 'insert', 'remove', 'update' ] } },
  note: 'When a filter expression is set, slowms and sampleRate are not used for profiling and slow-query log lines.',
  ok: 1
}
```

### 2. Ejecución de consulta y actualización desde la aplicación
```text
mongosh "mongodb://app_ventas:<REDACTED>@127.0.0.1:27017/comercial?appName=app-ventas-web" --quiet --eval 'db.clientes.find({ _id: 1 }).toArray(); db.clientes.updateOne({ _id: 1 }, { $set: { telefono: "6670000000" } })'
{
  acknowledged: true,
  insertedId: null,
  matchedCount: 1,
  modifiedCount: 1,
  upsertedCount: 0
}
```

### 3. Consulta de registros capturados (Sesión DBA)
```text
comercial> db.system.profile.find({}, { op: 1, ns: 1, user: 1, appName: 1, "command.q": 1, "command.u": 1, ts: 1 })
[
  {
    op: 'update',
    ns: 'comercial.clientes',
    command: { q: { _id: 1 }, u: { '$set': { telefono: '6670000000' } } },
    ts: ISODate('2026-11-13T20:12:44.260Z'),
    appName: 'app-ventas-web',
    user: 'app_ventas@comercial'
  }
]
```

## Respuestas

1. **¿Qué perdiste de evidencia al aplicar el filtro? ¿Qué ganaste?**
   - **Qué se perdió:** Se perdió la visibilidad sobre las operaciones de lectura (`query`), comandos administrativos (`command`) y operaciones de agregación/conteo; tampoco se registran consultas lentas que no sean de escritura, ya que al definir `filter` se ignoran `slowms` y `sampleRate`.
   - **Qué se ganó:** Se redujo drásticamente el volumen de documentos escritos en `system.profile`, disminuyendo el impacto en el rendimiento del servidor y evitando que el búfer circular de 1 MB se llene y sobrescriba rápidamente la evidencia crítica de modificaciones (`insert`, `update`, `remove`).

2. **¿Qué filtro usarías si solo interesaran operaciones sobre la colección `clientes`?**
   Filtraría por el espacio de nombres (`ns`) completo de la colección dentro de la base `comercial`:
   ```javascript
   db.setProfilingLevel(1, { filter: { ns: "comercial.clientes" } })
   ```
   *(O si solo interesan escrituras sobre esa colección: `{ filter: { ns: "comercial.clientes", op: { $in: ["insert", "update", "remove"] } } }`)*.
   