# Laboratorio 2: Trazabilidad y límites de auditoría en MongoDB Community Edition

- **Alumno:** Jesús Sauceda
- **Matrícula:** 18481604
- **Materia:** Administración de Bases de Datos — Unidad 3
- **Fecha:** 13 de noviembre de 2026
- **Entorno:** MongoDB 7.0.48 Community Edition (Windows) | `mongosh 2.14.2`

## Contenido de la entrega

- [Informe técnico completo](informe.md)
- [Script consolidado de `mongosh`](scripts/comandos-mongosh.js)

### Evidencias por actividad
1. [Actividad 1: Lo que no existe en esta edición](evidencias/01-edicion-y-limitacion.md)
2. [Actividad 2: El incidente sin perfilado](evidencias/02-incidente-sin-perfilado.md)
3. [Actividad 3: Activar el perfilador y registrar operaciones](evidencias/03-perfilador.md)
4. [Actividad 4: Reducir el volumen con un filtro](evidencias/04-filtro.md)
5. [Actividad 5: Accesos en la bitácora de `mongod`](evidencias/05-accesos-mongod.md)
6. [Actividad 6: Correlacionar un cambio de configuración con su autor](evidencias/06-correlacion.md)
7. [Actividad 7: Cambios de privilegios y control compensatorio](evidencias/07-privilegios-control-compensatorio.md)
8. [Actividad 8: Conservación e integridad de la evidencia](evidencias/08-conservacion.md)
9. [Actividad 9: Comparación PostgreSQL vs MongoDB Community](evidencias/09-comparacion.md)
10. [Actividad 10: Respuesta ejecutiva a Dirección](evidencias/10-respuesta-direccion.md)

### Evidencias crudas y cadena de custodia
- [`evidencias/system-profile.json`](evidencias/system-profile.json) — Exportación de operaciones capturadas (`query`, `update`, `remove`).
- [`evidencias/bitacora-mongod.log`](evidencias/bitacora-mongod.log) — Bitácora JSON exportada antes del reinicio del servicio.
- [`evidencias/hashes.sha256`](evidencias/hashes.sha256) — Firmas SHA-256 de las evidencias exportadas.

Para comprobar la integridad de los archivos exportados en PowerShell:

```powershell
Get-FileHash evidencias/system-profile.json, evidencias/bitacora-mongod.log -Algorithm SHA256 | ForEach-Object { "$($_.Hash.ToLower())  $(Split-Path$_.Path -Leaf)" }
```
