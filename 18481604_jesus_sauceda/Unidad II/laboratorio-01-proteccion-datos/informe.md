# Informe del Laboratorio 01

**Alumno:** Jesús Alonso Sauceda Soto (18481604)

## 19.1 Clasificación
Los datos que requieren protección son aquellos que identifican directamente al individuo (Nombre, Correo, Teléfono, RFC) debido a que son Datos Personales Sensibles, y aquellos que actúan como cuasi-identificadores (Edad, Ciudad, Código Postal) ya que, al combinarse, incrementan el riesgo de reidentificación de un titular. 

## 19.2 Enmascaramiento
* **Qué se ocultó:** Parte del correo, el teléfono y el RFC.
* **Para quién:** Para el rol `soporte`.
* **Por qué:** Porque necesitan identificar al cliente para atender solicitudes, pero no requieren consultar sus datos completos (Principio de mínimo privilegio).
* **Mecanismo utilizado:** Se implementó una VISTA (`v_clientes_soporte`) utilizando funciones de cadena (`CONCAT`, `LEFT`, `SUBSTRING`, `RIGHT`) y se revocó el acceso a la tabla original.

## 19.3 Seudonimización
* **Cómo se generaron los tokens:** Usando la extensión `pgcrypto` con la función `gen_random_uuid()`.
* **Dónde se encuentra el mapa de correspondencia:** En una tabla separada dentro de un esquema distinto (`pii.mapa_cliente`).
* **Quién debería poder acceder a él:** Únicamente roles administrativos (DBA) o personal estrictamente autorizado; nunca el área de analítica.
* **Por qué se separaron los permisos:** Para aplicar la separación de funciones. Si el analista tuviera acceso a la tabla de correspondencia, la seudonimización perdería su propósito porque el token podría asociarse inmediatamente a la identidad.

## 19.4 Anonimización
* **Identificadores eliminados:** Nombre, correo, teléfono y RFC.
* **Atributos generalizados:** La edad (agrupada en rangos) y el código postal (reducido a la región postal).
* **Grupos suprimidos:** Aquellos con menos de 5 registros (`HAVING COUNT(*) >= 5`).
* **Riesgo restante:** La anonimización no es 100% garantizada. Grupos pequeños o cruces de bases de datos externas podrían reidentificar a las personas.

## 19.5 Retención
* **Criterio utilizado:** 5 años desde la fecha de alta.
* **Información a conservar:** Registros recientes necesarios para operaciones vigentes.
* **Información a eliminar:** Registros de `fecha_alta < CURRENT_DATE - INTERVAL '5 years'`.
* **Controles antes de eliminar:** Debe existir aprobación documentada, un respaldo previo (backup) y evidencia en una bitácora de auditoría.

## 19.6 Conclusiones
* **Área de soporte:** Enmascaramiento dinámico (vistas).
* **Área de analítica:** Seudonimización separando la tabla de correspondencia.
* **Publicar estadísticas:** Anonimización (agregación y generalización).
* **Sobre el control de acceso:** Ninguna de estas técnicas sustituye al control de acceso porque ocultar la información no sirve de nada si cualquier usuario tiene permisos para consultar la tabla base o modificar las reglas de visibilidad.

---

## 20. Preguntas de reflexión
1. **Diferencia entre enmascaramiento y seudonimización:** El enmascaramiento oculta visualmente el dato en la consulta sin alterar el fondo, mientras que la seudonimización reemplaza el identificador original por un token, guardando la llave de la relación en otro lugar.
2. **Seudonimización no es anonimización:** Porque en la seudonimización existe una forma reversible (tabla de correspondencia) de recuperar la identidad original. La anonimización busca ser irreversible.
3. **Eliminar nombre y RFC no garantiza anonimato:** Porque los datos restantes (cuasi-identificadores) pueden cruzarse con otras fuentes para deducir quién es la persona.
4. **Función de cuasi-identificadores:** Atributos que por sí solos no te identifican (como edad o código postal), pero juntos actúan como una huella casi única.
5. **Importancia de separar el mapa:** Evita que un analista comprometido o curioso reconstruya la identidad original.
6. **Principio aplicado:** Separación de funciones (Separation of duties) y Mínimo privilegio.
7. **Vista vs Acceso directo:** La vista filtra columnas y enmascara datos antes de entregarlos al usuario, protegiendo la estructura base.
8. **Protección visual vs Acceso:** Proteger visualmente (enmascarar) evita que un usuario autorizado vea más de lo necesario; proteger contra acceso no autorizado evita que alguien entre al sistema desde un inicio.
9. **Retención como protección:** Evita acumular información innecesaria, reduciendo el impacto (superficie de exposición) en caso de una brecha de datos.
10. **Riesgo de conservación indefinida:** Mayor volumen de datos personales expuestos a filtraciones y posibles multas por incumplimiento de normativas de privacidad.
