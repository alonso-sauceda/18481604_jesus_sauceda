# Actividad 2: Responsables y Segregación de Funciones

## Matriz de Responsabilidades (`comercial`)

| Rol / Área | Tipo de responsabilidad | Alcance / Permisos | Restricciones |
|---|---|---|---|
| **Gerencia Comercial** | Propietario del dato (*Data Owner*) | Define reglas de negocio, calidad y autorización de cambios en `clientes`. | No ejecuta cambios técnicos directos en el motor. |
| **Seguridad de la Información** | Normativa / Vigilancia | Define políticas de acceso, auditoría, bitácoras y datos sensibles (`POL-01`–`POL-06`). | Supervisa cumplimiento sin operar DML de negocio. |
| **Auditoría Interna** | Control / Revisión | Revisa `auditoria.cambios_clientes`, conciliaciones y trazabilidad de incidentes. | Consulta de auditoría; no altera registros históricos. |
| **DBA (`postgres`)** | Custodio técnico (*Data Steward* / Admin) | Mantiene motor, respaldos, esquemas (`auditoria`, `dba`), vistas y controles. | Prohibido corregir datos de negocio sin aprobación del propietario. |
| **`app_ventas`** | Rol de aplicación | `SELECT` y `UPDATE` sobre `public.clientes`. | Sin `DELETE`, sin `DROP` ni acceso a esquemas de control. |
| **`soporte_ana`** | Rol de soporte | Consulta controlada (vista enmascarada `vw_clientes_soporte` / `SELECT`). | Sin permisos de escritura (`INSERT`, `UPDATE`, `DELETE`). |

## Respuestas
1. **¿Por qué el rol de aplicación (`app_ventas`) no debe tener privilegios de superusuario ni acceso directo a esquemas de administración?**
   Bajo el principio de mínimo privilegio, si la aplicación se ve comprometida, un rol con permisos excesivos o acceso a esquemas de control permitiría alterar auditorías, borrar datos o escalar privilegios.
2. **¿Qué ventaja tiene separar al propietario del dato del custodio técnico?**
   Evita decisiones unilaterales sobre el valor de negocio de los datos y crea controles cruzados: el negocio decide qué es válido o qué cambio procede, y el custodio garantiza la integridad técnica y la trazabilidad.
