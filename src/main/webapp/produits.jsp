<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Nos Produits - Ma Boutique</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .product-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            overflow: hidden;
            margin-bottom: 25px;
        }
        .product-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.15);
        }
        .product-image {
            height: 220px;
            object-fit: cover;
            width: 100%;
            transition: transform 0.3s ease;
        }
        .product-card:hover .product-image {
            transform: scale(1.05);
        }
        .product-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            z-index: 2;
        }
        .price-tag {
            font-size: 1.4rem;
            font-weight: 700;
            color: #2c5aa0;
        }
        .category-badge {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        .filter-section {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 30px;
            border: 1px solid rgba(0,0,0,0.05);
        }
        .stock-badge {
            font-size: 0.8rem;
            padding: 4px 10px;
            border-radius: 12px;
        }
        .btn-add-cart {
            background: linear-gradient(135deg, #28a745, #20c997);
            border: none;
            color: white;
            padding: 10px 20px;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-add-cart:hover {
            transform: scale(1.05);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.3);
        }
        .search-box {
            border-radius: 25px;
            padding: 12px 20px;
            border: 2px solid #e9ecef;
            transition: all 0.3s ease;
        }
        .search-box:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .section-title {
            position: relative;
            padding-bottom: 15px;
            margin-bottom: 30px;
        }
        .section-title:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 80px;
            height: 3px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 2px;
        }
    </style>
</head>
<body>
<!-- Navigation -->
<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm sticky-top">
    <div class="container">
        <a class="navbar-brand fw-bold text-primary" href="${pageContext.request.contextPath}/">
            <i class="fas fa-store me-2"></i>MaBoutique
        </a>
        <div class="navbar-nav ms-auto align-items-center">
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <span class="navbar-text me-3 text-dark fw-medium">
                        <i class="fas fa-user-circle me-2"></i>${sessionScope.userName}
                    </span>
                    <a class="nav-link text-dark mx-2 position-relative" href="${pageContext.request.contextPath}/panier">
                        <i class="fas fa-shopping-cart me-1"></i>Panier
                        <c:if test="${panier != null && panier.montant_total > 0}">
                            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                ${panier.montant_total} DH
                            </span>
                        </c:if>
                    </a>
                    <a class="nav-link text-dark mx-2" href="${pageContext.request.contextPath}/logout">
                        <i class="fas fa-sign-out-alt me-1"></i>Déconnexion
                    </a>
                </c:when>
                <c:otherwise>
                    <a class="nav-link text-dark mx-2" href="${pageContext.request.contextPath}/login">
                        <i class="fas fa-sign-in-alt me-1"></i>Connexion
                    </a>
                    <a class="btn btn-primary ms-2 px-3" href="${pageContext.request.contextPath}/register">
                        <i class="fas fa-user-plus me-1"></i>S'inscrire
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>

<div class="container py-5">
    <!-- En-tête -->
    <div class="row mb-4">
        <div class="col-12 text-center">
            <h1 class="section-title fw-bold display-5">Nos Produits</h1>
            <p class="text-muted lead">Découvrez notre sélection exclusive de produits de qualité</p>
        </div>
    </div>

    <!-- Filtres -->
    <div class="filter-section">
        <div class="row g-3">
            <div class="col-md-4">
                <label class="form-label fw-semibold text-dark">
                    <i class="fas fa-filter me-2"></i>Catégorie
                </label>
                <select class="form-select shadow-sm" id="categorie" onchange="filterProducts()">
                    <option value="">Toutes les catégories</option>
                    <c:forEach var="categorie" items="${categories}">
                        <option value="${categorie.id_categorie}">${categorie.nom}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-5">
                <label class="form-label fw-semibold text-dark">
                    <i class="fas fa-search me-2"></i>Recherche
                </label>
                <input type="text" class="form-control search-box" id="search" placeholder="Rechercher un produit..." onkeyup="filterProducts()">
            </div>
            <div class="col-md-3 d-flex align-items-end">
                <div class="form-check form-switch">
                    <input class="form-check-input" type="checkbox" id="disponibleOnly" checked onchange="filterProducts()">
                    <label class="form-check-label fw-medium text-dark" for="disponibleOnly">
                        Produits disponibles uniquement
                    </label>
                </div>
            </div>
        </div>
    </div>

    <!-- Messages -->
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success alert-dismissible fade show d-flex align-items-center" role="alert">
            <i class="fas fa-check-circle me-2 fs-5"></i>
            <div class="flex-grow-1">${successMessage}</div>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Liste des produits -->
    <div class="row" id="productsContainer">
        <c:forEach var="produit" items="${produits}">
            <div class="col-xl-3 col-lg-4 col-md-6 product-item"
                 data-category="${produit.categorie.id_categorie}"
                 data-name="${produit.nom.toLowerCase()}"
                 data-disponible="${produit.disponible && produit.stock > 0}">

                <div class="card product-card h-100 position-relative">
                    <!-- Badge de statut -->
                    <c:if test="${!produit.disponible || produit.stock == 0}">
                        <span class="product-badge badge bg-danger">Hors stock</span>
                    </c:if>
                    <c:if test="${produit.stock < 10 && produit.stock > 0}">
                        <span class="product-badge badge bg-warning text-dark">Stock limité</span>
                    </c:if>

                    <!-- Image du produit -->
                    <div class="position-relative overflow-hidden">
                        <img src="https://via.placeholder.com/400x300/667eea/ffffff?text=${produit.nom}"
                             class="card-img-top product-image" alt="${produit.nom}">
                    </div>

                    <div class="card-body d-flex flex-column p-4">
                        <!-- En-tête produit -->
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <h5 class="card-title fw-bold text-dark mb-0">${produit.nom}</h5>
                            <span class="price-tag">${produit.prix} DH</span>
                        </div>

                        <!-- Description -->
                        <p class="card-text text-muted mb-3 flex-grow-1 small">${produit.description}</p>

                        <!-- Catégorie et stock -->
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span class="category-badge">${produit.categorie.nom}</span>
                            <c:choose>
                                <c:when test="${produit.disponible && produit.stock > 0}">
                                    <span class="stock-badge bg-success text-white">
                                        <i class="fas fa-check me-1"></i>En stock
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="stock-badge bg-secondary text-white">
                                        <i class="fas fa-times me-1"></i>Rupture
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Bouton d'action -->
                        <c:choose>
                            <c:when test="${produit.disponible && produit.stock > 0}">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user}">
                                        <form action="${pageContext.request.contextPath}/produits" method="post">
                                            <input type="hidden" name="action" value="addToCart">
                                            <input type="hidden" name="productId" value="${produit.id_produit}">
                                            <input type="hidden" name="quantite" value="1">
                                            <button type="submit" class="btn btn-add-cart w-100">
                                                <i class="fas fa-cart-plus me-2"></i>Ajouter au panier
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn btn-outline-primary w-100" onclick="redirectToLogin(${produit.id_produit})">
                                            <i class="fas fa-cart-plus me-2"></i>Ajouter au panier
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <button class="btn btn-secondary w-100" disabled>
                                    <i class="fas fa-clock me-2"></i>Produit indisponible
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- Message aucun produit -->
    <c:if test="${empty produits}">
        <div class="text-center py-5">
            <i class="fas fa-box-open fa-4x text-muted mb-4"></i>
            <h3 class="text-muted mb-3">Aucun produit disponible</h3>
            <p class="text-muted mb-4">Nous mettons régulièrement à jour notre catalogue. Revenez bientôt !</p>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                <i class="fas fa-home me-2"></i>Retour à l'accueil
            </a>
        </div>
    </c:if>

    <!-- Message aucun produit après filtrage -->
    <div id="noProductsMessage" class="text-center py-5" style="display: none;">
        <i class="fas fa-search fa-4x text-warning mb-4"></i>
        <h3 class="text-warning mb-3">Aucun produit trouvé</h3>
        <p class="text-muted mb-4">Aucun produit ne correspond à vos critères de recherche.</p>
        <button class="btn btn-outline-warning" onclick="resetFilters()">
            <i class="fas fa-redo me-2"></i>Réinitialiser les filtres
        </button>
    </div>
