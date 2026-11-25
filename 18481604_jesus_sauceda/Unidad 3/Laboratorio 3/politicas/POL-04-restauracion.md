# POL-04: Restauración y Pruebas de Recuperación

- **Código:** POL-04
- **Propietario:** Gerencia de TI / Gerencia Comercial
- **Custodio:** Administrador de Base de Datos (DBA)
- **Alcance:** Procedimientos de recuperación de bases de datos `comercial` ante pérdida, corrupción o incidentes.

## 1. Objetivo
Establecer un procedimiento controlado y probado para restaurar datos con mínima pérdida operativa y sin sobrescribir evidencias forenses.

## 2. Reglas Operativas
1. **Autorización de restauración:** Toda restauración sobre el entorno productivo requiere aprobación de Gerencia Comercial y Seguridad de la Información.
2. **Preservación previa:** Antes de restaurar sobre producción, el DBA debe respaldar el estado actual dañado y preservar `auditoria.cambios_clientes` y la bitácora activa.
3. **Validación en entorno aislado:** La restauración (`pg_restore` / `mongorestore`) se ejecuta primero en una base temporal de verificación para comprobar conteo de registros e integridad antes de habilitar el servicio.
4. **Simulacros periódicos:** El DBA ejecutará al menos una prueba de restauración trimestral documentando tiempos de recuperación y resultados.

## 3. Verificación
- Acta de prueba de restauración y validación funcional firmada por el propietario del dato.
