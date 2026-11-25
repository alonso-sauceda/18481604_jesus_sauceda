# POL-03: Conservación, Retención y Disposición de Datos

- **Código:** POL-03
- **Propietario:** Auditoría Interna / Área Legal y Comercial
- **Custodio:** Administrador de Base de Datos (DBA)
- **Alcance:** Registros de clientes (`public.clientes`), tablas de auditoría (`auditoria.cambios_clientes`) y bitácoras del motor.

## 1. Objetivo
Definir los plazos mínimos y máximos de conservación de datos operativos y evidencias técnicas para cumplir obligaciones fiscales, auditorías internas y principios de privacidad.

## 2. Reglas Operativas
1. **Datos de clientes (`public.clientes`):** Se conservan activos durante la relación comercial y en archivo histórico durante **5 años** posteriores a la baja por obligaciones fiscales.
2. **Auditoría de cambios (`auditoria.cambios_clientes`):** Se conserva **12 meses** en línea y **4 años** en archivo histórico cifrado; nunca se elimina ni modifica manualmente.
3. **Bitácoras del motor (`pg_log` / `dba.bitacora` y `system.profile`):** Se retienen **90 días** en servidor y **12 meses** en repositorio de seguridad con firma `SHA-256`.
4. **Disposición segura:** Vencido el plazo legal o ante solicitud procedente de cancelación (derechos ARCO), los datos personales se anonimizan preservando la integridad referencial.

## 3. Verificación
- Revisión trimestral de tamaños de tabla/bitácora y cumplimiento de ventanas de archivado registradas en `evidencias/05-conservacion.md`.
