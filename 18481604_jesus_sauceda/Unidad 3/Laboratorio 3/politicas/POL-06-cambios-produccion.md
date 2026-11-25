# POL-06: Gestión de Cambios en Producción e Incidentes

- **Código:** POL-06
- **Propietario:** Gerencia Comercial y Seguridad de la Información
- **Custodio:** Administrador de Base de Datos (DBA)
- **Alcance:** Cambios de esquema (DDL), correcciones de datos (DML), configuración del motor y disparadores de auditoría.

## 1. Objetivo
Controlar cualquier modificación sobre la estructura, configuración o datos en producción, asegurando trazabilidad completa y segregación de autoridad.

## 2. Reglas Operativas
1. **Prohibición de corrección unilateral:** El DBA no puede corregir datos de negocio (como RFC, correos o duplicados) por iniciativa propia; toda modificación requiere solicitud aprobada por Gerencia Comercial.
2. **Integridad de mecanismos de auditoría:** Queda prohibido deshabilitar disparadores (`DISABLE TRIGGER`) o reducir `log_statement` sin una ventana de mantenimiento autorizada por Seguridad de la Información.
3. **Flujo de cambio:** Toda modificación estructural (`ALTER TABLE`, nuevas restricciones `CHECK`/`UNIQUE`) requiere: (a) aprobación del propietario, (b) respaldo previo, (c) ejecución fuera de horario crítico y (d) verificación posterior.
4. **Atención de incidentes:** Ante discrepancias entre `auditoria.cambios_clientes` y `dba.bitacora`, el DBA debe preservar las evidencias con hash `SHA-256` y notificar de inmediato a Auditoría Interna.

## 3. Verificación
- Conciliación periódica entre tickets de cambio aprobados, `auditoria.cambios_clientes` y `dba.bitacora` (`evidencias/06-conciliacion.md`).
