<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Connexion - Ma Boutique</title>
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
            max-width: 420px;
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
            background: linear-gradient(135deg, #667eea, #764ba2);
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
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
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
        .social-login {
            display: flex;
            gap: 15px;
            margin-bottom: 25px;
        }
        .btn-social {
            flex: 1;
            border: 2px solid #e9ecef;
            border-radius: 12px;
            padding: 10px;
            text-align: center;
            transition: all 0.3s ease;
            background: white;
        }
        .btn-social:hover {
            border-color: #667eea;
            transform: translateY(-2px);
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
            <p class="mb-0 opacity-75">Content de vous revoir !</p>
        </div>

        <!-- Corps -->
        <div class="auth-body">
            <c:if test="${not empty error}">
                <div class="alert error-alert d-flex align-items-center mb-4">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    <div class="flex-grow-1">${error}</div>
                </div>
            </c:if>

            <!-- Connexion sociale -->
            <div class="social-login">
                <button class="btn-social">
                    <i class="fab fa-google text-danger"></i>
                </button>
                <button class="btn-social">
                    <i class="fab fa-facebook text-primary"></i>
                </button>
                <button class="btn-social">
                    <i class="fab fa-apple"></i>
                </button>
            </div>

            <div class="auth-divider">
                <span>Ou connectez-vous avec votre email</span>
            </div>

            <!-- Formulaire -->
            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="mb-4">
                    <div class="input-group-icon">
                        <i class="fas fa-envelope"></i>
                        <input type="email" class="form-control" id="email" name="email"
                               placeholder="Adresse email" required>
                    </div>
                </div>

                <div class="mb-4">
                    <div class="input-group-icon">
                        <i class="fas fa-lock"></i>
                        <input type="password" class="form-control" id="password" name="password"
                               placeholder="Mot de passe" required>
                    </div>
                </div>

                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="remember">
                        <label class="form-check-label small text-muted" for="remember">
                            Se souvenir de moi
                        </label>
                    </div>
                    <a href="#" class="small text-decoration-none text-primary">
                        Mot de passe oublié ?
                    </a>
                </div>

                <button type="submit" class="btn-auth mb-3">
                    <i class="fas fa-sign-in-alt me-2"></i>Se connecter
                </button>
            </form>
        </div>

        <!-- Pied de page -->
        <div class="auth-footer">
            <p class="mb-0 text-muted">
                Nouveau sur MaBoutique ?
                <a href="${pageContext.request.contextPath}/register" class="text-primary text-decoration-none fw-semibold">
                    Créer un compte
                </a>
            </p>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>