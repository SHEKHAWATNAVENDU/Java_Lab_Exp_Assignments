package com.shopsphere.filter;

import com.shopsphere.model.User;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebFilter(filterName = "AuthenticationFilter", urlPatterns = {
    "/checkout/*",
    "/checkout",
    "/orders/*",
    "/orders",
    "/profile/*",
    "/profile",
    "/admin/*"
})
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Retrieve existing session without creating a new one
        HttpSession session = httpRequest.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user != null) {
            // User is authenticated, continue chain
            chain.doFilter(request, response);
            return;
        }

        // Handle unauthenticated requests
        String acceptHeader = httpRequest.getHeader("Accept");
        boolean isApiRequest = acceptHeader != null && acceptHeader.contains("application/json");

        if (isApiRequest) {
            httpResponse.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Authentication required.");
        } else {
            String requestUri = httpRequest.getRequestURI();
            String queryString = httpRequest.getQueryString();
            String redirectTarget = (queryString != null) ? (requestUri + "?" + queryString) : requestUri;

            String encodedRedirect = URLEncoder.encode(redirectTarget, StandardCharsets.UTF_8);
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login?redirect=" + encodedRedirect);
        }
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }
}

