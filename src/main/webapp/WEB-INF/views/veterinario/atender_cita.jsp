<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.clinipet.model.Usuario" %>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    Map<String,Object> d = (Map<String,Object>) request.getAttribute("datos");
    if (d == null) { response.sendRedirect(request.getContextPath() + "/enfermero/dashboard"); return; }

    String mascota    = d.get("mascota")    != null ? d.get("mascota").toString()    : "";
    String especie    = d.get("especie")    != null ? d.get("especie").toString()    : "";
    String raza       = d.get("raza")       != null ? d.get("raza").toString()       : "";
    String sexo       = d.get("sexo")       != null ? d.get("sexo").toString()       : "";
    String duenio     = d.get("duenio")     != null ? d.get("duenio").toString()     : "";
    String telDuenio  = d.get("tel_duenio") != null ? d.get("tel_duenio").toString() : "";
    String fecha      = d.get("fecha")      != null ? d.get("fecha").toString()      : "";
    String hora       = d.get("hora")       != null ? d.get("hora").toString()       : "";
    String motivo     = d.get("motivo")     != null ? d.get("motivo").toString()     : "";
    String idCita     = d.get("id_cita")    != null ? d.get("id_cita").toString()    : "";
    String idMascota  = d.get("id_mascota") != null ? d.get("id_mascota").toString() : "";

    // Pre-llenar si ya existe historia
    String diagnostico   = d.get("diagnostico")  != null ? d.get("diagnostico").toString()  : "";
    String tratamiento   = d.get("tratamiento")  != null ? d.get("tratamiento").toString()  : "";
    String medicacion    = d.get("medicacion")   != null ? d.get("medicacion").toString()   : "";
    String observaciones = d.get("observaciones")!= null ? d.get("observaciones").toString(): "";
