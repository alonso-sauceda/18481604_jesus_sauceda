# Actividad 8: Conservación e integridad de la evidencia

## Evidencia ejecutada

### 1. Exportación de bitácora y cálculo de hashes SHA-256 antes del reinicio (PowerShell)
```text
PS> mongosh "mongodb://admin:<REDACTED>@127.0.0.1:27017/comercial?authSource=admin" --quiet --eval 'db.adminCommand({ getLog: "global" }).log.join(String.fromCharCode(10))' > evidencias/bitacora-mongod.log

PS> Get-FileHash evidencias/system-profile.json, evidencias/bitacora-mongod.log -Algorithm SHA256 | ForEach-Object { "$($_.Hash.ToLower())  $(Split-Path $_.Path -Leaf)" } | Out-File -Encoding ascii evidencias/hashes.sha256

PS> Get-Content evidencias/hashes.sha256
10da8558fe6e4ac87299e3044f608569fa29141ce2d910fb32ea730f2edc7928  system-profile.json
6c931b4f3b9d87176f9e7395140f0adea98ad9870cf5c9e4fa282c0a2f91e496  bitacora-mongod.log
```

### 2. Verificación posterior al reinicio del servicio `MongoDB`
En PowerShell (archivo físico en disco):
```text
PS> Get-Item "C:\Program Files\MongoDB\Server\7.0\log\mongod.log" | Select-Object Name, Length, LastWriteTime

Name       Length LastWriteTime
----       ------ -------------
mongod.log 297882 13/11/2026 01:57:21 p. m.
```

En `mongosh` (Sesión DBA):
```text
comercial> db.getProfilingStatus()
{ was: 0, slowms: 100, sampleRate: 1, ok: 1 }

comercial> db.system.profile.countDocuments()
3

comercial> bitacora().length
83
```

## Respuestas

1. **¿Qué sobrevivió al reinicio del servicio y qué se perdió o reinició?**
   - **Sobrevivió en disco:** La colección `system.profile` conservó sus `3` documentos registrados previamente, y el archivo físico `C:\Program Files\MongoDB\Server\7.0\log\mongod.log` mantuvo su historial acumulado (`297,882` bytes) gracias a la directiva `logAppend: true`.
   - **Se reinició o perdió en memoria:** La configuración activa del perfilador volvió a su valor por defecto apagado (`was: 0`), ya que los cambios aplicados con `db.setProfilingLevel()` solo viven en memoria mientras el proceso está activo. Asimismo, el búfer circular en memoria consultado mediante `getLog: "global"` (`bitacora()`) se vació por completo al reiniciar y comenzó de cero con apenas `83` líneas correspondientes al nuevo arranque.

2. **¿Cómo harías persistente la configuración del perfilador ante reinicios del servidor?**
   Definiendo la sección `operationProfiling` directamente dentro del archivo de configuración `C:\Program Files\MongoDB\Server\7.0\bin\mongod.cfg` (especificando `mode: slowOp` o `all` junto con `filter` o `slowOpThresholdMs`) y reiniciando el servicio para que cargue esos parámetros en cada inicio.

3. **¿Para qué sirve generar el archivo `hashes.sha256` inmediatamente después de exportar las evidencias?**
   Permite garantizar la **integridad y cadena de custodia** de los archivos exportados (`system-profile.json` y `bitacora-mongod.log`). Si alguien modifica siquiera un carácter o marca de tiempo después de la extracción, al recalcular el resumen SHA-256 el valor no coincidirá con el registrado en `hashes.sha256`.
   