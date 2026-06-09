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
<title>Panel enfermero | CliniPet</title>

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
        <div class="brand"><div class="brand-icon"><i class="ti ti-paw"></i></div><div><h2 class="brand-title">CliniPet</h2><small>Enfermero / Veterinario</small></div></div>
        <div class="user-card"><strong><%= usuario != null ? usuario.getNombre() : "Enfermero / Veterinario" %></strong><br><span class="opacity-75"><%= usuario != null ? usuario.getRol() : "Enfermero / Veterinario" %></span></div>
        <nav class="navx">
            <a class="" href="${pageContext.request.contextPath}/dashboard"><i class="ti ti-layout-dashboard"></i> Admin</a>
            <a class="" href="${pageContext.request.contextPath}/recepcionista/dashboard"><i class="ti ti-calendar-heart"></i> Recepción</a>
            <a class="active" href="${pageContext.request.contextPath}/enfermero/dashboard"><i class="ti ti-stethoscope"></i> Enfermero</a>
            <a href="${pageContext.request.contextPath}/"><i class="ti ti-home"></i> Inicio</a>
            <a href="${pageContext.request.contextPath}/logout" style="margin-top:16px;background:rgba(190,18,60,.25)"><i class="ti ti-logout"></i> Cerrar sesión</a>
        </nav>
    </aside>
    <main class="main">

<%
    List<Map<String,Object>> misCitas = (List<Map<String,Object>>) request.getAttribute("misCitas");
    if(misCitas==null)misCitas=new ArrayList<>();
%>
<% if ("historia".equals(request.getParameter("ok"))) { %>
<div style="background:#dcfff0;border:1px solid #a7f0c9;color:#047857;border-radius:18px;padding:14px 22px;margin-bottom:18px;font-weight:800;font-size:1rem;display:flex;align-items:center;gap:10px">
  <i class="ti ti-circle-check" style="font-size:1.4rem"></i>
  Historia clínica guardada correctamente. La cita fue marcada como <strong>REALIZADA</strong>.
</div>
<% } %>
<div class="topbar"><div><h1 class="title-main">Panel de enfermero / veterinario</h1><p class="subtitle">Acepta, cancela o marca tus citas como realizadas.</p></div></div>
<div class="stats"><div class="stat-card"><i class="ti ti-calendar-heart"></i><h2><%= misCitas.size() %></h2><span>Mis citas</span></div><div class="stat-card"><i class="ti ti-check"></i><h2>OK</h2><span>Realizadas</span></div><div class="stat-card"><i class="ti ti-x"></i><h2>NO</h2><span>Cancelar</span></div><div class="stat-card"><i class="ti ti-clock"></i><h2>Hoy</h2><span>Agenda</span></div></div>
<section class="panel"><div class="panel-head"><h3 class="panel-title"><i class="ti ti-stethoscope"></i> Mis citas</h3><input class="search-input table-search" data-target="tablaMisCitas" placeholder="Buscar paciente..." style="width:330px;max-width:100%"></div><div class="table-card table-responsive"><table class="table card-table" id="tablaMisCitas"><thead><tr><th>Mascota</th><th>Dueño</th><th>Fecha</th><th>Motivo</th><th>Precio</th><th>Estado</th><th>Acciones</th></tr></thead><tbody>
<% for(Map<String,Object> c:misCitas){ %><tr><td><strong><%= c.get("mascota") %></strong><br><span class="text-secondary"><%= c.get("especie") %></span></td><td><%= c.get("duenio") %></td><td><%= c.get("fecha") %> <span class="text-secondary"><%= c.get("hora") %></span></td><td><%= c.get("motivo") %></td><td>$<%= c.get("precio") != null ? c.get("precio") : "0" %></td><td><span class="badge-soft"><%= c.get("estado") %></span></td><td><div class="actions"><form method="post" action="${pageContext.request.contextPath}/enfermero/citas/aceptar"><input type="hidden" name="id" value="<%= c.get("id") %>"><button class="icon-btn ok"><i class="ti ti-check"></i></button></form><a href="${pageContext.request.contextPath}/veterinario/atender?id_cita=<%= c.get("id") %>" class="icon-btn edit" style="text-decoration:none" title="Llenar historia clínica"><i class="ti ti-notes-medical"></i></a><form method="post" action="${pageContext.request.contextPath}/enfermero/citas/cancelar"><input type="hidden" name="id" value="<%= c.get("id") %>"><button class="icon-btn delete"><i class="ti ti-x"></i></button></form></div></td></tr><% } if(misCitas.isEmpty()){ %><tr><td colspan="7" class="text-center text-secondary p-4">No tienes citas asignadas.</td></tr><% } %>
</tbody></table></div></section>

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
</script>

</body>
</html>