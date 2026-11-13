# Actividad 9: Comparación de trazabilidad: PostgreSQL vs MongoDB Community

## Matriz comparativa

| Capacidad / Criterio | PostgreSQL (Bitácora + Disparadores) | MongoDB 7.0.48 Community Edition |
|---|---|---|
| **Auditoría nativa de eventos** | Configurable mediante `log_statement` (`none`, `ddl`, `mod`, `all`), `log_connections` y `log_disconnections`. | **No hay evidencia con esta edición.** La auditoría nativa (`auditLog`) es exclusiva de Enterprise y Atlas. |
| **Registro de lecturas (`SELECT` / `find`)** | Posible con `log_statement = 'all'` o extensión `pgAudit` (alto impacto en disco). | Posible activando `db.setProfilingLevel(2)` o filtro en `system.profile` (limitado al tamaño de la colección *capped*, 1 MB por defecto). |
| **Registro de escrituras (`INSERT`, `UPDATE`, `DELETE`)** | Registradas en bitácora con `log_statement = 'mod'`, incluyendo usuario, sesión, IP y sentencia SQL. | Registradas en `system.profile` con nivel 2 o nivel 1 filtrado (`op: { $in: ["insert", "update", "remove"] }`), mostrando `user`, `client`, `appName`, `ts` y `command`. |
| **Valores anteriores y posteriores (`BEFORE` / `AFTER`)** | **Sí**, mediante disparadores (`TRIGGER`) en tablas críticas que guardan `OLD` y `NEW` en una tabla de auditoría. | **No hay evidencia con esta edición.** `system.profile` solo guarda la instrucción enviada (`command`), nunca el estado previo del documento modificado o eliminado. |
| **Cambios de esquema y privilegios (`DDL` / `GRANT` / `REVOKE`)** | **Sí**, `log_statement = 'ddl'` registra `CREATE`, `ALTER`, `DROP`, `GRANT` y `REVOKE` con autor y hora exacta. | **No hay evidencia con esta edición.** Comandos como `grantRolesToUser` no se registran ni en `system.profile` ni en `mongod.log`; requieren instantáneas periódicas como control compensatorio. |
| **Accesos exitosos y fallidos** | Registrados en bitácora de texto/CSV (`connection authorized`, `authentication failed`). | Registrados en formato JSON estructurado en `mongod.log` (`Successfully authenticated`, `Failed to authenticate`), correlacionables por `ctx`. |
| **Persistencia ante reinicios** | Los parámetros en `postgresql.conf` y los archivos de log persisten tras reiniciar el servicio. | `mongod.log` (`logAppend: true`) y los documentos ya escritos en `system.profile` persisten, pero el nivel del perfilador vuelve a `0` si no está en `mongod.cfg` y `getLog` en memoria se limpia. |

## Conclusiones de la comparación

1. **¿En qué aspecto PostgreSQL ofrece mayor trazabilidad nativa sin herramientas externas?**
   En el registro de comandos administrativos (`DDL`) y cambios de privilegios (`GRANT`/`REVOKE`), así como en la posibilidad de capturar el estado anterior (`OLD`) y posterior (`NEW`) de cada fila mediante disparadores nativos en la base de datos.

2. **¿Qué ventaja operativa ofrece la bitácora de MongoDB frente al texto plano tradicional?**
   Desde MongoDB 4.4+, `mongod.log` escribe cada evento como un objeto **JSON estructurado** (`t`, `s`, `c`, `id`, `ctx`, `msg`, `attr`), lo que facilita filtrar, correlacionar conexiones (`ctx`) e ingerir registros en sistemas SIEM sin necesidad de expresiones regulares complejas.
   