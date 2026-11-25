# POL-02: Respaldos y Verificación de Integridad

- **Código:** POL-02
- **Propietario:** Gerencia de TI / Seguridad de la Información
- **Custodio:** Administrador de Base de Datos (DBA)
- **Alcance:** Base de datos `comercial` en PostgreSQL y colección `comercial` en MongoDB.

## 1. Objetivo
Asegurar la disponibilidad y recuperabilidad de los datos operativos y de auditoría ante fallos de hardware, errores humanos o incidentes de seguridad.

## 2. Reglas Operativas
1. **Frecuencia de respaldo:**
   - Respaldo lógico completo diario (`pg_dump -Fc` en PostgreSQL y `mongodump` en MongoDB) fuera de horario pico.
   - Respaldo preventivo obligatorio antes de cualquier cambio estructural (DDL) o actualización masiva en producción.
2. **Integridad criptográfica:** Todo archivo de respaldo o evidencia exportada debe acompañarse de su huella `SHA-256` para detectar alteraciones o corrupción.
3. **Almacenamiento separado:** Los respaldos deben almacenarse fuera del servidor de base de datos principal con permisos de lectura restringidos exclusivamente al DBA.

## 3. Verificación
- Comprobación semanal de existencia de respaldos, validación de hash `SHA-256` y bitácora de ejecución sin errores.
