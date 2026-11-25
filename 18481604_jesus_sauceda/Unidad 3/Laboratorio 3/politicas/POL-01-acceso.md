# POL-01: Control de Acceso y Mínimo Privilegio

- **Código:** POL-01
- **Propietario:** Seguridad de la Información / Gerencia Comercial
- **Custodio:** Administrador de Base de Datos (DBA)
- **Alcance:** Roles, esquemas, tablas y vistas de la base de datos `comercial` (PostgreSQL y MongoDB).

## 1. Objetivo
Garantizar que cada usuario o aplicación disponga únicamente de los privilegios mínimos necesarios para cumplir sus funciones, evitando accesos excesivos o exposición de datos personales.

## 2. Reglas Operativas
1. **Prohibición de uso operativo de superusuario:** Ninguna aplicación ni analista se conectará con el rol `postgres` en operaciones cotidianas.
2. **Segregación de funciones por rol:**
   - `app_ventas`: Autorizado únicamente para `SELECT` y `UPDATE` sobre `public.clientes`.
   - `soporte_ana`: Autorizado únicamente para consulta (`SELECT`) sin permisos de modificación (`UPDATE`/`DELETE`).
3. **Aislamiento de esquemas de control:** Se revoca todo acceso a `PUBLIC` sobre los esquemas `auditoria` y `dba`. Solo el DBA y Auditoría Interna pueden consultarlos.
4. **Cuentas temporales con expiración:** Todo rol temporal (`rol_temporal`) debe crearse con fecha de vencimiento (`VALID UNTIL`) y eliminarse al concluir la actividad autorizada.

## 3. Verificación
- Revisión periódica de privilegios en `information_schema.role_table_grants` y atributos de roles (`pg_roles`), documentada en `evidencias/E2-privilegios.txt`.
