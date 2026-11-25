# Actividad 4: Inventario y Catálogo de Objetos de Datos

## Catálogo de Activos de Información (`comercial`)

| Esquema.Objeto | Tipo | Motor | Clasificación | Propietario (Negocio) | Custodio | Descripción operativa |
|---|---|---|---|---|---|---|
| `public.clientes` | Tabla | PostgreSQL | Confidencial (Datos personales) | Gerencia Comercial | DBA | Maestro de clientes de Comercializadora Norte (IDs 1–8). |
| `auditoria.cambios_clientes` | Tabla | PostgreSQL | Restringido (Auditoría) | Auditoría Interna | DBA | Bitácora inmutable de cambios `INSERT`, `UPDATE`, `DELETE` con `JSONB`. |
| `auditoria.fn_auditar_clientes()` | Función | PostgreSQL | Interno / Control | Auditoría Interna | DBA | Función `SECURITY DEFINER` que captura estado antes/después. |
| `trg_auditoria_clientes` | Disparador | PostgreSQL | Interno / Control | Auditoría Interna | DBA | Trigger `AFTER INSERT OR UPDATE OR DELETE` sobre `public.clientes`. |
| `dba.bitacora` | Vista | PostgreSQL | Restringido (Seguridad) | Seguridad de la Información | DBA | Vista sobre `pg_current_logfile()` para inspección controlada del log. |
| `comercial.clientes` | Colección | MongoDB | Confidencial (Datos personales) | Gerencia Comercial | DBA | Perfil de clientes en plataforma digital / tienda en línea. |
| `comercial.system.profile` | Colección | MongoDB | Restringido (Auditoría) | Seguridad de la Información | DBA | Registro de operaciones lentas o auditadas en MongoDB. |

## Respuestas
1. **¿Qué riesgo existe cuando se crean tablas o vistas temporales/de prueba sin registrarlas en el catálogo?**
   Se genera "datos ocultos" (*shadow data*): copias sin control de acceso ni enmascaramiento que pueden contener datos personales (RFC, correos, teléfonos) fuera del alcance de auditoría, aumentando el riesgo de fuga de información y desactualización frente a la fuente oficial.
2. **¿Por qué el catálogo debe incluir tanto tablas de negocio como objetos de control (`auditoria`, `dba`)?**
   Porque un cambio no autorizado en una función o vista de auditoría compromete la confiabilidad de todo el gobierno de datos. Inventariar ambos asegura que tengan propietario asignado, respaldos y revisión periódica.
