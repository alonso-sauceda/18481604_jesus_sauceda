# Laboratorio 02: Cifrado, Credenciales y Comunicaciones Seguras

**Estudiante:** Jesús Alonso Sauceda Soto  
**Matrícula:** 18481604  
**Materia:** DBA 

---

## 1. Introducción
En esta práctica se analizaron e implementaron mecanismos criptográficos dentro de PostgreSQL para abordar los problemas de almacenamiento inseguro de credenciales, protección de datos sensibles en reposo y verificación de la seguridad en las comunicaciones entre cliente y servidor.

## 2. Protección de Credenciales
Se demostró que almacenar contraseñas en texto claro expone directamente las credenciales ante lecturas no autorizadas. Para evitar esto, se utilizó la extensión `pgcrypto` con las funciones `crypt()` y `gen_salt('bf')`, aplicando un algoritmo de hash con sal para asegurar que las contraseñas no puedan ser recuperadas directamente ni atacadas mediante tablas precalculadas.

## 3. Protección de Datos Sensibles
A diferencia de las contraseñas, ciertos datos como el RFC requieren ser recuperados en texto claro por usuarios autorizados. Se utilizó cifrado simétrico mediante `pgp_sym_encrypt()` y `pgp_sym_decrypt()`, garantizando la confidencialidad en reposo mediante una clave criptográfica.

## 4. TLS (Transport Layer Security)
Se consultó la vista `pg_stat_ssl` y parámetros del servidor para verificar el estado de cifrado en tránsito. Se identificó que TLS protege la comunicación contra intercepciones y modificaciones, diferenciando el cifrado en tránsito de las políticas de control de acceso.

## 5. Gestión de Claves
Se analizó el riesgo de la mala práctica "secreto en código fuente" (hardcoded secret). Incluir claves en scripts o repositorios compromete la seguridad del sistema independientemente del algoritmo utilizado.

## 6. Resultados
* Creación de la estructura de tablas para credenciales encriptadas y datos cifrados.
* Verificación exitosa de autenticación con hash booleano sin revertir la contraseña.
* Cifrado y descifrado del campo RFC mediante `pgcrypto`.
* Evaluación del estado de TLS en la sesión actual de la base de datos.

## 7. Problemas Encontrados
Al ejecutar comandos de inspección como `SHOW ssl_min_protocol_version;`, el motor devolvió un error de privilegios insuficientes (`pg_read_all_settings`), lo cual es esperado al trabajar con un usuario de nivel estudiante en un servidor administrado.

## 8. Conclusiones
La protección de una base de datos exige un enfoque integral: las contraseñas deben procesarse mediante funciones de derivación unidireccionales (hash), los datos recuperables mediante cifrado simétrico, las conexiones a través de TLS y las claves criptográficas gestionadas en un almacén de secretos independiente.

---

## Preguntas de Reflexión

1. **¿Por qué una contraseña no debe almacenarse como texto claro?**  
   Porque cualquier acceso o filtración a la base de datos expone directamente las cuentas de los usuarios.

2. **¿Por qué un hash no es equivalente a un cifrado?**  
   Un hash es una función unidireccional no reversible para verificar datos, mientras que el cifrado es una operación bidireccional diseñada para recuperar el texto original mediante una clave.

3. **¿Por qué el cifrado de una columna no sustituye al control de acceso?**  
   El control de acceso determina qué usuarios tienen permiso de consulta; el cifrado asegura que, aun obteniendo los datos, estos permanezcan ilegibles sin la clave correspondiente.

4. **¿Por qué TLS no sustituye a los mecanismos de autorización de PostgreSQL?**  
   TLS protege la vía de comunicación (datos en tránsito), pero no gestiona los permisos de los usuarios sobre las tablas u objetos dentro del motor.

5. **¿Qué ocurriría si una organización pierde una clave utilizada para cifrar información?**  
   La información cifrada con esa clave se volverá permanentemente inaccesible e irrecuperable.

6. **¿Qué ocurriría si una clave criptográfica se publica accidentalmente en GitLab?**  
   Cualquier persona con acceso al historial del repositorio podrá usarla para descifrar los datos protegidos.

7. **¿Por qué un repositorio privado no debe considerarse un almacén de secretos?**  
   Porque los repositorios mantienen un historial de commits donde las claves permanecen guardadas, además de estar expuestas a todos los miembros con acceso al código.

8. **¿Qué diferencia existe entre proteger información almacenada y proteger información durante su transmisión?**  
   La protección en reposo asegura archivos y tablas físicas en disco; la protección en tránsito (TLS) asegura los datos mientras viajan por la red.

9. **¿Por qué la gestión de claves es tan importante como el algoritmo criptográfico?**  
   Un algoritmo fuerte es inútil si la clave que lo controla es expuesta, extraviada o administrada en texto claro.

10. **¿Qué mecanismo adicional implementarías en una organización para proteger los respaldos de las bases de datos?**  
    Cifrado de archivos de respaldo (*backup encryption*) antes de transferirlos a medios de almacenamiento o servicios en la nube.