</div>

<!-- Footer -->
<footer class="bg-dark text-white py-4 mt-5">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-6">
                <h5 class="mb-2"><i class="fas fa-store me-2"></i>MaBoutique</h5>
                <p class="text-muted mb-0">Votre satisfaction est notre priorité</p>
            </div>
            <div class="col-md-6 text-md-end">
                <p class="text-muted mb-0">&copy; 2024 MaBoutique. Tous droits réservés.</p>
            </div>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Les fonctions JavaScript restent les mêmes
    function filterProducts() {
        const selectedCategory = document.getElementById('categorie').value;
        const searchText = document.getElementById('search').value.toLowerCase();
        const disponibleOnly = document.getElementById('disponibleOnly').checked;
        const products = document.querySelectorAll('.product-item');

        let visibleCount = 0;

        products.forEach(product => {
            const category = product.getAttribute('data-category');
            const name = product.getAttribute('data-name');
            const disponible = product.getAttribute('data-disponible') === 'true';

            const categoryMatch = selectedCategory === '' || category === selectedCategory;
            const nameMatch = name.includes(searchText);
            const disponibleMatch = !disponibleOnly || disponible;

            if (categoryMatch && nameMatch && disponibleMatch) {
                product.style.display = 'block';
                visibleCount++;
            } else {
                product.style.display = 'none';
            }
        });

        const noProductsMessage = document.getElementById('noProductsMessage');
        if (visibleCount === 0) {
            noProductsMessage.style.display = 'block';
        } else {
            noProductsMessage.style.display = 'none';
        }
    }

    function redirectToLogin(productId) {
        sessionStorage.setItem('productToAdd', productId);
        window.location.href = '${pageContext.request.contextPath}/login?from=products&product=' + productId;
    }

    function resetFilters() {
        document.getElementById('categorie').value = '';
        document.getElementById('search').value = '';
        document.getElementById('disponibleOnly').checked = true;
        filterProducts();
    }

    document.addEventListener('DOMContentLoaded', function() {
        const urlParams = new URLSearchParams(window.location.search);
        const category = urlParams.get('category');
        if (category) {
            document.getElementById('categorie').value = category;
        }
        filterProducts();
    });
</script>
</body>
</html>