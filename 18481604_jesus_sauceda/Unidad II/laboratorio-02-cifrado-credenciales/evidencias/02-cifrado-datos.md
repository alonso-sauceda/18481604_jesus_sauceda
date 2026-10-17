# Evidencia 02: Cifrado de Información Sensible

## 8.2 Recuperar el dato

**Pregunta 1:** ¿Qué diferencia existe entre crypt() y pgp_sym_encrypt()?
**Respuesta:** `crypt()` es una función de hash unidireccional diseñada para contraseñas (no se puede revertir), mientras que `pgp_sym_encrypt()` realiza un cifrado simétrico bidireccional diseñado para proteger datos que necesitan ser recuperados posteriormente mediante una clave.

**Pregunta 2:** ¿Cuál de los dos mecanismos permite recuperar el dato original?
**Respuesta:** `pgp_sym_encrypt()` (junto con su función contraparte `pgp_sym_decrypt()`), ya que el cifrado está diseñado específicamente para que la información vuelva a ser legible cuando existe una autorización legítima.

**Pregunta 3:** ¿Qué ocurre si se utiliza una clave incorrecta?
**Respuesta:** La función `pgp_sym_decrypt()` fallará y arrojará un error indicando que los datos están corruptos o que la clave es incorrecta (`Wrong key or corrupt data`), impidiendo el acceso a la información original.

**Pregunta 4:** ¿Qué problema de seguridad representa colocar la clave directamente en una consulta?
**Respuesta:** Es una mala práctica conocida como "secreto en código fuente" (hardcoded secret). Si la consulta queda registrada en historiales (logs), scripts, repositorios de Git o respaldos, cualquier persona con acceso a esos archivos obtendrá la clave y podrá descifrar toda la información sensible.