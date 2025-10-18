package ma.fstt.ecom.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import ma.fstt.ecom.model.*;

import jakarta.persistence.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProduitServlet", value = "/produits")
public class ProduitServlet extends HttpServlet {
    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = Persistence.createEntityManagerFactory("mycnx");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        EntityManager em = emf.createEntityManager();
        try {
            // Récupérer tous les produits disponibles
            TypedQuery<Produit> query = em.createQuery(
                    "SELECT p FROM Produit p WHERE p.disponible = true ORDER BY p.nom", Produit.class);
            List<Produit> produits = query.getResultList();

            // Récupérer les catégories
            TypedQuery<Categorie> catQuery = em.createQuery(
                    "SELECT c FROM Categorie c ORDER BY c.nom", Categorie.class);
            List<Categorie> categories = catQuery.getResultList();

            request.setAttribute("produits", produits);
            request.setAttribute("categories", categories);

            // Message de succès
            if ("true".equals(request.getParameter("added"))) {
                request.setAttribute("successMessage", "Produit ajouté au panier avec succès !");
            }

            request.getRequestDispatcher("produits.jsp").forward(request, response);

        } finally {
            em.close();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);

        if ("addToCart".equals(action) && session != null && session.getAttribute("userId") != null) {
            EntityManager em = emf.createEntityManager();
            EntityTransaction transaction = em.getTransaction();

            try {
                transaction.begin();

                Integer userId = (Integer) session.getAttribute("userId");
                String productIdStr = request.getParameter("productId");
                String quantiteStr = request.getParameter("quantite");

                if (productIdStr != null) {
                    int productId = Integer.parseInt(productIdStr);
                    int quantite = quantiteStr != null ? Integer.parseInt(quantiteStr) : 1;

                    // 1. Récupérer ou créer le panier
                    Panier panier = getPanierByUserId(em, userId);
                    if (panier == null) {
                        panier = createPanier(em, userId);
                    }

                    // 2. Récupérer le produit
                    Produit produit = em.find(Produit.class, productId);
                    if (produit == null || !produit.isDisponible() || produit.getStock() < quantite) {
                        throw new RuntimeException("Produit non disponible");
                    }

                    // 3. Vérifier si le produit est déjà dans le panier
                    LignePanier lignePanier = getLignePanier(em, panier.getId_panier(), productId);

                    if (lignePanier != null) {
                        // Mettre à jour la quantité
                        lignePanier.setQuantite(lignePanier.getQuantite() + quantite);
                        lignePanier.setSous_total(lignePanier.getQuantite() * lignePanier.getPrix_unitaire());
                    } else {
                        // Créer une nouvelle ligne
                        lignePanier = new LignePanier();
                        lignePanier.setPanier(panier);
                        lignePanier.setProduit(produit);
                        lignePanier.setQuantite(quantite);
                        lignePanier.setPrix_unitaire(produit.getPrix());
                        lignePanier.setSous_total(quantite * produit.getPrix());
                        em.persist(lignePanier);
                    }

                    // 4. Mettre à jour le montant total du panier
                    double nouveauTotal = calculerMontantTotal(em, panier.getId_panier());
                    panier.setMontant_total(nouveauTotal);

                    // 5. Mettre à jour le stock du produit
                    produit.setStock(produit.getStock() - quantite);
                    if (produit.getStock() == 0) {
                        produit.setDisponible(false);
                    }

                    transaction.commit();
                    response.sendRedirect(request.getContextPath() + "/produits?added=true");
                    return;
                }

            } catch (Exception e) {
                if (transaction.isActive()) {
                    transaction.rollback();
                }
                e.printStackTrace();
                request.setAttribute("errorMessage", "Erreur lors de l'ajout au panier: " + e.getMessage());
                doGet(request, response);
                return;
            } finally {
                em.close();
            }
        }

        response.sendRedirect(request.getContextPath() + "/produits");
    }

    private Panier getPanierByUserId(EntityManager em, int userId) {
        try {
            TypedQuery<Panier> query = em.createQuery(
                    "SELECT p FROM Panier p WHERE p.internaute.id_internaute = :userId", Panier.class);
            query.setParameter("userId", userId);
            return query.getResultStream().findFirst().orElse(null);
        } catch (Exception e) {
            return null;
        }
    }

    private Panier createPanier(EntityManager em, int userId) {
        Internaute internaute = em.find(Internaute.class, userId);
        Panier panier = new Panier();
        panier.setInternaute(internaute);
        panier.setMontant_total(0.0);
        panier.setStatut("actif");
        em.persist(panier);
        return panier;
    }

    private LignePanier getLignePanier(EntityManager em, int panierId, int productId) {
        try {
            TypedQuery<LignePanier> query = em.createQuery(
                    "SELECT lp FROM LignePanier lp WHERE lp.panier.id_panier = :panierId AND lp.produit.id_produit = :productId",
                    LignePanier.class);
            query.setParameter("panierId", panierId);
            query.setParameter("productId", productId);
            return query.getResultStream().findFirst().orElse(null);
        } catch (Exception e) {
            return null;
        }
    }

    private double calculerMontantTotal(EntityManager em, int panierId) {
        TypedQuery<Double> query = em.createQuery(
                "SELECT SUM(lp.sous_total) FROM LignePanier lp WHERE lp.panier.id_panier = :panierId",
                Double.class);
        query.setParameter("panierId", panierId);
        Double total = query.getSingleResult();
        return total != null ? total : 0.0;
    }

    @Override
    public void destroy() {
        if (emf != null) {
            emf.close();
        }
    }
}