<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.clinipet.dao.ProductoDAO" %>
<%@ page import="com.clinipet.model.Producto" %>
<%@ page import="java.util.List" %>

<%
    ProductoDAO productoDAO = new ProductoDAO();
    List<Producto> productos = productoDAO.listarMasVendidos();
    final String WA_NUMBER = "573204963536";

    // Detectar si el usuario está logueado (ajusta según tu sesión)
    boolean logueado = session.getAttribute("usuario") != null;
    String loginUrl = request.getContextPath() + "/login";
%>

<!doctype html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>CliniPet | Salud y amor para tu mascota</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/@tabler/core@1.0.0-beta20/dist/css/tabler.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/@tabler/icons-webfont@latest/tabler-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;500;600;700;800;900&family=Fredoka:wght@500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --green: #00c875;
            --green2: #00f5a0;
            --dark: #003d25;
            --dark2: #006b44;
            --text: #0f172a;
            --muted: #64748b;
            --shadow: 0 24px 70px rgba(0,80,50,.12);
            --line-height-body: 1.9;
            --letter-spacing-body: 0.015em;
            --paragraph-gap: 1.1rem;
            --nav-height: 94px;
        }
        * { box-sizing: border-box; }
        html { scroll-behavior: smooth; }
        body {
            margin: 0;
            padding-top: var(--nav-height);
            font-family: "Nunito", sans-serif;
            font-size: 1.05rem;
            line-height: var(--line-height-body);
            letter-spacing: var(--letter-spacing-body);
            color: var(--text);
            background:
                radial-gradient(circle at 15% 5%, rgba(0,200,117,.13), transparent 28%),
                radial-gradient(circle at 85% 10%, rgba(0,245,160,.14), transparent 26%),
                linear-gradient(135deg, #f8fffb, #eafff4);
            overflow-x: hidden;
        }
        h1,h2,h3,h4,h5,.brand-title,.title-main,.public-title {
            font-family: "Fredoka", sans-serif;
            letter-spacing: 0.01em;
            line-height: 1.15;
            margin-bottom: 0.6em;
        }
        p { margin-bottom: var(--paragraph-gap); line-height: var(--line-height-body); }

        /* NAV */
        .nav-public {
            position: fixed;
            top: 0; left: 0; right: 0;
            z-index: 1000;
            background: radial-gradient(circle at 20% 10%, rgba(0,245,160,.18), transparent 30%),
                        linear-gradient(135deg, #003d25, #006b44);
            box-shadow: 0 18px 55px rgba(0,61,37,.22);
        }
        .nav-inner {
            max-width: 1320px; margin: auto; padding: 18px 26px;
            display: flex; align-items: center; justify-content: space-between; gap: 22px;
        }
        .brand { display: flex; align-items: center; gap: 12px; color: white; text-decoration: none; }
        .brand-icon {
            width: 58px; height: 58px; border-radius: 20px; background: white; color: var(--green);
            display: grid; place-items: center; font-size: 2rem; box-shadow: 0 15px 32px rgba(0,0,0,.20);
        }
        .brand-title { margin: 0; color: white; font-size: 2rem; font-weight: 700; }
        .brand small { color: #dfffee; font-weight: 800; letter-spacing: 0.03em; }
        .nav-links { display: flex; align-items: center; gap: 26px; }
        .nav-links a {
            color: #eafff4; text-decoration: none; font-weight: 900;
            display: flex; align-items: center; gap: 8px; transition: .25s; letter-spacing: 0.02em;
        }
        .nav-links a:hover { color: var(--green2); transform: translateY(-2px); }
        .nav-links i { font-size: 1.45rem; color: var(--green2); }

        /* BOTONES */
        .btn-green,.btn-soft,.btn-outline-green {
            border: 0; border-radius: 18px; padding: 13px 22px; font-weight: 900;
            text-decoration: none; transition: .25s; display: inline-flex; align-items: center;
            gap: 8px; letter-spacing: 0.02em; cursor: pointer;
        }
        .btn-green {
            background: linear-gradient(135deg, var(--green), var(--green2));
            color: #003d25; box-shadow: 0 16px 38px rgba(0,200,117,.24);
        }
        .btn-soft { background: white; color: #063823; box-shadow: 0 12px 28px rgba(0,80,50,.08); }
        .btn-outline-green { border: 1px solid var(--green); background: white; color: var(--green); }
        .btn-green:hover,.btn-soft:hover,.btn-outline-green:hover { transform: translateY(-4px); }

        /* HERO */
        .public-hero {
            min-height: calc(100vh - var(--nav-height)); display: grid; place-items: center;
            padding: 70px 24px; position: relative; overflow: hidden;
        }
        .public-hero::before {
            content: ""; position: absolute; right: 8%; top: 90px;
            width: 520px; height: 520px; background: #dfffee;
            border-radius: 48% 52% 46% 54%; z-index: -1;
            animation: morph 6s ease-in-out infinite alternate;
        }
        .public-hero::after {
            content: "🐾"; position: absolute; left: 38%; top: 65px;
            font-size: 95px; opacity: .06; animation: floatPaw 5s ease-in-out infinite;
        }
        @keyframes morph {
            from { border-radius: 48% 52% 46% 54%; transform: scale(1); }
            to   { border-radius: 55% 45% 58% 42%; transform: scale(1.04); }
        }
        @keyframes floatPaw {
            0%,100% { transform: translateY(0) rotate(0deg); }
            50%      { transform: translateY(-18px) rotate(8deg); }
        }
        .public-card {
            max-width: 1320px; width: 100%;
            display: grid; grid-template-columns: 1fr 1fr; gap: 50px; align-items: center;
        }
        .badge-soft {
            background: #dcfff0; color: #007f4f; border-radius: 999px; padding: 9px 15px;
            font-weight: 900; display: inline-flex; align-items: center; gap: 7px; letter-spacing: 0.02em;
        }
        .public-title {
            font-size: clamp(3.1rem, 6vw, 5.7rem); line-height: 1.05;
            color: #063823; margin: 24px 0 20px; font-weight: 700;
        }
        .public-title span { color: var(--green); text-shadow: 0 8px 28px rgba(0,200,117,.18); }
        .hero-text { font-size: 1.2rem; color: var(--muted); line-height: 1.9; max-width: 660px; letter-spacing: 0.015em; }
        .public-img {
            height: 560px; border-radius: 42px;
            background: linear-gradient(180deg, rgba(255,255,255,.10), rgba(0,61,37,.10)),
                        url('https://images.unsplash.com/photo-1450778869180-41d0601e046e?auto=format&fit=crop&w=1400&q=90') center/cover;
            box-shadow: var(--shadow); position: relative; overflow: hidden;
        }
        .public-img::after {
            content: "Atención integral"; position: absolute; right: 28px; bottom: 28px;
            background: rgba(255,255,255,.94); color: #063823; border-radius: 24px;
            padding: 18px 24px; font-weight: 900; box-shadow: var(--shadow);
        }
        .hero-features { display: flex; gap: 26px; flex-wrap: wrap; margin-top: 32px; }
        .feature-mini { display: flex; align-items: center; gap: 10px; font-weight: 900; color: #063823; line-height: 1.55; }
        .feature-mini i { font-size: 2rem; color: var(--green); }

        /* SECCIONES */
        .section { padding: 86px 24px; }
        .containerx { max-width: 1320px; margin: auto; }
        .section-head {
            display: flex; align-items: end; justify-content: space-between;
            gap: 20px; margin-bottom: 36px;
        }
        .title-main { margin: 0; font-size: clamp(2.2rem, 4vw, 3.4rem); font-weight: 700; color: #063823; }
        .subtitle { color: var(--muted); font-size: 1.1rem; font-weight: 700; margin-top: 10px; line-height: 1.7; }

        /* CARDS BASE */
        .panel,.product-card,.service-card,.about-card {
            background: rgba(255,255,255,.94); border: 1px solid rgba(255,255,255,.96);
            border-radius: 30px; box-shadow: var(--shadow); overflow: hidden; transition: .35s;
        }
        .panel:hover,.product-card:hover,.service-card:hover,.about-card:hover { transform: translateY(-8px); }

        /* SERVICIOS */
        .service-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px; }
        .service-img { height: 210px; background-size: cover; background-position: center; }
        .service-body { padding: 28px 25px 25px; }
        .service-body i { color: var(--green); font-size: 2.2rem; }
        .service-body h3 { margin-top: 14px; color: #063823; font-weight: 700; font-size: 1.35rem; }
        .service-body p { color: var(--muted); font-weight: 700; line-height: 1.85; }

        /* ── BUSCADOR ── */
        .search-wrap {
            display: flex; align-items: center; gap: 14px;
            background: white; border-radius: 20px; padding: 12px 20px;
            box-shadow: 0 8px 28px rgba(0,80,50,.10); border: 1.5px solid #c8ffe2;
            margin-bottom: 32px;
        }
        .search-wrap i { font-size: 1.6rem; color: var(--green); flex-shrink: 0; }
        .search-wrap input {
            border: 0; outline: none; font-family: "Nunito", sans-serif;
            font-size: 1.1rem; font-weight: 700; color: var(--text);
            background: transparent; flex: 1; letter-spacing: 0.015em;
        }
        .search-wrap input::placeholder { color: #a0bdb0; }
        .search-clear {
            background: #eafff4; border: 0; border-radius: 10px; padding: 6px 14px;
            font-weight: 900; color: #006b44; cursor: pointer; font-size: .9rem; transition: .2s;
            display: none;
        }
        .search-clear.visible { display: inline-flex; align-items: center; gap: 5px; }
        .search-clear:hover { background: #d0ffe8; }
        #no-results {
            display: none; text-align: center; padding: 40px;
            background: rgba(255,255,255,.9); border-radius: 24px; box-shadow: var(--shadow);
            grid-column: 1/-1;
        }
        #no-results i { font-size: 3rem; color: var(--green); }

        /* ── BESTSELLER ── */
        .bestseller-banner {
            display: flex; align-items: center; gap: 10px;
            background: linear-gradient(135deg, #003d25, #00a864); color: white;
            border-radius: 16px; padding: 10px 20px; font-weight: 900; font-size: 1rem;
            letter-spacing: 0.04em; text-transform: uppercase;
            box-shadow: 0 8px 22px rgba(0,80,50,.18);
        }
        .bestseller-banner i { font-size: 1.4rem; color: #ffe068; }

        /* ── GRID PRODUCTOS ── */
        .products-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 28px; }
        .product-card { padding: 24px 22px 20px; position: relative; }
        .badge-top {
            position: absolute; top: 16px; left: 16px;
            background: linear-gradient(135deg, #ffb347, #ffe068); color: #5a3800;
            border-radius: 10px; padding: 5px 12px; font-size: .78rem; font-weight: 900;
            letter-spacing: 0.05em; display: flex; align-items: center; gap: 5px;
            z-index: 2; box-shadow: 0 4px 12px rgba(255,180,0,.28);
        }
        .product-img {
            height: 210px; border-radius: 24px; background-size: cover;
            background-position: center; background-color: #f5fff9; margin-bottom: 18px;
        }
        .product-card h3 { color: #063823; font-weight: 700; margin-bottom: 10px; font-size: 1.2rem; line-height: 1.3; }
        .product-card p { color: var(--muted); font-weight: 700; min-height: 55px; line-height: 1.8; margin-bottom: 14px; }
        .price { font-size: 1.5rem; font-weight: 900; color: var(--green); }

        /* ── CANTIDAD + CARRITO ── */
        .buy-row { display: flex; align-items: center; justify-content: space-between; gap: 10px; margin-top: 14px; }
        .qty-control {
            display: flex; align-items: center; gap: 6px;
            background: #f0fff7; border-radius: 14px; padding: 4px 8px;
        }
        .qty-btn {
            width: 30px; height: 30px; border-radius: 10px; border: 1.5px solid #9fffd4;
            background: white; color: var(--green); font-size: 1.1rem; font-weight: 900;
            cursor: pointer; transition: .2s; display: grid; place-items: center; line-height: 1;
        }
        .qty-btn:hover { background: #d0ffe8; }
        .qty-val { font-weight: 900; font-size: 1rem; min-width: 22px; text-align: center; color: #063823; }

        /* Botón agregar al carrito en tarjeta */
        .add-cart-btn {
            border-radius: 14px; border: 1.5px solid #9fffd4; background: white;
            color: var(--green); font-size: 1.1rem; font-weight: 900; padding: 8px 14px;
            cursor: pointer; transition: .25s; display: flex; align-items: center; gap: 6px;
            font-family: "Nunito", sans-serif;
        }
        .add-cart-btn:hover { background: #eafff4; transform: translateY(-2px); }
        .add-cart-btn.added { background: var(--green); color: #003d25; border-color: var(--green); }

        /* ── CARRITO FLOTANTE ── */
        .cart-fab {
            position: fixed; bottom: 32px; right: 32px; z-index: 2000;
            background: linear-gradient(135deg, var(--green), var(--green2));
            color: #003d25; border: 0; border-radius: 22px; padding: 16px 26px;
            font-family: "Nunito", sans-serif; font-weight: 900; font-size: 1.1rem;
            cursor: pointer; box-shadow: 0 16px 40px rgba(0,200,117,.35);
            display: none; align-items: center; gap: 10px; transition: .25s;
            animation: popIn .35s cubic-bezier(.34,1.56,.64,1);
        }
        .cart-fab:hover { transform: translateY(-4px) scale(1.03); }
        .cart-fab.visible { display: flex; }
        @keyframes popIn { from { transform: scale(.7); opacity: 0; } to { transform: scale(1); opacity: 1; } }
        .cart-count {
            background: #003d25; color: #00f5a0; border-radius: 999px;
            padding: 2px 10px; font-size: .95rem;
        }

        /* ── MODAL CARRITO ── */
        .modal-overlay {
            display: none; position: fixed; inset: 0; z-index: 3000;
            background: rgba(0,30,18,.55); backdrop-filter: blur(6px);
            align-items: center; justify-content: center; padding: 20px;
        }
        .modal-overlay.open { display: flex; }
        .modal-box {
            background: white; border-radius: 32px; width: 100%; max-width: 580px;
            max-height: 85vh; overflow-y: auto; box-shadow: 0 40px 100px rgba(0,0,0,.22);
            animation: slideUp .3s ease;
        }
        @keyframes slideUp { from { transform: translateY(40px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
        .modal-head {
            padding: 28px 30px 20px; border-bottom: 1.5px solid #e8fff3;
            display: flex; align-items: center; justify-content: space-between; gap: 16px;
        }
        .modal-head h3 { margin: 0; font-size: 1.8rem; color: #063823; }
        .modal-close {
            width: 40px; height: 40px; border-radius: 14px; border: 1.5px solid #c8ffe2;
            background: #f0fff7; color: #006b44; font-size: 1.3rem; cursor: pointer;
            display: grid; place-items: center; transition: .2s;
        }
        .modal-close:hover { background: #d0ffe8; }
        .modal-body { padding: 20px 30px; }
        .cart-item {
            display: flex; align-items: center; gap: 14px; padding: 14px 0;
            border-bottom: 1px solid #eafff4;
        }
        .cart-item-img {
            width: 64px; height: 64px; border-radius: 16px; background-size: cover;
            background-position: center; background-color: #f0fff7; flex-shrink: 0;
        }
        .cart-item-info { flex: 1; }
        .cart-item-info strong { display: block; color: #063823; font-size: 1rem; margin-bottom: 3px; }
        .cart-item-info span { color: var(--muted); font-size: .9rem; font-weight: 700; }
        .cart-item-price { font-weight: 900; color: var(--green); font-size: 1.1rem; white-space: nowrap; }
        .cart-item-remove {
            background: #fff0f0; border: 0; border-radius: 10px; width: 32px; height: 32px;
            color: #e05; cursor: pointer; display: grid; place-items: center; font-size: 1rem; transition: .2s;
        }
        .cart-item-remove:hover { background: #ffe0e0; }
        .cart-empty { text-align: center; padding: 40px 20px; color: var(--muted); font-weight: 700; }
        .cart-empty i { font-size: 3rem; color: #d0ffe8; display: block; margin-bottom: 12px; }
        .modal-footer {
            padding: 20px 30px 28px; border-top: 1.5px solid #e8fff3;
            display: flex; align-items: center; justify-content: space-between; gap: 14px; flex-wrap: wrap;
        }
        .cart-total { font-size: 1.4rem; font-weight: 900; color: #063823; }
        .cart-total span { color: var(--green); }

        /* Botón WhatsApp del modal */
        .btn-wa {
            background: #25d366; color: white; border: 0; border-radius: 18px;
            padding: 14px 24px; font-family: "Nunito", sans-serif; font-weight: 900;
            font-size: 1rem; cursor: pointer; display: flex; align-items: center; gap: 9px;
            transition: .25s; box-shadow: 0 10px 28px rgba(37,211,102,.28);
        }
        .btn-wa:hover { transform: translateY(-3px); background: #1fb85a; }

        /* MODAL LOGIN REQUERIDO */
        .modal-login-box {
            background: white; border-radius: 32px; width: 100%; max-width: 420px;
            padding: 40px 36px; text-align: center; box-shadow: 0 40px 100px rgba(0,0,0,.22);
            animation: slideUp .3s ease;
        }
        .modal-login-box i.big { font-size: 3.5rem; color: var(--green); display: block; margin-bottom: 16px; }
        .modal-login-box h3 { color: #063823; font-size: 1.7rem; margin-bottom: 10px; }
        .modal-login-box p { color: var(--muted); font-weight: 700; margin-bottom: 24px; }

        /* ABOUT */
        .about-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 34px; align-items: center; }
        .about-img {
            min-height: 460px; border-radius: 36px;
            background: linear-gradient(180deg, rgba(255,255,255,.12), rgba(0,61,37,.12)),
                        url('https://images.unsplash.com/photo-1576201836106-db1758fd1c97?auto=format&fit=crop&w=1200&q=90') center/cover;
            box-shadow: var(--shadow);
        }
        .about-card { padding: 50px; }
        .about-card p { color: var(--muted); font-size: 1.13rem; line-height: 1.9; font-weight: 700; }
        .benefits {
            display: grid; grid-template-columns: repeat(4, 1fr); gap: 0;
            background: #f0fff7; border: 1px solid #caffdf; border-radius: 26px;
            margin-top: 34px; overflow: hidden; box-shadow: var(--shadow);
        }
        .benefit {
            padding: 28px 25px; display: flex; gap: 15px; align-items: center;
            border-right: 1px solid #d4ffe9; font-weight: 900; line-height: 1.6;
        }
        .benefit:last-child { border-right: 0; }
        .benefit i { font-size: 2.2rem; color: var(--green); }

        /* UBICACIÓN */
        .location-card {
            display: grid; grid-template-columns: .85fr 1.15fr;
            gap: 0; border-radius: 34px; overflow: hidden; background: white; box-shadow: var(--shadow);
        }
        .contact-info {
            padding: 48px 42px;
            background: radial-gradient(circle at 15% 15%, rgba(255,255,255,.20), transparent 26%),
                        linear-gradient(135deg, #003d25, #00a864);
            color: white;
        }
        .contact-info h2,.contact-info h3 { color: white; }
        .contact-item {
            display: flex; gap: 14px; align-items: start;
            background: rgba(255,255,255,.13); border: 1px solid rgba(255,255,255,.18);
            border-radius: 22px; padding: 18px 17px; margin-top: 14px;
        }
        .contact-item i { font-size: 1.9rem; color: #dfffee; margin-top: 2px; }
        .contact-item p { margin-bottom: 0; opacity: 0.75; }
        .map iframe { width: 100%; height: 100%; min-height: 520px; border: 0; }

        /* CTA */
        .cta {
            border-radius: 36px; padding: 70px 30px; text-align: center; color: white;
            background: radial-gradient(circle at 20% 20%, rgba(255,255,255,.22), transparent 26%),
                        linear-gradient(135deg, #003d25, #00a864);
            box-shadow: var(--shadow);
        }
        .cta h2 { color: white; font-size: clamp(2rem, 4vw, 3.4rem); font-weight: 700; }

        footer { padding: 38px 24px; color: var(--muted); font-weight: 800; letter-spacing: 0.02em; }

        /* DARK THEME */
        body.theme-green {
            --text: #eafff4; --muted: #a9d8c2;
            background: radial-gradient(circle at 12% 10%, rgba(0,245,160,.20), transparent 28%),
                        linear-gradient(135deg, #02150d, #042414);
        }
        body.theme-green .panel,body.theme-green .product-card,
        body.theme-green .service-card,body.theme-green .about-card,
        body.theme-green .benefits,body.theme-green .product-img,
        body.theme-green .search-wrap,body.theme-green .modal-box,
        body.theme-green .modal-login-box,body.theme-green .qty-control {
            background: #062819; border-color: rgba(0,245,160,.20);
        }
        body.theme-green .product-card h3,body.theme-green .service-body h3,
        body.theme-green .title-main,body.theme-green .public-title,
        body.theme-green .feature-mini,body.theme-green .qty-val,
        body.theme-green .modal-head h3,body.theme-green .cart-item-info strong,
        body.theme-green .cart-total,body.theme-green .modal-login-box h3 { color: #eafff4; }
        body.theme-green .search-wrap input { color: #eafff4; }
        body.theme-green .btn-soft,body.theme-green .btn-outline-green,
        body.theme-green .add-cart-btn,body.theme-green .qty-btn { background: #062819; color: #eafff4; border-color: #00c875; }
        body.theme-green .modal-head { border-color: rgba(0,245,160,.2); }
        body.theme-green .cart-item { border-color: rgba(0,245,160,.15); }
        body.theme-green .modal-footer { border-color: rgba(0,245,160,.2); }

        /* RESPONSIVE */
        @media(max-width:1050px) {
            .nav-links { display: none; }
            .public-card,.about-grid,.location-card { grid-template-columns: 1fr; }
            .products-grid { grid-template-columns: repeat(2, 1fr); }
            .service-grid,.benefits { grid-template-columns: 1fr 1fr; }
            .public-img { height: 430px; }
        }
        @media(max-width:650px) {
            :root { --nav-height: 78px; }
            .nav-inner { padding: 14px; }
            .brand small { display: none; }
            .brand-title { font-size: 1.55rem; }
            .brand-icon { width: 50px; height: 50px; }
            .nav-inner .d-flex { gap: 6px !important; }
            .nav-inner .btn-green,.nav-inner .btn-outline-green { padding: 10px 12px; font-size: .85rem; }
            .public-title { font-size: 3rem; }
            .products-grid,.service-grid,.benefits { grid-template-columns: 1fr; }
            .section-head { align-items: start; flex-direction: column; }
            .about-card,.contact-info { padding: 28px; }
            .map iframe { min-height: 360px; }
            .cart-fab { bottom: 20px; right: 20px; padding: 14px 18px; font-size: 1rem; }
            .modal-box { border-radius: 24px; }
            .modal-head,.modal-body,.modal-footer { padding-left: 20px; padding-right: 20px; }
        }
    </style>
</head>
<body>

<!-- ═══════════════════════════════ NAV ═══════════════════════════════ -->
<nav class="nav-public">
    <div class="nav-inner">
        <a class="brand" href="#">
            <span class="brand-icon"><i class="ti ti-paw"></i></span>
            <span>
                <h2 class="brand-title">CliniPet</h2>
                <small>Salud y amor para tu mascota</small>
            </span>
        </a>
        <div class="nav-links">
            <a href="#servicios"><i class="ti ti-stethoscope"></i> Veterinaria</a>
            <a href="#productos"><i class="ti ti-shopping-bag"></i> Productos</a>
            <a href="#quienes"><i class="ti ti-users"></i> ¿Quiénes somos?</a>
            <a href="#ubicacion"><i class="ti ti-map-pin"></i> Ubicación</a>
            <a href="#contacto"><i class="ti ti-mail"></i> Contacto</a>
        </div>
        <div class="d-flex gap-2 align-items-center">
            <button class="btn-outline-green" id="themeToggle" type="button">
                <i class="ti ti-leaf"></i> Modo
            </button>
            <% if (logueado) {
                Object usuarioSes = session.getAttribute("usuario");
                String rolSes = "";
                String nombreSes = "";
                if (usuarioSes instanceof com.clinipet.model.Usuario) {
                    rolSes = ((com.clinipet.model.Usuario) usuarioSes).getRol();
                    nombreSes = ((com.clinipet.model.Usuario) usuarioSes).getNombre();
                }
                String panelUrl = request.getContextPath() + "/cliente/dashboard";
                if ("ADMIN".equalsIgnoreCase(rolSes) || "ADMINISTRADOR".equalsIgnoreCase(rolSes))
                    panelUrl = request.getContextPath() + "/dashboard";
                else if ("RECEPCIONISTA".equalsIgnoreCase(rolSes))
                    panelUrl = request.getContextPath() + "/recepcionista/dashboard";
                else if ("ENFERMERO".equalsIgnoreCase(rolSes) || "VETERINARIO".equalsIgnoreCase(rolSes))
                    panelUrl = request.getContextPath() + "/enfermero/dashboard";
            %>
            <a class="btn-soft" href="<%= panelUrl %>" style="font-weight:900">
                <i class="ti ti-layout-dashboard"></i> Mi panel
            </a>
            <a class="btn-danger-nav" href="${pageContext.request.contextPath}/logout"
               style="border:0;border-radius:18px;padding:13px 22px;font-weight:900;background:#fff1f2;color:#be123c;text-decoration:none;display:inline-flex;align-items:center;gap:8px">
                <i class="ti ti-logout"></i> Cerrar sesión
            </a>
            <% } else { %>
            <a class="btn-soft" href="${pageContext.request.contextPath}/registro" style="font-weight:900">
                <i class="ti ti-user-plus"></i> Registrarse
            </a>
            <a class="btn-green" href="${pageContext.request.contextPath}/login">
                <i class="ti ti-login"></i> Login
            </a>
            <% } %>
        </div>
    </div>
</nav>

<!-- ═══════════════════════════════ HERO ═══════════════════════════════ -->
<section class="public-hero">
    <div class="public-card">
        <div>
            <span class="badge-soft"><i class="ti ti-paw"></i> Bienvenido a CliniPet</span>
            <h1 class="public-title">Cuidamos su salud,<br>ellos te llenan de <span>amor</span></h1>
            <p class="hero-text">En CliniPet ofrecemos atención veterinaria especializada, productos de calidad, agenda de citas y una experiencia moderna para el bienestar de tu mascota.</p>
            <div class="d-flex gap-3 flex-wrap mt-4">
                <a href="#servicios" class="btn-green"><i class="ti ti-paw"></i> Nuestros servicios</a>
                <a href="#productos" class="btn-soft"><i class="ti ti-shopping-cart"></i> Tienda online</a>
                <a href="${pageContext.request.contextPath}/citas/nueva" class="btn-soft"><i class="ti ti-calendar-plus"></i> Agendar cita</a>
            </div>
            <div class="hero-features">
                <div class="feature-mini"><i class="ti ti-shield-check"></i> Profesionales<br>certificados</div>
                <div class="feature-mini"><i class="ti ti-heart"></i> Atención con<br>amor</div>
                <div class="feature-mini"><i class="ti ti-rosette-discount-check"></i> Productos de<br>calidad</div>
            </div>
        </div>
        <div class="public-img"></div>
    </div>
</section>

<!-- ═══════════════════════════════ SERVICIOS ═══════════════════════════════ -->
<section class="section" id="servicios">
    <div class="containerx">
        <div class="section-head">
            <div>
                <span class="badge-soft"><i class="ti ti-photo-heart"></i> Qué hacemos</span>
                <h2 class="title-main mt-3">Servicios veterinarios con atención profesional</h2>
                <p class="subtitle">Consulta, vacunación, bienestar y cuidado integral.</p>
            </div>
            <a href="${pageContext.request.contextPath}/citas/nueva" class="btn-outline-green">Pedir cita <i class="ti ti-arrow-right"></i></a>
        </div>
        <div class="service-grid">
            <div class="service-card">
                <div class="service-img" style="background-image:url('https://images.unsplash.com/photo-1628009368231-7bb7cfcb0def?auto=format&fit=crop&w=900&q=80')"></div>
                <div class="service-body"><i class="ti ti-stethoscope"></i><h3>Consulta médica</h3><p>Revisión, diagnóstico y acompañamiento para perros, gatos y otras mascotas.</p></div>
            </div>
            <div class="service-card">
                <div class="service-img" style="background-image:url('https://images.unsplash.com/photo-1583337130417-3346a1be7dee?auto=format&fit=crop&w=900&q=80')"></div>
                <div class="service-body"><i class="ti ti-vaccine"></i><h3>Vacunación y control</h3><p>Programación de vacunas, controles preventivos y seguimiento de salud.</p></div>
            </div>
            <div class="service-card">
                <div class="service-img" style="background-image:url('https://images.unsplash.com/photo-1601758125946-6ec2ef64daf8?auto=format&fit=crop&w=900&q=80')"></div>
                <div class="service-body"><i class="ti ti-bath"></i><h3>Bienestar y cuidado</h3><p>Aseo, productos, accesorios y recomendaciones para mejorar su calidad de vida.</p></div>
            </div>
        </div>
    </div>
</section>

<!-- ═══════════════════════════ PRODUCTOS ═══════════════════════════ -->
<section class="section" id="productos">
    <div class="containerx">
        <div class="section-head">
            <div>
                <span class="badge-soft"><i class="ti ti-trending-up"></i> Los favoritos de nuestros clientes</span>
                <h2 class="title-main mt-3">Productos más vendidos</h2>
                <p class="subtitle">Selecciona uno o varios productos y envíanos tu pedido por WhatsApp.</p>
            </div>
            <a href="${pageContext.request.contextPath}/registro" class="btn-outline-green">Crear cuenta <i class="ti ti-user-plus"></i></a>
        </div>

        <!-- BUSCADOR -->
        <div class="search-wrap">
            <i class="ti ti-search"></i>
            <input type="text" id="searchInput" placeholder="Buscar por nombre, categoría o especie…" autocomplete="off">
            <button class="search-clear" id="searchClear" type="button"><i class="ti ti-x"></i> Limpiar</button>
        </div>

        <!-- BANNER -->
        <div class="d-flex align-items-center gap-3 mb-4 flex-wrap">
            <div class="bestseller-banner"><i class="ti ti-star-filled"></i> Más vendidos · Ordenados por popularidad</div>
            <span id="search-count" style="color:var(--muted);font-weight:800;font-size:.95rem;"></span>
        </div>

        <!-- GRID -->
        <div class="products-grid" id="productsGrid">

            <% if (productos == null || productos.isEmpty()) { %>
            <div class="panel p-4 text-center" style="grid-column:1/-1">
                <i class="ti ti-package-off fs-1 text-success"></i>
                <h3>No hay productos cargados</h3>
                <p class="text-secondary">Agrega productos desde el panel administrativo.</p>
            </div>
            <% } else { int rank = 1; int totalProds = productos.size(); for (Producto p : productos) {
                if (rank > 4) break;
                String img = p.getImagenUrl();
                if (img == null || img.trim().isEmpty())
                    img = "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?auto=format&fit=crop&w=900&q=80";
                String desc = (p.getDescripcion() == null || p.getDescripcion().trim().isEmpty())
                        ? "Producto veterinario disponible en CliniPet." : p.getDescripcion();
                String especie  = p.getEspecie()   != null ? p.getEspecie()   : "General";
                String categoria= p.getCategoria() != null ? p.getCategoria() : "";
                String precio   = String.format("%,.0f", p.getPrecio());
            %>
            <div class="product-card"
                 data-nombre="<%= p.getNombre().toLowerCase() %>"
                 data-categoria="<%= categoria.toLowerCase() %>"
                 data-especie="<%= especie.toLowerCase() %>">

                <% if (rank <= 3) { %>
                <div class="badge-top">
                    <% if(rank==1){%><i class="ti ti-medal"></i> #1 Más vendido
                    <%}else if(rank==2){%><i class="ti ti-medal-2"></i> #2 Popular
                    <%}else{%><i class="ti ti-award"></i> #3 Favorito<%}%>
                </div>
                <% } %>

                <div class="product-img" style="background-image:url('<%= img %>')"></div>
                <h3><%= p.getNombre() %></h3>
                <p><%= desc %></p>
                <span class="badge-soft"><%= especie %> · <%= categoria %></span>

                <div class="buy-row">
                    <span class="price">$<%= precio %></span>

                    <div style="display:flex;align-items:center;gap:8px">
                        <!-- Control de cantidad -->
                        <div class="qty-control">
                            <button class="qty-btn" onclick="changeQty(this,-1)">−</button>
                            <span class="qty-val">1</span>
                            <button class="qty-btn" onclick="changeQty(this,1)">+</button>
                        </div>
                        <!-- Botón agregar al carrito -->
                        <button class="add-cart-btn"
                            data-id="<%= p.getIdProducto() %>"
                            data-nombre="<%= p.getNombre() %>"
                            data-precio="<%= p.getPrecio() %>"
                            data-img="<%= img %>"
                            onclick="addToCart(this)">
                            <i class="ti ti-shopping-cart-plus"></i> Agregar
                        </button>
                    </div>
                </div>
            </div>
            <% rank++; } } %>

            <!-- Mensaje si la búsqueda no da resultados -->
            <div id="no-results">
                <i class="ti ti-search-off"></i>
                <h3 style="color:#063823;margin-top:12px">Sin resultados</h3>
                <p style="color:var(--muted);font-weight:700">Intenta con otro nombre o categoría.</p>
            </div>
        </div>

        <!-- Banner "ver todos" -->
        <div style="text-align:center;margin-top:38px;padding:32px;background:linear-gradient(135deg,#dcfff0,#eafff4);border-radius:28px;border:2px dashed #00c875">
            <i class="ti ti-lock" style="font-size:2.5rem;color:#00c875"></i>
            <h3 style="font-family:'Fredoka',sans-serif;color:#003d25;font-size:1.8rem;margin:12px 0 8px">¿Quieres ver todos los productos?</h3>
            <p style="color:#64748b;font-weight:700;font-size:1.05rem;margin-bottom:20px">Estás viendo solo 4 de nuestros productos. Regístrate y accede a toda la tienda con carrito de compras.</p>
            <div style="display:flex;gap:14px;justify-content:center;flex-wrap:wrap">
                <a href="${pageContext.request.contextPath}/registro" style="border:0;border-radius:18px;padding:14px 28px;font-weight:900;background:linear-gradient(135deg,#00c875,#00f5a0);color:#003d25;text-decoration:none;display:inline-flex;align-items:center;gap:8px;font-size:1rem">
                    <i class="ti ti-user-plus"></i> Crear cuenta gratis
                </a>
                <a href="${pageContext.request.contextPath}/login" style="border:0;border-radius:18px;padding:14px 28px;font-weight:900;background:white;color:#003d25;text-decoration:none;display:inline-flex;align-items:center;gap:8px;box-shadow:0 12px 28px rgba(0,80,50,.10);font-size:1rem">
                    <i class="ti ti-login"></i> Ya tengo cuenta
                </a>
            </div>
        </div>
    </div>
</section>

<!-- ═══════════════════════════════ QUIÉNES SOMOS ═══════════════════════════════ -->
<section class="section" id="quienes">
    <div class="containerx">
        <div class="about-grid">
            <div class="about-img"></div>
            <div class="about-card">
                <span class="badge-soft"><i class="ti ti-users"></i> ¿Quiénes somos?</span>
                <h2 class="title-main mt-3">Somos una veterinaria enfocada en bienestar y confianza</h2>
                <p class="mt-3">CliniPet nace para unir atención veterinaria, productos de calidad y tecnología en una sola experiencia. Nuestro objetivo es que cada dueño pueda cuidar a su mascota de forma fácil, rápida y segura.</p>
                <p>Trabajamos con profesionales comprometidos, productos confiables y un sistema moderno que permite agendar citas, controlar pedidos y ofrecer una mejor atención.</p>
                <a href="${pageContext.request.contextPath}/citas/nueva" class="btn-green mt-2"><i class="ti ti-calendar-plus"></i> Agendar una cita</a>
            </div>
        </div>
        <div class="benefits">
            <div class="benefit"><i class="ti ti-truck-delivery"></i><div>Envíos rápidos<br><span class="text-secondary">A todo el país</span></div></div>
            <div class="benefit"><i class="ti ti-shield-check"></i><div>Pagos seguros<br><span class="text-secondary">Compra con confianza</span></div></div>
            <div class="benefit"><i class="ti ti-headset"></i><div>Soporte 24/7<br><span class="text-secondary">Estamos para ayudarte</span></div></div>
            <div class="benefit"><i class="ti ti-award"></i><div>Productos originales<br><span class="text-secondary">Calidad garantizada</span></div></div>
        </div>
    </div>
</section>

<!-- ═══════════════════════════════ UBICACIÓN ═══════════════════════════════ -->
<section class="section" id="ubicacion">
    <div class="containerx">
        <div class="section-head">
            <div>
                <span class="badge-soft"><i class="ti ti-map-pin-heart"></i> Ubicación</span>
                <h2 class="title-main mt-3">Visítanos y conoce más de CliniPet</h2>
                <p class="subtitle">Estamos ubicados en Sogamoso, Boyacá.</p>
            </div>
        </div>
        <div class="location-card">
            <div class="contact-info" id="contacto">
                <h2 class="fw-bold">Información de contacto</h2>
                <div class="contact-item"><i class="ti ti-map-pin"></i><div><h3>Dirección</h3><p>SENA CIMM, Sogamoso, Boyacá</p></div></div>
                <div class="contact-item"><i class="ti ti-phone"></i><div><h3>Teléfono / WhatsApp</h3><p>3204963536</p></div></div>
                <div class="contact-item"><i class="ti ti-mail"></i><div><h3>Correo</h3><p>contacto@clinipet.com</p></div></div>
                <div class="contact-item"><i class="ti ti-clock"></i><div><h3>Horario</h3><p>Lunes a viernes · 8:00 a.m. - 5:00 p.m.</p></div></div>
                <div class="d-flex flex-wrap gap-2 mt-4">
                    <a href="tel:3204963536" class="btn btn-light rounded-4 fw-bold px-4 py-3"><i class="ti ti-phone-call"></i> Llamar</a>
                    <a href="https://wa.me/<%= WA_NUMBER %>" target="_blank" rel="noopener noreferrer" class="btn btn-outline-light rounded-4 fw-bold px-4 py-3"><i class="ti ti-brand-whatsapp"></i> WhatsApp</a>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-light rounded-4 fw-bold px-4 py-3"><i class="ti ti-login"></i> Ingresar</a>
                </div>
            </div>
            <div class="map">
                <iframe loading="lazy" allowfullscreen referrerpolicy="no-referrer-when-downgrade"
                    src="https://www.google.com/maps?q=SENA%20CIMM%20Sogamoso%20Boyac%C3%A1&output=embed"></iframe>
            </div>
        </div>
    </div>
</section>

<!-- ═══════════════════════════════ CTA ═══════════════════════════════ -->
<section class="section pt-0">
    <div class="containerx">
        <div class="cta">
            <span class="badge-soft"><i class="ti ti-paw"></i> CliniPet listo para cuidar tu mascota</span>
            <h2 class="mt-4">Compra productos o agenda tu cita veterinaria en minutos.</h2>
            <p class="fs-3 opacity-75 mt-3">Inicia sesión para continuar. Si eres nuevo, puedes crear tu cuenta.</p>
            <div class="d-flex gap-3 justify-content-center flex-wrap mt-4">
                <a href="${pageContext.request.contextPath}/login" class="btn btn-light rounded-4 fw-bold px-5 py-3"><i class="ti ti-login"></i> Iniciar sesión</a>
                <a href="${pageContext.request.contextPath}/registro" class="btn btn-outline-light rounded-4 fw-bold px-5 py-3"><i class="ti ti-user-plus"></i> Registrarme</a>
            </div>
        </div>
    </div>
</section>

<footer>
    <div class="containerx d-flex justify-content-between align-items-center flex-wrap gap-2">
        <strong class="fs-3"><i class="ti ti-paw text-success"></i> CliniPet</strong>
        <span>Sistema de Gestión Integral Veterinaria · SENA CIMM Sogamoso</span>
    </div>
</footer>

<!-- ═══════════════════════ CARRITO FLOTANTE ═══════════════════════ -->
<button class="cart-fab" id="cartFab" onclick="openCart()">
    <i class="ti ti-shopping-cart"></i>
    Mi pedido
    <span class="cart-count" id="cartCount">0</span>
</button>

<!-- ═══════════════════════ MODAL CARRITO ═══════════════════════ -->
<div class="modal-overlay" id="cartModal">
    <div class="modal-box">
        <div class="modal-head">
            <h3><i class="ti ti-shopping-cart" style="color:var(--green)"></i> Mi pedido</h3>
            <button class="modal-close" onclick="closeCart()"><i class="ti ti-x"></i></button>
        </div>
        <div class="modal-body" id="cartBody">
            <div class="cart-empty"><i class="ti ti-basket-off"></i>No hay productos aún.</div>
        </div>
        <div class="modal-footer">
            <div class="cart-total">Total: <span id="cartTotal">$0</span></div>
            <button class="btn-wa" onclick="sendToWhatsApp()">
                <i class="ti ti-brand-whatsapp"></i> Pedir por WhatsApp
            </button>
        </div>
    </div>
</div>

<!-- ═══════════════════════ MODAL LOGIN REQUERIDO ═══════════════════════ -->
<div class="modal-overlay" id="loginModal">
    <div class="modal-login-box">
        <i class="ti ti-lock big"></i>
        <h3>Inicia sesión primero</h3>
        <p>Para realizar un pedido necesitas tener una cuenta activa en CliniPet.</p>
        <div class="d-flex gap-3 justify-content-center flex-wrap">
            <a href="${pageContext.request.contextPath}/login" class="btn-green" style="border-radius:16px;padding:13px 28px">
                <i class="ti ti-login"></i> Iniciar sesión
            </a>
            <button onclick="closeLoginModal()" style="background:#f0fff7;border:1.5px solid #c8ffe2;border-radius:16px;padding:13px 22px;font-weight:900;cursor:pointer;color:#006b44;font-family:inherit;font-size:1rem">
                Cancelar
            </button>
        </div>
    </div>
</div>

<%-- Los valores del servidor se inyectan en un elemento HTML oculto.
     Así el bloque <script> queda JavaScript puro y el linter no se queja. --%>
<div id="app-config" hidden
     data-wa="<%= WA_NUMBER %>"
     data-logueado="<%= logueado %>"
     data-login="<%= loginUrl %>"></div>

<script>
// ══════════════════════════════════════════════════════════════
//  ESTADO GLOBAL  (leído desde data-attributes, JS 100% puro)
// ══════════════════════════════════════════════════════════════
const _cfg      = document.getElementById('app-config').dataset;
const WA_NUMBER = _cfg.wa;
const LOGUEADO  = _cfg.logueado === 'true';
const LOGIN_URL  = _cfg.login;
let cart = {};   // { id: { nombre, precio, img, qty } }

// ══════════════════════════════════════════════════════════════
//  BUSCADOR EN TIEMPO REAL
// ══════════════════════════════════════════════════════════════
const searchInput  = document.getElementById('searchInput');
const searchClear  = document.getElementById('searchClear');
const searchCount  = document.getElementById('search-count');
const noResults    = document.getElementById('no-results');
const allCards     = document.querySelectorAll('#productsGrid .product-card');

searchInput.addEventListener('input', filterProducts);
searchClear.addEventListener('click', () => {
    searchInput.value = '';
    filterProducts();
    searchInput.focus();
});

function filterProducts() {
    const q = searchInput.value.trim().toLowerCase();
    searchClear.classList.toggle('visible', q.length > 0);
    let visible = 0;

    allCards.forEach(card => {
        const match = card.dataset.nombre.includes(q)
                   || card.dataset.categoria.includes(q)
                   || card.dataset.especie.includes(q);
        card.style.display = match ? '' : 'none';
        if (match) visible++;
    });

    noResults.style.display = (q && visible === 0) ? 'block' : 'none';
    searchCount.textContent = q ? `\${visible} resultado\${visible !== 1 ? 's' : ''}` : '';
}

// ══════════════════════════════════════════════════════════════
//  CONTROL DE CANTIDAD POR TARJETA
// ══════════════════════════════════════════════════════════════
function changeQty(btn, delta) {
    const ctrl = btn.closest('.qty-control');
    const span = ctrl.querySelector('.qty-val');
    let val = parseInt(span.textContent) + delta;
    if (val < 1) val = 1;
    if (val > 99) val = 99;
    span.textContent = val;
}

// ══════════════════════════════════════════════════════════════
//  AGREGAR AL CARRITO
// ══════════════════════════════════════════════════════════════
function addToCart(btn) {
    const id      = btn.dataset.id;
    const nombre  = btn.dataset.nombre;
    const precio  = parseFloat(btn.dataset.precio);
    const img     = btn.dataset.img;
    const qtySpan = btn.closest('.buy-row').querySelector('.qty-val');
    const qty     = parseInt(qtySpan.textContent);

    if (cart[id]) {
        cart[id].qty += qty;
    } else {
        cart[id] = { nombre, precio, img, qty };
    }

    // feedback visual
    btn.classList.add('added');
    btn.innerHTML = '<i class="ti ti-check"></i> Agregado';
    setTimeout(() => {
        btn.classList.remove('added');
        btn.innerHTML = '<i class="ti ti-shopping-cart-plus"></i> Agregar';
    }, 1400);

    updateCartUI();
}

// ══════════════════════════════════════════════════════════════
//  ACTUALIZAR UI DEL CARRITO
// ══════════════════════════════════════════════════════════════
function updateCartUI() {
    const items   = Object.values(cart);
    const total   = items.reduce((s, i) => s + i.precio * i.qty, 0);
    const count   = items.reduce((s, i) => s + i.qty, 0);
    const fab     = document.getElementById('cartFab');
    const counter = document.getElementById('cartCount');
    const body    = document.getElementById('cartBody');
    const totalEl = document.getElementById('cartTotal');

    counter.textContent = count;
    fab.classList.toggle('visible', count > 0);
    totalEl.textContent = '$' + total.toLocaleString('es-CO');

    if (items.length === 0) {
        body.innerHTML = '<div class="cart-empty"><i class="ti ti-basket-off"></i>No hay productos aún.</div>';
        return;
    }

    body.innerHTML = items.map(item => `
        <div class="cart-item">
            <div class="cart-item-img" style="background-image:url('\${item.img}')"></div>
            <div class="cart-item-info">
                <strong>\${item.nombre}</strong>
                <span>Cant: \${item.qty} &nbsp;·&nbsp; Unit: $\${item.precio.toLocaleString('es-CO')}</span>
            </div>
            <div class="cart-item-price">$\${(item.precio * item.qty).toLocaleString('es-CO')}</div>
            <button class="cart-item-remove" onclick="removeItem('\${Object.keys(cart).find(k=>cart[k]===item)}')">
                <i class="ti ti-trash"></i>
            </button>
        </div>
    `).join('');
}

function removeItem(id) {
    delete cart[id];
    updateCartUI();
}

// ══════════════════════════════════════════════════════════════
//  ABRIR / CERRAR CARRITO
// ══════════════════════════════════════════════════════════════
function openCart() {
    document.getElementById('cartModal').classList.add('open');
    document.body.style.overflow = 'hidden';
}
function closeCart() {
    document.getElementById('cartModal').classList.remove('open');
    document.body.style.overflow = '';
}
document.getElementById('cartModal').addEventListener('click', e => {
    if (e.target === document.getElementById('cartModal')) closeCart();
});

// ══════════════════════════════════════════════════════════════
//  ENVIAR A WHATSAPP (verifica login primero)
// ══════════════════════════════════════════════════════════════
function sendToWhatsApp() {
    if (!LOGUEADO) {
        closeCart();
        document.getElementById('loginModal').classList.add('open');
        document.body.style.overflow = 'hidden';
        return;
    }

    const items = Object.values(cart);
    if (items.length === 0) return;

    const total = items.reduce((s, i) => s + i.precio * i.qty, 0);
    const lineas = items.map(i =>
        `• \${i.nombre} x\${i.qty} = $\${(i.precio * i.qty).toLocaleString('es-CO')}`
    ).join('\n');

    const msg = encodeURIComponent(
        `Hola CliniPet! 🐾 Quiero realizar el siguiente pedido:\n\n` +
        lineas +
        `\n\n💰 *Total: $\${total.toLocaleString('es-CO')}*\n\n¿Cómo procedo con el pago?`
    );
    window.open(`https://wa.me/\${WA_NUMBER}?text=\${msg}`, '_blank');
}

function closeLoginModal() {
    document.getElementById('loginModal').classList.remove('open');
    document.body.style.overflow = '';
}
document.getElementById('loginModal').addEventListener('click', e => {
    if (e.target === document.getElementById('loginModal')) closeLoginModal();
});

// ══════════════════════════════════════════════════════════════
//  TEMA
// ══════════════════════════════════════════════════════════════
const themeToggle = document.getElementById('themeToggle');
if (localStorage.getItem('clinipetTheme') === 'green') {
    document.body.classList.add('theme-green');
    themeToggle.innerHTML = '<i class="ti ti-sun"></i> Claro';
}
themeToggle.addEventListener('click', function () {
    document.body.classList.toggle('theme-green');
    if (document.body.classList.contains('theme-green')) {
        localStorage.setItem('clinipetTheme', 'green');
        themeToggle.innerHTML = '<i class="ti ti-sun"></i> Claro';
    } else {
        localStorage.setItem('clinipetTheme', 'light');
        themeToggle.innerHTML = '<i class="ti ti-leaf"></i> Modo';
    }
});
</script>
</body>
</html>
