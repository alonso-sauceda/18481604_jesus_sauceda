# Evidencia 10: Evaluación de Políticas de Retención de Información

## Objetivo
Evaluar los riesgos técnicos, operativos y legales derivados de la conservación indefinida de datos personales y definir los criterios para establecer un periodo de retención adecuado.

## Procedimiento
1. Se evaluó la propuesta corporativa de conservar todos los datos de clientes de manera indefinida.
2. Se analizaron las implicaciones frente al principio de minimización y la normativa mexicana aplicable (LFPDPPP).
3. Se definieron las preguntas clave y la documentación necesaria para normar el periodo de conservación.

## Resultado

### Respuestas sobre la Política de Retención Indefinida
1. **¿Es compatible con el principio de minimización?**  
   No. El principio de minimización implica limitar el tratamiento a lo estrictamente necesario. Conservar datos sin una finalidad activa violenta directamente esta norma.

2. **¿Qué riesgos genera conservar información innecesaria?**  
   * **Riesgo de Seguridad:** Mayor impacto e indemnizaciones en caso de filtraciones de datos.
   * **Costos Operativos:** Incremento en almacenamiento, procesamiento y tiempos de respaldos.
   * **Incumplimiento Legal:** Sanciones por parte de los órganos garantes al almacenar datos obsoletos sin base jurídica.

3. **¿Qué debería determinar la organización antes de establecer el periodo?**  
   * Obligaciones legales sectoriales (CFF, normas contables, prevenciones de lavado de dinero).
   * Ciclo de vida de la relación contractual comercial.
   * Plazos de prescripción de acciones legales derivadas del contrato.

4. **¿Qué información debería documentarse para justificar el periodo?**  
   Fundamento legal aplicable, finalidad del almacenamiento en bloqueo, responsable del resguardo y procedimiento automatizado de purga.

## Análisis
La retención no debe ser una decisión técnica del DBA sino una política institucional alineada con las normativas legales. Conservar información obsoleta incrementa la superficie de ataque del servidor PostgreSQL.

## Conclusión
El DBA debe implementar mecanismos de depuración periódica (como trabajos programados o particionamiento por fechas) alineados a los plazos legales documentados por el oficial de privacidad.