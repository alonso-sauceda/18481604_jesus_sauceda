# Evidencia 01: Protección de Credenciales

## 7.1 El problema
**Pregunta:** ¿Qué ocurriría si una persona obtiene acceso de lectura a esta tabla?
**Respuesta:** La persona podría ver las contraseñas en texto claro. Esto representa una vulnerabilidad crítica, ya que cualquier exposición o filtración de la base de datos se convierte inmediatamente en una exposición directa de credenciales, permitiendo el robo de cuentas.

## 7.3 Generar una representación no reversible
**Pregunta 1:** ¿Son iguales? 
**Respuesta:** No.

**Pregunta 2:** Si no son iguales, ¿por qué?
**Respuesta:** Porque cada vez que se ejecuta la función, se genera una "sal" (salt) aleatoria diferente. Al combinar esta sal distinta con la misma contraseña, el algoritmo produce un hash completamente diferente.

**Pregunta 3:** ¿Qué función cumple gen_salt()?
**Respuesta:** Genera un valor aleatorio (sal) que se combina con la contraseña antes de aplicar el algoritmo criptográfico. Esto asegura que contraseñas idénticas no generen el mismo hash y previene ataques mediante tablas precalculadas (rainbow tables).

**Pregunta 4:** ¿Qué función cumple crypt()?
**Respuesta:** Aplica una transformación matemática unidireccional para generar el hash de la contraseña utilizando la sal proporcionada. Es el encargado de realizar la derivación de la clave (password hashing).

**Pregunta 5:** ¿Esto es cifrado reversible?
**Respuesta:** No. Es una función de hash criptográfico unidireccional. Por diseño, es computacionalmente inviable revertir el proceso para obtener la contraseña original a partir del hash generado.

## 7.5 Verificar una contraseña
**Pregunta 1:** ¿Qué resultado obtuviste con la contraseña correcta?
**Respuesta:** Se obtuvo un resultado booleano verdadero (`true` o `t`), indicando que la comprobación fue exitosa.

**Pregunta 2:** ¿Qué resultado obtuviste con la contraseña incorrecta?
**Respuesta:** Se obtuvo un resultado booleano falso (`false` o `f`).

**Pregunta 3:** ¿Por qué no es necesario recuperar la contraseña original?
**Respuesta:** Porque para autenticar a un usuario solo se necesita verificar si la contraseña ingresada produce el mismo hash almacenado. La función `crypt()` extrae la sal del hash guardado, procesa el intento de contraseña y compara si los hashes coinciden, sin necesidad de conocer el texto claro original.

**Pregunta 4:** ¿Por qué un hash no debe confundirse con cifrado?
**Respuesta:** El cifrado es un proceso reversible bidireccional diseñado para proteger datos que necesitan recuperarse posteriormente utilizando una clave (como un RFC o un número de tarjeta). Un hash es una transformación matemática unidireccional diseñada precisamente para que la información original no pueda ser recuperada (como en el caso de las contraseñas).
