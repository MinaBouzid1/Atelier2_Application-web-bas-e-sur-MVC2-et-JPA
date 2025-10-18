package ma.fstt.ecom.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import ma.fstt.ecom.model.*;

import jakarta.persistence.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(name = "PanierServlet", value = "/panier")
public class PanierServlet extends HttpServlet {
    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = Persistence.createEntityManagerFactory("mycnx");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        EntityManager em = emf.createEntityManager();
        try {
            Integer userId = (Integer) session.getAttribute("userId");

            // Récupérer le panier avec les lignes
            Panier panier = getPanierWithLignes(em, userId);

            request.setAttribute("panier", panier);
            request.getRequestDispatcher("panier.jsp").forward(request, response);

        } finally {
            em.close();
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        Integer userId = (Integer) session.getAttribute("userId");
        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();

            if ("remove".equals(action)) {
                String ligneIdStr = request.getParameter("ligneId");
                if (ligneIdStr != null) {
                    int ligneId = Integer.parseInt(ligneIdStr);
                    supprimerLignePanier(em, ligneId, userId);
                }
            }
            else if ("update".equals(action)) {
                String ligneIdStr = request.getParameter("ligneId");
                String quantiteStr = request.getParameter("quantite");
                if (ligneIdStr != null && quantiteStr != null) {
                    int ligneId = Integer.parseInt(ligneIdStr);
                    int nouvelleQuantite = Integer.parseInt(quantiteStr);
                    mettreAJourQuantite(em, ligneId, userId, nouvelleQuantite);
                }
            }
            else if ("commander".equals(action)) {
                // Logique de commande
                creerCommande(em, userId);
                request.setAttribute("successMessage", "Commande passée avec succès !");
            }

            transaction.commit();
            response.sendRedirect(request.getContextPath() + "/panier");

        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            e.printStackTrace();
            request.setAttribute("errorMessage", "Erreur: " + e.getMessage());
            doGet(request, response);
        } finally {
            em.close();
        }
    }
    private Panier createPanier(EntityManager em, int userId) {
        Internaute internaute = em.find(Internaute.class, userId);
        if (internaute == null) {
            throw new RuntimeException("Utilisateur non trouvé");
        }

        Panier panier = new Panier();
        panier.setInternaute(internaute);
        panier.setMontant_total(0.0);
        panier.setStatut("actif");
        em.persist(panier);
        return panier;
    }

    private Panier getPanierWithLignes(EntityManager em, int userId) {
        try {
            TypedQuery<Panier> query = em.createQuery(
                    "SELECT p FROM Panier p LEFT JOIN FETCH p.lignesPanier lp LEFT JOIN FETCH lp.produit WHERE p.internaute.id_internaute = :userId",
                    Panier.class);
            query.setParameter("userId", userId);
            Panier panier = query.getResultStream().findFirst().orElse(null);

            // Si pas de panier, en créer un nouveau
            if (panier == null) {
                panier = createPanier(em, userId);
            }

            return panier;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private void supprimerLignePanier(EntityManager em, int lignePanierId, int userId) {
        LignePanier lignePanier = em.find(LignePanier.class, lignePanierId);
        if (lignePanier != null && lignePanier.getPanier().getInternaute().getId_internaute() == userId) {
            // Restaurer le stock
            Produit produit = lignePanier.getProduit();
            produit.setStock(produit.getStock() + lignePanier.getQuantite());
            produit.setDisponible(true);

            // Supprimer la ligne
            em.remove(lignePanier);

            // Mettre à jour le montant total du panier
            Panier panier = lignePanier.getPanier();
            panier.setMontant_total(calculerMontantTotal(em, panier.getId_panier()));
        }
    }

    private void mettreAJourQuantite(EntityManager em, int ligneId, int userId, int nouvelleQuantite) {
        LignePanier lignePanier = em.find(LignePanier.class, ligneId);
        if (lignePanier != null && lignePanier.getPanier().getInternaute().getId_internaute() == userId) {
            Produit produit = lignePanier.getProduit();

            if (nouvelleQuantite <= 0) {
                // Supprimer si quantité = 0
                supprimerLignePanier(em, ligneId, userId);
                return;
            }

            // Calculer la différence de quantité
            int ancienneQuantite = lignePanier.getQuantite();
            int difference = nouvelleQuantite - ancienneQuantite;

            // Vérifier le stock
            if (produit.getStock() + ancienneQuantite < nouvelleQuantite) {
                throw new RuntimeException("Stock insuffisant. Stock disponible: " + (produit.getStock() + ancienneQuantite));
            }

            // Mettre à jour la ligne
            lignePanier.setQuantite(nouvelleQuantite);
            lignePanier.setSous_total(nouvelleQuantite * lignePanier.getPrix_unitaire());

            // Mettre à jour le stock
            produit.setStock(produit.getStock() - difference);
            produit.setDisponible(produit.getStock() > 0);

            // Mettre à jour le montant total du panier
            Panier panier = lignePanier.getPanier();
            panier.setMontant_total(calculerMontantTotal(em, panier.getId_panier()));
        }
    }

    private void creerCommande(EntityManager em, int userId) {
        Panier panier = getPanierWithLignes(em, userId);

        if (panier == null || panier.getLignesPanier() == null || panier.getLignesPanier().isEmpty()) {
            throw new RuntimeException("Le panier est vide");
        }

        // Créer la commande
        Commande commande = new Commande();
        commande.setInternaute(panier.getInternaute());
        commande.setNumero_commande("CMD" + System.currentTimeMillis());
        commande.setDate_commande(LocalDateTime.now());
        commande.setMontant_total(panier.getMontant_total());
        commande.setStatut("payée");
        commande.setAdresse_livraison(panier.getInternaute().getAdresse());
        commande.setMode_paiement("Carte bancaire");
        commande.setDate_paiement(LocalDateTime.now());

        em.persist(commande);

        // Créer les lignes de commande
        for (LignePanier lignePanier : panier.getLignesPanier()) {
            LigneCommande ligneCommande = new LigneCommande();
            ligneCommande.setCommande(commande);
            ligneCommande.setProduit(lignePanier.getProduit());
            ligneCommande.setQuantite(lignePanier.getQuantite());
            ligneCommande.setPrix_unitaire(lignePanier.getPrix_unitaire());
            ligneCommande.setSous_total(lignePanier.getSous_total());

            em.persist(ligneCommande);
        }

        // Vider le panier CORRECTEMENT
        // Important: Il faut vider la liste ET supprimer les lignes
        for (LignePanier lignePanier : panier.getLignesPanier()) {
            em.remove(lignePanier); // Supprime de la base de données
        }
        panier.getLignesPanier().clear(); // Vide la liste en mémoire
        panier.setMontant_total(0.0);

        // Forcer la mise à jour de l'entité panier
        em.merge(panier);
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