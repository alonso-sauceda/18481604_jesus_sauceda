-- Documentación de la tabla y columnas en el catálogo del motor
COMMENT ON TABLE public.clientes IS 'Clientes de Comercializadora Norte. Propietario: Gerencia Comercial. Custodio: DBA. Clasificación: confidencial (contiene datos personales).';

COMMENT ON COLUMN public.clientes.id IS 'Identificador interno del cliente. Generado por el sistema.';
COMMENT ON COLUMN public.clientes.nombre IS 'Nombre completo. Dato personal identificador directo.';
COMMENT ON COLUMN public.clientes.correo IS 'Correo de contacto. Dato personal. Uso: notificaciones al cliente.';
COMMENT ON COLUMN public.clientes.telefono IS 'Teléfono de contacto. Dato personal. Uso: seguimiento comercial y soporte.';
COMMENT ON COLUMN public.clientes.rfc IS 'RFC del cliente. Dato personal. Uso: facturación. Cambios auditados en auditoria.cambios_clientes.';
COMMENT ON COLUMN public.clientes.edad IS 'Edad en años cumplidos. Dato personal. Uso: analítica agregada.';
COMMENT ON COLUMN public.clientes.ciudad IS 'Ciudad de residencia o domicilio fiscal. Dato de ubicación. Uso: segmentación geográfica y logística.';
COMMENT ON COLUMN public.clientes.codigo_postal IS 'Código postal del cliente. Dato de ubicación. Uso: validación fiscal y envíos.';
COMMENT ON COLUMN public.clientes.fecha_alta IS 'Fecha de registro del cliente en el sistema. Metadato operativo generado automáticamente.';
COMMENT ON COLUMN public.clientes.segmento IS 'Clasificación comercial del cliente (Básico, Estándar, Premium). Uso: estrategias de venta.';

-- Consulta del diccionario operativo desde el motor
SELECT c.ordinal_position AS pos,
       c.column_name AS columna,
       c.data_type AS tipo,
       c.character_maximum_length AS longitud,
       c.is_nullable AS acepta_nulos,
       c.column_default AS valor_por_defecto,
       col_description('public.clientes'::regclass, c.ordinal_position) AS descripcion
FROM information_schema.columns c
WHERE c.table_schema = 'public'
  AND c.table_name = 'clientes'
ORDER BY c.ordinal_position;