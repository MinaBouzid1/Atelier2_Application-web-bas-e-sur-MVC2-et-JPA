# Plateforme E-commerce

## Description
MaBoutique est une plateforme e-commerce  développée en Java EE qui permet aux utilisateurs de parcourir des produits, gérer un panier d'achat et passer des commandes en ligne.

## Fonctionnalités Principales
- Système d'authentification utilisateur (inscription/connexion)
- Catalogue de produits avec filtres par catégorie et recherche
- Gestion du panier d'achat avec modification des quantités
- Passation de commandes avec suivi du statut
- Interface responsive adaptée mobile et desktop

## Architecture du Projet
Le projet suit une architecture MVC avec les composants suivants :

### Modèle (Package model)
- `Internaute` : Gestion des utilisateurs
- `Produit` et `Categorie` : Gestion du catalogue
- `Panier` et `LignePanier` : Gestion du panier
- `Commande` et `LigneCommande` : Gestion des commandes

### Contrôleur (Package controller)
- `ProduitServlet` : Gestion du catalogue produits
- `PanierServlet` : Gestion du panier et commandes
- `LoginServlet` et `RegisterServlet` : Authentification
- `AuthFilter` : Sécurisation des pages

### Vue (Pages JSP)
- `index.jsp` : Page d'accueil
- `produits.jsp` : Catalogue produits
- `panier.jsp` : Gestion du panier
- `login.jsp` et `register.jsp` : Pages d'authentification

## Technologies Utilisées
- **Backend** : Java EE, Servlets, JPA (EclipseLink)
- **Frontend** : JSP, Bootstrap 5, JavaScript
- **Base de données** : MySQL
- **Outils** : Maven, WildFly Server

## Installation et Déploiement

### Prérequis
- Java JDK 21 ou supérieur
- MySQL 8.0 ou supérieur
- Maven 3.6 ou supérieur
- WildFly 26 ou supérieur

### Étapes d'installation
1. Cloner le repository
2. Créer la base de données MySQL
3. Configurer les paramètres de connexion dans `persistence.xml`
4. Compiler avec Maven : `mvn clean package`
5. Déployer sur WildFly

## Structure de la Base de Données
La base de données comprend les tables principales :
- `internaute` : informations des utilisateurs
- `produit` et `categorie` : catalogue produits
- `panier` et `ligne_panier` : gestion panier
- `commande` et `ligne_commande` : historique commandes
