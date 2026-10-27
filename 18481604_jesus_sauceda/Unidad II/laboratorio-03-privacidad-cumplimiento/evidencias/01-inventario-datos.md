# Evidencia 01: Inventario y Finalidad de los Datos

## Objetivo
Clasificar los campos almacenados en la tabla principal de clientes para determinar si constituyen datos personales, definir su finalidad de uso, nivel de acceso, vigencia de retención y evaluar la necesidad de su recolección.

## Procedimiento
1. Se analizó la estructura de la tabla `clientes` compuesta por los campos: `id`, `nombre`, `correo`, `telefono`, `rfc`, `edad`, `ciudad`, `codigo_postal` y `fecha_alta`.
2. Se evaluó cada campo frente a los principios de minimización y limitación de finalidad.
3. Se construyó la matriz de inventario de datos personales con su justificación técnica y funcional.

## Resultado

| Campo | ¿Es dato personal? | Finalidad | ¿Es necesario? | Nivel de acceso | Retención |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **id** | No | Identificador único del registro operativo. | Sí | Todos los roles | Indefinido (mientras el registro exista) |
| **nombre** | Sí | Identificación directa del titular para atención e interacción. | Sí | Atención al cliente, Facturación | Durante la relación contractual + 5 años |
| **correo** | Sí | Canal de comunicación principal y autenticación. | Sí | Atención al cliente, Facturación | Durante la relación contractual + 5 años |
| **telefono** | Sí | Contacto directo para aclaraciones o soporte técnico. | Sí | Atención al cliente | Durante la relación contractual |
| **rfc** | Sí (Sensible/Fiscal) | Cumplimiento tributario y facturación fiscal. | Sí (solo Facturación) | Facturación | 5 años (conforme al Código Fiscal) |
| **edad** | Sí | Segmentación analítica (podría derivarse de la fecha de nacimiento). | No en producción | Analítica (agregado) | No almacenar valor directo |
| **ciudad** | Sí (Indirecto) | Análisis demográfico y logística de entregas. | Sí | Analítica, Logística | 3 años en datos agregados |
| **codigo_postal**| Sí (Indirecto) | Ubicación geográfica operativa y cálculo de envíos. | Sí | Analítica, Logística | 3 años en datos agregados |
| **fecha_alta** | No | Control interno y cálculo de antigüedad del cliente. | Sí | DBA, Analítica | Indefinido para registros activos |

## Análisis
* Los campos identificadores directos (`nombre`, `correo`, `telefono`, `rfc`) representan el mayor riesgo de privacidad en caso de vulneración.
* El campo `rfc` es indispensable para facturación legal pero totalmente innecesario para el área de soporte técnico.
* El campo `edad` almacenado de forma estática es ineficiente y expone información personal no requerida por áreas operativas.

## Conclusión
El inventario de datos permite delimitar qué información se recopila y establecer controles de acceso basados en el principio de menor privilegio, asegurando que cada departamento acceda exclusivamente a los atributos vinculados a sus funciones operativas.