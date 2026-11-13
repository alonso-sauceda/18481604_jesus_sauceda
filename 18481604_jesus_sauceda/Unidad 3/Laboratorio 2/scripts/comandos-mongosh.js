// ============================================================================
// Laboratorio 2: Trazabilidad y límites de auditoría en MongoDB 7.0.48 Community
// Script consolidado de comandos ejecutados en mongosh (Sesión DBA)
// ============================================================================

// Función auxiliar para leer y parsear la bitácora JSON en memoria de mongod
function bitacora() {
  return db.adminCommand({ getLog: "global" }).log.map(l => JSON.parse(l));
}

// ----------------------------------------------------------------------------
// Actividad 1: Verificación de edición, módulos y configuración de bitácora
// ----------------------------------------------------------------------------
db.version();
db.adminCommand({ buildInfo: 1 }).modules;
db.serverCmdLineOpts().parsed;

// ----------------------------------------------------------------------------
// Actividad 2: Diagnóstico de incidente sin perfilador activo (nivel 0)
// ----------------------------------------------------------------------------
db.getProfilingStatus();
db.system.profile.countDocuments();
bitacora().filter(e => JSON.stringify(e).includes("GAMA780912XXX")).length;
bitacora()
  .filter(e => JSON.stringify(e).includes("app-ventas-web"))
  .map(e => ({ t: e.t, c: e.c, ctx: e.ctx, msg: e.msg }))
  .slice(-8);

// ----------------------------------------------------------------------------
// Actividad 3: Activación del perfilador en nivel 2 y revisión de operaciones
// ----------------------------------------------------------------------------
db.setProfilingLevel(2);
db.getProfilingStatus();

db.system.profile
  .find(
    { ns: "comercial.clientes" },
    {
      op: 1,
      ns: 1,
      command: 1,
      user: 1,
      client: 1,
      appName: 1,
      ts: 1,
      millis: 1,
      nreturned: 1,
      docsExamined: 1,
      nModified: 1,
      ndeleted: 1
    }
  )
  .sort({ ts: 1 });

// ----------------------------------------------------------------------------
// Actividad 4: Reducción de volumen con filtro de escritura (nivel 1)
// ----------------------------------------------------------------------------
db.setProfilingLevel(0);
db.system.profile.drop();
db.setProfilingLevel(1, {
  filter: { op: { $in: ["insert", "update", "remove"] } }
});
db.getProfilingStatus();

db.system.profile.find(
  {},
  {
    op: 1,
    ns: 1,
    user: 1,
    appName: 1,
    "command.q": 1,
    "command.u": 1,
    ts: 1
  }
);

// ----------------------------------------------------------------------------
// Actividad 5: Consulta de accesos fallidos y exitosos en la bitácora
// ----------------------------------------------------------------------------
bitacora()
  .filter(e => e.c === "ACCESS" && e.msg === "Failed to authenticate")
  .map(e => ({
    t: e.t,
    id: e.id,
    ctx: e.ctx,
    user: e.attr.user,
    client: e.attr.client,
    error: e.attr.error,
    result: e.attr.result,
    app: e.attr.doc?.application?.name
  }));

bitacora()
  .filter(e => e.msg === "Successfully authenticated" && e.attr.user === "app_ventas")
  .slice(-1)
  .map(e => ({
    t: e.t,
    id: e.id,
    ctx: e.ctx,
    client: e.attr.client,
    result: e.attr.result,
    app: e.attr.doc?.application?.name
  }));

// ----------------------------------------------------------------------------
// Actividad 6: Correlación de cambios de configuración del perfilador con autor
// ----------------------------------------------------------------------------
bitacora()
  .filter(e => e.msg === "Profiler settings changed")
  .map(e => ({ t: e.t, ctx: e.ctx, msg: e.msg, attr: e.attr }));

bitacora()
  .filter(e => e.ctx === "conn22" && e.msg === "Successfully authenticated")
  .map(e => ({
    t: e.t,
    ctx: e.ctx,
    user: e.attr.user,
    db: e.attr.db,
    client: e.attr.client
  }));

// ----------------------------------------------------------------------------
// Actividad 7: Control compensatorio para cambios de privilegios (instantáneas)
// ----------------------------------------------------------------------------
db.getSiblingDB("auditoria").instantaneas_privilegios.insertOne({
  momento: new Date(),
  tomada_por: db.runCommand({ connectionStatus: 1 }).authInfo.authenticatedUsers,
  usuarios: db.getUsers().users.map(u => ({
    user: u.user,
    db: u.db,
    roles: u.roles
  }))
});

db.setProfilingLevel(2);
db.grantRolesToUser("app_ventas", [{ role: "dbAdmin", db: "comercial" }]);

db.system.profile.countDocuments({ "command.grantRolesToUser": { $exists: true } });
bitacora().filter(e => JSON.stringify(e).includes("grantRoles")).length;

db.getSiblingDB("auditoria").instantaneas_privilegios.insertOne({
  momento: new Date(),
  tomada_por: db.runCommand({ connectionStatus: 1 }).authInfo.authenticatedUsers,
  usuarios: db.getUsers().users.map(u => ({
    user: u.user,
    db: u.db,
    roles: u.roles
  }))
});

db.getSiblingDB("auditoria").instantaneas_privilegios.find({}, { _id: 0 }).sort({ momento: 1 });

db.revokeRolesFromUser("app_ventas", [{ role: "dbAdmin", db: "comercial" }]);
db.setProfilingLevel(1, {
  filter: { op: { $in: ["insert", "update", "remove"] } }
});

// ----------------------------------------------------------------------------
// Actividad 8: Verificación posterior al reinicio del servicio MongoDB
// ----------------------------------------------------------------------------
db.getProfilingStatus();
db.system.profile.countDocuments();
bitacora().length;