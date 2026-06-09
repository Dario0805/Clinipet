<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.clinipet.model.Usuario" %>

<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");

    List<Map<String,Object>> mascotas = (List<Map<String,Object>>) request.getAttribute("mascotas");
    List<Map<String,Object>> citas = (List<Map<String,Object>>) request.getAttribute("citas");
    List<Map<String,Object>> ventas = (List<Map<String,Object>>) request.getAttribute("ventas");
    List<Map<String,Object>> productos = (List<Map<String,Object>>) request.getAttribute("productos");

    if (mascotas == null) mascotas = new ArrayList<>();
    if (citas == null) citas = new ArrayList<>();

    // Citas con historia clínica (incluye diagnóstico, tratamiento, medicación)
    List<Map<String,Object>> citasHistoria = (List<Map<String,Object>>) request.getAttribute("citasHistoria");
    if (citasHistoria == null) citasHistoria = citas; // fallback
    if (ventas == null) ventas = new ArrayList<>();
    if (productos == null) productos = new ArrayList<>();
%>

<!doctype html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Panel cliente | CliniPet</title>
<meta name="viewport" content="width=device-width, initial-scale=1">

<link href="https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta20/dist/css/tabler.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/tabler-icons.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800;900&family=Fredoka:wght@600;700&display=swap" rel="stylesheet">

