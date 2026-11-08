# Evidencia 03: Inspección de Bitácoras mediante SQL

**Estudiante:** Jesús Sauceda  
**Servidor:** PostgreSQL 18.6 (Local)  
**Base de datos:** comercial  

![Lectura de bitácora en SQL](img/04-lectura-sql.png)

## 1. Lectura Directa con Conversión WIN1252
```sql
SELECT convert_from(pg_read_binary_file('log/postgresql-2026-11-07_192329.log', 0, 2000), 'WIN1252');
```

## 2. Justificación Técnica
`convert_from` y `pg_read_binary_file` permiten leer logs en Windows sobre la sesión de SQL evitando conflictos de codificación por caracteres especiales (tildes o eñes).