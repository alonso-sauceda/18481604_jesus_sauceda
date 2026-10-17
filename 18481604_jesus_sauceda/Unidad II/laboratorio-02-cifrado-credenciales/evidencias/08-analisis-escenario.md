# Evidencia 08: Análisis de Escenario de Seguridad

## Pregunta 1: ¿Cuáles son los principales riesgos?
Exposición directa de contraseñas y datos personales por falta de cifrado en reposo, vulnerabilidad ante ataques en tránsito (*man-in-the-middle*), filtración de claves criptográficas por inclusión directa en scripts de repositorio, y pérdida de confidencialidad en copias de seguridad no protegidas.

## Pregunta 2: ¿Qué mecanismo utilizarías para cada elemento?
* **Contraseñas:** Derivación de claves con algoritmos de hash criptográfico (`bcrypt`/`Argon2id`).
* **RFC e Información financiera:** Cifrado simétrico en reposo (`pgp_sym_encrypt`).
* **Conexiones:** Configurar TLS con nivel de validación estricto (`verify-full`).
* **Claves criptográficas:** Almacenarlas en un administrador de secretos externo fuera del control de versiones.
* **Respaldos:** Cifrado de archivos mediante herramientas de respaldo seguro.

## Pregunta 3: ¿Cuál de los problemas consideras más crítico y por qué?
El almacenamiento de claves criptográficas dentro de archivos SQL y repositorios de código, ya que expone las herramientas necesarias para descifrar toda la información del sistema, invalidando cualquier otro esfuerzo de cifrado aplicado.

## Pregunta 4: ¿Tener correctamente configurados los usuarios y permisos elimina estos riesgos?
No. El control de acceso gestiona quién puede consultar o modificar ciertos objetos dentro de la base de datos, pero no protege la información si la base de datos es filtrada físicamente, si las conexiones de red son interceptadas o si los secretos están escritos dentro del código fuente.