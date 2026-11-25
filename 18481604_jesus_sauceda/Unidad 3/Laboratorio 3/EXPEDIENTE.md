# Expediente de Gobierno de Datos — Comercializadora Norte

## 1. Resumen Ejecutivo
Este expediente integra el diagnóstico de calidad de datos, la asignación formal de responsabilidades (propietarios y custodios), el diccionario de datos operativo extraído del catálogo de PostgreSQL, cuatro políticas internas de gobierno de datos y la evidencia técnica de cumplimiento sobre la base de datos `comercial`.

## 2. Índice de Evidencias por Actividad

| Actividad | Entregables | Descripción |
|---|---|---|
| **1. Calidad de datos** | `sql/01-verificaciones-calidad.sql`<br>`evidencias/01-calidad.md` | Detección de duplicados (`IDs 1 y 7`), formatos inválidos de RFC/correo, edad fuera de rango (`ID 8`) y reglas de escalamiento al propietario. |
| **2. Responsables** | `evidencias/02-responsables.md` | Matriz de propietarios, custodios y usuarios autorizados para PostgreSQL y MongoDB bajo segregación de funciones. |
| **3. Diccionario operativo** | `sql/02-comentarios-diccionario.sql`<br>`evidencias/diccionario-clientes.csv`<br>`evidencias/03-diccionario.md` | Metadatos semánticos (`COMMENT ON`) integrados en `pg_description`, exportación CSV y clasificación extendida de seguridad. |
| **4. Políticas prácticas** | `politicas/01-calidad-datos.md`<br>`politicas/02-control-acceso.md`<br>`politicas/03-auditoria-bitacoras.md`<br>`politicas/04-gestion-cambios.md` | Políticas operativas `POL-GOV-01` a `POL-GOV-04` con reglas verificables y roles responsables. |
| **5. Cumplimiento técnico** | `sql/03-controles-verificacion.sql`<br>`evidencias/04-verificacion-tecnica.txt`<br>`evidencias/04-cumplimiento.md` | Implementación de restricciones `CHECK ... NOT VALID`, vista enmascarada `vw_clientes_soporte` y salida verificada de auditoría y privilegios. |