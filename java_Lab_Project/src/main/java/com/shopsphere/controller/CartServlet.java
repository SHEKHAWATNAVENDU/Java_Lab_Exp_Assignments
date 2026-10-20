package com.shopsphere.controller;

import com.shopsphere.dao.CartDAO;
import com.shopsphere.dao.ProductDAO;
import com.shopsphere.model.CartItem;
import com.shopsphere.model.Product;
import com.shopsphere.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart", "/cart/*"})
public class CartServlet extends HttpServlet {

    private final CartDAO cartDAO;
    private final ProductDAO productDAO;

    public CartServlet() {
        this.cartDAO = new CartDAO();
        this.productDAO = new ProductDAO();
    }

    public CartServlet(CartDAO cartDAO, ProductDAO productDAO) {
        this.cartDAO = cartDAO;
        this.productDAO = productDAO;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(true);
        User user = (User) session.getAttribute("user");

        try {
            List<CartItem> cartItems;
            if (user != null) {
                // Logged-in user: retrieve persistent cart items from database
                cartItems = cartDAO.findByUserId(user.getUserId());
            } else {
                // Guest user: retrieve session cart items
                @SuppressWarnings("unchecked")
                List<CartItem> sessionCart = (List<CartItem>) session.getAttribute("guestCart");
                cartItems = (sessionCart != null) ? sessionCart : new ArrayList<>();
            }

            // Map each cart item's product details for display
            Map<Long, Product> itemProductMap = new HashMap<>();
            int totalItemCount = 0;

            for (CartItem item : cartItems) {
                totalItemCount += (item.getQuantity() != null ? item.getQuantity() : 1);
                Optional<Product> prodOpt = productDAO.findById(item.getProductId());
                prodOpt.ifPresent(p -> itemProductMap.put(item.getProductId(), p));
            }

            // Update cart count badge in session
            session.setAttribute("cartCount", totalItemCount);

            req.setAttribute("cartItems", cartItems);
            req.setAttribute("itemProductMap", itemProductMap);

            // Forward to cart.jsp view
            req.getRequestDispatcher("/cart.jsp").forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException("Database error retrieving cart items", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(true);
        User user = (User) session.getAttribute("user");

        String action = req.getParameter("action");
        if (action == null) {
            action = "add";
        }

        try {
            switch (action) {
                case "add": {
                    String productIdStr = req.getParameter("productId");
                    String quantityStr = req.getParameter("quantity");
                    if (productIdStr != null && !productIdStr.trim().isEmpty()) {
                        long productId = Long.parseLong(productIdStr.trim());
                        int quantity = (quantityStr != null && !quantityStr.trim().isEmpty()) 
                            ? Math.max(1, Integer.parseInt(quantityStr.trim())) : 1;

                        if (user != null) {
                            CartItem item = new CartItem(null, user.getUserId(), productId, quantity, null, null);
                            cartDAO.addOrUpdateItem(item);
                        } else {
                            // Add to guest session cart
                            @SuppressWarnings("unchecked")
                            List<CartItem> sessionCart = (List<CartItem>) session.getAttribute("guestCart");
                            if (sessionCart == null) {
                                sessionCart = new ArrayList<>();
                                session.setAttribute("guestCart", sessionCart);
                            }

                            boolean found = false;
                            for (CartItem ci : sessionCart) {
                                if (ci.getProductId().equals(productId)) {
                                    ci.setQuantity(ci.getQuantity() + quantity);
                                    found = true;
                                    break;
                                }
                            }
                            if (!found) {
                                long tempId = System.currentTimeMillis();
                                sessionCart.add(new CartItem(tempId, 0L, productId, quantity, null, null));
                            }
                        }
                    }
                    break;
                }

                case "update": {
                    String cartIdStr = req.getParameter("cartId");
                    String quantityStr = req.getParameter("quantity");
                    if (cartIdStr != null && quantityStr != null) {
                        long cartId = Long.parseLong(cartIdStr.trim());
                        int quantity = Integer.parseInt(quantityStr.trim());

                        if (user != null) {
                            cartDAO.updateQuantity(cartId, quantity);
                        } else {
                            @SuppressWarnings("unchecked")
                            List<CartItem> sessionCart = (List<CartItem>) session.getAttribute("guestCart");
                            if (sessionCart != null) {
                                if (quantity <= 0) {
                                    sessionCart.removeIf(ci -> ci.getCartId().equals(cartId));
                                } else {
                                    for (CartItem ci : sessionCart) {
                                        if (ci.getCartId().equals(cartId)) {
                                            ci.setQuantity(quantity);
                                            break;
                                        }
                                    }
                                }
                            }
                        }
                    }
                    break;
                }

                case "delete": {
                    String cartIdStr = req.getParameter("cartId");
                    if (cartIdStr != null && !cartIdStr.trim().isEmpty()) {
                        long cartId = Long.parseLong(cartIdStr.trim());
                        if (user != null) {
                            cartDAO.deleteItem(cartId);
                        } else {
                            @SuppressWarnings("unchecked")
                            List<CartItem> sessionCart = (List<CartItem>) session.getAttribute("guestCart");
                            if (sessionCart != null) {
                                sessionCart.removeIf(ci -> ci.getCartId().equals(cartId));
                            }
                        }
                    }
                    break;
                }

                case "clear": {
                    if (user != null) {
                        cartDAO.clearCart(user.getUserId());
                    } else {
                        session.removeAttribute("guestCart");
                    }
                    session.setAttribute("cartCount", 0);
                    break;
                }
            }

            // Redirect back to cart view
            resp.sendRedirect(req.getContextPath() + "/cart");

        } catch (SQLException e) {
            throw new ServletException("Database error executing cart operation", e);
        }
    }
}

