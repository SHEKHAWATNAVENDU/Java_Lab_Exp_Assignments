package com.shopsphere.controller;

import com.shopsphere.model.Product;
import com.shopsphere.service.ProductService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "ProductServlet", urlPatterns = {"/products", "/products/*"})
public class ProductServlet extends HttpServlet {

    private final ProductService productService;

    public ProductServlet() {
        this.productService = new ProductService();
    }

    public ProductServlet(ProductService productService) {
        this.productService = productService;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();

        try {
            // Check if specific product ID requested in path (e.g. /products/42)
            if (pathInfo != null && pathInfo.length() > 1) {
                String idPart = pathInfo.substring(1);
                try {
                    Long productId = Long.parseLong(idPart);
                    Optional<Product> productOpt = productService.getProductById(productId);

                    if (productOpt.isPresent()) {
                        req.setAttribute("product", productOpt.get());
                        if (getServletContext().getResource("/WEB-INF/views/product-detail.jsp") != null) {
                            req.getRequestDispatcher("/WEB-INF/views/product-detail.jsp").forward(req, resp);
                        } else {
                            renderProductDetail(resp, productOpt.get());
                        }
                        return;
                    } else {
                        resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found.");
                        return;
                    }
                } catch (NumberFormatException e) {
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid product ID format.");
                    return;
                }
            }

            // Product catalog listing / category filtering / search / price / sort
            String categoryParam = req.getParameter("category");
            String searchParam = req.getParameter("q");
            String minPriceParam = req.getParameter("minPrice");
            String maxPriceParam = req.getParameter("maxPrice");
            String sortParam = req.getParameter("sort");
            String pageParam = req.getParameter("page");
            int page = (pageParam != null) ? Math.max(1, Integer.parseInt(pageParam)) : 1;

            Integer categoryId = null;
            if (categoryParam != null && !categoryParam.trim().isEmpty()) {
                try {
                    categoryId = Integer.parseInt(categoryParam.trim());
                } catch (NumberFormatException ignored) {}
            }

            java.math.BigDecimal minPrice = null;
            if (minPriceParam != null && !minPriceParam.trim().isEmpty()) {
                try {
                    minPrice = new java.math.BigDecimal(minPriceParam.trim());
                } catch (NumberFormatException ignored) {}
            }

            java.math.BigDecimal maxPrice = null;
            if (maxPriceParam != null && !maxPriceParam.trim().isEmpty()) {
                try {
                    maxPrice = new java.math.BigDecimal(maxPriceParam.trim());
                } catch (NumberFormatException ignored) {}
            }

            List<Product> products = productService.getFilteredProducts(categoryId, searchParam, minPrice, maxPrice, sortParam, page, 20);

            req.setAttribute("products", products);
            req.setAttribute("currentPage", page);

            if (getServletContext().getResource("/products.jsp") != null) {
                req.getRequestDispatcher("/products.jsp").forward(req, resp);
            } else if (getServletContext().getResource("/index.jsp") != null) {
                req.getRequestDispatcher("/index.jsp").forward(req, resp);
            } else if (getServletContext().getResource("/WEB-INF/views/products.jsp") != null) {
                req.getRequestDispatcher("/WEB-INF/views/products.jsp").forward(req, resp);
            } else {
                renderProductCatalog(resp, products, page);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error in ProductServlet", e);
        }
    }

    private void renderProductDetail(HttpServletResponse resp, Product p) throws IOException {
        resp.setContentType("text/html;charset=UTF-8");
        resp.getWriter().println("<!DOCTYPE html><html><head><title>" + p.getName() + " - BikeIsNice</title></head><body>" +
            "<h2>" + p.getName() + "</h2>" +
            "<p>SKU: " + p.getSku() + "</p>" +
            "<p>Price: $" + p.getPrice() + (p.getSalePrice() != null ? " (Sale: $" + p.getSalePrice() + ")" : "") + "</p>" +
            "<p>Description: " + (p.getDescription() != null ? p.getDescription() : "No description") + "</p>" +
            "<p>Stock: " + p.getStockQuantity() + " units available</p>" +
            "<a href='../products'>&larr; Back to Catalog</a>" +
            "</body></html>");
    }

    private void renderProductCatalog(HttpServletResponse resp, List<Product> products, int page) throws IOException {
        resp.setContentType("text/html;charset=UTF-8");
        var out = resp.getWriter();
        out.println("<!DOCTYPE html><html><head><title>BikeIsNice - Products</title></head><body>");
        out.println("<h2>Product Catalog (Page " + page + ")</h2><ul>");
        for (Product p : products) {
            out.println("<li><a href='products/" + p.getProductId() + "'>" + p.getName() + "</a> - $" + p.getPrice() + " (" + p.getStockQuantity() + " in stock)</li>");
        }
        out.println("</ul></body></html>");
    }
}

