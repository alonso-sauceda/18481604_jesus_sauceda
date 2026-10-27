# Evidencia 11: Matriz de Gobierno de Datos

## Objetivo
Diseñar una matriz de gobernanza de datos para formalizar los roles, responsabilidades, finalidades y controles técnicos sobre los campos de la tabla principal de clientes.

## Procedimiento
1. Se mapearon los datos de la entidad `clientes` con las áreas funcionales de la empresa.
2. Se asignaron los roles de Propietario del Dato (*Data Owner*) y Custodio (*Data Custodian*).
3. Se definieron los niveles de acceso y los controles técnicos aplicables a cada atributo.

## Resultado

| Dato | Finalidad | Responsable (Data Owner) | Usuarios Autorizados | Protección / Control Técnico |
| :--- | :--- | :--- | :--- | :--- |
| **nombre** | Identificación del cliente | Gerente de Ventas | Atención al Cliente, Facturación | Acceso vía Vistas / RLS |
| **correo** | Comunicación operativa | Gerente de Ventas | Atención al Cliente, Facturación | Enmascaramiento en pruebas |
| **telefono**| Soporte técnico | Jefe de Soporte | Atención al Cliente | Restricción por rol (`GRANT`) |
| **rfc** | Emisión de CFDI | Gerente de Finanzas | Facturación, Contabilidad | Cifrado / Restricción estricta |
| **edad** | Análisis demográfico | Gerente de Mercadotecnia | Analítica | Transformación a rangos |
| **ciudad** | Logística y envíos | Gerente de Operaciones | Analítica, Logística | Información agregada |
| **codigo_postal**| Zonificación | Gerente de Operaciones | Analítica, Logística | Consultas sin identificadores |

## Análisis
La asignación explícita de un *Data Owner* elimina la ambigüedad sobre quién autoriza el acceso a la información. El DBA actúa como Custodio (*Data Custodian*), ejecutando las restricciones técnicas pero no decidiendo sobre los permisos.

## Conclusión
La matriz de gobierno de datos estructura las políticas organizacionales dentro del motor de base de datos, garantizando que el acceso a la información esté determinado por la necesidad de negocio.