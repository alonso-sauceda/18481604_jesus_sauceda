-- 1. Consultar historial completo de cambios capturados por el disparador
SELECT id_evento,
       to_char(momento, 'YYYY-MM-DD HH24:MI:SS') AS fecha_hora,
       usuario_sesion,
       aplicacion,
       operacion,
       id_cliente,
       valores_antes->>'rfc' AS rfc_anterior,
       valores_despues->>'rfc' AS rfc_nuevo
FROM auditoria.cambios_clientes
ORDER BY id_evento;

-- 2. Consultar eventos relevantes en la bitácora del servidor (dba.bitacora)
SELECT num, linea
FROM dba.bitacora
WHERE linea ~* '(INSERT INTO|UPDATE |DELETE FROM|TRIGGER|ALTER TABLE)'
ORDER BY num DESC
LIMIT 30;