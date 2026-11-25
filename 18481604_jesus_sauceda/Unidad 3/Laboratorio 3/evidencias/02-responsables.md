# Actividad 2: Propietarios, custodios y usuarios

## Matriz de Responsables de Datos

| Conjunto de datos | Propietario | Custodio | Usuarios autorizados | Quién aprueba accesos | Quién aprueba correcciones |
|---|---|---|---|---|---|
| `comercial.public.clientes` (PostgreSQL) | Gerencia Comercial | DBA | `app_ventas` (lectura/escritura), `soporte_ana` (solo lectura) | Gerencia Comercial | Gerencia Comercial |
| `auditoria.cambios_clientes` (PostgreSQL) | Auditoría Interna / Seguridad de la Información | DBA | Auditoría Interna (lectura), disparador `trg_auditoria_clientes` (escritura automática) | Auditoría Interna / Seguridad de la Información | Ninguno (registro de auditoría inmutable; no se corrige) |
| Bitácora de PostgreSQL (`pg_log` / `dba.bitacora`) | Seguridad de la Información / Auditoría Interna | DBA | DBA y Auditoría Interna (solo lectura) | Seguridad de la Información / Auditoría Interna | Ninguno (evidencia técnica inmutable; no se edita) |
| `comercial.clientes` (MongoDB) | Gerencia Comercial | DBA | Aplicación de tienda en línea, equipo de soporte | Gerencia Comercial | Gerencia Comercial |
| `comercial.system.profile` (MongoDB) | Seguridad de la Información / Auditoría Interna | DBA | DBA y Auditoría Interna (solo lectura) | Seguridad de la Información / Auditoría Interna | Ninguno (colección rotativa gestionada por el motor) |

## Respuestas

1. **¿Por qué el propietario de `auditoria.cambios_clientes` no debería ser el mismo que opera `clientes`?**
   Por el principio de **segregación de funciones**. Si la Gerencia Comercial (propietaria de `clientes`) o el equipo operativo que modifica los datos también fuera propietario de la tabla de auditoría, tendría autoridad para aprobar la modificación o eliminación de sus propios rastros, invalidando la independencia y confiabilidad de la evidencia ante una revisión.

2. **¿Quién debería poder leer las bitácoras y la vista `dba.bitacora`? Relaciónalo con lo observado en el LAB-01 (secretos en la bitácora).**
   Únicamente el **DBA** (en su rol de custodio operativo) y **Auditoría Interna / Seguridad de la Información**, aplicando el principio de mínimo privilegio. Como se observó en el LAB-01, cuando `log_statement` registra sentencias DDL o DCL, la bitácora captura credenciales en texto claro (por ejemplo, `CREATE ROLE rol_temporal LOGIN PASSWORD 'Temporal_Practica_2026'`). Si usuarios generales o de aplicación leyeran `dba.bitacora`, quedarían expuestas contraseñas y datos sensibles de operaciones `INSERT`/`UPDATE`.

3. **¿Qué ocurre con la responsabilidad sobre un dato cuando nadie la tiene asignada? Relaciónalo con el problema inicial de la unidad.**
   Se produce un vacío de rendición de cuentas ("tierra de nadie") que impide gobernar el dato. Tal como plantea el problema inicial de la unidad, sin un propietario asignado nadie puede decidir oficialmente si el RFC de un cliente puede corregirse, qué valor es el válido ni si un cambio registrado en la bitácora fue legítimo o indebido, obligando al DBA a asumir decisiones de negocio que no le corresponden o dejando errores críticos sin resolver.