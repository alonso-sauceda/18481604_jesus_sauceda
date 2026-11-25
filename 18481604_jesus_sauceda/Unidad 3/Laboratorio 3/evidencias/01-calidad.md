# Actividad 1: Verificación de Calidad de Datos (`comercial`)

## Hallazgos detectados (sin alterar ni borrar registros)
- **Correos duplicados / normalización:** `ana.lopez@example.test` aparece en los IDs `1` (`Ana López`) y `7` (`Ana Lopez` con `ANA.LOPEZ@example.test`).
- **RFC inválido o faltante:** ID `7` tiene formato incompleto (`LOAA850315AB`, 12 caracteres en lugar de 13) y el ID `8` (`Jorge Díaz`) tiene `RFC` en `NULL`.
- **Correo inválido:** ID `8` tiene `sin-correo`.
- **Edad fuera de rango:** ID `8` registra edad `-3` (fuera del rango `18–120`).
- **Teléfono corto:** ID `8` tiene `667` (3 dígitos).

## Respuestas
1. **¿Por qué no se deben corregir ni eliminar de oficio los registros problemáticos sin consultar al área propietaria?**
   Porque como DBA no me corresponde decidir si un registro duplicado o erróneo debe depurarse, fusionarse o conservarse como evidencia; esa decisión pertenece al propietario del dato (Gerencia Comercial) para evitar pérdida de información o alteración de procesos operativos.
2. **¿Qué diferencia existe entre detectar una anomalía con una consulta (`SELECT`) y prevenirla con una regla en la base de datos (`CHECK`, `UNIQUE`, `NOT NULL`)?**
   La consulta `SELECT` es reactiva: audita y muestra problemas ya existentes en los datos. Las restricciones en el esquema (`CHECK`, `UNIQUE`, `NOT NULL`) son preventivas: bloquean en el motor los datos inválidos antes de que entren.
