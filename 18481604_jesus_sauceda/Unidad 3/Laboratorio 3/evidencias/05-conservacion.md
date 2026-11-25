# Actividad 5: Conservación, Retención y Disposición de Datos

## Matriz de Conservación y Retención

| Activo / Evidencia | Plazo activo | Plazo en archivo histórico | Justificación operativa / legal | Método de disposición o cierre |
|---|---|---|---|---|
| `public.clientes` (Datos fiscales y contacto) | Mientras exista relación comercial activa | 5 años posteriores a la baja del cliente | Obligaciones fiscales y de facturación (Código Fiscal / SAT) y atención a garantías. | Anonimización de datos personales (derechos ARCO) conservando IDs para integridad referencial. |
| `auditoria.cambios_clientes` | 12 meses en línea en el servidor | 4 años en respaldo histórico cifrado | Trazabilidad ante aclaraciones de clientes, auditorías internas y peritajes de incidentes. | Exportación archivada con firma SHA-256 y depuración controlada mediante ventana aprobada. |
| Bitácoras de PostgreSQL (`pg_log` / `E5`) | 90 días en disco del servidor | 12 meses en repositorio de seguridad | Investigación de accesos, cambios DDL y fallos operativos del motor. | Rotación automática y archivo comprimido con hash de integridad (`SHA-256`). |
| Respaldos lógicos (`pg_dump`) | 30 días (respaldos diarios/semanales) | 12 meses (cierre mensual) | Recuperación ante fallos lógicos, corrupción o borrados accidentales (`POL-02` / `POL-04`). | Sobrescritura rotativa segura tras verificar integridad del siguiente respaldo válido. |
| MongoDB `system.profile` | Rotación por tamaño (`capped collection`) | Exportación mensual a archivo de auditoría | Monitoreo de consultas y trazabilidad operativa en base documental. | Rotación automática del motor tras respaldo de evidencia. |

## Respuestas

1. **¿Por qué los registros de auditoría (`auditoria.cambios_clientes`) no deben borrarse aunque un cliente solicite cancelar su cuenta?**
   Porque la auditoría constituye evidencia legal y de control interno sobre qué operaciones ocurrieron y quién las autorizó. En caso de cancelación (derecho de cancelación/oposición ARCO), se anonimizan los datos personales en la tabla operativa tras vencer el plazo fiscal, pero se conserva el rastro de auditoría con acceso estrictamente restringido.
2. **¿Cómo se garantiza que una bitácora exportada (`E5-bitacora-postgresql.log`) no fue alterada después de su generación?**
   Calculando su resumen criptográfico (`SHA-256`) al momento de la extracción (`E5-bitacora-postgresql.sha256`) y resguardándolo por separado. Cualquier modificación de un solo carácter en el archivo `.log` invalida el hash.
