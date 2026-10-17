# Evidencia 04: Verificación de TLS

## 11.1 Verificar la conexión actual

**Pregunta 1:** ¿La conexión actual utiliza TLS?
**Respuesta:** No. Al consultar la vista `pg_stat_ssl` para la sesión actual, la columna `ssl` arrojó el valor `false`.

**Pregunta 2:** ¿Qué versión de TLS se está utilizando?
**Respuesta:** Aparece como `[null]`, debido a que la conexión no se estableció mediante una sesión protegida con SSL/TLS.

**Pregunta 3:** ¿Qué algoritmo de cifrado aparece?
**Respuesta:** Aparece como `[null]`, por la misma razón de no existir una sesión cifrada activa.

**Pregunta 4:** ¿Qué diferencia existe entre una conexión protegida con TLS y una conexión sin TLS?
**Respuesta:** Una conexión sin TLS (texto claro) transmite todas las consultas, credenciales y datos entre el cliente y el servidor en plano, permitiendo que un tercero analice o intercepte el tráfico de red. Una conexión protegida con TLS aplica cifrado en tránsito, garantizando la confidencialidad, la integridad de los datos y la autenticación del servidor.