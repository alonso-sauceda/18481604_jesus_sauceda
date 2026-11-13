# Actividad 10: Respuesta ejecutiva a Dirección

## Dictamen técnico sobre trazabilidad en `comercial` (MongoDB 7.0.48 Community)

Con base en las pruebas realizadas sobre la instancia actual de producción/laboratorio (`MongoDB 7.0.48 Community Edition`), se responden las cuatro consultas planteadas por Dirección:

### 1. ¿Podemos saber quién consultó, modificó o eliminó datos de clientes?
* **Con el perfilador desactivado (configuración por defecto, nivel `0`):** **No hay evidencia con esta edición.** Solo es posible demostrar qué usuario y aplicación se conectaron al servidor en esa ventana de tiempo mediante `mongod.log`, pero no qué colección ni qué registros tocaron.
* **Con el perfilador activado (nivel `2` o nivel `1` con filtro de operaciones):** **Sí**, siempre que los registros sigan dentro del búfer circular de `system.profile` o hayan sido exportados. Se identifica el usuario autenticado (`user`), dirección IP (`client`), nombre de aplicación (`appName`), marca de tiempo (`ts`) y la operación exacta (`query`, `update`, `remove`).

### 2. ¿Podemos recuperar el valor anterior de un dato modificado o el contenido completo de un cliente eliminado a partir de los registros de auditoría?
* **No hay evidencia con esta edición.** Ni `system.profile` ni la bitácora `mongod.log` almacenan copias previas (*before-images*) de los documentos antes de ser actualizados o borrados; únicamente conservan el criterio de búsqueda y la instrucción ejecutada. La recuperación de datos históricos depende exclusivamente de respaldos programados o del registro de historial a nivel de aplicación.

### 3. ¿Podemos demostrar quién otorgó o revocó privilegios administrativos a un usuario y en qué segundo exacto ocurrió?
* **No hay evidencia con esta edición.** La auditoría nativa de comandos de seguridad (`grantRolesToUser`, `revokeRolesFromUser`, cambios de esquema) forma parte exclusiva de MongoDB Enterprise y MongoDB Atlas.
* Mediante el **control compensatorio de instantáneas periódicas** (`auditoria.instantaneas_privilegios`) implementado en este laboratorio, podemos demostrar **qué permisos cambiaron** y acotar el **intervalo de tiempo** entre dos capturas, pero no atribuir la acción a un administrador específico ni obtener el segundo exacto.

### 4. Recomendación técnica y hoja de ruta
1. **Corto plazo (sin costo de licencia):** Configurar `operationProfiling` de forma permanente en `mongod.cfg` con un filtro enfocado en operaciones de escritura sobre colecciones críticas (`comercial.clientes`), programar una tarea automatizada cada 15–30 minutos para tomar instantáneas de privilegios y respaldar/exportar `system.profile` y `mongod.log` con verificación de integridad SHA-256.
2. **Mediano plazo (si existe exigencia normativa o auditoría externa):** Si la organización requiere atribución individual en tiempo real sobre cambios de permisos (`DDL`/`DCL`), monitoreo continuo de lecturas sin penalización de rendimiento o cumplimiento formal (LFPDPPP, PCI-DSS, ISO 27001), se recomienda evaluar la migración a **MongoDB Enterprise** o **MongoDB Atlas**.
