<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Ma Boutique - Accueil</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 100px 0;
            text-align: center;
        }
        .feature-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            margin-bottom: 30px;
        }
        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }
        .feature-icon {
            font-size: 3rem;
            color: #667eea;
            margin-bottom: 20px;
        }
        .btn-gradient {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            color: white;
            padding: 12px 30px;
            border-radius: 50px;
            font-weight: 600;
            transition: transform 0.3s ease;
        }
        .btn-gradient:hover {
            transform: scale(1.05);
            color: white;
        }
        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
        }
        .stats-section {
            background: #f8f9fa;
            padding: 80px 0;
        }
        .stat-number {
            font-size: 3rem;
            font-weight: 700;
            color: #667eea;
        }
    </style>
</head>
<body>
<!-- Navigation -->
<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
    <div class="container">
        <a class="navbar-brand text-gradient" href="${pageContext.request.contextPath}/">
            <i class="fas fa-store me-2"></i>MaBoutique
        </a>
        <div class="navbar-nav ms-auto">
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <span class="navbar-text me-3 text-dark">
                        <i class="fas fa-user-circle me-1"></i>Bonjour, ${sessionScope.userName}
                    </span>
                    <a class="nav-link text-dark mx-2" href="${pageContext.request.contextPath}/produits">
                        <i class="fas fa-box me-1"></i>Produits
                    </a>
                    <a class="nav-link text-dark mx-2" href="${pageContext.request.contextPath}/panier">
                        <i class="fas fa-shopping-cart me-1"></i>Panier
                        <c:if test="${panier != null && panier.montant_total > 0}">
                            <span class="badge bg-danger ms-1">${panier.montant_total} DH</span>
                        </c:if>
                    </a>
                    <a class="nav-link text-dark mx-2" href="${pageContext.request.contextPath}/logout">
                        <i class="fas fa-sign-out-alt me-1"></i>Déconnexion
                    </a>
                </c:when>
                <c:otherwise>
                    <a class="nav-link text-dark mx-2" href="${pageContext.request.contextPath}/produits">
                        <i class="fas fa-box me-1"></i>Produits
                    </a>
                    <a class="nav-link text-dark mx-2" href="${pageContext.request.contextPath}/login">
                        <i class="fas fa-sign-in-alt me-1"></i>Connexion
                    </a>
                    <a class="btn btn-outline-primary ms-2" href="${pageContext.request.contextPath}/register">
                        <i class="fas fa-user-plus me-1"></i>S'inscrire
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>

<!-- Hero Section -->
<section class="hero-section">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <h1 class="display-4 fw-bold mb-4">Bienvenue dans notre boutique en ligne</h1>
                <p class="lead mb-5">Découvrez une sélection exclusive de produits de qualité aux meilleurs prix. Livraison rapide et service client exceptionnel.</p>
                <div class="d-flex gap-3 justify-content-center flex-wrap">
                    <a href="${pageContext.request.contextPath}/produits" class="btn btn-light btn-lg px-4 py-2">
                        <i class="fas fa-shopping-bag me-2"></i>Découvrir les produits
                    </a>
                    <c:if test="${empty sessionScope.user}">
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-light btn-lg px-4 py-2">
                            <i class="fas fa-rocket me-2"></i>Commencer maintenant
                        </a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Features Section -->
<section class="py-5">
    <div class="container">
        <div class="row text-center mb-5">
            <div class="col-lg-8 mx-auto">
                <h2 class="fw-bold mb-3">Pourquoi choisir MaBoutique ?</h2>
                <p class="text-muted">Nous nous engageons à vous offrir la meilleure expérience d'achat en ligne</p>
            </div>
        </div>
        <div class="row">
            <div class="col-md-4">
                <div class="card feature-card h-100 text-center p-4">
                    <div class="feature-icon">
                        <i class="fas fa-shipping-fast"></i>
                    </div>
                    <h5>Livraison Rapide</h5>
                    <p class="text-muted">Livraison express sous 48h dans toute la région</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card feature-card h-100 text-center p-4">
                    <div class="feature-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <h5>Paiement Sécurisé</h5>
                    <p class="text-muted">Transactions 100% sécurisées avec cryptage SSL</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card feature-card h-100 text-center p-4">
                    <div class="feature-icon">
                        <i class="fas fa-headset"></i>
                    </div>
                    <h5>Support 24/7</h5>
                    <p class="text-muted">Notre équipe est disponible pour vous aider à tout moment</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Stats Section -->
<section class="stats-section">
    <div class="container">
        <div class="row text-center">
            <div class="col-md-3">
                <div class="stat-number">500+</div>
                <p class="text-muted">Produits disponibles</p>
            </div>
            <div class="col-md-3">
                <div class="stat-number">10K+</div>
                <p class="text-muted">Clients satisfaits</p>
            </div>
            <div class="col-md-3">
                <div class="stat-number">98%</div>
                <p class="text-muted">Taux de satisfaction</p>
            </div>
            <div class="col-md-3">
                <div class="stat-number">24h</div>
                <p class="text-muted">Support disponible</p>
            </div>
        </div>
    </div>
</section>

<!-- Footer -->
<footer class="bg-dark text-white py-4">
    <div class="container">
        <div class="row">
            <div class="col-md-6">
                <h5><i class="fas fa-store me-2"></i>MaBoutique</h5>
                <p class="text-muted">Votre boutique en ligne de confiance depuis 2024</p>
            </div>
            <div class="col-md-6 text-end">
                <p class="text-muted mb-0">&copy; 2024 MaBoutique. Tous droits réservés.</p>
            </div>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>