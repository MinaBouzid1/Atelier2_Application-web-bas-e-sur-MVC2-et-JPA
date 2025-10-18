<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Inscription - Ma Boutique</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .auth-container {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .auth-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.15);
            overflow: hidden;
            max-width: 500px;
            width: 100%;
        }
        .auth-header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 40px 30px 30px;
            text-align: center;
        }
        .auth-body {
            padding: 40px 30px;
        }
        .form-control {
            border-radius: 12px;
            padding: 12px 20px;
            border: 2px solid #e9ecef;
            transition: all 0.3s ease;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-auth {
            background: linear-gradient(135deg, #28a745, #20c997);
            border: none;
            color: white;
            padding: 12px 30px;
            border-radius: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
            width: 100%;
        }
        .btn-auth:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(40, 167, 69, 0.3);
        }
        .input-group-icon {
            position: relative;
        }
        .input-group-icon .form-control {
            padding-left: 45px;
        }
        .input-group-icon i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
            z-index: 5;
        }
        .auth-divider {
            text-align: center;
            margin: 25px 0;
            position: relative;
        }
        .auth-divider:before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 1px;
            background: #e9ecef;
        }
        .auth-divider span {
            background: white;
            padding: 0 15px;
            color: #6c757d;
            font-size: 0.9rem;
        }
        .auth-footer {
            text-align: center;
            padding: 20px 30px;
            background: #f8f9fa;
            border-top: 1px solid #e9ecef;
        }
        .error-alert {
            border-radius: 12px;
            border: none;
            background: linear-gradient(135deg, #e74c3c, #c0392b);
            color: white;
        }
        .progress-steps {
            display: flex;
            justify-content: space-between;
            margin-bottom: 30px;
            position: relative;
        }
        .progress-steps:before {
            content: '';
            position: absolute;
            top: 15px;
            left: 0;
            right: 0;
            height: 2px;
            background: #e9ecef;
            z-index: 1;
        }
        .step {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: #e9ecef;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
            font-weight: 600;
            color: #6c757d;
            position: relative;
            z-index: 2;
        }
        .step.active {
            background: #667eea;
            color: white;
        }
    </style>
</head>
<body>
<div class="auth-container">
    <div class="auth-card">
        <!-- En-tête -->
        <div class="auth-header">
            <a href="${pageContext.request.contextPath}/" class="text-white text-decoration-none">
                <i class="fas fa-store fa-2x mb-3"></i>
                <h3 class="fw-bold mb-2">MaBoutique</h3>
            </a>
            <p class="mb-0 opacity-75">Rejoignez notre communauté</p>
        </div>

        <!-- Corps -->
        <div class="auth-body">
            <!-- Étapes de progression -->
            <div class="progress-steps">
                <div class="step active">1</div>
                <div class="step">2</div>
                <div class="step">3</div>
            </div>

            <c:if test="${not empty error}">
                <div class="alert error-alert d-flex align-items-center mb-4">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    <div class="flex-grow-1">${error}</div>
                </div>
            </c:if>

            <!-- Formulaire -->
            <form action="${pageContext.request.contextPath}/register" method="post">
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label small fw-semibold text-muted">Prénom</label>
                        <div class="input-group-icon">
                            <i class="fas fa-user"></i>
                            <input type="text" class="form-control" id="prenom" name="prenom"
                                   placeholder="Votre prénom" required>
                        </div>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label class="form-label small fw-semibold text-muted">Nom</label>
                        <div class="input-group-icon">
                            <i class="fas fa-user"></i>
                            <input type="text" class="form-control" id="nom" name="nom"
                                   placeholder="Votre nom" required>
                        </div>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label small fw-semibold text-muted">Adresse email</label>
                    <div class="input-group-icon">
                        <i class="fas fa-envelope"></i>
                        <input type="email" class="form-control" id="email" name="email"
                               placeholder="votre@email.com" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label small fw-semibold text-muted">Mot de passe</label>
                    <div class="input-group-icon">
                        <i class="fas fa-lock"></i>
                        <input type="password" class="form-control" id="password" name="password"
                               placeholder="Créez un mot de passe" required>
                    </div>
                    <div class="form-text small">
                        Utilisez au moins 8 caractères avec des chiffres et des lettres
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label small fw-semibold text-muted">Adresse</label>
                    <div class="input-group-icon">
                        <i class="fas fa-home"></i>
                        <textarea class="form-control" id="adresse" name="adresse"
                                  rows="2" placeholder="Votre adresse complète"></textarea>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label small fw-semibold text-muted">Téléphone</label>
                    <div class="input-group-icon">
                        <i class="fas fa-phone"></i>
                        <input type="tel" class="form-control" id="telephone" name="telephone"
                               placeholder="Votre numéro de téléphone">
                    </div>
                </div>

                <div class="form-check mb-4">
                    <input class="form-check-input" type="checkbox" id="terms" required>
                    <label class="form-check-label small text-muted" for="terms">
                        J'accepte les
                        <a href="#" class="text-primary text-decoration-none">conditions d'utilisation</a>
                        et la
                        <a href="#" class="text-primary text-decoration-none">politique de confidentialité</a>
                    </label>
                </div>

                <button type="submit" class="btn-auth mb-3">
                    <i class="fas fa-user-plus me-2"></i>Créer mon compte
                </button>
            </form>
        </div>

        <!-- Pied de page -->
        <div class="auth-footer">
            <p class="mb-0 text-muted">
                Déjà un compte ?
                <a href="${pageContext.request.contextPath}/login" class="text-primary text-decoration-none fw-semibold">
                    Se connecter
                </a>
            </p>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Animation pour la force du mot de passe
    document.getElementById('password').addEventListener('input', function() {
        const password = this.value;
        const strength = calculatePasswordStrength(password);
        updatePasswordStrength(strength);
    });

    function calculatePasswordStrength(password) {
        let strength = 0;
        if (password.length >= 8) strength++;
        if (password.match(/[a-z]/) && password.match(/[A-Z]/)) strength++;
        if (password.match(/\d/)) strength++;
        if (password.match(/[^a-zA-Z\d]/)) strength++;
        return strength;
    }

    function updatePasswordStrength(strength) {
        // Implémentation optionnelle pour afficher la force du mot de passe
    }
</script>
</body>
</html>