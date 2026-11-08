Alumno2026
# Informe Ejecutivo: Auditoría y Bitácoras en PostgreSQL (Laboratorio 1)

**Estudiante:** Jesús Sauceda  
**Materia:** Administración de Bases de Datos  
**Motor:** PostgreSQL 18.6 (Local)  

---

## 1. Resumen Ejecutivo
Se configuró y validó el sistema de auditoría en un servidor PostgreSQL local. Se corrigió el parámetro `log_statement = 'none'` cambiando a `'all'` para garantizar el registro continuo de todas las sentencias DDL y DML.

## 2. Diagnóstico y Cambios Aplicados
* Habilitación de registro completo (`log_statement = 'all'`).
* Formateo de línea con metainformación de tiempo, PID, usuario y aplicación (`log_line_prefix = '%m [%p] %u@%d %a '`).

## 3. Conclusión
El sistema registra y permite auditar eventos críticos directamente desde consultas SQL (`pg_ls_logdir`, `pg_read_binary_file`), asegurando la trazabilidad de operaciones.