# Evidencia 01: Configuración Inicial de Bitácoras

**Estudiante:** Jesús Sauceda  
**Servidor:** PostgreSQL 18.6 (Local)  
**Base de datos:** comercial  

![Configuración Inicial](img/01-configuracion.png)

## 1. Salida de comandos ejecutados

```text
comercial=# SHOW logging_collector;
 logging_collector 
-------------------
 on

comercial=# SHOW log_directory;
 log_directory 
---------------
 log

comercial=# SHOW log_destination;
 log_destination 
-----------------
 stderr

comercial=# SHOW log_statement;
 log_statement 
---------------
 none

comercial=# SHOW log_min_messages;
 log_min_messages 
------------------
 warning