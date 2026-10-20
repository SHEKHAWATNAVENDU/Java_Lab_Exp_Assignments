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

@WebFilter(filterName = "AdminFilter", urlPatterns = "/admin/*")
public class AdminFilter implements Filter {

    private static final String ADMIN_ROLE = "ADMIN";

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        HttpSession session = httpRequest.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        // 1. If not authenticated at all, redirect to login
        if (user == null) {
            String requestUri = httpRequest.getRequestURI();
            String queryString = httpRequest.getQueryString();
            String redirectTarget = (queryString != null) ? (requestUri + "?" + queryString) : requestUri;
            String encodedRedirect = URLEncoder.encode(redirectTarget, StandardCharsets.UTF_8);

            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login?redirect=" + encodedRedirect);
            return;
        }

        // 2. If authenticated, verify the user possesses the 'ADMIN' role
        if (!ADMIN_ROLE.equalsIgnoreCase(user.getRole())) {
            httpResponse.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "Access Denied: You do not possess administrator permissions for this resource."
            );
            return;
        }

        // 3. Authorized admin user: proceed with request
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup if needed
    }
}

