package ma.fstt.ecom.controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

        // Pages publiques (accessibles sans authentification)
        if (path.startsWith("/login") || path.startsWith("/register") ||
                path.startsWith("/css/") || path.startsWith("/js/") ||
                path.startsWith("/images/") || path.equals("/") ||
                path.equals("/produits") || path.startsWith("/hello-servlet")) {
            chain.doFilter(request, response);
            return;
        }

        // Vérifier la session pour les pages protégées (panier, commande, etc.)
        HttpSession session = httpRequest.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            // Stocker la page demandée pour redirection après login
            session = httpRequest.getSession(true);
            session.setAttribute("redirectAfterLogin", path);

            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        chain.doFilter(request, response);
    }
}