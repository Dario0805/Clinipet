<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.clinipet.model.Usuario" %>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    List<Map<String,Object>> citas = (List<Map<String,Object>>) request.getAttribute("citas");
    List<Map<String,Object>> ventas = (List<Map<String,Object>>) request.getAttribute("ventas");
    List<Map<String,Object>> productos = (List<Map<String,Object>>) request.getAttribute("productos");
    List<Map<String,Object>> veterinarios = (List<Map<String,Object>>) request.getAttribute("veterinarios");
    List<Map<String,Object>> usuarios = (List<Map<String,Object>>) request.getAttribute("usuarios");

    if (citas == null) citas = new ArrayList<>();
    if (ventas == null) ventas = new ArrayList<>();
    if (productos == null) productos = new ArrayList<>();
    if (veterinarios == null) veterinarios = new ArrayList<>();
    if (usuarios == null) usuarios = new ArrayList<>();

    int citasHoy = citas.size();
    int citasPendientes = 0;
    int stockBajo = 0;
    int ventasPendientes = 0;
    double totalVentas = 0;

    for (Map<String,Object> c : citas) {
        String estado = String.valueOf(c.get("estado"));
        if ("PENDIENTE".equalsIgnoreCase(estado)) citasPendientes++;
    }

    for (Map<String,Object> p : productos) {
        try {
            int stock = Integer.parseInt(String.valueOf(p.get("stock")));
            int minimo = 5;
            if (p.get("stock_minimo") != null) minimo = Integer.parseInt(String.valueOf(p.get("stock_minimo")));
            if (stock <= minimo) stockBajo++;
        } catch(Exception e) {}
    }

    for (Map<String,Object> v : ventas) {
        try {
            totalVentas += Double.parseDouble(String.valueOf(v.get("total")));
        } catch(Exception e) {}
        String estadoV = String.valueOf(v.get("estado"));
        if ("PENDIENTE".equalsIgnoreCase(estadoV)) ventasPendientes++;
    }
%>

<!doctype html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Dashboard administrativo | CliniPet</title>

<link href="https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta20/dist/css/tabler.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/tabler-icons.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800;900&family=Fredoka:wght@500;600;700&display=swap" rel="stylesheet">

