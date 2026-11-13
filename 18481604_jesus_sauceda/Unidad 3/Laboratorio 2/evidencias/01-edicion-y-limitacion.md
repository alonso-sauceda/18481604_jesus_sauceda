# Actividad 1: Lo que no existe en esta edición

## Evidencia ejecutada (Sesión DBA)

```text
comercial> db.version()
7.0.48

comercial> db.adminCommand({ buildInfo: 1 }).modules
[]

comercial> db.serverCmdLineOpts().parsed
{
  config: 'C:\\Program Files\\MongoDB\\Server\\7.0\\bin\\mongod.cfg',
  net: { bindIp: '127.0.0.1', port: 27017 },
  security: { authorization: 'enabled' },
  storage: { dbPath: 'C:\\Program Files\\MongoDB\\Server\\7.0\\data' },
  systemLog: {
    destination: 'file',
    logAppend: true,
    path: 'C:\\Program Files\\MongoDB\\Server\\7.0\\log\\mongod.log'
  }
}
```

## Respuestas

1. **¿Qué edición de MongoDB está instalada y cómo se comprueba?**
   Está instalada **MongoDB 7.0.48 Community Edition**. Se comprueba ejecutando `db.adminCommand({ buildInfo: 1 }).modules`, que devuelve un arreglo vacío (`[]`); en MongoDB Enterprise este campo incluye el módulo `"enterprise"`.

2. **¿Qué ocurre si se intenta habilitar el parámetro `auditLog` en `mongod.cfg` en esta edición?**
   El servicio `mongod` rechaza la configuración y falla al iniciar con el error `Unrecognized option: auditLog`, ya que el subsistema de auditoría nativa (`auditLog`) es exclusivo de **MongoDB Enterprise** y **MongoDB Atlas**.

3. **¿Qué mecanismos nativos sí están disponibles en Community Edition para observar actividad?**
   Están disponibles dos mecanismos:
   - **La bitácora del servidor (`mongod.log`):** Registra eventos del proceso, conexiones, autenticaciones exitosas o fallidas y cambios de configuración en formato JSON estructurado.
   - **El perfilador de base de datos (`system.profile`):** Captura operaciones CRUD y comandos ejecutados sobre una base de datos específica según el nivel y filtro configurados.
   