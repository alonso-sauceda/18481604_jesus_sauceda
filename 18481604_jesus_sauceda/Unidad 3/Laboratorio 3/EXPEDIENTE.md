# Expediente de Gobierno de Datos — Comercializadora Norte

## 1. Resumen Ejecutivo
Este expediente integra los entregables del **Laboratorio 3 (Unidad III)** sobre la base de datos `comercial` (PostgreSQL 18 y MongoDB): diagnóstico de calidad de datos, matriz de propietarios y custodios, diccionario de datos operativo en catálogo, inventario de objetos, reglas de conservación, conciliación de auditoría y seis políticas operativas (`POL-01` a `POL-06`) respaldadas por evidencia técnica (`E1`–`E6`).

## 2. Índice de Actividades y Evidencias

| Actividad / Sección | Archivos entregables | Descripción |
|---|---|---|
| **1. Calidad de datos** | `sql/01-verificaciones-calidad.sql`<br>`evidencias/01-calidad.md` | Detección de duplicados (`IDs 1 y 7`), formatos inválidos de RFC/correo y edad fuera de rango (`ID 8`) sin alteración unilateral del DBA. |
| **2. Responsables** | `evidencias/02-responsables.md` | Matriz de propietarios, custodios y usuarios autorizados bajo segregación de funciones. |
| **3. Diccionario operativo** | `sql/02-comentarios-diccionario.sql`<br>`evidencias/diccionario-clientes.csv`<br>`evidencias/03-diccionario.md` | Documentación semántica en `pg_description` (`COMMENT ON`), exportación CSV y clasificación de seguridad. |
| **4. Inventario y catálogo** | `sql/03-inventario-tablas.sql`<br>`evidencias/04-catalogo.md` | Catálogo completo de tablas, vistas, secuencias y funciones de negocio y auditoría. |
| **5. Conservación y retención** | `evidencias/05-conservacion.md` | Plazos de retención activa/histórica, anonimización ARCO e integridad criptográfica `SHA-256`. |
| **6. Conciliación de cambios** | `sql/04-registro-cambios.sql`<br>`evidencias/06-conciliacion.md` | Cruce entre `auditoria.cambios_clientes` y `dba.bitacora` (detección de cambio de RFC y desactivación de trigger). |
| **Políticas (`POL-01`–`POL-06`)** | `politicas/POL-01-acceso.md` a `POL-06-cambios-produccion.md` | Normativa operativa de acceso, respaldos, retención, restauración, datos sensibles y cambios en producción. |
| **Evidencias técnicas (`E1`–`E6`)** | `evidencias/E1-...` a `evidencias/E6-mongodb/` | Salidas directas del motor (configuración, privilegios, triggers, auditoría, bitácora `.log` + `.sha256` y MongoDB). |