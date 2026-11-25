# POL-05: Protección de Datos Personales y Sensibles

- **Código:** POL-05
- **Propietario:** Seguridad de la Información / Gerencia Comercial
- **Custodio:** Administrador de Base de Datos (DBA)
- **Alcance:** Atributos personales en `clientes` (`nombre`, `correo`, `telefono`, `rfc`, `edad`, `ciudad`, `codigo_postal`) y credenciales en bitácoras.

## 1. Objetivo
Prevenir la exposición no autorizada de datos personales de clientes y credenciales técnicas dentro de consultas, vistas o archivos de registro.

## 2. Reglas Operativas
1. **Clasificación en catálogo:** Toda tabla o columna con datos personales debe documentarse explícitamente mediante `COMMENT ON` y mantenerse en el diccionario de datos (`evidencias/03-diccionario.md`).
2. **Minimización y enmascaramiento:** Los roles de consulta o soporte no deben visualizar RFC, teléfonos ni correos completos cuando no sea indispensable para su tarea; deben consumir vistas enmascaradas.
3. **Protección de secretos en bitácoras:** Queda estrictamente prohibido ejecutar sentencias que contengan contraseñas en texto claro mientras `log_statement` esté configurado en `'ddl'`, `'mod'` o `'all'`.
4. **Confidencialidad de evidencias:** Los archivos extraídos de auditoría y bitácoras (`E4`, `E5`) se tratan como información restringida y no se comparten fuera del canal autorizado.

## 3. Verificación
- Inspección de comentarios en catálogo (`evidencias/diccionario-clientes.csv`), control de acceso a `dba.bitacora` y revisión de bitácoras exportadas.
