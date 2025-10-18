package ma.fstt.ecom.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class TestJPA {

    public static void main(String[] args) {

        // Création de l'EntityManager
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("mycnx");
        EntityManager em = emf.createEntityManager();

        try {
            em.getTransaction().begin();

            // 1️⃣ Créer un internaute
            Internaute internaute = new Internaute();
            internaute.setNom("Leila");
            internaute.setPrenom("Mohamed");
            internaute.setEmail("leila@example.com");
            internaute.setMot_de_passe("123456");
            internaute.setAdresse("123 rue de Casablanca");
            internaute.setTelephone("0612345678");

            em.persist(internaute);



            // 3️⃣ Créer une commande
            Commande commande = new Commande();
            commande.setInternaute(internaute);
            commande.setNumero_commande("CMD001");
            commande.setDate_commande(LocalDateTime.now());
            commande.setMontant_total(0.0);
            commande.setStatut("en attente");
            commande.setAdresse_livraison("123 rue de Casablanca");
            commande.setMode_paiement("Carte bancaire");

            em.persist(commande);

            // 4️⃣ Créer des produits
            Categorie categorie = new Categorie();
            categorie.setNom("Informatique");
            categorie.setDescription("Ordinateurs et accessoires");
            em.persist(categorie);

            Produit produit1 = new Produit();
            produit1.setNom("Laptop HP");
            produit1.setCategorie(categorie);
            produit1.setDescription("Laptop HP 15 pouces");
            produit1.setPrix(500.0);
            produit1.setStock(10);
            produit1.setDisponible(true);

            Produit produit2 = new Produit();
            produit2.setNom("Souris Logitech");
            produit2.setCategorie(categorie);
            produit2.setDescription("Souris sans fil Logitech");
            produit2.setPrix(30.0);
            produit2.setStock(50);
            produit2.setDisponible(true);

            em.persist(produit1);
            em.persist(produit2);

            // 5️⃣ Créer les lignes de commande
            LigneCommande ligne1 = new LigneCommande();
            ligne1.setCommande(commande);
            ligne1.setProduit(produit1);
            ligne1.setQuantite(1);
            ligne1.setPrix_unitaire(produit1.getPrix());
            ligne1.setSous_total(produit1.getPrix() * ligne1.getQuantite());

            LigneCommande ligne2 = new LigneCommande();
            ligne2.setCommande(commande);
            ligne2.setProduit(produit2);
            ligne2.setQuantite(2);
            ligne2.setPrix_unitaire(produit2.getPrix());
            ligne2.setSous_total(produit2.getPrix() * ligne2.getQuantite());

            em.persist(ligne1);
            em.persist(ligne2);

            // 6️⃣ Mettre à jour le montant total de la commande
            commande.setMontant_total(ligne1.getSous_total() + ligne2.getSous_total());
            em.merge(commande);

            em.getTransaction().commit();

            System.out.println("Données insérées avec succès !");

        } catch (Exception e) {
            em.getTransaction().rollback();
            e.printStackTrace();
        } finally {
            em.close();
            emf.close();
        }
    }
}
