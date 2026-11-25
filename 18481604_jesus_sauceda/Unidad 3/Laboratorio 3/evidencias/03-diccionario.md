# Actividad 3: Diccionario de Datos Operativo (`public.clientes`)

## Documentación en Catálogo (`COMMENT ON`)
Las descripciones de `public.clientes` y sus columnas se registraron directamente en el catálogo de PostgreSQL (`pg_description`) y se exportaron a `evidencias/diccionario-clientes.csv`.

## Clasificación y Uso de Columnas

| Columna | Clasificación | Sensibilidad / Privacidad | Uso operativo |
|---|---|---|---|
| `id` | Identificador interno | Interno | Clave primaria (`BIGSERIAL`) del cliente. |
| `nombre` | Dato personal directo | Confidencial | Identificación del cliente. |
| `correo` | Dato de contacto personal | Confidencial | Notificaciones y comunicación. |
| `telefono` | Dato de contacto personal | Confidencial | Seguimiento comercial y soporte. |
| `rfc` | Dato fiscal / personal | Confidencial | Facturación; cambios auditados en `auditoria.cambios_clientes`. |
| `edad` | Dato demográfico / personal | Confidencial | Segmentación y analítica. |
| `ciudad` | Ubicación | Interno / Restringido | Segmentación geográfica y logística. |
| `codigo_postal` | Ubicación | Interno / Restringido | Validación de domicilio y envíos. |
| `fecha_alta` | Metadato operativo | Interno | Fecha de registro (`DEFAULT CURRENT_DATE`). |
| `segmento` | Clasificación comercial | Interno | Categoría del cliente (`Básico`, `Estándar`, `Premium`). |

## Respuestas
1. **¿Por qué conviene guardar la documentación de columnas dentro del motor (`COMMENT ON`) y no solo en un documento externo?**
   Porque viaja con el esquema de la base de datos, puede consultarse en cualquier momento desde `information_schema` / `pg_description` y reduce el riesgo de que el diccionario quede desactualizado respecto a la tabla real.
2. **¿Qué aporta el archivo CSV (`diccionario-clientes.csv`) junto con el diccionario en el motor?**
   Facilita la revisión, auditoría y compartición tabular del catálogo de columnas sin necesidad de abrir una sesión interactiva en `psql`.
