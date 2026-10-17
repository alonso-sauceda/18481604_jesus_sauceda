# Evidencia 07: Comparación de Mecanismos de Protección

| Situación | Mecanismo apropiado | ¿Qué protege? |
| :--- | :--- | :--- |
| **Contraseña de usuario** | Hash / Derivación de claves (`crypt` / `bcrypt`) | Credenciales en reposo (protección no reversible) |
| **RFC almacenado en una tabla** | Cifrado simétrico (`pgp_sym_encrypt`) | Datos sensibles en reposo que requieren recuperación |
| **Consulta enviada desde un cliente al servidor** | TLS (`sslmode=verify-full`) | Datos en tránsito (confidencialidad e integridad en la red) |
| **Respaldo de una base de datos** | Cifrado de archivos / Cifrado de respaldos | Archivos físicos en reposo ante accesos no autorizados |
| **Clave criptográfica** | Gestor de secretos (Vault / Módulo KMS) | Secretos y claves de cifrado de forma centralizada |# Evidencia 07: Comparación de Mecanismos de Protección

| Situación | Mecanismo apropiado | ¿Qué protege? |
| :--- | :--- | :--- |
| **Contraseña de usuario** | Hash / Derivación de claves (`crypt` / `bcrypt`) | Credenciales en reposo (protección no reversible) |
| **RFC almacenado en una tabla** | Cifrado simétrico (`pgp_sym_encrypt`) | Datos sensibles en reposo que requieren recuperación |
| **Consulta enviada desde un cliente al servidor** | TLS (`sslmode=verify-full`) | Datos en tránsito (confidencialidad e integridad en la red) |
| **Respaldo de una base de datos** | Cifrado de archivos / Cifrado de respaldos | Archivos físicos en reposo ante accesos no autorizados |
| **Clave criptográfica** | Gestor de secretos (Vault / Módulo KMS) | Secretos y claves de cifrado de forma centralizada |