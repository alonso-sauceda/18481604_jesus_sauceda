# Actividad 6: Conciliación entre Auditoría y Bitácora del Servidor

## Tabla de Conciliación de Eventos (`comercial`)

| # | Evento observado | ¿En `auditoria.cambios_clientes`? | ¿En `dba.bitacora`? | Estado de conciliación | Dictamen de gobierno |
|---|---|---|---|---|---|
| 1 | Alta inicial de 6 clientes base (`IDs 1–6`) | Sí (`id_evento` 1 al 6, `INSERT`) | Sí (`INSERT INTO public.clientes`) | Conciliado | Carga inicial autorizada del sistema. |
| 2 | Modificación de RFC de María García (`ID 2`) | Sí (`id_evento` 7, `UPDATE`, `XY2` -> `ZZ9`) | Sí (`UPDATE public.clientes`) | Conciliado (requiere ticket) | Cambio rastreado; debe validarse contra solicitud de Gerencia Comercial. |
| 3 | Deshabilitación y reactivación de `trg_auditoria_clientes` | No (los triggers no auditan comandos `ALTER TABLE`) | Sí (`ALTER TABLE ... DISABLE/ENABLE TRIGGER`) | Alerta de seguridad | Demuestra defensa en profundidad: la bitácora del servidor detecta intentos de evasión del trigger. |
| 4 | Inserción de registros con anomalías (`IDs 7 y 8`) | Sí (`id_evento` 8 y 9, `INSERT`) | Sí (`INSERT INTO clientes`) | Conciliado (hallazgo calidad) | Evidencia preservada sin borrar; escalada a Gerencia Comercial (`01-calidad.md`). |

## Respuestas

1. **¿Por qué es indispensable cruzar `auditoria.cambios_clientes` con `dba.bitacora` en lugar de confiar en una sola fuente?**
   Porque cada mecanismo cubre puntos ciegos del otro: `auditoria.cambios_clientes` guarda los valores exactos antes y después en formato estructurado (`JSONB`), mientras que `dba.bitacora` registra comandos administrativos (`ALTER TABLE`, `DISABLE TRIGGER`, conexiones y roles) que un disparador de tabla nunca puede capturar.
2. **¿Qué debe hacer el DBA si detecta en `dba.bitacora` una operación DML sobre `clientes` que no aparece en `auditoria.cambios_clientes`?**
   Tratarlo como un incidente crítico de seguridad: significa que el disparador estuvo deshabilitado durante esa ventana. Debe preservar inmediatamente el archivo de bitácora con su hash `SHA-256`, identificar el usuario y sesión responsable en `dba.bitacora` y reportar el hallazgo a Seguridad de la Información y Auditoría Interna.
