<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="es">
<head>

    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>

    <title>CliniPet | Login</title>

    <link href="https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta20/dist/css/tabler.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/tabler-icons.min.css" rel="stylesheet"/>

    <style>

        *{
            margin:0;
            padding:0;
            box-sizing:border-box;
        }

        body{
            min-height:100vh;
            overflow:hidden;
            font-family:'Segoe UI',sans-serif;
            background:
                    radial-gradient(circle at top left, rgba(0,255,163,.15), transparent 30%),
                    radial-gradient(circle at bottom right, rgba(0,180,120,.18), transparent 35%),
                    linear-gradient(135deg,#e8f7ef,#dff5ea,#edf9f1);
            position:relative;
        }

        .overlay-circle{
            position:absolute;
            border-radius:50%;
            background:rgba(0,128,96,.06);
            animation:float 8s ease-in-out infinite;
        }

        .circle1{
            width:280px;
            height:280px;
            top:-100px;
            right:-60px;
        }

        .circle2{
            width:220px;
            height:220px;
            bottom:-70px;
            left:-70px;
            animation-delay:2s;
        }

        @keyframes float{
            0%{transform:translateY(0px);}
            50%{transform:translateY(-16px);}
            100%{transform:translateY(0px);}
        }

        .left-content{
            color:#064e3b;
        }

        .logo-text{
            font-size:68px;
            font-weight:900;
            line-height:1;
            color:#013b2c;
        }

        .logo-text span{
            color:#00d084;
        }

        .description{
            margin-top:24px;
            color:#4b5563;
            font-size:18px;
            max-width:520px;
            line-height:1.8;
        }

        .feature-box{
            display:flex;
            align-items:center;
            gap:14px;
            background:rgba(255,255,255,.65);
            border:1px solid rgba(0,128,96,.08);
            padding:16px 18px;
            border-radius:20px;
            margin-bottom:14px;
            transition:.3s;
            backdrop-filter:blur(10px);
            box-shadow:0 10px 25px rgba(0,0,0,.04);
        }

        .feature-box:hover{
            transform:translateX(6px);
            background:white;
        }

        .feature-box i{
            font-size:28px;
            color:#00c97d;
        }

        .login-card{
            background:rgba(255,255,255,.72);
            border:1px solid rgba(255,255,255,.5);
            backdrop-filter:blur(18px);
            border-radius:34px;
            box-shadow:0 20px 60px rgba(0,0,0,.08);
        }

        .login-header{
            text-align:center;
            margin-bottom:34px;
        }

        .pet-logo{
            width:105px;
            height:105px;
            border-radius:50%;
            margin:auto;
            background:linear-gradient(135deg,#00d084,#009966);
            display:flex;
            align-items:center;
            justify-content:center;
            box-shadow:0 15px 40px rgba(0,208,132,.35);
        }

        .pet-logo i{
            font-size:54px;
            color:white;
        }

        .login-title{
            color:#013b2c;
            font-weight:800;
            margin-top:22px;
        }

        .login-subtitle{
            color:#6b7280;
        }

        .form-label{
            color:#013b2c;
            font-weight:700;
            margin-bottom:8px;
        }

        .form-control{
            height:58px;
            border-radius:18px;
            border:none;
            background:white;
            color:#013b2c;
            padding-left:14px;
            box-shadow:0 5px 15px rgba(0,0,0,.04);
        }

        .form-control::placeholder{
            color:#9ca3af;
        }

        .form-control:focus{
            background:white;
            color:#013b2c;
            box-shadow:none;
            border:2px solid #00d084;
        }

        .input-icon-addon{
            color:#00c97d;
        }

        .btn-login{
            height:58px;
            border:none;
            border-radius:18px;
            background:linear-gradient(135deg,#00d084,#00b86f);
            color:white;
            font-weight:800;
            font-size:16px;
            transition:.3s;
        }

        .btn-login:hover{
            transform:translateY(-2px);
            box-shadow:0 12px 30px rgba(0,208,132,.28);
        }

        .btn-register{
            height:56px;
            border-radius:18px;
            font-weight:700;
            background:#013b2c;
            border:none;
        }

        .btn-register:hover{
            background:#022f24;
        }

        /* BOTON PATA */
        .paw-back{
            width:58px;
            height:58px;
            border-radius:18px;
            background:white;
            display:flex;
            align-items:center;
            justify-content:center;
            text-decoration:none;
            box-shadow:0 8px 18px rgba(0,0,0,.06);
            transition:.3s;
            border:2px solid rgba(0,208,132,.15);
        }

        .paw-back i{
            font-size:28px;
            color:#00c97d;
        }

        .paw-back:hover{
            transform:translateX(-4px) scale(1.05);
            background:#00d084;
        }

        .paw-back:hover i{
            color:white;
        }

        .demo-info{
            margin-top:26px;
            background:rgba(0,208,132,.08);
            padding:14px;
            border-radius:16px;
            text-align:center;
            color:#065f46;
            font-size:14px;
        }

        .buttons-row{
            display:flex;
            gap:14px;
            margin-top:20px;
            align-items:center;
        }

        @media(max-width:991px){

            body{
                overflow:auto;
                padding:30px 0;
            }

            .left-content{
                display:none;
            }
        }

    </style>

</head>

<body>

<div class="overlay-circle circle1"></div>
<div class="overlay-circle circle2"></div>

<div class="container position-relative">

    <div class="row min-vh-100 align-items-center justify-content-center g-5">

        <!-- IZQUIERDA -->
        <div class="col-lg-6 left-content">

            <h1 class="logo-text">
                Clini<span>Pet</span>
            </h1>

            <p class="description">
                Plataforma veterinaria inteligente para gestionar clientes,
                mascotas, ventas, citas médicas e historial clínico
                desde un solo lugar.
            </p>

            <div class="mt-5">

                <div class="feature-box">

                    <i class="ti ti-heart-handshake"></i>

                    <div>
                        <strong>Gestión de Clientes</strong><br>
                        Administración completa de propietarios y mascotas.
                    </div>

                </div>

                <div class="feature-box">

                    <i class="ti ti-shopping-cart"></i>

                    <div>
                        <strong>Carrito de Compras</strong><br>
                        Compra de productos veterinarios online.
                    </div>

                </div>

                <div class="feature-box">

                    <i class="ti ti-calendar-event"></i>

                    <div>
                        <strong>Citas Veterinarias</strong><br>
                        Agenda médica moderna y organizada.
                    </div>

                </div>

            </div>

        </div>

        <!-- LOGIN -->
        <div class="col-md-9 col-lg-5">

            <div class="card login-card border-0">

                <div class="card-body p-4 p-md-5">

                    <div class="login-header">

                        <div class="pet-logo">
                            <i class="ti ti-paw"></i>
                        </div>

                        <h2 class="login-title">
                            Bienvenido de nuevo
                        </h2>

                        <p class="login-subtitle">
                            Inicia sesión para continuar en CliniPet
                        </p>

                    </div>

                    <% if(request.getAttribute("error") != null){ %>

                        <div class="alert alert-danger">
                            <%= request.getAttribute("error") %>
                        </div>

                    <% } %>

                    <form method="post" action="${pageContext.request.contextPath}/login">

                        <div class="mb-4">

                            <label class="form-label">
                                Correo electrónico
                            </label>

                            <div class="input-icon">

                                <span class="input-icon-addon">
                                    <i class="ti ti-mail"></i>
                                </span>

                                <input
                                        type="email"
                                        class="form-control"
                                        name="correo"
                                        placeholder="correo@clinipet.com"
                                        required>

                            </div>

                        </div>

                        <div class="mb-4">

                            <label class="form-label">
                                Contraseña
                            </label>

                            <div class="input-icon">

                                <span class="input-icon-addon">
                                    <i class="ti ti-lock"></i>
                                </span>

                                <input
                                        type="password"
                                        class="form-control"
                                        name="password"
                                        placeholder="********"
                                        required>

                            </div>

                        </div>

                        <button class="btn btn-login w-100" type="submit">

                            <i class="ti ti-login me-2"></i>
                            Ingresar al Sistema

                        </button>

                    </form>

                    <!-- BOTONES -->
                    <div class="buttons-row">

                        <!-- PATA VOLVER -->
                        <a
                                href="${pageContext.request.contextPath}/"
                                class="paw-back"
                                title="Volver al inicio">

                            <i class="ti ti-paw"></i>

                        </a>

                        <!-- REGISTRO -->
                        <a
                                href="${pageContext.request.contextPath}/registro"
                                class="btn btn-register flex-fill text-white">

                            <i class="ti ti-user-plus me-2"></i>
                            Crear nueva cuenta

                        </a>

                    </div>

                    <div class="demo-info">

                        <strong>Demo:</strong><br>
                        admin@clinipet.com / 123456

                    </div>

                </div>

            </div>

        </div>

    </div>

</div>

</body>
</html>