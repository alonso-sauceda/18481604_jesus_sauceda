# Evidencia 02: Análisis del Archivo Físico de Bitácora

**Estudiante:** Jesús Sauceda  
**Servidor:** PostgreSQL 18.6 (Local)  
**Base de datos:** comercial  

![Tráfico Auditado](img/03-trafico.png)

## 1. Archivo de Log Activo
`log/postgresql-2026-11-07_192329.log`

## 2. Verificación de Auditoría
Se confirma la captura exitosa de las operaciones DDL (`CREATE TABLE`) y DML (`INSERT`, `UPDATE`) dentro del archivo físico de log del servidor.