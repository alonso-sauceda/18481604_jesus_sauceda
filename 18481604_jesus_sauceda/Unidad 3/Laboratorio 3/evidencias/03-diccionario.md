# Actividad 3: Diccionario de datos operativo

## Diccionario Extendido de `public.clientes`

| Columna | Clasificación (Unidad II) | Finalidad | Control aplicado | ¿Cambios auditados? | Regla de calidad |
|---|---|---|---|---|---|
| `id` | Interno / No sensible | Identificación única de registro | Llave primaria (`BIGSERIAL`), solo lectura para usuarios | Sí (`auditoria.cambios_clientes`) | No nulo, único, autoincremental |
| `nombre` | Dato personal (identificador) | Identificación del cliente | Acceso restringido por rol (`GRANT SELECT`) | Sí (`auditoria.cambios_clientes`) | Obligatorio (`NOT NULL`) |
| `correo` | Dato personal (contacto) | Notificaciones y comunicación | Enmascaramiento en vista de soporte (U2) | Sí (`auditoria.cambios_clientes`) | Obligatorio, único y formato válido (`@`) |
| `telefono` | Dato personal (contacto) | Contacto directo y soporte | Enmascaramiento en vista de soporte (U2) | Sí (`auditoria.cambios_clientes`) | Longitud a 10 dígitos numéricos |
| `rfc` | Dato personal (fiscal) | Facturación electrónica | Vista enmascarada para soporte (U2) + bitácora | Sí (`auditoria.cambios_clientes`) | Formato oficial SAT (12 o 13 caracteres) |
| `edad` | Dato personal (demográfico) | Analítica agregada de mercado | Acceso controlado por rol | Sí (`auditoria.cambios_clientes`) | Rango válido entre 18 y 120 años |
| `ciudad` | Dato personal (ubicación) | Segmentación geográfica y logística | Acceso controlado por rol | Sí (`auditoria.cambios_clientes`) | Catálogo de ciudades válidas |
| `codigo_postal` | Dato personal (ubicación) | Validación fiscal y logística | Acceso controlado por rol | Sí (`auditoria.cambios_clientes`) | Exactamente 5 dígitos numéricos |
| `fecha_alta` | Operativo / Interno | Trazabilidad de antigüedad | Valor por defecto automático (`CURRENT_DATE`) | Sí (`auditoria.cambios_clientes`) | Fecha válida no futura |
| `segmento` | Comercial / Interno | Clasificación de nivel de servicio | Modificable solo por `app_ventas` | Sí (`auditoria.cambios_clientes`) | Valores permitidos: Básico, Estándar, Premium |

## Respuestas

1. **¿Qué ventaja tiene guardar el significado en `COMMENT` en lugar de solo en un documento aparte?**
   Los metadatos semánticos viven integrados directamente dentro del catálogo del sistema (`pg_description`). Cualquier administrador, desarrollador o herramienta de inventario que inspeccione la base de datos (`\d+`, `information_schema` o `col_description`) obtiene el significado actualizado en tiempo real, evitando que la documentación quede desfasada, dispersa o perdida fuera del servidor.

2. **¿Quedaron registrados los `COMMENT` en la bitácora? ¿Con qué nivel de `log_statement`?**
   Sí, quedaron registrados en la bitácora del servidor. En PostgreSQL, la instrucción `COMMENT` pertenece a las sentencias de definición de datos (DDL), por lo que se registra a partir del nivel `log_statement = 'ddl'` (y también con `'mod'` y `'all'`, ya que los niveles son acumulativos; como nuestro servidor tiene activo `'mod'`, las sentencias quedaron asentadas).

3. **¿Qué información del diccionario debe mantenerse fuera del motor? ¿Por qué?**
   Deben mantenerse fuera del motor los detalles de controles de seguridad (como qué roles tienen acceso a vistas enmascaradas), políticas internas de retención, procedimientos de respuesta a incidentes y reglas de negocio extensas. En PostgreSQL, las tablas del catálogo (`pg_description`) son legibles por cualquier usuario conectado (`PUBLIC`), por lo que almacenar ahí la arquitectura de seguridad expondría información útil para un atacante y saturaría los metadatos técnicos.