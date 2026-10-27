# Evidencia 15: Arquitectura de Privacidad de Datos

## Objetivo
Diseñar un modelo arquitectónico que integre los controles de privacidad y gobernanza directamente en las capas de datos, separando las cargas transaccionales de las analíticas.

## Procedimiento
1. Se esquematizó el flujo de datos desde la captura transaccional hasta la explotación analítica.
2. Se definieron las fronteras de seguridad y los mecanismos de intercambio de información.
3. Se integraron los conceptos de vistas seguras, roles de solo lectura y enmascaramiento.

## Resultado

### Diagrama Lógico de Arquitectura
```text
[ Aplicación Transaccional ] -> (Inserta datos completos) -> [ Tabla: clientes ]
                                                                     |
                                                                     +--> [ Vista: clientes_soporte ] -> [ Rol: Soporte ]
                                                                     |
[ Proceso ETL / Cron ] -> (Anonimización / Agregación) -> [ Vista: v_analitica_clientes ] -> [ Rol: Analista ]