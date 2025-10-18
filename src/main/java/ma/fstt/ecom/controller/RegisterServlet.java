package ma.fstt.ecom.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import ma.fstt.ecom.model.Internaute;
import ma.fstt.ecom.model.Panier;
import jakarta.persistence.*;

import java.io.IOException;

@WebServlet(name = "RegisterServlet", value = "/register")
public class RegisterServlet extends HttpServlet {
    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = Persistence.createEntityManagerFactory("mycnx");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String adresse = request.getParameter("adresse");
        String telephone = request.getParameter("telephone");

        EntityManager em = emf.createEntityManager();
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();

            // Vérifier si l'email existe déjà
            TypedQuery<Internaute> checkQuery = em.createQuery(
                    "SELECT i FROM Internaute i WHERE i.email = :email", Internaute.class
            );
            checkQuery.setParameter("email", email);

            if (!checkQuery.getResultList().isEmpty()) {
                request.setAttribute("error", "Cet email est déjà utilisé");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }

            // Créer le nouvel internaute
            Internaute internaute = new Internaute();
            internaute.setNom(nom);
            internaute.setPrenom(prenom);
            internaute.setEmail(email);
            internaute.setMot_de_passe(password);
            internaute.setAdresse(adresse);
            internaute.setTelephone(telephone);

            em.persist(internaute);

            // Créer un panier pour le nouvel utilisateur
            Panier panier = new Panier();
            panier.setInternaute(internaute);
            panier.setMontant_total(0.0);
            panier.setStatut("actif");

            em.persist(panier);

            transaction.commit();

            // Connecter automatiquement l'utilisateur
            HttpSession session = request.getSession();
            session.setAttribute("user", internaute);
            session.setAttribute("userId", internaute.getId_internaute());
            session.setAttribute("userName", internaute.getPrenom() + " " + internaute.getNom());

            response.sendRedirect(request.getContextPath() + "/produits");

        } catch (Exception e) {
            if (transaction.isActive()) {
                transaction.rollback();
            }
            request.setAttribute("error", "Erreur lors de l'inscription: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        } finally {
            em.close();
        }
    }

    @Override
    public void destroy() {
        if (emf != null) {
            emf.close();
        }
    }
}