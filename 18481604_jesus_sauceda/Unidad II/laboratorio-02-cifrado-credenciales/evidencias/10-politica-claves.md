# Evidencia 10: Política Mínima de Protección de Claves

1. **Generación:** Las claves criptográficas deben ser generadas utilizando un generador de números pseudoaleatorios criptográficamente seguro (CSPRNG) con la longitud requerida por el algoritmo.
2. **Almacenamiento:** Ninguna clave criptográfica debe almacenarse en el código fuente, scripts SQL ni dentro de repositorios de control de versiones.
3. **Acceso:** El acceso a las claves se limitará exclusivamente a los servicios y procesos autorizados bajo el principio de mínimo privilegio.
4. **Rotación:** Las claves criptográficas de producción deberán rotarse periódicamente de manera planificada y según las políticas de seguridad vigentes.
5. **Respaldo:** Los respaldos de las claves deben almacenarse de forma cifrada en ubicaciones físicamente separadas de la base de datos.
6. **Revocación:** Debe contarse con un procedimiento inmediato de revocación de claves en caso de sospecha o confirmación de compromiso.
7. **Exposición accidental:** Cualquier clave que haya sido publicada o expuesta accidentalmente en un repositorio o registro de auditoría debe ser revocada y reemplazada de inmediato.
8. **Eliminación:** La destrucción de claves fuera de uso se realizará mediante procedimientos seguros de borrado criptográfico que impidan su recuperación.