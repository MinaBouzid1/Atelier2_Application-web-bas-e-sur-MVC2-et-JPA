package ma.fstt.ecom.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import ma.fstt.ecom.model.Internaute;
import jakarta.persistence.*;

import java.io.IOException;

@WebServlet(name = "LoginServlet", value = "/login")
public class LoginServlet extends HttpServlet {
    private EntityManagerFactory emf;

    @Override
    public void init() throws ServletException {
        emf = Persistence.createEntityManagerFactory("mycnx");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Internaute> query = em.createQuery(
                    "SELECT i FROM Internaute i WHERE i.email = :email AND i.mot_de_passe = :password",
                    Internaute.class
            );
            query.setParameter("email", email);
            query.setParameter("password", password);

            Internaute internaute = query.getResultStream().findFirst().orElse(null);

            // Ajouter cette méthode dans LoginServlet.java après la connexion réussie
            if (internaute != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", internaute);
                session.setAttribute("userId", internaute.getId_internaute());
                session.setAttribute("userName", internaute.getPrenom() + " " + internaute.getNom());

                // Redirection après login
                String redirect = (String) session.getAttribute("redirectAfterLogin");
                String productId = request.getParameter("product");

                if (redirect != null) {
                    session.removeAttribute("redirectAfterLogin");
                    response.sendRedirect(request.getContextPath() + redirect);
                } else if (productId != null) {
                    // Rediriger vers les produits et ajouter automatiquement le produit
                    response.sendRedirect(request.getContextPath() + "/produits?addProduct=" + productId);
                } else {
                    response.sendRedirect(request.getContextPath() + "/produits");
                }
            }

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