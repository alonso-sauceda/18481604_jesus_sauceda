-- ============================================================================
-- ACTIVIDAD 5: Implementación de controles y verificación de políticas
-- ============================================================================

-- 1. POL-GOV-01 (Calidad): Restricciones declarativas NOT VALID
-- Protegen futuras inserciones/actualizaciones sin eliminar los registros 7 y 8
ALTER TABLE public.clientes
    DROP CONSTRAINT IF EXISTS chk_clientes_rfc_formato,
    DROP CONSTRAINT IF EXISTS chk_clientes_correo_formato,
    DROP CONSTRAINT IF EXISTS chk_clientes_edad_rango;

ALTER TABLE public.clientes
    ADD CONSTRAINT chk_clientes_rfc_formato
        CHECK (rfc ~ '^[A-Z&]{3,4}[0-9]{6}[A-Z0-9]{3}$') NOT VALID,
    ADD CONSTRAINT chk_clientes_correo_formato
        CHECK (correo ~ '^[^@\s]+@[^@\s]+\.[^@\s]+$') NOT VALID,
    ADD CONSTRAINT chk_clientes_edad_rango
        CHECK (edad IS NULL OR (edad >= 18 AND edad <= 120)) NOT VALID;

-- 2. POL-GOV-02 (Acceso): Vista enmascarada para soporte_ana
CREATE OR REPLACE VIEW public.vw_clientes_soporte AS
SELECT
    id,
    nombre,
    regexp_replace(correo, '(^.).*(@.*$)', '\1***\2') AS correo_enmascarado,
    CASE WHEN telefono IS NOT NULL THEN '******' || right(telefono, 4) ELSE NULL END AS telefono_enmascarado,
    CASE WHEN rfc IS NOT NULL THEN left(rfc, 4) || '******' || right(rfc, 3) ELSE NULL END AS rfc_enmascarado,
    ciudad,
    segmento
FROM public.clientes;

REVOKE SELECT ON public.clientes FROM soporte_ana;
GRANT SELECT ON public.vw_clientes_soporte TO soporte_ana;

-- ============================================================================
-- CONSULTAS DE VERIFICACIÓN DE CUMPLIMIENTO
-- ============================================================================

-- V1. Configuración de bitácoras (POL-GOV-03)
SELECT name AS parametro, setting AS valor
FROM pg_settings
WHERE name IN ('logging_collector', 'log_statement', 'log_connections', 'log_disconnections')
ORDER BY name;

-- V2. Estado del disparador de auditoría (POL-GOV-03)
SELECT tgname AS disparador,
       CASE tgenabled WHEN 'O' THEN 'ACTIVO' ELSE 'INACTIVO' END AS estado
FROM pg_trigger
WHERE tgrelid = 'public.clientes'::regclass
  AND NOT tgisinternal;

-- V3. Reglas de calidad activas en public.clientes (POL-GOV-01)
SELECT conname AS restriccion,
       convalidated AS historico_validado,
       pg_get_constraintdef(oid) AS definicion
FROM pg_constraint
WHERE conrelid = 'public.clientes'::regclass
  AND contype = 'c'
ORDER BY conname;

-- V4. Matriz efectiva de privilegios por rol (POL-GOV-02)
SELECT grantee AS rol,
       table_name AS objeto,
       privilege_type AS privilegio
FROM information_schema.role_table_grants
WHERE table_schema = 'public'
  AND grantee IN ('app_ventas', 'soporte_ana')
ORDER BY grantee, table_name, privilege_type;

-- V5. Muestra de vista enmascarada para soporte (POL-GOV-02)
SELECT * FROM public.vw_clientes_soporte ORDER BY id LIMIT 3;

-- V6. Trazabilidad registrada en auditoria.cambios_clientes (POL-GOV-03)
SELECT id_evento, momento, usuario_sesion, operacion, id_cliente
FROM auditoria.cambios_clientes
ORDER BY id_evento;