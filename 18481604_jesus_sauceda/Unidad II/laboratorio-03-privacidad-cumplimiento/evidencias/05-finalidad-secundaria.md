# Evidencia 05: Análisis de Finalidad Secundaria

## Objetivo
Evaluar las implicaciones técnicas, legales y de privacidad al utilizar los datos de clientes para una finalidad secundaria distinta a la original, como el envío de promociones personalizadas.

## Procedimiento
1. Se analizó la propuesta de Marketing para utilizar `edad`, `ciudad` y comportamiento de compra con fines comerciales.
2. Se evaluaron las preguntas de gobernanza de datos para determinar si se cuenta con base jurídica e infraestructura adecuada.
3. Se definieron los controles técnicos para limitar la exposición de datos personales hacia áreas comerciales.

## Resultado

### Respuestas al análisis de finalidad secundaria

1. **¿El hecho de que la organización ya tenga los datos significa automáticamente que puede utilizarlos para cualquier finalidad?**  
   No. El principio de limitación de la finalidad establece que los datos recopilados para un propósito específico (p. ej., prestar un servicio o emitir una factura) no pueden ser utilizados para finalidades secundarias (p. ej., marketing) sin el consentimiento explícito del titular o un aviso de privacidad que lo contemple de origen.

2. **¿Qué preguntas debería realizar la organización antes de implementar este tratamiento?**  
   * ¿El aviso de privacidad contempla el envío de mercadotecnia personalizada?
   * ¿Se ha proporcionado al titular un mecanismo sencillo para otorgar o rechazar su consentimiento (Opt-in / Opt-out)?
   * ¿Existe el riesgo de reidentificación o discriminación basada en los patrones analizados?

3. **¿Qué datos serían realmente necesarios?**  
   Únicamente identificadores anonimizados o seudonimizados, ciudad, rango de edad y preferencias de categoría de producto. No se requiere el nombre completo, RFC ni teléfono directo.

4. **¿Necesitaría el área de marketing acceso directo a clientes?**  
   No. El área de marketing no debe consultar la tabla operativa `clientes`. Debe trabajar con vistas preparadas o tablas de campañas que contengan solo identificadores de comunicación consentidos.

5. **¿Qué controles técnicos podrían limitar la información entregada?**  
   * Creación de **vistas filtradas** que expongan únicamente usuarios con bandera de consentimiento explícito (`opt_in_marketing = TRUE`).
   * Aplicación de **enmascaramiento dinámico** sobre el correo electrónico o el teléfono en entornos de segmentación.

## Análisis
La reutilización de información operativa para fines promocionales sin controles de consentimiento expone a la empresa a sanciones administrativas conforme a la LFPDPPP y genera pérdida de confianza en los titulares.

## Conclusión
Las finalidades secundarias exigen una validación previa entre el DBA, la oficina de privacidad y el área jurídica. Técnicamente, el DBA debe garantizar la separación de datos a través de vistas seguras y banderas de consentimiento a nivel de base de datos.
