# Informe Técnico: Hardening y Configuración Segura de PostgreSQL

**Asignatura:** Administración de Bases de Datos  
**Unidad:** II - Seguridad, privacidad y control de acceso  
**Tema:** 2.6 Hardening de bases de datos  

---

## 1. Cuestionario de Evaluación Técnica

### 1. ¿Cuál era la principal superficie de ataque identificada?
La principal superficie de ataque radicaba en la combinación de una escucha abierta en todas las interfaces de red (`listen_addresses = '*'`), reglas de autenticación `pg_hba.conf` excesivamente permisivas (`0.0.0.0/0`) y el uso potencial de cuentas con permisos elevados o sin límites de tiempo de espera (*timeouts*) en transacciones inactivas[cite: 8, 12, 13, 18].

### 2. ¿Qué configuración representaba el mayor riesgo?
Permitir el acceso desde cualquier origen IPv4 (`0.0.0.0/0`) en el archivo `pg_hba.conf` mediante cuentas con privilegios administrativos o sin restricciones de red[cite: 8, 13]. Esto elimina la barrera de red perimetral dentro del motor y expone la base de datos a ataques de fuerza bruta desde cualquier segmento[cite: 4, 8].

### 3. ¿Qué cambio produjo la mayor reducción de exposición?
Restringir `listen_addresses` a la interfaz privada/local e implementar reglas estrictas de *allowlist* en `pg_hba.conf` especificando IP, base de datos y usuario exacto[cite: 5, 7, 11, 15].

### 4. ¿Qué diferencia existe entre firewall y `pg_hba.conf`?
* **Firewall:** Opera en la capa de red/transporte del sistema operativo, filtrando paquetes por IP de origen/destino y puerto antes de que alcancen el servicio de PostgreSQL[cite: 6].
* **`pg_hba.conf`:** Controla la autenticación a nivel de aplicación dentro de PostgreSQL, evaluando la identidad del usuario, la base de datos específica solicitada y el método de autenticación tras haber aceptado la conexión TCP[cite: 5, 6].

### 5. ¿Qué diferencia existe entre autenticación y autorización?
* **Autenticación:** Verifica la identidad del usuario que intenta conectarse (¿Quién eres?) mediante credenciales, certs o hashes[cite: 6].
* **Autorización:** Determina los privilegios y acciones que el usuario autenticado tiene permitidos sobre las tablas y esquemas (¿Qué puedes hacer?)[cite: 6].

### 6. ¿Por qué una cuenta de aplicación no debe ser `SUPERUSER`?
Porque vulnera el principio de mínimo privilegio[cite: 7]. Si la aplicación sufre una vulnerabilidad de inyección SQL (SQLi) o se comprometen sus credenciales, el atacante obtendría control total sobre todo el motor, pudiendo borrar bases de datos, leer datos de otros usuarios o ejecutar funciones del sistema operativo[cite: 33].

### 7. ¿Por qué cambiar el puerto de PostgreSQL no constituye hardening suficiente?
Cambiar el puerto TCP `5432` por otro (ej. `5433`) únicamente aporta "seguridad por obscuridad", reduciendo el ruido de escaneos automatizados masivos[cite: 5, 32]. No sustituye los controles de autenticación, la autorización ni las reglas de filtrado de red[cite: 5, 32].

### 8. ¿Por qué `listen_addresses='*'` puede ser innecesario?
Porque vincula el servicio de PostgreSQL a todas las tarjetas de red disponibles, incluyendo interfaces públicas expuestas a Internet[cite: 5]. Si la aplicación reside en la misma máquina o en una red interna específica, el motor solo debe escuchar en la IP privada o en `localhost`[cite: 5].

### 9. ¿Qué papel tiene el sistema operativo en la seguridad de PostgreSQL?
El sistema operativo es la capa base[cite: 33]. Si los archivos de configuración (`pg_hba.conf`, `postgresql.conf`) o el directorio de datos (`data_directory`) tienen permisos permisivos en el SO, cualquier usuario local del servidor podría leer datos confidenciales, extraer hashes o alterar las reglas de acceso sin necesidad de autenticarse en PostgreSQL[cite: 7, 19].

### 10. ¿Qué controles deberían revisarse periódicamente?
1. Auditoría de usuarios con rol `SUPERUSER` y privilegios `CREATEROLE`[cite: 16].
2. Revisión de reglas activas en `pg_hba.conf`[cite: 12].
3. Expiración y política de algoritmos de contraseñas (`scram-sha-256`)[cite: 15].
4. Logs de conexiones fallidas o sospechosas[cite: 10, 11].
5. Parámetros de timeout de sesiones e inactivas[cite: 18].

