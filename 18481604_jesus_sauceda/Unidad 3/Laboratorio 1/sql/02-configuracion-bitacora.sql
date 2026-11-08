-- Actividad 2: Habilitación de auditoría completa y formato de prefijo de línea
ALTER SYSTEM SET log_statement = 'all';
ALTER SYSTEM SET log_line_prefix = '%m [%p] %u@%d %a ';
SELECT pg_reload_conf();

-- Verificación de parámetros aplicados en caliente
SHOW log_statement;
SHOW log_line_prefix;