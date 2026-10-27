# Registro de Cambios de Hardening (Estado Inicial vs. Estado Final)

Este documento detalla las modificaciones conceptuales y configuraciones analizadas durante el proceso de hardening en la instancia de PostgreSQL.

| Parámetro / Control | Estado Inicial (Inspeccionado) | Estado Propuesto (Hardened) | Justificación Técnica del Cambio |
| :--- | :--- | :--- | :--- |
| **`listen_addresses`** | `'*'` (Escucha en todas las interfaces) | `'localhost'` o IP de red privada | Evita la exposición innecesaria del servicio a redes públicas o no confiables. |
| **`pg_hba.conf`** | Contiene reglas permisivas (`0.0.0.0/0`) | Reglas específicas por IP y BD (`hostssl app_db app_user 10.10.10.0/24 scram-sha-256`) | Aplica el principio de mínimo privilegio en el control de acceso a nivel de red. |
| **`password_encryption`** | `scram-sha-256` | `scram-sha-256` | Se verifica y ratifica el esquema de hash criptográfico más seguro soportado por PostgreSQL. |
| **`ssl`** | `off` / No forzado en cliente | `on` (con `hostssl` obligatorio) | Protege la confidencialidad de las credenciales y datos en tránsito mediante TLS. |
| **Cuentas de Aplicación** | Uso potencial de cuentas elevadas | Roles dedicados sin `SUPERUSER` | Mitiga el impacto en caso de que la aplicación sufra una inyección SQL o sea comprometida. |
| **`idle_in_transaction_session_timeout`** | `0` (Inseguro / Sin límite) | `60000` (60 segundos) | Evita el acaparamiento de bloqueos (*locks*) y agotamiento de la tabla de conexiones por transacciones colgadas. |
| **Permisos SO (`pg_hba.conf`)** | Permisivos / No verificados | `0600` (Exclusivo para usuario `postgres`) | Previene la lectura de hashes o la modificación maliciosa de reglas por otros usuarios del SO. |