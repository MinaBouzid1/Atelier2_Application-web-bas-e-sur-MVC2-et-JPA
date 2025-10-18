<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Mon Panier - Ma Boutique</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .cart-header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border-radius: 15px 15px 0 0;
        }
        .cart-item {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }
        .cart-item:hover {
            box-shadow: 0 8px 25px rgba(0,0,0,0.12);
        }
        .product-image {
            width: 90px;
            height: 90px;
            object-fit: cover;
            border-radius: 10px;
        }
        .quantity-controls {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .quantity-btn {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 2px solid #e9ecef;
            background: white;
            transition: all 0.3s ease;
        }
        .quantity-btn:hover {
            border-color: #667eea;
            background: #667eea;
            color: white;
        }
        .quantity-input {
            width: 60px;
            text-align: center;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            padding: 5px;
        }
        .cart-summary {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-radius: 15px;
            padding: 25px;
            border: 1px solid rgba(0,0,0,0.05);
        }
        .btn-remove {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 8px 15px;
            transition: all 0.3s ease;
        }
        .btn-remove:hover {
            transform: scale(1.05);
            box-shadow: 0 5px 15px rgba(231, 76, 60, 0.3);
        }
        .btn-checkout {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            border: none;
            border-radius: 12px;
            padding: 15px 30px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
        }
        .btn-checkout:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(40, 167, 69, 0.3);
        }
        .empty-cart {
            text-align: center;
            padding: 80px 20px;
        }
        .empty-cart-icon {
            font-size: 5rem;
            color: #6c757d;
            margin-bottom: 20px;
        }
        .price-highlight {
            font-size: 1.3rem;
            font-weight: 700;
            color: #2c5aa0;
        }
        .section-divider {
            border-top: 2px dashed #dee2e6;
            margin: 20px 0;
        }
    </style>
</head>
<body>
<!-- Navigation -->
<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
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
                    <a class="nav-link text-dark mx-2" href="${pageContext.request.contextPath}/produits">
                        <i class="fas fa-box me-1"></i>Produits
                    </a>
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
                    <a class="nav-link text-dark mx-2" href="${pageContext.request.contextPath}/produits">
                        <i class="fas fa-box me-1"></i>Produits
                    </a>
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
        <div class="col-12">
            <h1 class="fw-bold display-5 mb-2">
                <i class="fas fa-shopping-cart me-3"></i>Mon Panier
            </h1>
            <p class="text-muted lead">Gérez vos articles et passez commande en toute simplicité</p>
        </div>
    </div>

    <!-- Messages -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success alert-dismissible fade show d-flex align-items-center" role="alert">
            <i class="fas fa-check-circle me-2 fs-5"></i>
            <div class="flex-grow-1">${sessionScope.successMessage}</div>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center" role="alert">
            <i class="fas fa-exclamation-circle me-2 fs-5"></i>
            <div class="flex-grow-1">${sessionScope.errorMessage}</div>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <c:choose>
        <c:when test="${empty panier || empty panier.lignesPanier}">
            <!-- Panier vide -->
            <div class="empty-cart">
                <div class="empty-cart-icon">
                    <i class="fas fa-shopping-cart"></i>
                </div>
                <h3 class="text-muted mb-3">Votre panier est vide</h3>
                <p class="text-muted mb-4">Découvrez nos produits et ajoutez-les à votre panier pour commencer vos achats.</p>
                <a href="${pageContext.request.contextPath}/produits" class="btn btn-primary btn-lg px-4">
                    <i class="fas fa-box me-2"></i>Découvrir les produits
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <!-- Panier avec articles -->
            <div class="row">
                <div class="col-lg-8">
                    <!-- En-tête des articles -->
                    <div class="card cart-header mb-3">
                        <div class="card-body py-3">
                            <div class="row align-items-center">
                                <div class="col-md-6">
                                    <h5 class="mb-0 fw-semibold">
                                        <i class="fas fa-list me-2"></i>Articles dans le panier
                                    </h5>
                                </div>
                                <div class="col-md-6 text-md-end">
                                    <span class="badge bg-light text-dark fs-6">${panier.lignesPanier.size()} article(s)</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Liste des articles -->
                    <c:forEach var="ligne" items="${panier.lignesPanier}">
                        <div class="card cart-item">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <!-- Image et informations -->
                                    <div class="col-md-2">
                                        <img src="https://via.placeholder.com/150/667eea/ffffff?text=${ligne.produit.nom}"
                                             alt="${ligne.produit.nom}" class="product-image">
                                    </div>
                                    <div class="col-md-4">
                                        <h6 class="fw-bold text-dark mb-1">${ligne.produit.nom}</h6>
                                        <p class="text-muted small mb-2">${ligne.produit.description}</p>
                                        <p class="text-muted small mb-0">
                                            <strong>Prix unitaire:</strong> ${ligne.prix_unitaire} DH
                                        </p>
                                    </div>

                                    <!-- Contrôles de quantité -->
                                    <div class="col-md-3">
                                        <div class="quantity-controls">
                                            <button type="button" class="quantity-btn"
                                                    onclick="updateQuantity(${ligne.id_ligne_panier}, ${ligne.quantite - 1})">
                                                <i class="fas fa-minus"></i>
                                            </button>

                                            <input type="number" value="${ligne.quantite}"
                                                   min="1" max="${ligne.produit.stock + ligne.quantite}"
                                                   class="quantity-input"
                                                   onchange="updateQuantity(${ligne.id_ligne_panier}, this.value)">

                                            <button type="button" class="quantity-btn"
                                                    onclick="updateQuantity(${ligne.id_ligne_panier}, ${ligne.quantite + 1})">
                                                <i class="fas fa-plus"></i>
                                            </button>
                                        </div>
                                    </div>

                                    <!-- Prix et actions -->
                                    <div class="col-md-3 text-end">
                                        <div class="price-highlight mb-2">${ligne.sous_total} DH</div>
                                        <form action="${pageContext.request.contextPath}/panier" method="post">
                                            <input type="hidden" name="action" value="remove">
                                            <input type="hidden" name="ligneId" value="${ligne.id_ligne_panier}">
                                            <button type="submit" class="btn-remove btn-sm"
                                                    onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce produit ?')">
                                                <i class="fas fa-trash me-1"></i>Supprimer
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Récapitulatif -->
                <div class="col-lg-4">
                    <div class="cart-summary">
                        <h5 class="fw-bold mb-4">
                            <i class="fas fa-receipt me-2"></i>Récapitulatif
                        </h5>

                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span class="fw-semibold">Sous-total:</span>
                            <span class="fw-bold fs-5">${panier.montant_total} DH</span>
                        </div>

                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span class="fw-semibold">Livraison:</span>
                            <span class="text-success fw-bold">30.00 DH</span>
                        </div>

                        <div class="section-divider"></div>

                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <strong class="fs-5">Total:</strong>
                            <strong class="fs-4 text-primary">${panier.montant_total + 30} DH</strong>
                        </div>

                        <form action="${pageContext.request.contextPath}/panier" method="post">
                            <input type="hidden" name="action" value="commander">
                            <button type="submit" class="btn-checkout w-100 mb-3"
                                    onclick="return confirm('Confirmer la commande et le paiement ?')">
                                <i class="fas fa-credit-card me-2"></i>Commander et Payer
                            </button>
                        </form>

                        <a href="${pageContext.request.contextPath}/produits" class="btn btn-outline-primary w-100">
                            <i class="fas fa-arrow-left me-2"></i>Continuer mes achats
                        </a>
                    </div>

                    <!-- Informations de livraison -->
                    <div class="card mt-4 border-0 shadow-sm">
                        <div class="card-body">
                            <h6 class="fw-bold mb-3">
                                <i class="fas fa-truck me-2"></i>Livraison
                            </h6>
                            <div class="d-flex align-items-center mb-2">
                                <i class="fas fa-clock text-warning me-2"></i>
                                <span class="small">Délai: 2-3 jours ouvrables</span>
                            </div>
                            <div class="d-flex align-items-center">
                                <i class="fas fa-map-marker-alt text-danger me-2"></i>
                                <span class="small">Adresse: ${panier.internaute.adresse}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- Footer -->
