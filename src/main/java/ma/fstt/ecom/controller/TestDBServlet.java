package ma.fstt.ecom.controller;


import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import jakarta.persistence.*;

import java.io.IOException;

@WebServlet("/test-db")
public class TestDBServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        EntityManagerFactory emf = null;
        EntityManager em = null;

        try {
            emf = Persistence.createEntityManagerFactory("mycnx");
            em = emf.createEntityManager();

            // Test simple de connexion
            boolean connected = em.createNativeQuery("SELECT 1").getSingleResult() != null;

            response.getWriter().println("Database connection: " + (connected ? "SUCCESS" : "FAILED"));

        } catch (Exception e) {
            response.getWriter().println("Database connection FAILED: " + e.getMessage());
            e.printStackTrace(response.getWriter());
        } finally {
            if (em != null) em.close();
            if (emf != null) emf.close();
        }
    }
}