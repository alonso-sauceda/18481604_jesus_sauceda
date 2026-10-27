# Evidencia 12: Análisis de Privacidad por Diseño y por Defecto

## Objetivo
Evaluar una propuesta de diseño de base de datos identificando violaciones a los principios de privacidad desde la etapa de concepción y proponer una estructura optimizada.

## Procedimiento
1. Se analizó el esquema propuesto por desarrollo que incluía campos como `salario`, `estado_civil`, `ocupacion` y `fecha_nacimiento` sin justificación.
2. Se respondieron los cuestionamientos de auditoría de privacidad.
3. Se aplicaron los principios de Privacidad por Diseño y Privacidad por Defecto.

## Resultado

### Respuestas al Cuestionamiento de Diseño
1. **¿Qué problemas identificas?**  
   Acumulación excesiva de datos personales sensibles (salario, estado civil) sin un propósito de negocio definido, incrementando el riesgo ante una brecha.

2. **¿Qué principio de privacidad se está ignorando?**  
   Los principios de Minimización de Datos y Proporcionalidad.

3. **¿Qué preguntas realizarías antes de aprobar el diseño?**  
   * ¿Para qué proceso de negocio específico se requiere capturar el `salario` y `estado_civil`?
   * ¿Existe una obligación legal que exija recabar la `fecha_nacimiento` completa?

4. **¿Qué datos eliminarías?**  
   `salario`, `estado_civil`, `ocupacion` y `direccion` detallada (si solo se requiere zona logística).

5. **¿Qué datos requerirían una justificación adicional?**  
   `fecha_nacimiento` (reemplazar por confirmación booleana de edad) y `rfc` (solicitar solo al facturar).

6. **¿Cómo aplicarías privacidad por defecto?**  
   Configurando el esquema para que únicamente capture los datos indispensables para crear la cuenta.

## Análisis
Almacenar datos "por si se necesitan" vulnera el principio de Privacidad por Diseño. Las bases de datos deben estructurarse limitando los atributos expuestos.

## Conclusión
Implementar privacidad por defecto desde el Modelado Entidad-Relación reduce costos de cumplimiento y protege la información del titular.