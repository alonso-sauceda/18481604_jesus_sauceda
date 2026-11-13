# Actividad 6: Correlacionar un cambio de configuración con su autor

## Evidencia ejecutada (Sesión DBA)

### 1. Búsqueda de cambios en la configuración del perfilador
```text
comercial> bitacora().filter(e => e.msg === "Profiler settings changed").map(e => ({ t: e.t, ctx: e.ctx, msg: e.msg, attr: e.attr }))
[
  {
    t: { '$date': '2026-11-13T13:07:40.311-07:00' },
    ctx: 'conn22',
    msg: 'Profiler settings changed',
    attr: {
      from: { level: 0, slowms: 100, sampleRate: 1 },
      to: { level: 2, slowms: 100, sampleRate: 1 },
      db: 'comercial'
    }
  },
  {
    t: { '$date': '2026-11-13T13:11:48.540-07:00' },
    ctx: 'conn22',
    msg: 'Profiler settings changed',
    attr: {
      from: { level: 2, slowms: 100, sampleRate: 1 },
      to: { level: 0, slowms: 100, sampleRate: 1 },
      db: 'comercial'
    }
  },
  {
    t: { '$date': '2026-11-13T13:12:04.409-07:00' },
    ctx: 'conn22',
    msg: 'Profiler settings changed',
    attr: {
      from: { level: 0, slowms: 100, sampleRate: 1 },
      to: {
        level: 1,
        slowms: 100,
        sampleRate: 1,
        filter: { op: { '$in': [ 'insert', 'remove', 'update' ] } }
      },
      db: 'comercial'
    }
  }
]
```

### 2. Correlación de la conexión `conn22` con su autenticación
```text
comercial> bitacora().filter(e => e.ctx === "conn22" && e.msg === "Successfully authenticated").map(e => ({ t: e.t, ctx: e.ctx, user: e.attr.user, db: e.attr.db, client: e.attr.client }))
[
  {
    t: { '$date': '2026-11-13T12:52:11.773-07:00' },
    ctx: 'conn22',
    user: 'admin',
    db: 'admin',
    client: '127.0.0.1:52069'
  }
]
```

## Respuestas

1. **¿Qué usuario cambió la configuración del perfilador? ¿Qué dos eventos lo demuestran?**
   El usuario **`admin`** (autenticado en la base `admin` desde `127.0.0.1:52069`). Lo demuestran dos eventos vinculados por el mismo identificador de contexto (`ctx: 'conn22'`):
   - Primero, el evento `ACCESS` con mensaje `"Successfully authenticated"` a las `2026-11-13T12:52:11.773-07:00`, que asocia `conn22` con el usuario `admin`.
   - Segundo, los eventos con mensaje `"Profiler settings changed"` ocurridos posteriormente en esa misma conexión `conn22` (a las `13:07:40`, `13:11:48` y `13:12:04`).

2. **¿Qué condición debe cumplirse para que esta correlación sea válida?**
   Ambos eventos deben pertenecer al **mismo ciclo de ejecución (uptime) del proceso `mongod`**, sin reinicios intermedios del servicio, y el evento de autenticación debe ocurrir antes del cambio de configuración. Si el servicio se reinicia, la numeración de conexiones vuelve a empezar desde `conn1` y el mismo identificador `conn22` podría corresponder a otro usuario distinto.

3. **¿Por qué es relevante que quede registrado un cambio de configuración del propio mecanismo de registro?**
   Porque un usuario con privilegios elevados o un atacante suele desactivar o alterar los filtros del perfilador (`setProfilingLevel(0)`) antes de realizar acciones indebidas para ocultar su rastro. Registrar quién y cuándo modificó la configuración permite detectar intentos de evasión y sostener la integridad de la cadena de custodia.