%>
<!doctype html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Atender cita #<%= idCita %> | CliniPet</title>
<link href="https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta20/dist/css/tabler.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/tabler-icons.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800;900&family=Fredoka:wght@600;700&display=swap" rel="stylesheet">
<style>
:root{--green:#00c875;--green2:#00f5a0;--dark:#003d25;--muted:#64748b;--shadow:0 20px 60px rgba(0,80,50,.12)}
*{box-sizing:border-box}
body{margin:0;font-family:"Nunito",sans-serif;background:linear-gradient(135deg,#f8fffb,#eafff4);color:#0f172a;min-height:100vh}
h1,h2,h3,h4{font-family:"Fredoka",sans-serif}

.topbar{background:linear-gradient(135deg,#003d25,#007f4f);color:white;padding:18px 32px;display:flex;align-items:center;gap:18px;box-shadow:0 4px 20px rgba(0,61,37,.2)}
.topbar .brand{font-family:"Fredoka",sans-serif;font-size:1.6rem;font-weight:700;color:white;text-decoration:none;display:flex;align-items:center;gap:10px}
.topbar .brand-icon{width:44px;height:44px;border-radius:14px;background:white;color:#00c875;display:grid;place-items:center;font-size:1.4rem}
.topbar .sep{color:rgba(255,255,255,.4);font-size:1.2rem}
.topbar .page-title{font-size:1.1rem;font-weight:700;opacity:.9}
.topbar .back-btn{margin-left:auto;background:rgba(255,255,255,.15);border:1px solid rgba(255,255,255,.25);color:white;border-radius:14px;padding:10px 18px;text-decoration:none;font-weight:800;display:flex;align-items:center;gap:8px;transition:.2s}
.topbar .back-btn:hover{background:rgba(255,255,255,.25);color:white}

.container{max-width:860px;margin:32px auto;padding:0 20px}

.card{background:white;border-radius:28px;box-shadow:var(--shadow);overflow:hidden;margin-bottom:24px}
.card-head{padding:22px 28px;border-bottom:1px solid #dbeee5;display:flex;align-items:center;gap:12px}
.card-head i{font-size:1.5rem;color:var(--green)}
.card-head h3{margin:0;font-size:1.3rem;color:#063823}
.card-head .badge-cita{background:#dcfff0;color:#007f4f;border-radius:999px;padding:5px 14px;font-weight:900;font-size:.85rem;margin-left:auto}
.card-body{padding:24px 28px}

.info-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:14px;margin-bottom:8px}
.info-item{background:#f8fffb;border:1px solid #dbeee5;border-radius:16px;padding:14px 16px}
.info-item label{display:block;font-size:.75rem;font-weight:900;color:var(--muted);text-transform:uppercase;margin-bottom:4px}
.info-item span{font-weight:800;color:#0f172a;font-size:.97rem}

.form-group{margin-bottom:20px}
.form-group label{display:block;font-weight:900;color:#063823;margin-bottom:8px;font-size:.95rem}
.form-group label i{color:var(--green);margin-right:6px}
.form-group textarea{width:100%;border:1.5px solid #dbeee5;border-radius:16px;padding:14px 16px;font-family:"Nunito",sans-serif;font-size:.97rem;font-weight:700;resize:vertical;outline:none;transition:.2s;color:#0f172a;background:#fafffe}
.form-group textarea:focus{border-color:var(--green);box-shadow:0 0 0 3px rgba(0,200,117,.12)}
.form-group .hint{color:var(--muted);font-size:.8rem;font-weight:700;margin-top:5px}

.medicacion-box textarea{background:#f0fff8;border-color:#a7f0c9}
.medicacion-box textarea:focus{border-color:#00c875;box-shadow:0 0 0 3px rgba(0,200,117,.18)}

.btn-primary{background:linear-gradient(135deg,var(--green),var(--green2));color:#003d25;border:0;border-radius:18px;padding:16px 32px;font-weight:900;font-size:1.05rem;cursor:pointer;display:inline-flex;align-items:center;gap:10px;transition:.25s;box-shadow:0 16px 38px rgba(0,200,117,.28)}
.btn-primary:hover{transform:translateY(-2px);box-shadow:0 20px 45px rgba(0,200,117,.35)}
.btn-secondary{background:white;color:#063823;border:1.5px solid #dbeee5;border-radius:18px;padding:14px 24px;font-weight:900;font-size:.97rem;cursor:pointer;display:inline-flex;align-items:center;gap:8px;text-decoration:none;transition:.2s}
.btn-secondary:hover{border-color:var(--green);color:#063823}

.alert-ok{background:#dcfff0;border:1px solid #a7f0c9;color:#047857;border-radius:16px;padding:14px 20px;margin-bottom:20px;font-weight:800;display:flex;align-items:center;gap:10px}

.emoji-title{font-size:1.8rem;margin-right:8px}

@media(max-width:600px){.info-grid{grid-template-columns:1fr 1fr}.container{padding:0 12px}}
</style>
</head>
<body>

<div class="topbar">
    <a class="brand" href="${pageContext.request.contextPath}/enfermero/dashboard">
        <div class="brand-icon"><i class="ti ti-paw"></i></div>
        CliniPet
    </a>
    <span class="sep">/</span>
    <span class="page-title">Atender cita</span>
    <a class="back-btn" href="${pageContext.request.contextPath}/enfermero/dashboard">
        <i class="ti ti-arrow-left"></i> Volver al panel
    </a>
</div>

<div class="container">

    <%-- Mensaje de éxito si volvemos después de guardar --%>
    <% if ("historia".equals(request.getParameter("ok"))) { %>
    <div class="alert-ok"><i class="ti ti-circle-check" style="font-size:1.4rem"></i> Historia clínica guardada correctamente. La cita fue marcada como <strong>REALIZADA</strong>.</div>
    <% } %>

    <%-- ── DATOS DEL PACIENTE ─────────────────────────────────────────── --%>
    <div class="card">
        <div class="card-head">
            <i class="ti ti-stethoscope"></i>
            <h3><span class="emoji-title">🐾</span> Paciente — <%= mascota %> <small style="font-size:.85rem;color:var(--muted)">(Cita #<%= idCita %>)</small></h3>
            <span class="badge-cita"><i class="ti ti-calendar"></i> <%= fecha %> &nbsp;·&nbsp; <%= hora %></span>
        </div>
        <div class="card-body">
            <div class="info-grid">
                <div class="info-item">
                    <label><i class="ti ti-paw"></i> Mascota</label>
                    <span><%= mascota %></span>
                </div>
                <div class="info-item">
                    <label><i class="ti ti-dna"></i> Especie / Raza</label>
                    <span><%= especie %> <%= raza.isEmpty() ? "" : "— " + raza %></span>
                </div>
                <div class="info-item">
                    <label><i class="ti ti-gender-bigender"></i> Sexo</label>
                    <span><%= sexo.isEmpty() ? "No registrado" : sexo %></span>
                </div>
                <div class="info-item">
                    <label><i class="ti ti-user"></i> Dueño</label>
                    <span><%= duenio %></span>
                </div>
                <div class="info-item">
                    <label><i class="ti ti-phone"></i> Teléfono</label>
                    <span><%= telDuenio.isEmpty() ? "No registrado" : telDuenio %></span>
                </div>
                <div class="info-item">
                    <label><i class="ti ti-clipboard-text"></i> Motivo</label>
                    <span><%= motivo %></span>
                </div>
            </div>
        </div>
    </div>

    <%-- ── FORMULARIO HISTORIA CLÍNICA ───────────────────────────────── --%>
    <div class="card">
        <div class="card-head">
            <i class="ti ti-notes-medical"></i>
            <h3>Historia clínica — Tratamiento</h3>
        </div>
        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/veterinario/atender">
                <input type="hidden" name="id_cita"    value="<%= idCita %>">
                <input type="hidden" name="id_mascota" value="<%= idMascota %>">

                <div class="form-group">
                    <label><i class="ti ti-microscope"></i> Diagnóstico</label>
                    <textarea name="diagnostico" rows="3"
                              placeholder="Ej: Otitis externa leve en oído derecho, sin signos sistémicos..."
                    ><%= diagnostico %></textarea>
                </div>

                <div class="form-group">
                    <label><i class="ti ti-heart-rate-monitor"></i> Tratamiento indicado</label>
                    <textarea name="tratamiento" rows="3"
                              placeholder="Ej: Limpieza de oídos diaria, revisión en 10 días..."
                    ><%= tratamiento %></textarea>
                </div>

                <div class="form-group medicacion-box">
                    <label><i class="ti ti-pill"></i> 💊 Medicación y dosis</label>
                    <textarea name="medicacion" rows="4"
                              placeholder="Ej:&#10;• Otomite gotas — 3 gotas en oído derecho cada 12h por 7 días&#10;• Amoxicilina 250mg — 1 tableta cada 8h por 5 días con comida&#10;• Meloxicam 0.5mg — 1 tableta diaria por 3 días"
                    ><%= medicacion %></textarea>
                    <p class="hint">💡 Escribe cada medicamento en una línea separada, incluyendo dosis, frecuencia y duración.</p>
                </div>

                <div class="form-group">
                    <label><i class="ti ti-writing"></i> Observaciones adicionales</label>
                    <textarea name="observaciones" rows="3"
                              placeholder="Ej: Programar control en 2 semanas. Evitar baños durante el tratamiento..."
                    ><%= observaciones %></textarea>
                </div>

                <div style="display:flex;gap:14px;align-items:center;flex-wrap:wrap;margin-top:8px">
                    <button type="submit" class="btn-primary">
                        <i class="ti ti-device-floppy"></i> Guardar historia clínica
                    </button>
                    <a href="${pageContext.request.contextPath}/enfermero/dashboard" class="btn-secondary">
                        <i class="ti ti-x"></i> Cancelar
                    </a>
                </div>

            </form>
        </div>
    </div>

</div>

</body>
</html>
