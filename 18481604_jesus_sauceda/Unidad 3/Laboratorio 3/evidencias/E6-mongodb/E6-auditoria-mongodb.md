# E6: Evidencia de Gobierno y Perfilado en MongoDB (`comercial`)

## 1. Activos Documentales Bajo Gobierno
- **Base de datos:** `comercial`
- **Colección operativa:** `comercial.clientes` (Propietario: Gerencia Comercial | Custodio: DBA)
- **Colección de auditoría/perfilado:** `comercial.system.profile` (Propietario: Seguridad de la Información | Custodio: DBA)

## 2. Comandos de Verificación y Políticas Aplicadas (`POL-01` a `POL-06`)

```javascript
use comercial

// 1. Verificar nivel de perfilado activo (POL-03 / POL-05)
db.getProfilingStatus()

// 2. Consultar muestra de operaciones registradas en system.profile (POL-06)
db.system.profile.find(
  { ns: /^comercial\./ },
  { ts: 1, op: 1, ns: 1, command: 1, user: 1 }
).sort({ ts: -1 }).limit(5)

// 3. Verificar usuarios y roles asignados en la base comercial (POL-01)
db.getUsers()
