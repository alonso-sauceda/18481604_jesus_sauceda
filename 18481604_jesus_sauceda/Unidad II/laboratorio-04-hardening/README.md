# LAB-04: Hardening y Configuración Segura de PostgreSQL[cite: 28]

## Objetivo[cite: 28]
Aplicar un proceso integral de hardening sobre PostgreSQL 16[cite: 1], identificando configuraciones inseguras, reduciendo la superficie de exposición y estableciendo controles estrictos de acceso, autenticación y configuración segura[cite: 2].

## Entorno[cite: 28]
* **Motor:** PostgreSQL 16[cite: 1]
* **Servidor Académico:** `ficlabs` (Entorno compartido de la facultad)[cite: 35, 36]
* **Base de datos de trabajo:** `db_18481604_jesus_sauceda`[cite: 35]
* **Cliente:** pgAdmin 4 / Visual Studio Code[cite: 35]
* **Restricción de Entorno:** Cuenta de alumno compartida sin privilegios de `SUPERUSER`[cite: 35, 36].

## Superficie de ataque inicial[cite: 28]
Tras la inspección efectuada mediante los scripts SQL, se determinó la siguiente superficie de exposición inicial[cite: 3, 8]:
* **Puerto TCP:** `5432` activo[cite: 4, 38].
* **Escucha de Interfaces:** `'*'` (Escucha abierta)[cite: 4, 38].
* **Conexión de Sesión:** IP de origen `172.18.0.1` sin cifrado SSL/TLS activo (`ssl = false`)[cite: 21, 38].
* **Control de Sesiones Inactivas:** `idle_in_transaction_session_timeout = 0` (Sin límite de expiración para transacciones colgadas)[cite: 18, 40].
* **Límite de Conexiones:** `max_connections = 200`[cite: 18, 41].

## Hallazgos[cite: 28]
1. **Ausencia de TLS en Tránsito:** La conexión actual opera de forma no cifrada, exponiendo datos y credenciales a intercepción en red local[cite: 21, 38].
2. **Sesiones Inactivas Indefinidas:** La falta de timeout en transacciones inactivas permite el acaparamiento de recursos y bloqueos en la base de datos[cite: 18, 40].
3. **Reglas de Red Amplias en el Escenario:** Exposición a rangos `0.0.0.0/0` en entornos por defecto sin filtrado estricto por IP[cite: 8, 12, 13].
4. **Verificación Positiva:** El motor almacena contraseñas utilizando el algoritmo seguro `scram-sha-256`[cite: 15, 41].

## Cambios realizados[cite: 28]
* Se estructuraron los scripts SQL limpios (`sql/01-inspeccion.sql`, `sql/02-roles.sql`, `sql/03-configuracion.sql` y `sql/04-verificacion.sql`) adaptados a los permisos del entorno[cite: 27].
* Se definió la línea base de seguridad formal en `configuracion/baseline.md`[cite: 25, 27].
* Se documentó la matriz de cambios de estado inicial vs. estado hardening en `configuracion/cambios.md`[cite: 22, 27].
* Se elaboró el informe técnico y caso práctico integral en `informe.md`[cite: 23, 27, 30].

## Justificación de los cambios[cite: 28]
* **Restricción de `listen_addresses` y `pg_hba.conf`:** Minimiza la superficie de ataque perimetral reduciendo los vectores de acceso remoto no autorizados[cite: 3, 5, 12].
* **Implementación de SSL/TLS (`hostssl`):** Garantiza la confidencialidad e integridad del tráfico de datos en tránsito[cite: 15, 21].
* **Configuración de `idle_in_transaction_session_timeout`:** Protege la disponibilidad del servidor contra ataques de denegación de servicio por agotamiento de conexiones[cite: 18].
* **Separación de Roles (Mínimo Privilegio):** Evita que una vulnerabilidad en la capa de aplicación otorgue control total sobre el motor de BD[cite: 7, 16, 33].

## Verificación[cite: 28]
Se validaron los parámetros en pgAdmin comprobando[cite: 2, 26, 41]:
* Identificación de la versión del motor y parámetros de timeout (`04-verificacion.sql`)[cite: 27, 41].
* Monitoreo de sesiones activas mediante `pg_stat_activity` y `pg_stat_ssl`[cite: 8, 21, 38].
* Confirmación del mecanismo `scram-sha-256` para credenciales