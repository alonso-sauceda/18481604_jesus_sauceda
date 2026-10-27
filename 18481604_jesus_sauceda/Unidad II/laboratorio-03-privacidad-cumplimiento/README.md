# Laboratorio 03: Privacidad, Cumplimiento y Gobierno de Datos

## Descripción
Este laboratorio práctico aborda la implementación de controles técnicos en PostgreSQL para cumplir con principios fundamentales de privacidad y protección de datos, incluyendo la minimización, limitación de la finalidad y gobernanza de la información.

## Estructura del Repositorio

- **`sql/`**: Contiene los scripts SQL para la configuración de esquemas y controles de acceso.
  - `01-minimizacion.sql`: Creación de tablas y aplicación del principio de minimización.
  - `02-finalidad.sql`: Consultas de agregación y anonimización para analítica.
  - `03-control-acceso.sql`: Creación de vistas restrictivas y gestión de roles.
- **`evidencias/`**: Archivos Markdown documentando el análisis y las decisiones de diseño.
  - `01-inventario-datos.md`
  - `05-finalidad-secundaria.md`
  - `08-ciclo-vida.md`
  - `10-retencion.md`
  - `11-gobierno-datos.md`
  - `12-privacidad-diseno.md`
  - `14-evaluacion-integral.md`
  - `15-arquitectura.md`

## Ejecución
1. Conectarse a la instancia de PostgreSQL utilizando pgAdmin 4.
2. Abrir y ejecutar los scripts de la carpeta `sql/` en el orden numerado.
3. Consultar las evidencias documentales en la carpeta `evidencias/` para comprender el marco teórico y justificación de cada control técnico.