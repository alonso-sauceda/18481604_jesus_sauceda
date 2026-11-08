# Laboratorio 1: Bitácoras y Auditoría en PostgreSQL

**Estudiante:** Jesús Sauceda  
**Materia:** Administración de Bases de Datos  
**Unidad:** Unidad 3 - Bitácoras y Auditoría  
**Entorno:** PostgreSQL 18.6 (Local)  

---

## 📌 Descripción del Proyecto

En este laboratorio se realiza la configuración, generación de tráfico y análisis del colector de bitácoras (*logging collector*) en PostgreSQL 18.6. Se diagnostican los parámetros iniciales del servidor, se habilita la auditoría completa de sentencias SQL (`log_statement = 'all'`) con formateo de línea (`log_line_prefix`), y se implementa la lectura directa de los archivos de registro mediante funciones SQL nativas.

---

## 📁 Estructura del Repositorio

```text
Laboratorio 1/
├── sql/
│   ├── 01-colector-y-vista.sql        # Diagnóstico inicial y consultas de lectura SQL
│   ├── 02-configuracion-bitacora.sql  # Modificación de parámetros ALTER SYSTEM
│   └── 03-trafico-auditado.sql        # Tráfico de prueba (DDL, DML y log activo)
├── evidencias/
│   ├── img/                           # Capturas de pantalla de la terminal
│   │   ├── 01-configuracion.png
│   │   ├── 02-configuracion.png
│   │   ├── 03-trafico.png
│   │   └── 04-lectura-sql.png
│   ├── 01-configuracion-inicial.md    # Evidencia 1: Parámetros SHOW por defecto
│   ├── 02-analisis-bitacora.md        # Evidencia 2: Inspección de log físico
│   ├── 03-vista-bitacora.md           # Evidencia 3: Lectura binaria convertida en SQL
│   └── 04-configuracion-bitacora.md   # Evidencia 4: Ajustes globales de auditoría
├── informe.md                         # Informe ejecutivo final de la práctica
└── README.md                          # Guía e índice del laboratorio
```

---

## 🚀 Resumen de Actividades Ejecutadas

1. **Diagnóstico Inicial:** Evaluación de `logging_collector`, `log_directory`, `log_destination`, `log_statement` y `log_min_messages`.
2. **Configuración de Auditoría:** Ajuste global de `log_statement` a `'all'` y prefijo `%m [%p] %u@%d %a ` recargado con `SELECT pg_reload_conf()`.
3. **Generación de Tráfico:** Ejecución de operaciones `CREATE TABLE`, `INSERT`, `UPDATE` y localización del archivo de log activo con `pg_current_logfile()`.
4. **Inspección SQL:** Consulta mediante `pg_ls_logdir()` y resolución del error de codificación Windows `WIN1252` con `convert_from(pg_read_binary_file(), 'WIN1252')`.