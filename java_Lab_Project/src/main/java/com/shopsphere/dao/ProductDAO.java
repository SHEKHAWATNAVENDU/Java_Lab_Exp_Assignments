package com.shopsphere.dao;

import com.shopsphere.model.Product;
import com.shopsphere.util.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ProductDAO {

    private static final String SQL_INSERT = 
        "INSERT INTO products (category_id, sku, name, slug, description, price, sale_price, stock_quantity, status) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String SQL_FIND_BY_ID = 
        "SELECT product_id, category_id, sku, name, slug, description, price, sale_price, stock_quantity, status, created_at, updated_at " +
        "FROM products WHERE product_id = ?";

    private static final String SQL_FIND_BY_SKU = 
        "SELECT product_id, category_id, sku, name, slug, description, price, sale_price, stock_quantity, status, created_at, updated_at " +
        "FROM products WHERE sku = ?";

    private static final String SQL_FIND_BY_CATEGORY = 
        "SELECT product_id, category_id, sku, name, slug, description, price, sale_price, stock_quantity, status, created_at, updated_at " +
        "FROM products WHERE category_id = ? AND status = 'active' ORDER BY name ASC";

    private static final String SQL_FIND_ALL_ACTIVE = 
        "SELECT product_id, category_id, sku, name, slug, description, price, sale_price, stock_quantity, status, created_at, updated_at " +
        "FROM products WHERE status = 'active' ORDER BY created_at DESC LIMIT ? OFFSET ?";

    private static final String SQL_UPDATE = 
        "UPDATE products SET category_id = ?, sku = ?, name = ?, slug = ?, description = ?, price = ?, sale_price = ?, stock_quantity = ?, status = ? " +
        "WHERE product_id = ?";

    private static final String SQL_UPDATE_STOCK = 
        "UPDATE products SET stock_quantity = stock_quantity + ? WHERE product_id = ? AND (stock_quantity + ?) >= 0";

    private static final String SQL_DELETE = 
        "DELETE FROM products WHERE product_id = ?";

    public Product create(Product product) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_INSERT, Statement.RETURN_GENERATED_KEYS)) {

            if (product.getCategoryId() != null) {
                ps.setInt(1, product.getCategoryId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, product.getSku());
            ps.setString(3, product.getName());
            ps.setString(4, product.getSlug());
            ps.setString(5, product.getDescription());
            ps.setBigDecimal(6, product.getPrice());

            if (product.getSalePrice() != null) {
                ps.setBigDecimal(7, product.getSalePrice());
            } else {
                ps.setNull(7, Types.DECIMAL);
            }

            ps.setInt(8, product.getStockQuantity() != null ? product.getStockQuantity() : 0);
            ps.setString(9, product.getStatus() != null ? product.getStatus() : "active");

            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating product failed, no rows affected.");
            }

            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    product.setProductId(generatedKeys.getLong(1));
                } else {
                    throw new SQLException("Creating product failed, no ID obtained.");
                }
            }
            return product;
        }
    }

    public Optional<Product> findById(Long productId) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_FIND_BY_ID)) {

            ps.setLong(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToProduct(rs));
                }
            }
        }
        return Optional.empty();
    }

    public Optional<Product> findBySku(String sku) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_FIND_BY_SKU)) {

            ps.setString(1, sku);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Optional.of(mapResultSetToProduct(rs));
                }
            }
        }
        return Optional.empty();
    }

    public List<Product> findByCategory(Integer categoryId) throws SQLException {
        List<Product> products = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_FIND_BY_CATEGORY)) {

            ps.setInt(1, categoryId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(mapResultSetToProduct(rs));
                }
            }
        }
        return products;
    }

    public List<Product> findAllActive(int limit, int offset) throws SQLException {
        List<Product> products = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_FIND_ALL_ACTIVE)) {

            ps.setInt(1, limit);
            ps.setInt(2, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(mapResultSetToProduct(rs));
                }
            }
        }
        return products;
    }

    public List<Product> findFiltered(Integer categoryId, String searchQuery, BigDecimal minPrice, BigDecimal maxPrice, String sortBy, int limit, int offset) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT product_id, category_id, sku, name, slug, description, price, sale_price, stock_quantity, status, created_at, updated_at FROM products WHERE status = 'active'");
        List<Object> params = new ArrayList<>();

        if (categoryId != null && categoryId > 0) {
            sql.append(" AND category_id = ?");
            params.add(categoryId);
        }

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append(" AND (LOWER(name) LIKE ? OR LOWER(description) LIKE ? OR LOWER(sku) LIKE ?)");
            String term = "%" + searchQuery.trim().toLowerCase() + "%";
            params.add(term);
            params.add(term);
            params.add(term);
        }

        if (minPrice != null && minPrice.compareTo(BigDecimal.ZERO) >= 0) {
            sql.append(" AND price >= ?");
            params.add(minPrice);
        }

        if (maxPrice != null && maxPrice.compareTo(BigDecimal.ZERO) >= 0) {
            sql.append(" AND price <= ?");
            params.add(maxPrice);
        }

        if ("price_asc".equalsIgnoreCase(sortBy)) {
            sql.append(" ORDER BY price ASC");
        } else if ("price_desc".equalsIgnoreCase(sortBy)) {
            sql.append(" ORDER BY price DESC");
        } else {
            sql.append(" ORDER BY created_at DESC, product_id DESC");
        }

        sql.append(" LIMIT ? OFFSET ?");
        params.add(limit > 0 ? limit : 20);
        params.add(offset >= 0 ? offset : 0);

        List<Product> products = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof Integer) {
                    ps.setInt(i + 1, (Integer) p);
                } else if (p instanceof BigDecimal) {
                    ps.setBigDecimal(i + 1, (BigDecimal) p);
                } else if (p instanceof String) {
                    ps.setString(i + 1, (String) p);
                } else {
                    ps.setObject(i + 1, p);
                }
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(mapResultSetToProduct(rs));
                }
            }
        }
        return products;
    }

    public boolean update(Product product) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_UPDATE)) {

            if (product.getCategoryId() != null) {
                ps.setInt(1, product.getCategoryId());
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, product.getSku());
            ps.setString(3, product.getName());
            ps.setString(4, product.getSlug());
            ps.setString(5, product.getDescription());
            ps.setBigDecimal(6, product.getPrice());

            if (product.getSalePrice() != null) {
                ps.setBigDecimal(7, product.getSalePrice());
            } else {
                ps.setNull(7, Types.DECIMAL);
            }

            ps.setInt(8, product.getStockQuantity());
            ps.setString(9, product.getStatus());
            ps.setLong(10, product.getProductId());

            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateStock(Long productId, int quantityDelta) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_UPDATE_STOCK)) {

            ps.setInt(1, quantityDelta);
            ps.setLong(2, productId);
            ps.setInt(3, quantityDelta);

            return ps.executeUpdate() > 0;
        }
    }

    public boolean delete(Long productId) throws SQLException {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_DELETE)) {

            ps.setLong(1, productId);
            return ps.executeUpdate() > 0;
        }
    }

    private Product mapResultSetToProduct(ResultSet rs) throws SQLException {
        Timestamp createdTs = rs.getTimestamp("created_at");
        Timestamp updatedTs = rs.getTimestamp("updated_at");
        int categoryIdVal = rs.getInt("category_id");
        Integer categoryId = rs.wasNull() ? null : categoryIdVal;

        return new Product(
            rs.getLong("product_id"),
            categoryId,
            rs.getString("sku"),
            rs.getString("name"),
            rs.getString("slug"),
            rs.getString("description"),
            rs.getBigDecimal("price"),
            rs.getBigDecimal("sale_price"),
            rs.getInt("stock_quantity"),
            rs.getString("status"),
            createdTs != null ? createdTs.toLocalDateTime() : null,
            updatedTs != null ? updatedTs.toLocalDateTime() : null
        );
    }
}

