# Línea Base de Seguridad (Baseline) - PostgreSQL 16

Este documento define la línea base de seguridad recomendada para la instancia de PostgreSQL, estableciendo los parámetros y controles necesarios para reducir la superficie de ataque en el entorno de Comercializadora Norte S.A. de C.V.

## 1. Configuración de Red y Acceso
* **Interfaces de escucha (`listen_addresses`)**: Configurar únicamente en la IP de la interfaz interna/privada o `localhost` (`127.0.0.1`). Evitar el uso de `'*'`.
* **Puerto del servicio (`port`)**: Mantener el puerto TCP `5432` documentado internamente o cambiar a un puerto no estándar únicamente para reducir ruido en escaneos masivos, respaldado siempre por reglas de firewall.
* **Control por Red (Firewall)**: Restringir el tráfico al puerto `5432` permitiendo únicamente conexiones desde la subred de servidores de aplicación y la red de administración DBA.
* **Archivo `pg_hba.conf`**:
  * Aplicar el principio de mínimo privilegio.
  * Prohibir rangos globales como `0.0.0.0/0` o `::/0`.
  * Especificar `HOST`, `DATABASE`, `USER`, `ADDRESS` y `METHOD` para cada regla.

## 2. Autenticación y Cifrado
* **Cifrado de contraseñas (`password_encryption`)**: Obligatorio `scram-sha-256`. Módulos heredados como `md5` o `plaintext` quedan prohibidos.
* **Comunicaciones Seguras (`ssl`)**: Habilitado (`ssl = on`) exigiendo protocolo mínimo TLSv1.2 (`ssl_min_protocol_version = 'TLSv1.2'`).
* **Canal Cifrado**: Exigir conexiones SSL en `pg_hba.conf` mediante directivas `hostssl`.

## 3. Gestión de Roles y Autorización
* **Separación de Funciones**:
  * **Cuentas DBA**: Privilegios administrativos completos (`SUPERUSER`), de uso exclusivo para mantenimiento.
  * **Cuentas de Aplicación**: Acceso restringido a tablas del sistema mediante roles específicos con permisos DML (`SELECT`, `INSERT`, `UPDATE`, `DELETE`). Queda prohibido usar cuentas `SUPERUSER` para conectar aplicaciones.
  * **Cuentas de Consulta / Analistas**: Acceso exclusivo de lectura (`SELECT`) a vistas o esquemas autorizados.

## 4. Parámetros de Sesión y Recursos
* **Número de Conexiones (`max_connections`)**: Ajustado al dimensionamiento real (ej. 100-200), reservando conexiones para administración (`superuser_reserved_connections = 3`).
* **Tiempos de Espera (Timeouts)**:
  * `statement_timeout = 30000` (30 segundos máximo por consulta).
  * `idle_in_transaction_session_timeout = 60000` (60 segundos máximo para transacciones inactivas).

## 5. Sistema Operativo y Almacenamiento
* **Propietario de Procesos**: Ejecución bajo la cuenta dedicada del sistema operativo `postgres`.
* **Permisos de Archivos**:
  * Directorio de datos (`data_directory`): Permisos `0700` (`drwx------`).
  * Archivos de configuración (`postgresql.conf`, `pg_hba.conf`): Permisos `0600` (`-rw-------`).