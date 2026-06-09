<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.clinipet.model.Usuario" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
%>
<!doctype html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Panel recepcionista | CliniPet</title>

<link href="https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta20/dist/css/tabler.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/tabler-icons.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800;900&family=Fredoka:wght@500;600;700&display=swap" rel="stylesheet">
<style>
:root{--green:#00c875;--green2:#00f5a0;--dark:#003d25;--text:#0f172a;--muted:#64748b;--line:#dbeee5;--shadow:0 24px 70px rgba(0,80,50,.12)}
*{box-sizing:border-box}body{margin:0;font-family:"Nunito",sans-serif;color:var(--text);background:radial-gradient(circle at 15% 5%,rgba(0,200,117,.13),transparent 28%),linear-gradient(135deg,#f8fffb,#eafff4);overflow-x:hidden}
h1,h2,h3,h4,h5,.brand-title,.title-main{font-family:"Fredoka",sans-serif}
.layout{display:flex;min-height:100vh}.side{width:295px;min-height:100vh;position:fixed;left:0;top:0;color:white;padding:28px 22px;z-index:1000;background:linear-gradient(180deg,#003d25,#007f4f);box-shadow:18px 0 55px rgba(0,61,37,.16)}
.brand{display:flex;align-items:center;gap:12px;margin-bottom:24px}.brand-icon{width:58px;height:58px;border-radius:20px;background:white;color:var(--green);display:grid;place-items:center;font-size:2rem}.brand-title{font-size:2rem;font-weight:700;margin:0;color:white}
.user-card{background:rgba(255,255,255,.13);border:1px solid rgba(255,255,255,.18);border-radius:24px;padding:18px;margin-bottom:22px}
.navx a{display:flex;align-items:center;gap:12px;color:#eafff4;text-decoration:none;padding:15px 18px;border-radius:20px;margin-top:8px;font-weight:900;transition:.25s}.navx a:hover,.navx .active{background:rgba(255,255,255,.17);transform:translateX(4px)}
.main{margin-left:295px;width:calc(100% - 295px);padding:34px}.topbar{display:flex;justify-content:space-between;align-items:center;gap:20px;margin-bottom:26px;flex-wrap:wrap}.title-main{margin:0;color:#063823;font-weight:700;font-size:2.4rem}.subtitle{margin:8px 0 0;color:var(--muted);font-weight:700}
.btn-green,.btn-soft,.btn-danger-soft,.btn-warning-soft,.btn-info-soft{border:0;border-radius:18px;padding:12px 17px;font-weight:900;text-decoration:none;transition:.25s;display:inline-flex;align-items:center;gap:8px}.btn-green{background:linear-gradient(135deg,var(--green),var(--green2));color:#003d25;box-shadow:0 16px 38px rgba(0,200,117,.24)}.btn-soft{background:white;color:#063823;box-shadow:0 12px 28px rgba(0,80,50,.08)}.btn-danger-soft{background:#fff1f2;color:#be123c}.btn-warning-soft{background:#fff7ed;color:#c2410c}.btn-info-soft{background:#ecfeff;color:#0369a1}
.stats{display:grid;grid-template-columns:repeat(4,1fr);gap:18px;margin-bottom:24px}.stat-card{background:rgba(255,255,255,.92);border-radius:30px;padding:24px;box-shadow:var(--shadow);min-height:145px}.stat-card i{font-size:2rem;color:var(--green)}.stat-card h2{margin:10px 0 4px;font-size:2.05rem;font-weight:800;color:#0f172a}.stat-card span{color:var(--muted);font-weight:800}
.grid-2{display:grid;grid-template-columns:1.15fr .85fr;gap:24px;margin-bottom:24px}.panel{background:rgba(255,255,255,.94);border-radius:30px;box-shadow:var(--shadow);overflow:hidden;margin-bottom:24px}.panel-head{padding:22px 24px;border-bottom:1px solid var(--line);display:flex;align-items:center;justify-content:space-between;gap:14px;flex-wrap:wrap}.panel-title{display:flex;align-items:center;gap:10px;margin:0;font-weight:700}.panel-title i{color:var(--green)}.panel-body{padding:24px}
.search-input{width:100%;border:1px solid var(--line);border-radius:18px;padding:14px 17px;font-weight:800;outline:none}.table-card{overflow:hidden;border-radius:26px;border:1px solid var(--line);background:white}.table{margin:0}.table thead th{color:#047857;font-size:.8rem;text-transform:uppercase;background:#f8fffb}.table tbody td{vertical-align:middle;font-weight:750}
.badge-soft{background:#dcfff0;color:#007f4f;border-radius:999px;padding:7px 13px;font-weight:900;display:inline-flex;align-items:center;gap:5px}.badge-danger{background:#ffe4e6;color:#be123c}.badge-warning{background:#ffedd5;color:#c2410c}.badge-info{background:#e0f2fe;color:#0369a1}
.actions{display:flex;gap:8px;align-items:center;flex-wrap:wrap}.icon-btn{width:39px;height:39px;border-radius:13px;border:0;display:grid;place-items:center;color:#064e3b;background:#eafff4;transition:.2s;text-decoration:none}.icon-btn.delete{background:#fff1f2;color:#be123c}.icon-btn.edit{background:#ecfeff;color:#0369a1}.icon-btn.ok{background:#dcfff0;color:#007f4f}
.sales-chart{height:250px;display:flex;align-items:end;gap:16px;padding-top:24px}.bar-wrap{flex:1;display:flex;flex-direction:column;align-items:center;gap:10px}.bar{width:100%;min-height:22px;border-radius:999px 999px 12px 12px;background:linear-gradient(180deg,var(--green2),var(--green));box-shadow:0 12px 24px rgba(0,200,117,.22)}.bar-label{color:var(--muted);font-weight:900;font-size:.82rem}
.alert-card{border-radius:24px;padding:18px;border:1px solid var(--line);background:#fff}.alert-card.warning{background:#fff7ed;border-color:#fed7aa}.alert-card.danger{background:#fff1f2;border-color:#fecdd3}.alert-card.ok{background:#f0fdf4;border-color:#bbf7d0}
@media(max-width:1250px){.stats{grid-template-columns:repeat(2,1fr)}.grid-2{grid-template-columns:1fr}}@media(max-width:900px){.layout{display:block}.side{position:relative;width:100%;min-height:auto}.main{margin-left:0;width:100%;padding:22px}}@media(max-width:620px){.stats{grid-template-columns:1fr}}
</style>

</head>
<body>
<div class="layout">
    <aside class="side">
        <div class="brand"><div class="brand-icon"><i class="ti ti-paw"></i></div><div><h2 class="brand-title">CliniPet</h2><small>Recepcionista</small></div></div>
        <div class="user-card"><strong><%= usuario != null ? usuario.getNombre() : "Recepcionista" %></strong><br><span class="opacity-75"><%= usuario != null ? usuario.getRol() : "Recepcionista" %></span></div>
        <nav class="navx">
            <a class="" href="${pageContext.request.contextPath}/dashboard"><i class="ti ti-layout-dashboard"></i> Admin</a>
            <a class="active" href="${pageContext.request.contextPath}/recepcionista/dashboard"><i class="ti ti-calendar-heart"></i> Recepción</a>
            
            <a href="${pageContext.request.contextPath}/"><i class="ti ti-home"></i> Inicio</a>
            <a href="${pageContext.request.contextPath}/logout"><i class="ti ti-logout"></i> Cerrar sesión</a>
        </nav>
    </aside>
    <main class="main">

<%
    List<Map<String,Object>> citasPendientes = (List<Map<String,Object>>) request.getAttribute("citasPendientes");
    List<Map<String,Object>> doctores = (List<Map<String,Object>>) request.getAttribute("doctores");
    if(citasPendientes==null)citasPendientes=new ArrayList<>();
    if(doctores==null)doctores=new ArrayList<>();
%>
<div class="topbar"><div><h1 class="title-main">Panel de recepcionista</h1><p class="subtitle">Solo citas pendientes, alertas de mascotas con cita y disponibilidad de doctores.</p></div><div style="display:flex;gap:10px;flex-wrap:wrap"><a href="${pageContext.request.contextPath}/recepcionista/dashboard" class="btn-soft"><i class="ti ti-layout-dashboard"></i> Mi panel</a><a href="${pageContext.request.contextPath}/citas/nueva" class="btn-green"><i class="ti ti-calendar-plus"></i> Agendar cita</a><a href="${pageContext.request.contextPath}/logout" style="border:0;border-radius:18px;padding:12px 17px;font-weight:900;background:#fff1f2;color:#be123c;text-decoration:none;display:inline-flex;align-items:center;gap:8px"><i class="ti ti-logout"></i> Cerrar sesión</a></div></div>
<div class="stats"><div class="stat-card"><i class="ti ti-calendar-heart"></i><h2><%= citasPendientes.size() %></h2><span>Citas pendientes</span></div><div class="stat-card"><i class="ti ti-stethoscope"></i><h2><%= doctores.size() %></h2><span>Doctores</span></div><div class="stat-card"><i class="ti ti-alert-triangle"></i><h2>!</h2><span>Validar mascota con cita</span></div><div class="stat-card"><i class="ti ti-cash"></i><h2>$</h2><span>Asignar precio</span></div></div>
<div class="grid-2">
<section class="panel"><div class="panel-head"><h3 class="panel-title"><i class="ti ti-calendar-exclamation"></i> Citas pendientes</h3><input class="search-input table-search" data-target="tablaPendientes" placeholder="Buscar cita..." style="width:330px;max-width:100%"></div><div class="table-card table-responsive"><table class="table card-table" id="tablaPendientes"><thead><tr><th>Dueño</th><th>Mascota</th><th>Fecha</th><th>Motivo</th><th>Doctor</th><th>Precio</th><th>Acción</th></tr></thead><tbody>
<%
    for(Map<String,Object> c : citasPendientes){
        String cId     = String.valueOf(c.get("id"));
        String cDuenio = String.valueOf(c.get("duenio"));
        String cMasc   = String.valueOf(c.get("mascota"));
        String cFecha  = String.valueOf(c.get("fecha"));
        String cHora   = c.get("hora") != null ? String.valueOf(c.get("hora")) : "";
        String cMotivo = c.get("motivo") != null ? String.valueOf(c.get("motivo")) : "";
        String cDoctor = c.get("doctor") != null ? String.valueOf(c.get("doctor")) : "Sin asignar";
        String cPrecio = c.get("precio") != null ? String.valueOf(c.get("precio")) : "0";
        // Escapar comillas simples en motivo para el onclick
        String cMotivoJs = cMotivo.replace("'", "\\'");
%>
<tr>
  <td><%= cDuenio %></td>
  <td><strong><%= cMasc %></strong></td>
  <td><%= cFecha %> <span class="text-secondary"><%= cHora %></span></td>
  <td><%= cMotivo %></td>
  <td><%= cDoctor %></td>
  <td>$<%= cPrecio %></td>
  <td>
    <button class="icon-btn edit"
      onclick="abrirEditar('<%= cId %>','<%= cFecha %>','<%= cHora %>','<%= cMotivoJs %>','<%= cPrecio %>')">
      <i class="ti ti-edit"></i>
    </button>
  </td>
</tr>
<% } if(citasPendientes.isEmpty()){ %><tr><td colspan="7" class="text-center text-secondary p-4">No hay citas pendientes.</td></tr><% } %>
</tbody></table></div></section>
<section class="panel"><div class="panel-head"><h3 class="panel-title"><i class="ti ti-user-check"></i> Doctores disponibles/ocupados</h3></div><div class="panel-body d-grid gap-3">
<% for(Map<String,Object> d:doctores){ %><div class="alert-card <%= "DISPONIBLE".equalsIgnoreCase(String.valueOf(d.get("estado"))) ? "ok" : "warning" %>"><strong><%= d.get("nombre") %></strong><br><span class="text-secondary"><%= d.get("especialidad") %> · <%= d.get("estado") %></span></div><% } if(doctores.isEmpty()){ %><div class="text-secondary fw-bold">No hay doctores cargados.</div><% } %>
</div></section></div>

    </main>
</div>

<script>
document.querySelectorAll('.table-search').forEach(function(input){
    input.addEventListener('input', function(){
        const value = input.value.toLowerCase().trim();
        const table = document.getElementById(input.dataset.target);
        if(!table) return;
        table.querySelectorAll('tbody tr').forEach(function(row){
            row.style.display = row.innerText.toLowerCase().includes(value) ? '' : 'none';
        });
    });
});

function abrirEditar(id, fecha, hora, motivo, precio){
    document.getElementById('editId').value = id;
    document.getElementById('editFecha').value = fecha;
    document.getElementById('editHora').value = hora;
    document.getElementById('editMotivo').value = motivo;
    document.getElementById('editPrecio').value = precio;
    document.getElementById('editModal').style.display='flex';
}
function cerrarEditar(){
    document.getElementById('editModal').style.display='none';
}
</script>

<!-- MODAL EDITAR CITA -->
<div id="editModal" style="display:none;position:fixed;inset:0;background:rgba(0,40,20,.5);z-index:9999;align-items:center;justify-content:center">
    <div style="background:white;border-radius:28px;padding:34px;max-width:520px;width:90%;box-shadow:0 30px 80px rgba(0,60,35,.2)">
        <h2 style="font-family:'Fredoka',sans-serif;color:#003d25;margin:0 0 20px;display:flex;align-items:center;gap:10px">
            <i class="ti ti-edit" style="color:#0369a1"></i> Editar cita
        </h2>
        <form method="post" action="${pageContext.request.contextPath}/citas/editar">
            <input type="hidden" name="id" id="editId">
            <div style="display:grid;gap:14px">
                <div>
                    <label style="font-weight:800;display:block;margin-bottom:6px">Fecha</label>
                    <input type="date" name="fecha" id="editFecha" class="form-control" required
                           style="border-radius:14px;padding:12px;border:1px solid #dbeee5;width:100%">
                </div>
                <div>
                    <label style="font-weight:800;display:block;margin-bottom:6px">Hora</label>
                    <input type="time" name="hora" id="editHora" class="form-control"
                           style="border-radius:14px;padding:12px;border:1px solid #dbeee5;width:100%">
                </div>
                <div>
                    <label style="font-weight:800;display:block;margin-bottom:6px">Precio ($)</label>
                    <input type="number" name="precio" id="editPrecio" class="form-control" min="0"
                           style="border-radius:14px;padding:12px;border:1px solid #dbeee5;width:100%">
                </div>
                <div>
                    <label style="font-weight:800;display:block;margin-bottom:6px">Motivo</label>
                    <textarea name="motivo" id="editMotivo" rows="3"
                              style="border-radius:14px;padding:12px;border:1px solid #dbeee5;width:100%;font-family:inherit;resize:vertical"></textarea>
                </div>
                <div style="display:flex;gap:12px;margin-top:8px">
                    <button type="submit" style="flex:1;border:0;border-radius:16px;background:linear-gradient(135deg,#00c875,#00f5a0);color:#003d25;padding:13px;font-weight:900;cursor:pointer;font-size:1rem">
                        <i class="ti ti-check"></i> Guardar cambios
                    </button>
                    <button type="button" onclick="cerrarEditar()" style="flex:1;border:1px solid #ddd;border-radius:16px;background:white;color:#003d25;padding:13px;font-weight:900;cursor:pointer;font-size:1rem">
                        <i class="ti ti-x"></i> Cancelar
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>

</body>
</html>