<style>
:root{
    --green:#00a85a;
    --green2:#00d978;
    --dark:#003d25;
    --dark2:#005f3c;
    --text:#0f172a;
    --muted:#64748b;
    --line:#dbeee5;
    --bg:#f7fffb;
    --shadow:0 18px 55px rgba(0,60,35,.10);
    --blue:#2f80ed;
    --orange:#ff9f2d;
    --purple:#7c5cff;
    --red:#ef4444;
}
*{box-sizing:border-box}
html{scroll-behavior:smooth}
body{
    margin:0;
    font-family:"Nunito",sans-serif;
    color:var(--text);
    background:
        radial-gradient(circle at 24% 8%,rgba(0,200,117,.10),transparent 28%),
        radial-gradient(circle at 90% 15%,rgba(0,217,120,.10),transparent 30%),
        linear-gradient(135deg,#fbfffd,#eefbf5);
    overflow-x:hidden;
}
h1,h2,h3,h4,h5,.brand-title,.page-title{font-family:"Fredoka",sans-serif;letter-spacing:.1px}
.layout{display:flex;min-height:100vh}

.sidebar{
    width:292px;
    min-height:100vh;
    position:fixed;
    top:0;
    left:0;
    color:white;
    padding:28px 22px;
    display:flex;
    flex-direction:column;
    background:
        radial-gradient(circle at 10% 0%,rgba(0,217,120,.22),transparent 35%),
        linear-gradient(180deg,#00452a,#005934 52%,#00371f);
    box-shadow:18px 0 55px rgba(0,61,37,.24);
    z-index:1000;
}
.brand{
    display:flex;
    align-items:center;
    gap:15px;
    margin-bottom:32px;
}
.brand-icon{
    width:66px;
    height:66px;
    border-radius:22px;
    display:grid;
    place-items:center;
    background:white;
    color:var(--green);
    font-size:2.5rem;
    box-shadow:0 16px 35px rgba(0,0,0,.22);
}
.brand-title{margin:0;color:white;font-size:2.05rem;font-weight:700}
.brand small{color:#c9f7df;font-weight:800;font-size:1rem}
.nav-menu{display:grid;gap:12px}
.nav-menu a{
    display:flex;
    align-items:center;
    gap:13px;
    padding:16px 18px;
    color:#eafff4;
    text-decoration:none;
    font-weight:900;
    border-radius:16px;
    transition:.25s;
}
.nav-menu a i{font-size:1.45rem}
.nav-menu a:hover,.nav-menu a.active{
    background:linear-gradient(135deg,rgba(0,200,117,.85),rgba(0,150,85,.78));
    box-shadow:0 14px 28px rgba(0,0,0,.12);
    transform:translateX(4px);
}
.side-separator{height:1px;background:rgba(255,255,255,.14);margin:26px 0}
.user-panel{
    margin-top:auto;
    border:1px solid rgba(255,255,255,.18);
    background:rgba(255,255,255,.08);
    border-radius:22px;
    padding:18px;
}
.user-row{display:flex;align-items:center;gap:12px}
.avatar{
    width:56px;
    height:56px;
    border-radius:50%;
    background:#fff;
    color:#005934;
    display:grid;
    place-items:center;
    font-size:1.7rem;
}
.user-panel strong{color:white}
.role-pill{
    display:block;
    margin-top:14px;
    border-radius:10px;
    padding:10px;
    text-align:center;
    background:linear-gradient(135deg,#00a85a,#00d978);
    color:white;
    font-weight:900;
}
.side-footer{margin-top:26px;color:#c9f7df;font-size:.82rem}

.main{
    margin-left:292px;
    width:calc(100% - 292px);
    padding:28px 28px 38px;
}
.topbar{
    display:flex;
    justify-content:space-between;
    align-items:center;
    gap:18px;
    margin-bottom:28px;
}
.top-left{display:flex;align-items:center;gap:18px}
.menu-btn{
    width:46px;
    height:46px;
    border:0;
    border-radius:14px;
    background:white;
    display:grid;
    place-items:center;
    box-shadow:var(--shadow);
    font-size:1.45rem;
    color:#0f172a;
}
.page-title{
    margin:0;
    display:flex;
    align-items:center;
    gap:14px;
    color:#0f172a;
    font-size:2.25rem;
    font-weight:700;
}
.page-title i{color:var(--green);font-size:2.5rem}
.top-actions{display:flex;align-items:center;gap:22px;color:#0f172a;font-weight:800}
.top-actions i{font-size:1.35rem}
.notification{position:relative}
.notification span{
    position:absolute;
    top:-9px;
    right:-11px;
    width:21px;
    height:21px;
    border-radius:50%;
    display:grid;
    place-items:center;
    background:#ef4444;
    color:white;
    font-size:.72rem;
    font-weight:900;
}

.quick-actions{
    display:flex;
    gap:10px;
    flex-wrap:wrap;
    margin-bottom:22px;
}
.quick-btn{
    border:0;
    border-radius:12px;
    padding:12px 16px;
    font-weight:900;
    color:white;
    text-decoration:none;
    display:inline-flex;
    align-items:center;
    gap:8px;
    background:linear-gradient(135deg,#00a85a,#00d978);
    box-shadow:0 12px 26px rgba(0,168,90,.18);
}
.quick-btn.blue{background:linear-gradient(135deg,#2f80ed,#56a3ff)}
.quick-btn.orange{background:linear-gradient(135deg,#ff9f2d,#ffb45b)}
.quick-btn.purple{background:linear-gradient(135deg,#7c5cff,#9b7bff)}
.quick-btn.dark{background:linear-gradient(135deg,#003d25,#006b44)}

.stats{
    display:grid;
    grid-template-columns:repeat(4,1fr);
    gap:18px;
    margin-bottom:22px;
}
.stat-card{
    background:rgba(255,255,255,.94);
    border:1px solid rgba(15,23,42,.08);
    border-radius:12px;
    min-height:184px;
    padding:24px;
    position:relative;
    overflow:hidden;
    box-shadow:var(--shadow);
}
.stat-top{display:flex;gap:18px;align-items:flex-start}
.stat-icon{
    width:64px;
    height:64px;
    border-radius:15px;
    display:grid;
    place-items:center;
    color:white;
    font-size:2.25rem;
    box-shadow:0 16px 28px rgba(0,0,0,.13);
}
.stat-icon.green{background:linear-gradient(135deg,#00a85a,#00d978)}
.stat-icon.blue{background:linear-gradient(135deg,#2f80ed,#56a3ff)}
.stat-icon.orange{background:linear-gradient(135deg,#ff9f2d,#ffb45b)}
.stat-icon.purple{background:linear-gradient(135deg,#7c5cff,#9b7bff)}
.stat-card h3{margin:0;font-size:1.05rem;font-weight:800}
.stat-card h2{margin:9px 0 2px;font-family:"Nunito",sans-serif;font-size:2.2rem;font-weight:900;color:#0f172a}
.stat-card p{color:var(--muted);margin:0;font-weight:700}
.spark{position:absolute;left:18px;right:18px;bottom:0;height:54px;opacity:.78}
.spark svg{width:100%;height:100%}

.grid-2{
    display:grid;
    grid-template-columns:1.15fr .85fr;
    gap:20px;
    margin-bottom:20px;
}
.grid-2.bottom{grid-template-columns:1fr 1fr}
.panel{
    background:rgba(255,255,255,.96);
    border:1px solid rgba(15,23,42,.08);
    border-radius:12px;
    box-shadow:var(--shadow);
    overflow:hidden;
    margin-bottom:20px;
}
.panel-head{
    padding:18px 20px;
    border-bottom:1px solid rgba(15,23,42,.08);
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:14px;
    flex-wrap:wrap;
}
.panel-title{margin:0;display:flex;align-items:center;gap:10px;font-size:1.2rem;font-weight:800}
.panel-title i{color:var(--green)}
.panel-body{padding:20px}
.view-btn{
    border:0;
    background:linear-gradient(135deg,#00a85a,#00d978);
    color:white;
    font-weight:900;
    border-radius:8px;
    padding:8px 13px;
    text-decoration:none;
}
.search-box{
    width:100%;
    max-width:360px;
    border:1px solid rgba(15,23,42,.10);
    border-radius:12px;
    padding:11px 14px;
    font-weight:800;
    outline:none;
}
.search-box:focus{border-color:#00a85a;box-shadow:0 0 0 .2rem rgba(0,168,90,.12)}

.line-chart{height:250px;position:relative;padding:12px 12px 0 58px}
.chart-grid{
    position:absolute;
    inset:12px 18px 38px 58px;
    background:
        linear-gradient(to bottom, transparent calc(25% - 1px), rgba(15,23,42,.08) 25%, transparent calc(25% + 1px)),
        linear-gradient(to bottom, transparent calc(50% - 1px), rgba(15,23,42,.08) 50%, transparent calc(50% + 1px)),
        linear-gradient(to bottom, transparent calc(75% - 1px), rgba(15,23,42,.08) 75%, transparent calc(75% + 1px));
}
.y-labels{
    position:absolute;
    left:10px;
    top:11px;
    bottom:38px;
    display:flex;
    flex-direction:column;
    justify-content:space-between;
    color:#334155;
    font-size:.85rem;
    font-weight:700;
}
.chart-svg{position:absolute;inset:12px 18px 38px 58px}
.x-labels{
    position:absolute;
    left:58px;
    right:18px;
    bottom:13px;
    display:grid;
    grid-template-columns:repeat(7,1fr);
    text-align:center;
    color:#334155;
    font-weight:700;
    font-size:.85rem;
}

.alert-list{display:grid;gap:14px}
.alert-item{
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:16px;
    padding:18px;
    border-radius:10px;
    cursor:pointer;
    border:0;
    text-align:left;
}
.alert-left{display:flex;align-items:center;gap:15px}
.alert-icon{
    width:45px;
    height:45px;
    border-radius:50%;
    display:grid;
    place-items:center;
    color:white;
    font-size:1.35rem;
}
.alert-item h4{margin:0 0 4px;font-family:"Nunito",sans-serif;font-weight:900;font-size:1rem}
.alert-item p{margin:0;color:#334155}
.alert-red{background:#fff0f0}
.alert-red .alert-icon{background:#ef4444}
.alert-orange{background:#fff7e8}
.alert-orange .alert-icon{background:#ff9f2d}
.alert-blue{background:#eff6ff}
.alert-blue .alert-icon{background:#2f80ed}

.table{margin:0}
.table thead th{
    color:#00824b;
    font-size:.78rem;
    text-transform:uppercase;
    letter-spacing:.04em;
    font-weight:900;
    background:#fbfffd;
    border-bottom:1px solid rgba(15,23,42,.08);
}
.table tbody td{vertical-align:middle;font-weight:700}
.badge-status{
    border-radius:10px;
    padding:7px 12px;
    font-weight:900;
    display:inline-flex;
    align-items:center;
    gap:5px;
}
.badge-pendiente{background:#fff2d9;color:#e07800}
.badge-confirmada{background:#dfffe9;color:#00824b}
.badge-cancelada{background:#ffe0e0;color:#e11d48}
.badge-realizada{background:#e0f2fe;color:#0369a1}
.badge-bajo{background:#ffe0e0;color:#e11d48}
.badge-ok{background:#dfffe9;color:#00824b}
.icon-btn{
    width:34px;
    height:34px;
    border:0;
    border-radius:8px;
    display:grid;
    place-items:center;
    color:white;
    font-size:1.15rem;
    box-shadow:0 8px 18px rgba(0,0,0,.10);
}
.icon-ok{background:#00a85a}
.icon-x{background:#ef4444}
.icon-edit{background:#2f80ed}
.action-row{display:flex;gap:8px}
.product-mini{display:flex;align-items:center;gap:10px}
.product-img{
    width:36px;
    height:36px;
    border-radius:8px;
    background-size:cover;
    background-position:center;
    background-color:#f1f5f9;
}
.tab-content{display:none}
.tab-content.active{display:block}

.modalx{
    position:fixed;
    inset:0;
    background:rgba(0,30,18,.62);
    z-index:2000;
    display:none;
    align-items:center;
    justify-content:center;
    padding:20px;
}
.modalx.show{display:flex}
.modal-cardx{
    width:min(760px,100%);
    background:white;
    border-radius:20px;
    box-shadow:0 35px 100px rgba(0,0,0,.30);
    overflow:hidden;
}
.modal-headx{
    padding:20px 22px;
    background:linear-gradient(135deg,#003d25,#00a85a);
    color:white;
    display:flex;
    justify-content:space-between;
    align-items:center;
}
.modal-headx h3{color:white;margin:0}
.modal-close{
    border:0;
    width:38px;
    height:38px;
    border-radius:12px;
    background:rgba(255,255,255,.15);
    color:white;
    font-size:1.5rem;
}
.modal-bodyx{padding:22px}
.form-grid{
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:14px;
}
.form-grid .full{grid-column:1/-1}
.form-label{font-weight:900;color:#064e3b}
.form-control,.form-select{
    border-radius:12px;
    padding:12px 13px;
    border:1px solid rgba(15,23,42,.12);
}
.btn-save{
    border:0;
    border-radius:12px;
    padding:12px 18px;
    background:linear-gradient(135deg,#00a85a,#00d978);
    color:white;
    font-weight:900;
}
.btn-cancel{
    border:0;
    border-radius:12px;
    padding:12px 18px;
    background:#f1f5f9;
    color:#0f172a;
    font-weight:900;
}

@media(max-width:1250px){
    .stats{grid-template-columns:repeat(2,1fr)}
    .grid-2,.grid-2.bottom{grid-template-columns:1fr}
}
@media(max-width:900px){
    .layout{display:block}
    .sidebar{position:relative;width:100%;min-height:auto}
    .main{margin-left:0;width:100%;padding:20px}
    .topbar{align-items:flex-start;flex-direction:column}
}
@media(max-width:620px){
    .stats{grid-template-columns:1fr}
    .page-title{font-size:1.7rem}
    .form-grid{grid-template-columns:1fr}
    .form-grid .full{grid-column:auto}
}

.logout-top{
    background:#ef4444;
    color:white;
    padding:9px 14px;
    border-radius:12px;
    text-decoration:none;
    font-weight:900;
    display:inline-flex;
    align-items:center;
    gap:7px;
    box-shadow:0 12px 25px rgba(239,68,68,.18);
}
.logout-top:hover{color:white;transform:translateY(-2px)}
.notification{cursor:pointer}
.noti-box{
    display:none;
    position:absolute;
    right:0;
    top:42px;
    width:320px;
    background:white;
    border:1px solid rgba(15,23,42,.08);
    border-radius:16px;
    box-shadow:0 22px 70px rgba(0,30,18,.22);
    padding:14px;
    z-index:3000;
}
.noti-box.show{display:block}
.noti-title{
    font-weight:900;
    color:#003d25;
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:10px;
}
.noti-item{
    display:flex;
    gap:10px;
    align-items:flex-start;
    padding:12px;
    border-radius:12px;
    margin-top:8px;
    background:#f8fffb;
}
.noti-item.warning{background:#fff7e8;color:#9a4b00}
.noti-item.danger{background:#fff0f0;color:#b91c1c}
.noti-item.ok{background:#eafff4;color:#007f4f}
.noti-item i{font-size:1.35rem}
.toastx{
    position:fixed;
    right:24px;
    bottom:24px;
    background:#003d25;
    color:white;
    border-radius:16px;
    padding:14px 18px;
    box-shadow:0 22px 70px rgba(0,30,18,.30);
    display:none;
    z-index:4000;
    font-weight:900;
}
.toastx.show{display:flex;align-items:center;gap:9px}

</style>
</head>

<body>
<div class="layout">

    <aside class="sidebar">
        <div class="brand">
            <div class="brand-icon"><i class="ti ti-paw"></i></div>
            <div>
                <h2 class="brand-title">CliniPet</h2>
                <small>Administración</small>
            </div>
        </div>

        <nav class="nav-menu">
            <a class="active nav-tab" href="#" data-tab="resumen"><i class="ti ti-home"></i> Dashboard</a>
            <a class="nav-tab" href="#" data-tab="usuarios"><i class="ti ti-users"></i> Usuarios</a>
            <a class="nav-tab" href="#" data-tab="veterinarios"><i class="ti ti-stethoscope"></i> Veterinarios</a>
            <a class="nav-tab" href="#" data-tab="stock"><i class="ti ti-package"></i> Stock</a>
            <a class="nav-tab" href="#" data-tab="ventas"><i class="ti ti-shopping-cart"></i> Ventas</a>
        </nav>

        <div class="side-separator"></div>

        <nav class="nav-menu">
            <a href="${pageContext.request.contextPath}/logout"><i class="ti ti-logout"></i> Cerrar sesión</a>
        </nav>

        <div class="user-panel">
            <div class="user-row">
                <div class="avatar"><i class="ti ti-user"></i></div>
                <div>
                    <strong><%= usuario != null ? usuario.getNombre() : "Administrador" %></strong><br>
                    <span class="opacity-75">admin@clinipet.com</span>
                </div>
            </div>
            <span class="role-pill">Rol: <%= usuario != null ? usuario.getRol() : "Administrador" %></span>
        </div>

        <div class="side-footer">
            <h3 class="text-white mb-1"><i class="ti ti-paw"></i> CliniPet</h3>
            <span>Clínica Veterinaria</span><br><br>
            <small>© 2026 CliniPet.</small>
        </div>
    </aside>

    <main class="main">
        <div class="topbar">
            <div class="top-left">
                <button class="menu-btn" type="button"><i class="ti ti-menu-2"></i></button>
                <h1 class="page-title"><i class="ti ti-paw"></i> Dashboard administrativo</h1>
            </div>

            <div class="top-actions">
                <a href="${pageContext.request.contextPath}/logout" class="logout-top">
                    <i class="ti ti-logout"></i> Cerrar sesión
                </a>

                <span><i class="ti ti-clock"></i> 29/04/2026 16:35</span>

                <div class="notification" onclick="toggleNoti(event)">
                    <i class="ti ti-bell"></i>
                    <span><%= (stockBajo + citasPendientes + ventasPendientes) %></span>

                    <div class="noti-box" id="notiBox" onclick="event.stopPropagation()">
                        <div class="noti-title">
                            <span><i class="ti ti-bell"></i> Notificaciones</span>
                            <small><%= (stockBajo + citasPendientes + ventasPendientes) %> alertas</small>
                        </div>

                        <% if(ventasPendientes > 0){ %>
                        <div class="noti-item" style="background:#fff7ed;border-left:4px solid #f97316;padding:14px 16px;border-radius:14px;margin-bottom:8px">
                            <i class="ti ti-shopping-bag" style="color:#f97316;font-size:1.4rem;flex-shrink:0"></i>
                            <div style="flex:1">
                                <strong style="color:#9a3412"><%= ventasPendientes %> pedido<%= ventasPendientes > 1 ? "s" : "" %> pendiente<%= ventasPendientes > 1 ? "s" : "" %> de confirmar</strong><br>
                                <small style="color:#c2410c">Clientes esperan confirmación de su compra.</small><br>
                                <div style="margin-top:8px;display:flex;flex-direction:column;gap:6px">
                                <% for(Map<String,Object> v : ventas) {
                                    String ev = String.valueOf(v.get("estado"));
                                    if("PENDIENTE".equalsIgnoreCase(ev)) {
                                        Object idV = v.get("id") != null ? v.get("id") : v.get("id_venta");
                                %>
                                <form method="post" action="${pageContext.request.contextPath}/ventas/confirmar" style="display:flex;align-items:center;gap:8px">
                                    <input type="hidden" name="id" value="<%= idV %>">
                                    <span style="font-size:.82rem;color:#64748b;flex:1">
                                        Pedido #<%= idV %> — <%= v.get("cliente") %> — $<%= v.get("total") %>
                                    </span>
                                    <button type="submit" style="border:0;border-radius:10px;background:#00a85a;color:white;padding:5px 12px;font-weight:900;font-size:.78rem;cursor:pointer;white-space:nowrap">
                                        <i class="ti ti-check"></i> Confirmar
                                    </button>
                                </form>
                                <% }} %>
                                </div>
                            </div>
                        </div>
                        <% } %>

                        <% if(stockBajo > 0){ %>
                        <button class="noti-item warning w-100 border-0 text-start" type="button" onclick="showTab('stock')">
                            <i class="ti ti-package-off"></i>
                            <div>
                                <strong><%= stockBajo %> productos con stock bajo</strong><br>
                                <small>Haz clic para revisar el inventario completo.</small>
                            </div>
                        </button>
                        <% } %>

                        <% if(citasPendientes > 0){ %>
                        <button class="noti-item danger w-100 border-0 text-start" type="button" onclick="showTab('citas')">
                            <i class="ti ti-calendar-exclamation"></i>
                            <div>
                                <strong><%= citasPendientes %> citas pendientes</strong><br>
                                <small>Necesitan confirmación o seguimiento.</small>
                            </div>
                        </button>
                        <% } %>

                        <% if(stockBajo == 0 && citasPendientes == 0 && ventasPendientes == 0){ %>
                        <div class="noti-item ok">
                            <i class="ti ti-check"></i>
                            <div>
                                <strong>Todo está bien</strong><br>
                                <small>No tienes alertas pendientes.</small>
                            </div>
                        </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>

        <div class="quick-actions">
            <button class="quick-btn" type="button" onclick="openModal('modalProducto')"><i class="ti ti-plus"></i> Nuevo producto</button>
            <button class="quick-btn blue" type="button" onclick="openModal('modalUsuario')"><i class="ti ti-user-plus"></i> Nuevo usuario</button>
            <button class="quick-btn orange" type="button" onclick="openModal('modalVeterinario')"><i class="ti ti-stethoscope"></i> Nuevo veterinario</button>
            <a class="quick-btn purple" href="${pageContext.request.contextPath}/citas/nueva"><i class="ti ti-calendar-plus"></i> Nueva cita</a>
            <button class="quick-btn dark" type="button" onclick="generarPDF()"><i class="ti ti-file-type-pdf"></i> Exportar PDF</button>
        </div>

        <!-- RESUMEN -->
        <section id="tab-resumen" class="tab-content active">
            <section class="stats">
                <div class="stat-card">
                    <div class="stat-top">
                        <div class="stat-icon green"><i class="ti ti-calendar"></i></div>
                        <div>
                            <h3>Citas de hoy</h3>
                            <h2><%= citasHoy %></h2>
                            <p>Total citas programadas</p>
                        </div>
                    </div>
                    <div class="spark"><svg viewBox="0 0 300 60" preserveAspectRatio="none"><path d="M0 45 C30 43,40 50,65 35 C90 20,110 43,135 36 C155 30,165 44,185 33 C205 18,220 15,240 28 C260 40,275 8,300 16 L300 60 L0 60 Z" fill="rgba(0,200,117,.15)"></path><path d="M0 45 C30 43,40 50,65 35 C90 20,110 43,135 36 C155 30,165 44,185 33 C205 18,220 15,240 28 C260 40,275 8,300 16" fill="none" stroke="#00a85a" stroke-width="3"></path></svg></div>
                </div>

                <div class="stat-card">
                    <div class="stat-top">
                        <div class="stat-icon blue"><i class="ti ti-shopping-cart"></i></div>
                        <div>
                            <h3>Ventas de hoy</h3>
                            <h2>$<%= String.format("%,.0f", totalVentas) %></h2>
                            <p>Total en ventas</p>
                        </div>
                    </div>
                    <div class="spark"><svg viewBox="0 0 300 60" preserveAspectRatio="none"><path d="M0 45 C30 38,45 52,75 28 C105 10,125 44,150 35 C175 20,185 18,210 31 C235 45,245 8,270 15 C285 20,292 10,300 12 L300 60 L0 60 Z" fill="rgba(47,128,237,.14)"></path><path d="M0 45 C30 38,45 52,75 28 C105 10,125 44,150 35 C175 20,185 18,210 31 C235 45,245 8,270 15 C285 20,292 10,300 12" fill="none" stroke="#2f80ed" stroke-width="3"></path></svg></div>
                </div>

                <div class="stat-card">
                    <div class="stat-top">
                        <div class="stat-icon orange"><i class="ti ti-package"></i></div>
                        <div>
                            <h3>Stock bajo</h3>
                            <h2><%= stockBajo %></h2>
                            <p>Productos bajos</p>
                        </div>
                    </div>
                    <div class="spark"><svg viewBox="0 0 300 60" preserveAspectRatio="none"><path d="M0 35 C25 40,45 55,70 42 C95 28,115 54,140 42 C160 30,175 50,195 35 C215 18,235 22,250 35 C270 48,285 20,300 25 L300 60 L0 60 Z" fill="rgba(255,159,45,.15)"></path><path d="M0 35 C25 40,45 55,70 42 C95 28,115 54,140 42 C160 30,175 50,195 35 C215 18,235 22,250 35 C270 48,285 20,300 25" fill="none" stroke="#ff9f2d" stroke-width="3"></path></svg></div>
                </div>

                <div class="stat-card">
                    <div class="stat-top">
                        <div class="stat-icon purple"><i class="ti ti-file-description"></i></div>
                        <div>
                            <h3>Doctores</h3>
                            <h2><%= veterinarios.size() %></h2>
                            <p>Total doctores</p>
                        </div>
                    </div>
                    <div class="spark"><svg viewBox="0 0 300 60" preserveAspectRatio="none"><path d="M0 43 C25 38,45 50,70 24 C95 0,115 42,140 37 C160 34,175 48,195 33 C215 18,235 25,250 17 C270 5,285 8,300 13 L300 60 L0 60 Z" fill="rgba(124,92,255,.13)"></path><path d="M0 43 C25 38,45 50,70 24 C95 0,115 42,140 37 C160 34,175 48,195 33 C215 18,235 25,250 17 C270 5,285 8,300 13" fill="none" stroke="#7c5cff" stroke-width="3"></path></svg></div>
                </div>
            </section>

            <section class="grid-2">
                <div class="panel">
                    <div class="panel-head"><h3 class="panel-title"><i class="ti ti-chart-bar"></i> Ventas - Últimos 7 días</h3></div>
                    <div class="panel-body">
                        <div class="line-chart">
                            <div class="chart-grid"></div>
                            <div class="y-labels"><span>$1.500.000</span><span>$1.200.000</span><span>$900.000</span><span>$600.000</span><span>$300.000</span><span>$0</span></div>
                            <svg class="chart-svg" viewBox="0 0 700 230" preserveAspectRatio="none">
                                <defs><linearGradient id="areaGreen" x1="0" x2="0" y1="0" y2="1"><stop offset="0%" stop-color="#00a85a" stop-opacity=".26"/><stop offset="100%" stop-color="#00a85a" stop-opacity=".02"/></linearGradient></defs>
                                <path d="M0 170 L116 135 L232 165 L348 95 L464 148 L580 118 L700 105 L700 230 L0 230 Z" fill="url(#areaGreen)"></path>
                                <path d="M0 170 L116 135 L232 165 L348 95 L464 148 L580 118 L700 105" fill="none" stroke="#009b56" stroke-width="4"></path>
                                <circle cx="0" cy="170" r="7" fill="#009b56"></circle><circle cx="116" cy="135" r="7" fill="#009b56"></circle><circle cx="232" cy="165" r="7" fill="#009b56"></circle><circle cx="348" cy="95" r="7" fill="#009b56"></circle><circle cx="464" cy="148" r="7" fill="#009b56"></circle><circle cx="580" cy="118" r="7" fill="#009b56"></circle><circle cx="700" cy="105" r="7" fill="#009b56"></circle>
                            </svg>
                            <div class="x-labels"><span>23 Abr</span><span>24 Abr</span><span>25 Abr</span><span>26 Abr</span><span>27 Abr</span><span>28 Abr</span><span>29 Abr</span></div>
                        </div>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-head"><h3 class="panel-title"><i class="ti ti-alert-triangle text-warning"></i> Alertas importantes</h3></div>
                    <div class="panel-body">
                        <div class="alert-list">
                            <button class="alert-item alert-red" type="button" onclick="showTab('citas')">
                                <div class="alert-left"><div class="alert-icon"><i class="ti ti-exclamation-mark"></i></div><div><h4><%= citasPendientes %> citas pendientes por confirmar</h4><p>Hay citas que necesitan confirmación</p></div></div>
                                <i class="ti ti-chevron-right"></i>
                            </button>

                            <button class="alert-item alert-orange" type="button" onclick="showTab('stock')">
                                <div class="alert-left"><div class="alert-icon"><i class="ti ti-alert-triangle"></i></div><div><h4><%= stockBajo %> productos con stock bajo</h4><p>Productos que necesitan reposición</p></div></div>
                                <i class="ti ti-chevron-right"></i>
                            </button>

                            <button class="alert-item alert-blue" type="button" onclick="showTab('veterinarios')">
                                <div class="alert-left"><div class="alert-icon"><i class="ti ti-info-circle"></i></div><div><h4>Revisar doctores disponibles</h4><p>Antes de asignar una nueva cita</p></div></div>
                                <i class="ti ti-chevron-right"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </section>

            <section class="grid-2 bottom">
                <div class="panel">
                    <div class="panel-head">
                        <h3 class="panel-title"><i class="ti ti-calendar"></i> Citas de hoy</h3>
                        <button class="view-btn" type="button" onclick="showTab('citas')">Ver todas</button>
                    </div>
                    <div class="table-responsive">
                        <table class="table card-table">
                            <thead><tr><th>Hora</th><th>Paciente</th><th>Mascota</th><th>Servicio</th><th>Estado</th><th>Acciones</th></tr></thead>
                            <tbody>
                                <% for(Map<String,Object> c : citas){ 
                                    String estado = String.valueOf(c.get("estado"));
                                    String claseEstado = "badge-pendiente";
                                    if ("CONFIRMADA".equalsIgnoreCase(estado)) claseEstado = "badge-confirmada";
                                    if ("CANCELADA".equalsIgnoreCase(estado)) claseEstado = "badge-cancelada";
                                    if ("REALIZADA".equalsIgnoreCase(estado)) claseEstado = "badge-realizada";
                                %>
                                <tr>
                                    <td><%= c.get("hora") %></td>
                                    <td><%= c.get("duenio") %></td>
                                    <td><i class="ti ti-paw"></i> <%= c.get("mascota") %></td>
                                    <td><%= c.get("motivo") %></td>
                                    <td><span class="badge-status <%= claseEstado %>"><%= estado %></span></td>
                                    <td>
                                        <div class="action-row">
                                            <form method="post" action="${pageContext.request.contextPath}/citas/realizada">
                                                <input type="hidden" name="id" value="<%= c.get("id") != null ? c.get("id") : c.get("id_cita") %>">
                                                <button class="icon-btn icon-ok" title="Realizada"><i class="ti ti-check"></i></button>
                                            </form>
                                            <form method="post" action="${pageContext.request.contextPath}/citas/cancelar">
                                                <input type="hidden" name="id" value="<%= c.get("id") != null ? c.get("id") : c.get("id_cita") %>">
                                                <button class="icon-btn icon-x" title="Cancelar"><i class="ti ti-x"></i></button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                                <% } %>
                                <% if(citas.isEmpty()){ %><tr><td colspan="6" class="text-center text-secondary p-4">No hay citas registradas.</td></tr><% } %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-head">
                        <h3 class="panel-title"><i class="ti ti-package"></i> Productos en inventario</h3>
                        <button class="view-btn" type="button" onclick="showTab('stock')">Ver todos</button>
                    </div>
                    <div class="table-responsive">
                        <table class="table card-table">
                            <thead><tr><th>Producto</th><th>Categoría</th><th>Precio</th><th>Stock</th><th>Estado</th></tr></thead>
                            <tbody>
                                <%
                                int contadorProductos = 0;
                                for(Map<String,Object> p : productos){
                                    if(contadorProductos >= 5) break;
                                    contadorProductos++;
                                    int stock = 0;
                                    int stockMinimo = 5;
                                    try { stock = Integer.parseInt(String.valueOf(p.get("stock"))); } catch(Exception e) {}
                                    try { stockMinimo = Integer.parseInt(String.valueOf(p.get("stock_minimo"))); } catch(Exception e) {}
                                    boolean bajo = stock <= stockMinimo;
                                %>
                                <tr>
                                    <td><div class="product-mini"><div class="product-img" style="background-image:url('<%= p.get("imagen_url") != null ? p.get("imagen_url") : "" %>')"></div><strong><%= p.get("nombre") %></strong></div></td>
                                    <td><%= p.get("categoria") %></td>
                                    <td>$<%= p.get("precio") %></td>
                                    <td class="<%= bajo ? "text-danger fw-bold" : "text-success fw-bold" %>"><%= stock %></td>
                                    <td><span class="badge-status <%= bajo ? "badge-bajo" : "badge-ok" %>"><%= bajo ? "Stock bajo" : "Disponible" %></span></td>
                                </tr>
                                <% } %>
                                <% if(productos.isEmpty()){ %><tr><td colspan="5" class="text-center text-secondary p-4">No hay productos cargados.</td></tr><% } %>
                                <% if(productos.size() > 5){ %>
                                <tr>
                                    <td colspan="5" class="text-center p-3">
                                        <button class="view-btn" type="button" onclick="showTab('stock')" style="width:100%">
                                            <i class="ti ti-chevron-down"></i> Ver todos los productos (<%= productos.size() %>)
                                        </button>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </section>
        </section>

        <!-- CITAS COMPLETAS -->
        <section id="tab-citas" class="tab-content">
            <div class="panel">
                <div class="panel-head">
                    <h3 class="panel-title"><i class="ti ti-calendar"></i> Todas las citas</h3>
                    <input type="text" class="search-box table-search" data-target="tablaTodasCitas" placeholder="Buscar cita...">
                </div>
                <div class="table-responsive">
                    <table class="table card-table" id="tablaTodasCitas">
                        <thead><tr><th>ID</th><th>Dueño</th><th>Mascota</th><th>Doctor</th><th>Fecha</th><th>Hora</th><th>Motivo</th><th>Precio</th><th>Estado</th><th>Acciones</th></tr></thead>
                        <tbody>
                        <% for(Map<String,Object> c : citas){ %>
                            <tr>
                                <td><%= c.get("id") != null ? c.get("id") : c.get("id_cita") %></td>
                                <td><%= c.get("duenio") %></td>
                                <td><%= c.get("mascota") %></td>
                                <td><%= c.get("doctor") != null ? c.get("doctor") : c.get("veterinario") %></td>
                                <td><%= c.get("fecha") %></td>
                                <td><%= c.get("hora") %></td>
                                <td><%= c.get("motivo") %></td>
                                <td>$<%= c.get("precio") != null ? c.get("precio") : "0" %></td>
                                <td><span class="badge-status badge-pendiente"><%= c.get("estado") %></span></td>
                                <td>
                                    <div class="action-row">
                                        <button class="icon-btn icon-edit" type="button" onclick="openEditCita(this)" data-id="<%= c.get("id") != null ? c.get("id") : c.get("id_cita") %>" data-duenio="<%= c.get("duenio") %>" data-mascota="<%= c.get("mascota") %>" data-doctor="<%= c.get("doctor") != null ? c.get("doctor") : c.get("veterinario") %>" data-fecha="<%= c.get("fecha") %>" data-hora="<%= c.get("hora") %>" data-motivo="<%= c.get("motivo") %>" data-precio="<%= c.get("precio") != null ? c.get("precio") : "0" %>" data-estado="<%= c.get("estado") %>"><i class="ti ti-edit"></i></button>
                                        <form method="post" action="${pageContext.request.contextPath}/citas/realizada"><input type="hidden" name="id" value="<%= c.get("id") != null ? c.get("id") : c.get("id_cita") %>"><button class="icon-btn icon-ok"><i class="ti ti-check"></i></button></form>
                                        <form method="post" action="${pageContext.request.contextPath}/citas/cancelar"><input type="hidden" name="id" value="<%= c.get("id") != null ? c.get("id") : c.get("id_cita") %>"><button class="icon-btn icon-x"><i class="ti ti-x"></i></button></form>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                        <% if(citas.isEmpty()){ %><tr><td colspan="10" class="text-center text-secondary p-4">No hay citas.</td></tr><% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>

        <!-- USUARIOS -->
        <section id="tab-usuarios" class="tab-content">
            <div class="panel">
                <div class="panel-head">
                    <h3 class="panel-title"><i class="ti ti-users"></i> Usuarios registrados</h3>
                    <div class="d-flex gap-2 flex-wrap">
                        <input type="text" class="search-box table-search" data-target="tablaUsuarios" placeholder="Buscar usuario...">
                        <button class="view-btn" type="button" onclick="openModal('modalUsuario')">Agregar usuario</button>
                    </div>
                </div>
                <div class="table-responsive">
                    <table class="table card-table" id="tablaUsuarios">
                        <thead><tr><th>ID</th><th>Nombre</th><th>Correo</th><th>Rol</th><th>Estado</th><th>Acciones</th></tr></thead>
                        <tbody>
                        <% for(Map<String,Object> u : usuarios){ %>
                            <tr>
                                <td><%= u.get("id") != null ? u.get("id") : u.get("id_usuario") %></td>
                                <td><strong><%= u.get("nombre") %></strong></td>
                                <td><%= u.get("correo") %></td>
                                <td><span class="badge-status badge-ok"><%= u.get("rol") %></span></td>
                                <td><%= u.get("estado") != null ? u.get("estado") : "ACTIVO" %></td>
                                <td>
                                    <div class="action-row">
                                        <button class="icon-btn icon-edit" type="button" onclick="openEditUsuario(this)" data-id="<%= u.get("id") != null ? u.get("id") : u.get("id_usuario") %>" data-nombre="<%= u.get("nombre") %>" data-correo="<%= u.get("correo") %>" data-rol="<%= u.get("rol") %>" data-estado="<%= u.get("estado") != null ? u.get("estado") : "ACTIVO" %>"><i class="ti ti-edit"></i></button>
                                        <form method="post" action="${pageContext.request.contextPath}/usuarios/eliminar" onsubmit="return confirm('¿Eliminar usuario?');"><input type="hidden" name="id" value="<%= u.get("id") != null ? u.get("id") : u.get("id_usuario") %>"><button class="icon-btn icon-x"><i class="ti ti-trash"></i></button></form>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                        <% if(usuarios.isEmpty()){ %><tr><td colspan="6" class="text-center text-secondary p-4">No hay usuarios cargados desde el servlet.</td></tr><% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>

        <!-- VETERINARIOS -->
        <section id="tab-veterinarios" class="tab-content">
            <div class="panel">
                <div class="panel-head">
                    <h3 class="panel-title"><i class="ti ti-stethoscope"></i> Veterinarios</h3>
                    <div class="d-flex gap-2 flex-wrap">
                        <input type="text" class="search-box table-search" data-target="tablaVeterinarios" placeholder="Buscar veterinario...">
                        <button class="view-btn" type="button" onclick="openModal('modalVeterinario')">Agregar veterinario</button>
                    </div>
                </div>
                <div class="table-responsive">
                    <table class="table card-table" id="tablaVeterinarios">
                        <thead><tr><th>ID</th><th>Nombre</th><th>Correo</th><th>Teléfono</th><th>Especialidad</th><th>Estado</th><th>Acceso</th><th>Acciones</th></tr></thead>
                        <tbody>
                        <% for(Map<String,Object> v : veterinarios){ 
                            boolean tieneAcceso = v.get("id_usuario") != null && !String.valueOf(v.get("id_usuario")).equals("null") && !String.valueOf(v.get("id_usuario")).equals("0");
                        %>
                            <tr>
                                <td><%= v.get("id") != null ? v.get("id") : v.get("id_veterinario") %></td>
                                <td><strong><%= v.get("nombre") %></strong></td>
                                <td><%= v.get("correo") %></td>
                                <td><%= v.get("telefono") %></td>
                                <td><%= v.get("especialidad") %></td>
                                <td><span class="badge-status badge-ok"><%= v.get("estado") %></span></td>
                                <td>
                                    <% if(tieneAcceso){ %>
                                    <span class="badge-status badge-ok" title="Puede iniciar sesión en el panel"><i class="ti ti-lock-open"></i> Activo</span>
                                    <% } else { %>
                                    <span class="badge-status" style="background:#fff7ed;color:#c2410c" title="Sin contraseña asignada — usa el botón editar para asignarla"><i class="ti ti-lock"></i> Sin acceso</span>
                                    <% } %>
                                </td>
                                <td>
                                    <div class="action-row">
                                        <button class="icon-btn icon-edit" type="button" onclick="openEditVeterinario(this)" data-id="<%= v.get("id") != null ? v.get("id") : v.get("id_veterinario") %>" data-nombre="<%= v.get("nombre") %>" data-correo="<%= v.get("correo") %>" data-telefono="<%= v.get("telefono") %>" data-especialidad="<%= v.get("especialidad") %>" data-estado="<%= v.get("estado") %>"><i class="ti ti-edit"></i></button>
                                        <form method="post" action="${pageContext.request.contextPath}/veterinarios/eliminar" onsubmit="return confirm('¿Eliminar veterinario?');"><input type="hidden" name="id" value="<%= v.get("id") != null ? v.get("id") : v.get("id_veterinario") %>"><button class="icon-btn icon-x"><i class="ti ti-trash"></i></button></form>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                        <% if(veterinarios.isEmpty()){ %><tr><td colspan="8" class="text-center text-secondary p-4">No hay veterinarios.</td></tr><% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>

        <!-- STOCK COMPLETO -->
        <section id="tab-stock" class="tab-content">
            <div class="panel">
                <div class="panel-head">
                    <h3 class="panel-title"><i class="ti ti-package"></i> Todo el stock de productos</h3>
                    <div class="d-flex gap-2 flex-wrap">
                        <input type="text" class="search-box table-search" data-target="tablaStockCompleto" placeholder="Buscar producto...">
                        <button class="view-btn" type="button" onclick="openModal('modalProducto')">Agregar producto</button>
                    </div>
                </div>
                <div class="table-responsive">
                    <table class="table card-table" id="tablaStockCompleto">
                        <thead><tr><th>ID</th><th>Producto</th><th>Código</th><th>Categoría</th><th>Especie</th><th>Precio</th><th>Stock</th><th>Stock mínimo</th><th>Estado</th><th>Acciones</th></tr></thead>
                        <tbody>
                        <% for(Map<String,Object> p : productos){
                            int stock = 0;
                            int minimo = 5;
                            try { stock = Integer.parseInt(String.valueOf(p.get("stock"))); } catch(Exception e) {}
                            try { minimo = Integer.parseInt(String.valueOf(p.get("stock_minimo"))); } catch(Exception e) {}
                        %>
                            <tr>
                                <td><%= p.get("id") != null ? p.get("id") : p.get("id_producto") %></td>
                                <td><div class="product-mini"><div class="product-img" style="background-image:url('<%= p.get("imagen_url") != null ? p.get("imagen_url") : "" %>')"></div><strong><%= p.get("nombre") %></strong></div></td>
                                <td><%= p.get("codigo") %></td>
                                <td><%= p.get("categoria") %></td>
                                <td><%= p.get("especie") %></td>
                                <td>$<%= p.get("precio") %></td>
                                <td class="<%= stock <= minimo ? "text-danger fw-bold" : "text-success fw-bold" %>"><%= stock %></td>
                                <td><%= minimo %></td>
                                <td><span class="badge-status <%= stock <= minimo ? "badge-bajo" : "badge-ok" %>"><%= stock <= minimo ? "Bajo" : "Disponible" %></span></td>
                                <td>
                                    <div class="action-row">
                                        <button class="icon-btn icon-edit" type="button" onclick="openEditProducto(this)" data-id="<%= p.get("id") != null ? p.get("id") : p.get("id_producto") %>" data-codigo="<%= p.get("codigo") %>" data-nombre="<%= p.get("nombre") %>" data-categoria="<%= p.get("categoria") %>" data-especie="<%= p.get("especie") %>" data-precio="<%= p.get("precio") %>" data-stock="<%= p.get("stock") %>" data-stockminimo="<%= p.get("stock_minimo") %>" data-imagen="<%= p.get("imagen_url") %>"><i class="ti ti-edit"></i></button>
                                        <form method="post" action="${pageContext.request.contextPath}/productos/eliminar" onsubmit="return confirm('¿Eliminar producto?');"><input type="hidden" name="id" value="<%= p.get("id") != null ? p.get("id") : p.get("id_producto") %>"><button class="icon-btn icon-x"><i class="ti ti-trash"></i></button></form>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                        <% if(productos.isEmpty()){ %><tr><td colspan="10" class="text-center text-secondary p-4">No hay productos cargados.</td></tr><% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>

        <!-- VENTAS -->
        <section id="tab-ventas" class="tab-content">
            <div class="panel">
                <div class="panel-head">
                    <h3 class="panel-title"><i class="ti ti-shopping-cart"></i> Ventas y pedidos</h3>
                    <input type="text" class="search-box table-search" data-target="tablaVentas" placeholder="Buscar venta...">
                </div>
                <div class="table-responsive">
                    <table class="table card-table" id="tablaVentas">
                        <thead><tr><th>ID</th><th>Cliente</th><th>Fecha</th><th>Total</th><th>Método</th><th>Estado</th><th>Acciones</th></tr></thead>
                        <tbody>
                        <% for(Map<String,Object> v : ventas){ %>
                            <tr>
                                <td><%= v.get("id") != null ? v.get("id") : v.get("id_venta") %></td>
                                <td><strong><%= v.get("cliente") %></strong></td>
                                <td><%= v.get("fecha") %></td>
                                <td>$<%= v.get("total") %></td>
                                <td><%= v.get("metodo") != null ? v.get("metodo") : v.get("metodo_pago") %></td>
                                <td><span class="badge-status badge-ok"><%= v.get("estado") != null ? v.get("estado") : "RECIBIDO" %></span></td>
                                <td>
<button class="icon-btn icon-edit" type="button" title="Editar" onclick="openEditVenta(this)" data-id="<%= v.get("id") != null ? v.get("id") : v.get("id_venta") %>" data-total="<%= v.get("total") %>" data-metodo="<%= v.get("metodo") != null ? v.get("metodo") : "EFECTIVO" %>" data-estado="<%= v.get("estado") != null ? v.get("estado") : "CONFIRMADO" %>"><i class="ti ti-edit"></i></button>
<form method="post" action="${pageContext.request.contextPath}/ventas/confirmar" style="display:inline" onsubmit="return confirm('¿Confirmar esta venta?');"><input type="hidden" name="id" value="<%= v.get("id") != null ? v.get("id") : v.get("id_venta") %>"><button class="icon-btn" style="background:#00a85a;color:white" title="Confirmar"><i class="ti ti-check"></i></button></form>
<form method="post" action="${pageContext.request.contextPath}/ventas/eliminar" style="display:inline" onsubmit="return confirm('¿Eliminar esta venta?');"><input type="hidden" name="id" value="<%= v.get("id") != null ? v.get("id") : v.get("id_venta") %>"><button class="icon-btn icon-x" title="Eliminar"><i class="ti ti-trash"></i></button></form>
</td>
                            </tr>
                        <% } %>
                        <% if(ventas.isEmpty()){ %><tr><td colspan="7" class="text-center text-secondary p-4">No hay ventas registradas.</td></tr><% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>

    </main>
</div>

<!-- MODAL PRODUCTO -->
<div class="modalx" id="modalProducto">
    <div class="modal-cardx">
        <div class="modal-headx">
            <h3><i class="ti ti-package"></i> Nuevo producto</h3>
            <button class="modal-close" type="button" onclick="closeModal('modalProducto')"><i class="ti ti-x"></i></button>
        </div>
        <div class="modal-bodyx">
            <form method="post" action="${pageContext.request.contextPath}/productos/guardar">
                <div class="form-grid">
                    <div><label class="form-label">Código</label><input class="form-control" name="codigo" required></div>
                    <div><label class="form-label">Nombre</label><input class="form-control" name="nombre" required></div>
                    <div><label class="form-label">Categoría</label><input class="form-control" name="categoria" required></div>
                    <div><label class="form-label">Especie</label><input class="form-control" name="especie" required></div>
                    <div><label class="form-label">Precio</label><input class="form-control" name="precio" type="number" step="0.01" required></div>
                    <div><label class="form-label">Stock</label><input class="form-control" name="stock" type="number" required></div>
                    <div><label class="form-label">Stock mínimo</label><input class="form-control" name="stock_minimo" type="number" value="5" required></div>
                    <div><label class="form-label">Fecha vencimiento</label><input class="form-control" name="fecha_vencimiento" type="date"></div>
                    <div class="full"><label class="form-label">Imagen URL</label><input class="form-control" name="imagen_url"></div>
                    <div class="full"><label class="form-label">Descripción</label><textarea class="form-control" name="descripcion" rows="3"></textarea></div>
                    <div class="full d-flex justify-content-end gap-2 mt-2">
                        <button class="btn-cancel" type="button" onclick="closeModal('modalProducto')">Cancelar</button>
                        <button class="btn-save">Guardar producto</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL USUARIO -->
<div class="modalx" id="modalUsuario">
    <div class="modal-cardx">
        <div class="modal-headx">
            <h3><i class="ti ti-user-plus"></i> Nuevo usuario</h3>
            <button class="modal-close" type="button" onclick="closeModal('modalUsuario')"><i class="ti ti-x"></i></button>
        </div>
        <div class="modal-bodyx">
            <form method="post" action="${pageContext.request.contextPath}/usuarios/guardar">
                <div class="form-grid">
                    <div><label class="form-label">Nombre</label><input class="form-control" name="nombre" required></div>
                    <div><label class="form-label">Correo</label><input class="form-control" name="correo" type="email" required></div>
                    <div><label class="form-label">Contraseña</label><input class="form-control" name="password" type="password" required></div>
                    <div><label class="form-label">Rol</label><select class="form-select" name="rol"><option>ADMIN</option><option>RECEPCIONISTA</option><option>ENFERMERO</option><option>CLIENTE</option></select></div>
                    <div class="full d-flex justify-content-end gap-2 mt-2">
                        <button class="btn-cancel" type="button" onclick="closeModal('modalUsuario')">Cancelar</button>
                        <button class="btn-save">Guardar usuario</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL VETERINARIO -->
<div class="modalx" id="modalVeterinario">
    <div class="modal-cardx">
        <div class="modal-headx">
            <h3><i class="ti ti-stethoscope"></i> Nuevo veterinario</h3>
            <button class="modal-close" type="button" onclick="closeModal('modalVeterinario')"><i class="ti ti-x"></i></button>
        </div>
        <div class="modal-bodyx">
            <form method="post" action="${pageContext.request.contextPath}/veterinarios/guardar">
                <div class="form-grid">
                    <div><label class="form-label">Nombre</label><input class="form-control" name="nombre" required></div>
                    <div><label class="form-label">Especialidad</label><input class="form-control" name="especialidad" required></div>
                    <div><label class="form-label">Correo</label><input class="form-control" name="correo" type="email" required></div>
                    <div><label class="form-label">Teléfono</label><input class="form-control" name="telefono" required></div>
                    <div><label class="form-label">Estado</label><select class="form-select" name="estado"><option>DISPONIBLE</option><option>OCUPADO</option></select></div>
                    <div><label class="form-label">Contraseña de acceso</label><input class="form-control" name="contrasena" type="password" placeholder="Para que el veterinario pueda iniciar sesión" required></div>
                    <div class="full d-flex justify-content-end gap-2 mt-2">
                        <button class="btn-cancel" type="button" onclick="closeModal('modalVeterinario')">Cancelar</button>
                        <button class="btn-save">Guardar veterinario</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>



<!-- MODAL EDITAR CITA -->
<div class="modalx" id="modalEditCita">
    <div class="modal-cardx">
        <div class="modal-headx">
            <h3><i class="ti ti-edit"></i> Editar cita</h3>
            <button class="modal-close" type="button" onclick="closeModal('modalEditCita')"><i class="ti ti-x"></i></button>
        </div>
        <div class="modal-bodyx">
            <form method="post" action="${pageContext.request.contextPath}/citas/actualizar">
                <input type="hidden" name="id" id="editCitaId">
                <div class="form-grid">
                    <div><label class="form-label">Dueño</label><input class="form-control" name="duenio" id="editCitaDuenio" readonly></div>
                    <div><label class="form-label">Mascota</label><input class="form-control" name="mascota" id="editCitaMascota" readonly></div>
                    <div><label class="form-label">Doctor</label><input class="form-control" name="doctor" id="editCitaDoctor"></div>
                    <div><label class="form-label">Fecha</label><input class="form-control" name="fecha" id="editCitaFecha" type="date"></div>
                    <div><label class="form-label">Hora</label><input class="form-control" name="hora" id="editCitaHora" type="time"></div>
                    <div><label class="form-label">Precio</label><input class="form-control" name="precio" id="editCitaPrecio" type="number" step="0.01"></div>
                    <div class="full"><label class="form-label">Motivo</label><input class="form-control" name="motivo" id="editCitaMotivo"></div>
                    <div><label class="form-label">Estado</label><select class="form-select" name="estado" id="editCitaEstado"><option>PENDIENTE</option><option>CONFIRMADA</option><option>REALIZADA</option><option>CANCELADA</option></select></div>
                    <div class="full d-flex justify-content-end gap-2 mt-2">
                        <button class="btn-cancel" type="button" onclick="closeModal('modalEditCita')">Cancelar</button>
                        <button class="btn-save">Actualizar cita</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL EDITAR PRODUCTO -->
<div class="modalx" id="modalEditProducto">
    <div class="modal-cardx">
        <div class="modal-headx">
            <h3><i class="ti ti-edit"></i> Editar producto</h3>
            <button class="modal-close" type="button" onclick="closeModal('modalEditProducto')"><i class="ti ti-x"></i></button>
        </div>
        <div class="modal-bodyx">
            <form method="post" action="${pageContext.request.contextPath}/productos/actualizar">
                <input type="hidden" name="id" id="editProductoId">
                <div class="form-grid">
                    <div><label class="form-label">Código</label><input class="form-control" name="codigo" id="editProductoCodigo" required></div>
                    <div><label class="form-label">Nombre</label><input class="form-control" name="nombre" id="editProductoNombre" required></div>
                    <div><label class="form-label">Categoría</label><input class="form-control" name="categoria" id="editProductoCategoria" required></div>
                    <div><label class="form-label">Especie</label><input class="form-control" name="especie" id="editProductoEspecie" required></div>
                    <div><label class="form-label">Precio</label><input class="form-control" name="precio" id="editProductoPrecio" type="number" step="0.01" required></div>
                    <div><label class="form-label">Stock</label><input class="form-control" name="stock" id="editProductoStock" type="number" required></div>
                    <div><label class="form-label">Stock mínimo</label><input class="form-control" name="stock_minimo" id="editProductoStockMinimo" type="number" required></div>
                    <div class="full"><label class="form-label">Imagen URL</label><input class="form-control" name="imagen_url" id="editProductoImagen"></div>
                    <div class="full d-flex justify-content-end gap-2 mt-2">
                        <button class="btn-cancel" type="button" onclick="closeModal('modalEditProducto')">Cancelar</button>
                        <button class="btn-save">Actualizar producto</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL EDITAR USUARIO -->
<div class="modalx" id="modalEditUsuario">
    <div class="modal-cardx">
        <div class="modal-headx">
            <h3><i class="ti ti-edit"></i> Editar usuario</h3>
            <button class="modal-close" type="button" onclick="closeModal('modalEditUsuario')"><i class="ti ti-x"></i></button>
        </div>
        <div class="modal-bodyx">
            <form method="post" action="${pageContext.request.contextPath}/usuarios/actualizar">
                <input type="hidden" name="id" id="editUsuarioId">
                <div class="form-grid">
                    <div><label class="form-label">Nombre</label><input class="form-control" name="nombre" id="editUsuarioNombre" required></div>
                    <div><label class="form-label">Correo</label><input class="form-control" name="correo" id="editUsuarioCorreo" type="email" required></div>
                    <div><label class="form-label">Rol</label><select class="form-select" name="rol" id="editUsuarioRol"><option>ADMIN</option><option>RECEPCIONISTA</option><option>ENFERMERO</option><option>CLIENTE</option></select></div>
                    <div><label class="form-label">Estado</label><select class="form-select" name="estado" id="editUsuarioEstado"><option>ACTIVO</option><option>INACTIVO</option></select></div>
                    <div class="full d-flex justify-content-end gap-2 mt-2">
                        <button class="btn-cancel" type="button" onclick="closeModal('modalEditUsuario')">Cancelar</button>
                        <button class="btn-save">Actualizar usuario</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL EDITAR VETERINARIO -->
<div class="modalx" id="modalEditVeterinario">
    <div class="modal-cardx">
        <div class="modal-headx">
            <h3><i class="ti ti-edit"></i> Editar veterinario</h3>
            <button class="modal-close" type="button" onclick="closeModal('modalEditVeterinario')"><i class="ti ti-x"></i></button>
        </div>
        <div class="modal-bodyx">
            <form method="post" action="${pageContext.request.contextPath}/veterinarios/actualizar">
                <input type="hidden" name="id" id="editVetId">
                <div class="form-grid">
                    <div><label class="form-label">Nombre</label><input class="form-control" name="nombre" id="editVetNombre" required></div>
                    <div><label class="form-label">Especialidad</label><input class="form-control" name="especialidad" id="editVetEspecialidad" required></div>
                    <div><label class="form-label">Correo</label><input class="form-control" name="correo" id="editVetCorreo" type="email" required></div>
                    <div><label class="form-label">Teléfono</label><input class="form-control" name="telefono" id="editVetTelefono" required></div>
                    <div><label class="form-label">Estado</label><select class="form-select" name="estado" id="editVetEstado"><option>DISPONIBLE</option><option>OCUPADO</option></select></div>
                    <div>
                        <label class="form-label">Nueva contraseña <span style="color:#94a3b8;font-weight:400">(dejar vacío para no cambiar)</span></label>
                        <input class="form-control" name="contrasena" id="editVetContrasena" type="password" placeholder="Nueva contraseña de acceso">
                    </div>
                    <div class="full d-flex justify-content-end gap-2 mt-2">
                        <button class="btn-cancel" type="button" onclick="closeModal('modalEditVeterinario')">Cancelar</button>
                        <button class="btn-save">Actualizar veterinario</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="toastx" id="toastx"><i class="ti ti-check"></i><span id="toastText">Listo</span></div>

<!-- MODAL EDITAR VENTA -->
<div class="modalx" id="modalEditVenta">
    <div class="modal-cardx">
        <div class="modal-headx">
            <h3><i class="ti ti-edit"></i> Editar venta</h3>
            <button class="modal-close" type="button" onclick="closeModal('modalEditVenta')"><i class="ti ti-x"></i></button>
        </div>
        <div class="modal-bodyx">
            <form method="post" action="${pageContext.request.contextPath}/ventas/actualizar">
                <input type="hidden" name="id" id="editVentaId">
                <div class="form-grid">
                    <div><label class="form-label">Total ($)</label><input class="form-control" name="total" id="editVentaTotal" type="number" step="0.01" required></div>
                    <div><label class="form-label">Método de pago</label>
                        <select class="form-select" name="metodo_pago" id="editVentaMetodo">
                            <option value="EFECTIVO">EFECTIVO</option>
                            <option value="TARJETA">TARJETA</option>
                            <option value="TRANSFERENCIA">TRANSFERENCIA</option>
                            <option value="PENDIENTE">PENDIENTE</option>
                        </select>
                    </div>
                    <div><label class="form-label">Estado</label>
                        <select class="form-select" name="estado" id="editVentaEstado">
                            <option value="CONFIRMADO">CONFIRMADO</option>
                            <option value="PENDIENTE">PENDIENTE</option>
                            <option value="CANCELADO">CANCELADO</option>
                        </select>
                    </div>
                    <div class="full d-flex justify-content-end gap-2 mt-2">
                        <button class="btn-cancel" type="button" onclick="closeModal('modalEditVenta')">Cancelar</button>
                        <button class="btn-save">Actualizar venta</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<script>

function toggleNoti(event){
    event.stopPropagation();
    const box = document.getElementById('notiBox');
    if(box) box.classList.toggle('show');
}

document.addEventListener('click', function(){
    const box = document.getElementById('notiBox');
    if(box) box.classList.remove('show');
});

function toast(msg){
    const t = document.getElementById('toastx');
    const txt = document.getElementById('toastText');
    if(!t || !txt) return;
    txt.textContent = msg;
    t.classList.add('show');
    setTimeout(function(){ t.classList.remove('show'); }, 2500);
}


function openEditVenta(btn){
    document.getElementById('editVentaId').value = btn.dataset.id || '';
    document.getElementById('editVentaTotal').value = btn.dataset.total || '';
    document.getElementById('editVentaMetodo').value = btn.dataset.metodo || 'EFECTIVO';
    document.getElementById('editVentaEstado').value = btn.dataset.estado || 'CONFIRMADO';
    openModal('modalEditVenta');
}

function openEditCita(btn){
    document.getElementById('editCitaId').value = btn.dataset.id || '';
    document.getElementById('editCitaDuenio').value = btn.dataset.duenio || '';
    document.getElementById('editCitaMascota').value = btn.dataset.mascota || '';
    document.getElementById('editCitaDoctor').value = btn.dataset.doctor || '';
    document.getElementById('editCitaFecha').value = btn.dataset.fecha || '';
    document.getElementById('editCitaHora').value = (btn.dataset.hora || '').substring(0,5);
    document.getElementById('editCitaMotivo').value = btn.dataset.motivo || '';
    document.getElementById('editCitaPrecio').value = btn.dataset.precio || '0';
    document.getElementById('editCitaEstado').value = btn.dataset.estado || 'PENDIENTE';
    openModal('modalEditCita');
}

function openEditProducto(btn){
    document.getElementById('editProductoId').value = btn.dataset.id || '';
    document.getElementById('editProductoCodigo').value = btn.dataset.codigo || '';
    document.getElementById('editProductoNombre').value = btn.dataset.nombre || '';
    document.getElementById('editProductoCategoria').value = btn.dataset.categoria || '';
    document.getElementById('editProductoEspecie').value = btn.dataset.especie || '';
    document.getElementById('editProductoPrecio').value = btn.dataset.precio || '';
    document.getElementById('editProductoStock').value = btn.dataset.stock || '';
    document.getElementById('editProductoStockMinimo').value = btn.dataset.stockminimo || '5';
    document.getElementById('editProductoImagen').value = btn.dataset.imagen || '';
    openModal('modalEditProducto');
}

function openEditUsuario(btn){
    document.getElementById('editUsuarioId').value = btn.dataset.id || '';
    document.getElementById('editUsuarioNombre').value = btn.dataset.nombre || '';
    document.getElementById('editUsuarioCorreo').value = btn.dataset.correo || '';
    document.getElementById('editUsuarioRol').value = btn.dataset.rol || 'CLIENTE';
    document.getElementById('editUsuarioEstado').value = btn.dataset.estado || 'ACTIVO';
    openModal('modalEditUsuario');
}

function openEditVeterinario(btn){
    document.getElementById('editVetId').value = btn.dataset.id || '';
    document.getElementById('editVetNombre').value = btn.dataset.nombre || '';
    document.getElementById('editVetCorreo').value = btn.dataset.correo || '';
    document.getElementById('editVetTelefono').value = btn.dataset.telefono || '';
    document.getElementById('editVetEspecialidad').value = btn.dataset.especialidad || '';
    document.getElementById('editVetEstado').value = btn.dataset.estado || 'DISPONIBLE';
    openModal('modalEditVeterinario');
}

function showTab(tab){
    document.querySelectorAll('.tab-content').forEach(function(section){
        section.classList.remove('active');
    });
    document.querySelectorAll('.nav-tab').forEach(function(link){
        link.classList.remove('active');
    });

    const target = document.getElementById('tab-' + tab);
    if(target){
        target.classList.add('active');
    }

    document.querySelectorAll('.nav-tab').forEach(function(link){
        if(link.dataset.tab === tab){
            link.classList.add('active');
        }
    });

    window.scrollTo({top:0, behavior:'smooth'});
}

document.querySelectorAll('.nav-tab').forEach(function(link){
    link.addEventListener('click', function(e){
        e.preventDefault();
        showTab(link.dataset.tab);
    });
});

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

function openModal(id){
    document.getElementById(id).classList.add('show');
}
function closeModal(id){
    document.getElementById(id).classList.remove('show');
}

document.querySelectorAll('.modalx').forEach(function(modal){
    modal.addEventListener('click', function(e){
        if(e.target === modal){
            modal.classList.remove('show');
        }
    });
});

(function(){
    const params = new URLSearchParams(window.location.search);
    const ok = params.get('ok');
    if(ok){
        const msgs = {
            'Cita+registrada+correctamente': 'Cita registrada correctamente',
            'Cita+actualizada+correctamente': 'Cita actualizada correctamente',
            'Venta+eliminada+correctamente': 'Venta eliminada correctamente',
            'Venta+actualizada+correctamente': 'Venta actualizada correctamente',
            'Venta+confirmada+correctamente': 'Venta confirmada correctamente'
        };
        toast(msgs[ok] || decodeURIComponent(ok.replace(/\+/g,' ')));
    }
    if(params.get('error')) toast('Error: ' + decodeURIComponent(params.get('error').replace(/\+/g,' ')));
})();

</script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.8.2/jspdf.plugin.autotable.min.js"></script>
<script>
function generarPDF() {
    const { jsPDF } = window.jspdf;
    const doc = new jsPDF({ orientation: 'portrait', unit: 'mm', format: 'a4' });

    const GREEN = [0, 168, 90];
    const DARK  = [0, 61, 37];
    const GRAY  = [100, 116, 139];
    const W = doc.internal.pageSize.getWidth();
    const now = new Date();
    const fecha = now.toLocaleDateString('es-CO', {year:'numeric',month:'long',day:'numeric',hour:'2-digit',minute:'2-digit'});

    // ─── ENCABEZADO ───
    doc.setFillColor(...GREEN);
    doc.roundedRect(0, 0, W, 32, 0, 0, 'F');
    doc.setTextColor(255,255,255);
    doc.setFontSize(22);
    doc.setFont('helvetica','bold');
    doc.text('CliniPet', 14, 14);
    doc.setFontSize(10);
    doc.setFont('helvetica','normal');
    doc.text('Clínica Veterinaria — Reporte General', 14, 22);
    doc.text(fecha, W - 14, 22, { align: 'right' });

    let y = 40;

    function sectionTitle(title, icon) {
        doc.setFillColor(...DARK);
        doc.roundedRect(10, y, W - 20, 9, 2, 2, 'F');
        doc.setTextColor(255,255,255);
        doc.setFontSize(11);
        doc.setFont('helvetica','bold');
        doc.text(title, 14, y + 6.2);
        y += 13;
    }

    function checkPage(needed) {
        if (y + needed > 275) { doc.addPage(); y = 16; }
    }

    // ─── VENTAS ───
    sectionTitle('Ventas registradas');
    const ventasTable = document.getElementById('tablaVentas');
    if (ventasTable) {
        const rows = [];
        ventasTable.querySelectorAll('tbody tr').forEach(tr => {
            const cells = tr.querySelectorAll('td');
            if (cells.length >= 5) {
                rows.push([
                    cells[0]?.innerText?.trim() || '',
                    cells[1]?.innerText?.trim() || '',
                    cells[2]?.innerText?.trim() || '',
                    cells[3]?.innerText?.trim() || '',
                    cells[4]?.innerText?.trim() || ''
                ]);
            }
        });
        if (rows.length > 0) {
            doc.autoTable({
                startY: y,
                head: [['ID', 'Cliente', 'Fecha', 'Total', 'Estado']],
                body: rows,
                styles: { fontSize: 8.5, cellPadding: 3 },
                headStyles: { fillColor: GREEN, textColor: 255, fontStyle: 'bold' },
                alternateRowStyles: { fillColor: [240, 255, 248] },
                margin: { left: 10, right: 10 }
            });
            y = doc.lastAutoTable.finalY + 10;
        }
    }

    // ─── CITAS ───
    checkPage(30);
    sectionTitle('Citas médicas');
    const citasTable = document.getElementById('tablaTodasCitas');
    if (citasTable) {
        const rows = [];
        citasTable.querySelectorAll('tbody tr').forEach(tr => {
            const cells = tr.querySelectorAll('td');
            if (cells.length >= 5) {
                rows.push([
                    cells[0]?.innerText?.trim() || '',
                    cells[1]?.innerText?.trim() || '',
                    cells[2]?.innerText?.trim() || '',
                    cells[3]?.innerText?.trim() || '',
                    cells[4]?.innerText?.trim() || ''
                ]);
            }
        });
        if (rows.length > 0) {
            doc.autoTable({
                startY: y,
                head: [['Mascota', 'Dueño', 'Fecha', 'Motivo', 'Estado']],
                body: rows,
                styles: { fontSize: 8.5, cellPadding: 3 },
                headStyles: { fillColor: [47, 128, 237], textColor: 255, fontStyle: 'bold' },
                alternateRowStyles: { fillColor: [240, 248, 255] },
                margin: { left: 10, right: 10 }
            });
            y = doc.lastAutoTable.finalY + 10;
        }
    }

    // ─── STOCK DE PRODUCTOS ───
    checkPage(30);
    sectionTitle('Inventario de productos');
    const stockTable = document.getElementById('tablaStockCompleto');
    if (stockTable) {
        const rows = [];
        stockTable.querySelectorAll('tbody tr').forEach(tr => {
            const cells = tr.querySelectorAll('td');
            if (cells.length >= 4) {
                rows.push([
                    cells[0]?.innerText?.trim() || '',
                    cells[1]?.innerText?.trim() || '',
                    cells[2]?.innerText?.trim() || '',
                    cells[3]?.innerText?.trim() || ''
                ]);
            }
        });
        if (rows.length > 0) {
            doc.autoTable({
                startY: y,
                head: [['Producto', 'Categoría', 'Precio', 'Stock']],
                body: rows,
                styles: { fontSize: 8.5, cellPadding: 3 },
                headStyles: { fillColor: [255, 159, 45], textColor: 255, fontStyle: 'bold' },
                alternateRowStyles: { fillColor: [255, 251, 240] },
                margin: { left: 10, right: 10 }
            });
            y = doc.lastAutoTable.finalY + 10;
        }
    }

    // ─── VETERINARIOS ───
    checkPage(30);
    sectionTitle('Veterinarios');
    const vetTable = document.getElementById('tablaVeterinarios');
    if (vetTable) {
        const rows = [];
        vetTable.querySelectorAll('tbody tr').forEach(tr => {
            const cells = tr.querySelectorAll('td');
            if (cells.length >= 5) {
                rows.push([
                    cells[0]?.innerText?.trim() || '',
                    cells[1]?.innerText?.trim() || '',
                    cells[2]?.innerText?.trim() || '',
                    cells[3]?.innerText?.trim() || '',
                    cells[4]?.innerText?.trim() || ''
                ]);
            }
        });
        if (rows.length > 0) {
            doc.autoTable({
                startY: y,
                head: [['ID', 'Nombre', 'Correo', 'Teléfono', 'Especialidad']],
                body: rows,
                styles: { fontSize: 8.5, cellPadding: 3 },
                headStyles: { fillColor: [124, 92, 255], textColor: 255, fontStyle: 'bold' },
                alternateRowStyles: { fillColor: [248, 245, 255] },
                margin: { left: 10, right: 10 }
            });
            y = doc.lastAutoTable.finalY + 10;
        }
    }

    // ─── PIE ───
    const pages = doc.internal.getNumberOfPages();
    for (let i = 1; i <= pages; i++) {
        doc.setPage(i);
        doc.setFontSize(8);
        doc.setTextColor(...GRAY);
        doc.text('CliniPet © ' + now.getFullYear() + ' — Generado el ' + fecha, 14, 291);
        doc.text('Pág. ' + i + ' de ' + pages, W - 14, 291, { align: 'right' });
    }

    doc.save('CliniPet_Reporte_' + now.toISOString().slice(0,10) + '.pdf');
    toast('PDF generado correctamente');
}
</script>

</body>
</html>
