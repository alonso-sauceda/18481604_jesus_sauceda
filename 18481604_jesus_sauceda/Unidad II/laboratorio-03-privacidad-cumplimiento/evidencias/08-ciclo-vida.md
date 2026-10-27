# Evidencia 08: Derecho de Cancelación y Ciclo de Vida de los Datos

## Objetivo
Analizar las implicaciones técnicas y arquitectónicas del derecho de cancelación (ARCO) sobre el ciclo de vida completo de la información en una base de datos relacional y sus sistemas periféricos.

## Procedimiento
1. Se analizó el caso en el que un cliente solicita la cancelación de sus datos personales.
2. Se construyó el mapa de dispersión de la información a través de los diferentes componentes de la infraestructura tecnológica.
3. Se evaluaron las restricciones de integridad referencial y las políticas de purga en respaldos, réplicas y ambientes no productivos.

## Resultado

### Mapa de Dispersión de la Información
```text
[ Base de Datos Producción (tabla: clientes) ]
       │
       ├──► [ Respaldos Físicos y Lógicos (WAL, dump files) ]
       ├──► [ Réplicas de Lectura (Standby Nodes) ]
       ├──► [ Vistas y Tablas de Reportes (Data Warehouse / Analítica) ]
       ├──► [ Archivos Exportados (CSV, Excel en repositorios locales) ]
       └──► [ Sistemas Externos (CRMs, Plataformas de Email Marketing) ]