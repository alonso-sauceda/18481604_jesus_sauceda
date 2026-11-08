-- Actividad 1: Diagnóstico inicial de parámetros de bitácora
SHOW logging_collector;
SHOW log_directory;
SHOW log_destination;
SHOW log_statement;
SHOW log_min_messages;

-- Actividad 4: Inspección y lectura de bitácoras desde la base de datos
SELECT name, size, modification FROM pg_ls_logdir();

-- Lectura con conversión WIN1252 para evitar fallos de codificación UTF-8 en Windows
SELECT convert_from(pg_read_binary_file('log/postgresql-2026-11-07_192329.log', 0, 2000), 'WIN1252');