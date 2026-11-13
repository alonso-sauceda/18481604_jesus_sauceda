# Actividad 5: Accesos en la bitácora de mongod

## Evidencia ejecutada

### 1. Generación de intentos fallidos de autenticación
```text
mongosh "mongodb://app_ventas:<REDACTED>@127.0.0.1:27017/comercial" --quiet --eval "db.clientes.countDocuments()"
MongoServerError: Authentication failed.

mongosh "mongodb://usuario_inexistente:<REDACTED>@127.0.0.1:27017/comercial" --quiet --eval "db.clientes.countDocuments()"
MongoServerError: Authentication failed.
```

### 2. Consulta de accesos fallidos en la bitácora (Sesión DBA)
```text
comercial> bitacora().filter(e => e.c === "ACCESS" && e.msg === "Failed to authenticate").map(e => ({ t: e.t, id: e.id, ctx: e.ctx, user: e.attr.user, client: e.attr.client, error: e.attr.error, result: e.attr.result, app: e.attr.doc?.application?.name }))
[
  {
    t: { '$date': '2026-11-13T13:39:24.448-07:00' },
    id: 5286307,
    ctx: 'conn54',
    user: 'app_ventas',
    client: '127.0.0.1:50767',
    error: 'AuthenticationFailed: SCRAM authentication failed, storedKey mismatch',
    result: 18,
    app: 'mongosh 2.14.2'
  },
  {
    t: { '$date': '2026-11-13T13:39:33.358-07:00' },
    id: 5286307,
    ctx: 'conn56',
    user: 'usuario_inexistente',
    client: '127.0.0.1:50774',
    error: 'UserNotFound: Could not find user "usuario_inexistente" for db "comercial"',
    result: 11,
    app: 'mongosh 2.14.2'
  },
  {
    t: { '$date': '2026-11-13T13:39:33.362-07:00' },
    id: 5286307,
    ctx: 'conn56',
    user: 'usuario_inexistente',
    client: '127.0.0.1:50774',
    error: 'UserNotFound: Could not find user "usuario_inexistente" for db "comercial"',
    result: 11,
    app: 'mongosh 2.14.2'
  }
]
```

### 3. Consulta del último acceso exitoso de la aplicación (Sesión DBA)
```text
comercial> bitacora().filter(e => e.msg === "Successfully authenticated" && e.attr.user === "app_ventas").slice(-1).map(e => ({ t: e.t, id: e.id, ctx: e.ctx, client: e.attr.client, result: e.attr.result, app: e.attr.doc?.application?.name }))
[
  {
    t: { '$date': '2026-11-13T13:12:44.262-07:00' },
    id: 5286306,
    ctx: 'conn52',
    client: '127.0.0.1:58351',
    result: 0,
    app: 'app-ventas-web'
  }
]
```

## Respuestas

1. **¿Qué campo distingue un acceso fallido de uno exitoso?**
   Se distinguen por tres campos en el JSON de la bitácora:
   - `msg`: muestra `"Failed to authenticate"` cuando falla y `"Successfully authenticated"` cuando tiene éxito.
   - `id`: el identificador numérico es `5286307` para fallos y `5286306` para accesos exitosos.
   - `attr.result`: devuelve `0` en accesos exitosos y un código de error distinto de cero cuando falla (`18` por clave incorrecta, `11` por usuario inexistente), acompañado de `attr.error`.

2. **¿Qué diferencia hay entre el error de contraseña incorrecta y el de usuario inexistente? ¿Por qué el cliente recibe el mismo mensaje en ambos casos?**
   - **En la bitácora:** Con contraseña incorrecta registra `AuthenticationFailed: SCRAM authentication failed, storedKey mismatch` (`result: 18`). Con usuario inexistente registra `UserNotFound: Could not find user "usuario_inexistente" for db "comercial"` (`result: 11`).
   - **En el cliente:** Ambos devuelven el mismo mensaje genérico (`MongoServerError: Authentication failed.`) para evitar la enumeración de usuarios; así un atacante no puede descubrir qué nombres de cuenta son válidos.

3. **¿Por qué el nombre de la aplicación del intento fallido es `mongosh 2.14.2` y no `app-ventas-web`?**
   Porque en las cadenas de conexión de los intentos fallidos no se incluyó el parámetro `?appName=app-ventas-web`, por lo que `mongosh` reportó su identificador por defecto (`mongosh 2.14.2`).
   