---

## 2. Resolución del Caso Integral (Actividad 18)

### Matriz de Identificación de Riesgos

| # | Problema Identificado | Riesgo Asociado | Control Propuesto |
| :-: | :--- | :--- | :--- |
| **1** | Escucha en todas las interfaces (`*`)[cite: 8, 24] | Exposición directa a redes no confiables o Internet[cite: 4, 8]. | Modificar `listen_addresses` a la IP privada o `localhost`[cite: 5]. |
| **2** | `pg_hba.conf` permite `0.0.0.0/0`[cite: 8, 24] | Ataques de fuerza bruta remotos desde cualquier IP[cite: 4, 8]. | Reemplazar por reglas *allowlist* con subredes específicas[cite: 6, 7]. |
| **3** | Aplicación conectada como `SUPERUSER`[cite: 8, 24] | Compromiso total del motor mediante inyección SQL[cite: 33]. | Crear rol dedicado de aplicación con permisos DML limitados[cite: 7, 17]. |
| **4** | Firewall permite 5432 desde cualquier origen[cite: 8, 24] | Ausencia de filtrado perimetral de red[cite: 6, 8]. | Restringir el puerto 5432 en el firewall a la IP del app server[cite: 6, 20]. |
| **5** | Confianza exclusiva en "contraseñas fuertes"[cite: 8, 24] | Vulnerabilidad ante fugas de credenciales o comp. de app[cite: 32]. | Aplicar defensa en profundidad (Red + Auth + Privilegios)[cite: 3, 33]. |
| **6** | Falta de cifrado SSL en tránsito verificado[cite: 8, 24] | Intercepción de tráfico (*eavesdropping*) y credenciales[cite: 21]. | Habilitar `ssl = on` y exigir `hostssl` en `pg_hba.conf`[cite: 15, 21]. |
| **7** | Ausencia de timeouts en sesiones inactivas[cite: 18] | Denegación de servicio por agotamiento de conexiones[cite: 18]. | Configurar `idle_in_transaction_session_timeout = 60000`[cite: 18]. |
| **8** | Sin auditoría de logs de conexiones activada[cite: 8, 10] | Imposibilidad de detectar o investigar accesos no autorizados[cite: 10]. | Habilitar `log_connections = on` y `log_disconnections = on`[cite: 10, 11]. |
| **9** | Archivos de configuración con permisos por defecto en SO[cite: 8] | Modificación no autorizada por otros usuarios del SO[cite: 7, 19]. | Asegurar permisos `0600` para configuraciones y `0700` para datos[cite: 19]. |
| **10** | Sin documentación ni baseline de seguridad formal[cite: 8] | Configuraciones inconsistentes y falta de reproducibilidad[cite: 7, 8, 33]. | Implementar la línea base y la checklist de hardening[cite: 7, 8, 23]. |

### ¿Es suficiente tener contraseñas fuertes?
**No, no es suficiente[cite: 25, 32].** Una contraseña fuerte solo protege la fase de autenticación previa al acceso[cite: 6, 32]. La seguridad en bases de datos requiere una estrategia de **Defensa en Profundidad**[cite: 3, 33]:
* Si la red permite cualquier origen (`0.0.0.0/0`), el servidor recibe tráfico malicioso constante[cite: 8, 13].
* Si la cuenta tiene permisos de `SUPERUSER`, un error en la aplicación expone toda la base de datos[cite: 17, 33].
* Si el archivo de configuración en el sistema operativo es accesible por terceros, la contraseña puede ser puenteada o interceptada[cite: 7, 19].

---

## 3. Reflexión Individual (Actividad 31)

Si recibiera la responsabilidad de asegurar un servidor PostgreSQL en producción que ya se encuentra operando, **lo primero que cambiaría sería restringir las reglas de acceso en `pg_hba.conf` y el firewall de red para permitir únicamente el tráfico proveniente de las IPs autorizadas de la aplicación y administración[cite: 6, 7, 12].**

**Justificación:**
* **Riesgo y Exposición:** La exposición de red es la puerta de entrada de ataques externos[cite: 4, 8]. Aislar la red detiene de inmediato cualquier escaneo o intento de fuerza bruta proveniente de actores no autorizados[cite: 4, 6].
* **Disponibilidad e Impacto:** Aplicar este cambio mediante una regla de *allowlist* específica no interrumpe el tráfico legítimo de la producción actual si se especifican correctamente las IPs en uso, logrando la máxima reducción de riesgo sin afectar la continuidad operativa del negocio[cite: 6, 7, 30].