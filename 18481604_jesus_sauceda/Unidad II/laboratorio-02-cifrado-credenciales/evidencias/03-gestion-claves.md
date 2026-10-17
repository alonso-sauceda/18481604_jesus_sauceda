# Evidencia 03: Gestión de Claves

## 9.1 Identificar una mala práctica
**Pregunta:** ¿Qué ocurriría si esta clave fuera una clave utilizada realmente por una organización y el archivo se publicara en un repositorio Git?

**Respuesta:**
Si la clave se publica en un repositorio Git, queda expuesta a cualquier persona con acceso al código o al historial de commits. Un atacante con acceso a la base de datos (o a un respaldo de la misma) podría utilizar esa clave para descifrar inmediatamente toda la información sensible almacenada (como RFCs, tarjetas o datos personales), anulando por completo la protección brindada por el cifrado.

## 9.2 Regla del laboratorio
Las claves criptográficas, contraseñas, tokens y secretos nunca deben escribirse directamente en los scripts ni almacenarse en repositorios de código. Para la realización de estas prácticas únicamente se utilizan claves ficticias de prueba.