<footer class="bg-dark text-white py-4 mt-5">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-6">
                <h5 class="mb-2"><i class="fas fa-store me-2"></i>MaBoutique</h5>
                <p class="text-muted mb-0">Livraison rapide et service client exceptionnel</p>
            </div>
            <div class="col-md-6 text-md-end">
                <p class="text-muted mb-0">&copy; 2024 MaBoutique. Tous droits réservés.</p>
            </div>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function updateQuantity(ligneId, newQuantity) {
        if (newQuantity < 1) {
            if (confirm('Voulez-vous supprimer ce produit du panier ?')) {
                const form = document.createElement('form');
                form.method = 'post';
                form.action = '${pageContext.request.contextPath}/panier';

                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'remove';
                form.appendChild(actionInput);

                const ligneIdInput = document.createElement('input');
                ligneIdInput.type = 'hidden';
                ligneIdInput.name = 'ligneId';
                ligneIdInput.value = ligneId;
                form.appendChild(ligneIdInput);

                document.body.appendChild(form);
                form.submit();
            }
            return;
        }

        const form = document.createElement('form');
        form.method = 'post';
        form.action = '${pageContext.request.contextPath}/panier';

        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'update';
        form.appendChild(actionInput);

        const ligneIdInput = document.createElement('input');
        ligneIdInput.type = 'hidden';
        ligneIdInput.name = 'ligneId';
        ligneIdInput.value = ligneId;
        form.appendChild(ligneIdInput);

        const quantiteInput = document.createElement('input');
        quantiteInput.type = 'hidden';
        quantiteInput.name = 'quantite';
        quantiteInput.value = newQuantity;
        form.appendChild(quantiteInput);

        document.body.appendChild(form);
        form.submit();
    }

    document.addEventListener('DOMContentLoaded', function() {
        const quantityInputs = document.querySelectorAll('.quantity-input');
        quantityInputs.forEach(input => {
            input.addEventListener('change', function() {
                const ligneId = this.closest('.row').querySelector('input[name="ligneId"]').value;
                updateQuantity(ligneId, this.value);
            });
        });
    });
</script>
</body>
</html>