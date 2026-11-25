-- Restaurar estado exacto de privilegios del LAB-01 antes de inventariar
DROP VIEW IF EXISTS public.vw_clientes_soporte;
GRANT SELECT ON public.clientes TO soporte_ana;

-- Inventario completo de tablas, vistas y secuencias en esquemas de negocio y control
SELECT n.nspname AS esquema,
       c.relname AS objeto,
       CASE c.relkind
           WHEN 'r' THEN 'Tabla'
           WHEN 'v' THEN 'Vista'
           WHEN 'S' THEN 'Secuencia'
           WHEN 'i' THEN 'Índice'
       END AS tipo_objeto,
       pg_get_userbyid(c.relowner) AS propietario_motor,
       c.reltuples::bigint AS filas_estimadas,
       pg_size_pretty(pg_total_relation_size(c.oid)) AS tamano_total,
       obj_description(c.oid, 'pg_class') AS descripcion_catalogo
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
WHERE n.nspname IN ('public', 'auditoria', 'dba')
  AND c.relkind IN ('r', 'v', 'S')
ORDER BY n.nspname, c.relkind, c.relname;

-- Inventario de funciones y disparadores de gobierno/auditoría
SELECT n.nspname AS esquema,
       p.proname AS funcion,
       pg_get_userbyid(p.proowner) AS propietario_motor,
       obj_description(p.oid, 'pg_proc') AS descripcion
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname IN ('public', 'auditoria', 'dba');