<style>
:root{
    --green:#00a85a;
    --green2:#00d978;
    --dark:#003d25;
    --muted:#64748b;
    --shadow:0 22px 70px rgba(0,60,35,.13);
}
*{box-sizing:border-box}
body{
    margin:0;
    font-family:"Nunito",sans-serif;
    background:linear-gradient(135deg,#fbfffd,#eafff4);
    color:#0f172a;
}
h1,h2,h3{font-family:"Fredoka",sans-serif}
.layout{display:flex;min-height:100vh}
.side{
    width:280px;
    position:fixed;
    left:0;
    top:0;
    min-height:100vh;
    background:linear-gradient(180deg,#00452a,#00371f);
    color:white;
    padding:28px 22px;
}
.brand{
    display:flex;
    gap:12px;
    align-items:center;
    margin-bottom:30px;
}
.brand-icon{
    width:58px;
    height:58px;
    border-radius:20px;
    background:white;
    color:#00a85a;
    display:grid;
    place-items:center;
    font-size:2rem;
}
.navx{display:grid;gap:10px}
.navx a{
    color:#eafff4;
    text-decoration:none;
    padding:14px 16px;
    border-radius:15px;
    font-weight:900;
    display:flex;
    gap:10px;
    align-items:center;
}
.navx a:hover,.navx a.active{background:rgba(0,200,117,.28)}
.main{
    margin-left:280px;
    width:calc(100% - 280px);
    padding:32px;
}
.top{
    display:flex;
    justify-content:space-between;
    align-items:center;
    gap:18px;
    margin-bottom:24px;
}
.title{
    font-size:2.5rem;
    color:#063823;
    margin:0;
}
.btnx{
    border:0;
    border-radius:14px;
    padding:12px 18px;
    font-weight:900;
    text-decoration:none;
    display:inline-flex;
    align-items:center;
    gap:8px;
}
.btn-green{
    background:linear-gradient(135deg,var(--green),var(--green2));
    color:white;
}
.btn-green:hover{color:white}
.btn-soft{
    background:white;
    color:#003d25;
    box-shadow:var(--shadow);
}
.btn-soft:hover{color:#003d25}
.btn-red{
    background:#ef4444;
    color:white;
}
.btn-red:hover{color:white}
.stats{
    display:grid;
    grid-template-columns:repeat(3,1fr);
    gap:18px;
    margin-bottom:24px;
}
.stat{
    background:white;
    border-radius:24px;
    padding:24px;
    box-shadow:var(--shadow);
}
.stat i{font-size:2rem;color:#00a85a}
.stat h2{font-size:2.2rem;margin:8px 0}
.stat span{color:#64748b;font-weight:800}
.grid{
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:22px;
}
.panel{
    background:white;
    border-radius:26px;
    box-shadow:var(--shadow);
    overflow:hidden;
    margin-bottom:22px;
}
.panel-head{
    padding:20px 22px;
    border-bottom:1px solid #dbeee5;
    display:flex;
    justify-content:space-between;
    align-items:center;
    gap:12px;
}
.panel-title{
    margin:0;
    color:#063823;
}
.panel-body{padding:22px}
.badge-soft{
    background:#dcfff0;
    color:#007f4f;
    border-radius:999px;
    padding:7px 12px;
    font-weight:900;
}
.table td,.table th{vertical-align:middle}

.modal-mascota{
    display:none;
    position:fixed;
    inset:0;
    background:rgba(0,30,18,.65);
    z-index:9999;
    align-items:center;
    justify-content:center;
    padding:20px;
}
.modal-mascota.show{display:flex}
.modal-card{
    background:white;
    width:min(650px,100%);
    border-radius:24px;
    overflow:hidden;
    box-shadow:0 30px 90px rgba(0,0,0,.25);
}
.modal-head{
    background:linear-gradient(135deg,#003d25,#00a85a);
    color:white;
    padding:22px;
    display:flex;
    justify-content:space-between;
    align-items:center;
}
.modal-head h2{margin:0;color:white}
.modal-close{
    border:0;
    background:rgba(255,255,255,.18);
    color:white;
    border-radius:12px;
    width:40px;
    height:40px;
    font-size:22px;
}
.modal-body{padding:24px}
.form-grid{
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:16px;
}
.form-grid .full{grid-column:1/-1}
.form-control,.form-select{
    border-radius:14px;
    padding:12px 14px;
}
label{font-weight:900;color:#064e3b;margin-bottom:6px}

@media(max-width:1050px){
    .side{position:relative;width:100%;min-height:auto}
    .main{margin-left:0;width:100%}
    .layout{display:block}
    .grid{grid-template-columns:1fr}
    .stats{grid-template-columns:1fr}
}
@media(max-width:620px){
    .top{align-items:flex-start;flex-direction:column}
    .form-grid{grid-template-columns:1fr}
    .form-grid .full{grid-column:auto}
}
.icon-btn{display:inline-flex;align-items:center;justify-content:center;width:30px;height:30px;border-radius:6px;border:none;cursor:pointer;font-size:14px;background:#e2e8f0;color:#64748b;transition:opacity .2s}
.icon-btn:hover{opacity:.8}
.icon-x{background:#ef4444;color:white}
</style>
</head>

<body>
<div class="layout">

    <aside class="side">
        <div class="brand">
            <span class="brand-icon"><i class="ti ti-paw"></i></span>
            <div>
                <h2 class="mb-0 text-white">CliniPet</h2>
                <small>Panel cliente</small>
            </div>
        </div>

        <nav class="navx">
            <a class="active" href="${pageContext.request.contextPath}/cliente/dashboard">
                <i class="ti ti-home"></i> Mi panel
            </a>

            <a href="${pageContext.request.contextPath}/citas/nueva">
                <i class="ti ti-calendar-plus"></i> Agendar cita
            </a>

            <a href="${pageContext.request.contextPath}/cliente/comprar">
                <i class="ti ti-shopping-cart"></i> Tienda
            </a>

            <a href="${pageContext.request.contextPath}/">
                <i class="ti ti-world"></i> Ir al inicio
            </a>

            <a href="${pageContext.request.contextPath}/logout" style="margin-top:16px;background:rgba(190,18,60,.25)">
                <i class="ti ti-logout"></i> Cerrar sesión
            </a>
        </nav>
    </aside>

    <main class="main">

        <div class="top">
            <div>
                <h1 class="title">Hola, <%= usuario != null ? usuario.getNombre() : "Cliente" %> 🐾</h1>
                <p class="text-secondary fw-bold">
                    Agenda citas y revisa la información de tus mascotas.
                </p>
            </div>

            <div class="d-flex gap-2 flex-wrap">
                <a href="${pageContext.request.contextPath}/" class="btnx btn-soft">
                    <i class="ti ti-world"></i> Ir al inicio
                </a>

                <a href="${pageContext.request.contextPath}/citas/nueva" class="btnx btn-green">
                    <i class="ti ti-calendar-plus"></i> Agendar cita
                </a>

                <a href="${pageContext.request.contextPath}/logout" class="btnx btn-red">
                    <i class="ti ti-logout"></i> Cerrar sesión
                </a>
            </div>
        </div>

        <% if(request.getParameter("ok") != null){ %>
        <div class="alert alert-success rounded-4 fw-bold">
            <% String okVal = request.getParameter("ok");
               if("cita".equals(okVal)){ %>
                <i class="ti ti-calendar-check"></i> ¡Cita agendada correctamente!
            <% } else if("compra".equals(okVal)){ %>
                <i class="ti ti-shopping-cart"></i> ¡Compra realizada correctamente!
            <% } else { %>
                <i class="ti ti-check"></i> <%= okVal %>
            <% } %>
        </div>
        <% } %>

        <% if(request.getParameter("error") != null){ %>
        <div class="alert alert-danger rounded-4 fw-bold">
            <%= request.getParameter("error") %>
        </div>
        <% } %>

        <section class="stats">
            <div class="stat">
                <i class="ti ti-paw"></i>
                <h2><%= mascotas.size() %></h2>
                <span>Mis mascotas</span>
            </div>

            <div class="stat">
                <i class="ti ti-calendar"></i>
                <h2><%= citas.size() %></h2>
                <span>Mis citas</span>
            </div>

            <div class="stat">
                <i class="ti ti-shopping-bag"></i>
                <h2><%= ventas.size() %></h2>
                <span>Mis compras</span>
            </div>
        </section>

        <section class="grid">

            <div class="panel">
                <div class="panel-head">
                    <h2 class="panel-title">
                        <i class="ti ti-paw"></i> Mis mascotas
                    </h2>

                    <button class="btnx btn-green" type="button" onclick="abrirModalMascota()">
                        <i class="ti ti-plus"></i> Nueva
                    </button>
                </div>

                <div class="panel-body">
                    <% for(Map<String,Object> m : mascotas){ %>
                    <div class="d-flex justify-content-between align-items-center p-3 rounded-4 mb-2"
                         style="background:#f7fffb;border:1px solid #dbeee5">
                        <div>
                            <strong><%= m.get("nombre") %></strong><br>
                            <span class="text-secondary">
                                <%= m.get("especie") %> · <%= m.get("raza") %>
                            </span>
                        </div>

                        <span class="badge-soft"><%= m.get("alerta") %></span>
                    </div>
                    <% } %>

                    <% if(mascotas.isEmpty()){ %>
                    <p class="text-secondary fw-bold">
                        No tienes mascotas vinculadas a tu cuenta.
                    </p>
                    <% } %>
                </div>
            </div>

            <div class="panel">
                <div class="panel-head">
                    <h2 class="panel-title">
                        <i class="ti ti-calendar"></i> Mis citas
                    </h2>

                    <a href="${pageContext.request.contextPath}/citas/nueva" class="btnx btn-green">
                        Nueva
                    </a>
                </div>

                <div class="table-responsive">
                    <table class="table card-table">
                        <thead>
                            <tr>
                                <th>Mascota</th>
                                <th>Fecha</th>
                                <th>Estado</th>
                                <th>Tratamiento</th>
                                <th>Descargar</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for(Map<String,Object> c : citasHistoria){ %>
                            <%
                                String estadoCita = c.get("estado") != null ? c.get("estado").toString() : "PENDIENTE";
                                boolean tieneHistoria = c.get("diagnostico") != null && !c.get("diagnostico").toString().isEmpty();
                                String badgeClass = "REALIZADA".equalsIgnoreCase(estadoCita) ? "badge-soft" :
                                                    "CANCELADA".equalsIgnoreCase(estadoCita) ? "badge-soft badge-danger" :
                                                    "CONFIRMADA".equalsIgnoreCase(estadoCita) ? "badge-soft badge-info" : "badge-soft badge-warning";
                            %>
                            <tr>
                                <td>
                                    <strong><%= c.get("mascota") %></strong>
                                    <% if (c.get("especie") != null) { %><br><small class="text-secondary"><%= c.get("especie") %></small><% } %>
                                </td>
                                <td>
                                    <%= c.get("fecha") %><br>
                                    <small class="text-secondary"><%= c.get("hora") != null ? c.get("hora") : "" %></small>
                                </td>
                                <td><span class="<%= badgeClass %>"><%= estadoCita %></span></td>
                                <td style="max-width:220px">
                                    <% if (tieneHistoria) { %>
                                        <div style="font-size:.82rem;color:#047857;font-weight:800">
                                            <i class="ti ti-pill" style="color:#00a85a"></i>
                                            <%= c.get("medicacion").toString().length() > 80
                                                ? c.get("medicacion").toString().substring(0, 80) + "..."
                                                : c.get("medicacion").toString() %>
                                        </div>
                                    <% } else { %>
                                        <span class="text-secondary" style="font-size:.82rem">Sin historia todavía</span>
                                    <% } %>
                                </td>
                                <td>
                                    <% if (tieneHistoria) { %>
                                    <a href="${pageContext.request.contextPath}/cliente/pdf-tratamiento?id_cita=<%= c.get("id_cita") %>"
                                       target="_blank"
                                       style="background:linear-gradient(135deg,#00a85a,#00d978);color:white;border-radius:12px;padding:8px 14px;font-weight:900;font-size:.82rem;text-decoration:none;display:inline-flex;align-items:center;gap:6px;white-space:nowrap"
                                       title="Descargar PDF del tratamiento">
                                        <i class="ti ti-file-type-pdf"></i> Descargar
                                    </a>
                                    <% } else { %>
                                    <span style="color:#cbd5e1;font-size:.8rem">—</span>
                                    <% } %>
                                </td>
                            </tr>
                            <% } %>
                            <% if(citasHistoria.isEmpty()){ %>
                            <tr>
                                <td colspan="5" class="text-center text-secondary p-4">
                                    No tienes citas todavía.
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

        </section>

        <section class="panel">
            <div class="panel-head">
                <h2 class="panel-title">
                    <i class="ti ti-shopping-bag"></i> Mis compras
                </h2>
            </div>

            <div class="table-responsive">
                <table class="table card-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Fecha</th>
                            <th>Total</th>
                            <th>Método</th>
                            <th>Estado</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>

                    <tbody>
                        <% for(Map<String,Object> v : ventas){ %>
                        <tr>
                            <td><%= v.get("id") %></td>
                            <td><%= v.get("fecha") %></td>
                            <td>$<%= v.get("total") %></td>
                            <td><%= v.get("metodo") %></td>
                            <td>
                                <%
                                String ev = String.valueOf(v.get("estado"));
                                String evStyle = "PENDIENTE".equalsIgnoreCase(ev)
                                    ? "background:#fff7ed;color:#c2410c;border:1px solid #fed7aa"
                                    : "CANCELADO".equalsIgnoreCase(ev)
                                    ? "background:#fff1f2;color:#be123c;border:1px solid #fecdd3"
                                    : "background:#dcfff0;color:#007f4f;border:1px solid #bbf7d0";
                                %>
                                <span class="badge-soft" style="<%= evStyle %>">
                                    <% if("PENDIENTE".equalsIgnoreCase(ev)){ %><i class="ti ti-clock"></i> En espera<% }
                                       else if("CONFIRMADO".equalsIgnoreCase(ev)){ %><i class="ti ti-check"></i> Confirmado<% }
                                       else { %><%= ev %><% } %>
                                </span>
                            </td>
                            <td>
                                <form method="post" action="${pageContext.request.contextPath}/cliente/ventas/eliminar" style="display:inline" onsubmit="return confirm('¿Eliminar esta compra?');"><input type="hidden" name="id" value="<%= v.get("id") %>"><button class="icon-btn icon-x" title="Eliminar compra"><i class="ti ti-trash"></i></button></form>
                            </td>
                        </tr>
                        <% } %>

                        <% if(ventas.isEmpty()){ %>
                        <tr>
                            <td colspan="6" class="text-center text-secondary p-4">
                                No tienes compras todavía.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </section>

        <!-- PRODUCTOS DESTACADOS -->
        <section class="panel" style="margin-top:20px">
            <div class="panel-head">
                <h2 class="panel-title"><i class="ti ti-shopping-bag"></i> Productos disponibles</h2>
                <a href="${pageContext.request.contextPath}/cliente/comprar" class="view-btn" style="text-decoration:none">
                    Ver todos
                </a>
            </div>
            <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:16px;padding:16px">
                <%
                int contProd = 0;
                for(Map<String,Object> p : productos){
                    if(contProd >= 4) break;
                    contProd++;
                    String imgP = p.get("imagen_url") != null && !String.valueOf(p.get("imagen_url")).trim().isEmpty()
                        ? String.valueOf(p.get("imagen_url"))
                        : "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?auto=format&fit=crop&w=400&q=60";
                    int stockP = 0;
                    try { stockP = Integer.parseInt(String.valueOf(p.get("stock"))); } catch(Exception ex){}
                %>
                <div style="background:white;border-radius:18px;box-shadow:0 8px 30px rgba(0,60,35,.10);overflow:hidden">
                    <div style="height:130px;background-image:url('<%= imgP %>');background-size:cover;background-position:center"></div>
                    <div style="padding:14px">
                        <strong style="font-size:.95rem"><%= p.get("nombre") %></strong><br>
                        <span style="color:#64748b;font-size:.82rem"><%= p.get("categoria") %></span><br>
                        <div style="display:flex;justify-content:space-between;align-items:center;margin-top:10px">
                            <span style="color:#00a85a;font-weight:900;font-size:1.05rem">$<%= p.get("precio") %></span>
                            <% if(stockP > 0){ %>
                            <a href="${pageContext.request.contextPath}/cliente/comprar"
                               style="border:0;border-radius:10px;background:linear-gradient(135deg,#00a85a,#00d978);color:white;padding:7px 12px;font-weight:700;cursor:pointer;font-size:.82rem;text-decoration:none;display:inline-flex;align-items:center;gap:5px">
                                <i class="ti ti-shopping-cart-plus"></i> Al carrito
                            </a>
                            <% } else { %>
                            <span style="color:#ef4444;font-size:.78rem;font-weight:700">Sin stock</span>
                            <% } %>
                        </div>
                    </div>
                </div>
                <% } %>
                <% if(productos.isEmpty()){ %>
                <div style="grid-column:1/-1;text-align:center;padding:30px;color:#64748b">
                    No hay productos disponibles.
                </div>
                <% } %>
            </div>
            <% if(productos.size() > 4){ %>
            <div style="text-align:center;padding:0 16px 20px">
                <a href="${pageContext.request.contextPath}/cliente/comprar"
                   style="display:inline-block;border:0;border-radius:14px;background:linear-gradient(135deg,#00a85a,#00d978);color:white;padding:12px 28px;font-weight:900;text-decoration:none">
                    <i class="ti ti-chevron-down"></i> Ver todos los productos (<%= productos.size() %>)
                </a>
            </div>
            <% } %>
        </section>

    </main>
</div>

<div id="modalMascota" class="modal-mascota">
    <div class="modal-card">

        <div class="modal-head">
            <h2>
                <i class="ti ti-paw"></i> Registrar mascota
            </h2>

            <button type="button" class="modal-close" onclick="cerrarModalMascota()">
                ×
            </button>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/cliente/mascotas/guardar" class="modal-body">
            <div class="form-grid">

                <div>
                    <label>Nombre</label>
                    <input class="form-control" name="nombre" required>
                </div>

                <div>
                    <label>Especie</label>
                    <select class="form-select" name="especie" required>
                        <option value="">Selecciona</option>
                        <option value="Perro">Perro</option>
                        <option value="Gato">Gato</option>
                        <option value="Ave">Ave</option>
                        <option value="Conejo">Conejo</option>
                        <option value="Otro">Otro</option>
                    </select>
                </div>

                <div>
                    <label>Raza</label>
                    <input class="form-control" name="raza" required>
                </div>

                <div>
                    <label>Fecha nacimiento</label>
                    <input class="form-control" type="date" name="fecha_nacimiento">
                </div>

                <div>
                    <label>Sexo</label>
                    <select class="form-select" name="sexo" required>
                        <option value="">Selecciona</option>
                        <option value="MACHO">MACHO</option>
                        <option value="HEMBRA">HEMBRA</option>
                    </select>
                </div>

                <div class="full d-flex justify-content-end gap-2 mt-2">
                    <button type="button" class="btnx btn-soft" onclick="cerrarModalMascota()">
                        Cancelar
                    </button>

                    <button class="btnx btn-green">
                        <i class="ti ti-device-floppy"></i> Guardar mascota
                    </button>
                </div>

            </div>
        </form>
    </div>
</div>

<script>
function abrirModalMascota(){
    document.getElementById('modalMascota').classList.add('show');
}

function cerrarModalMascota(){
    document.getElementById('modalMascota').classList.remove('show');
}

document.getElementById('modalMascota').addEventListener('click', function(e){
    if(e.target === this){
        cerrarModalMascota();
    }
});
</script>

</body>
</html>