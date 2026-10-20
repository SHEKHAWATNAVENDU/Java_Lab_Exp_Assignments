package com.shopsphere;

import com.shopsphere.dao.CouponDAO;
import com.shopsphere.dao.ProductDAO;
import com.shopsphere.dao.UserDAO;
import com.shopsphere.listener.DatabaseInitializerListener;
import com.shopsphere.model.Coupon;
import com.shopsphere.model.Product;
import com.shopsphere.model.User;
import com.shopsphere.util.DBConnection;
import org.junit.jupiter.api.Assumptions;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.*;

public class DatabaseSchemaTest {

    private static boolean dbAvailable = false;

    @BeforeAll
    static void checkDatabaseAvailability() {
        // Only run database tests if credentials and server are reachable
        try (Connection conn = DBConnection.getConnection()) {
            dbAvailable = (conn != null && !conn.isClosed());
        } catch (Exception e) {
            dbAvailable = false;
        }
    }

    @Test
    @DisplayName("DBConnection URL formation and metadata getters")
    void testDbConnectionUrl() {
        String url = DBConnection.getDbUrl();
        assertNotNull(url, "JDBC URL should not be null");
        assertTrue(url.startsWith("jdbc:mysql://"), "JDBC URL should start with jdbc:mysql://");
        assertEquals("shopsphere", DBConnection.getDbName());
    }

    @Test
    @DisplayName("Verify all 12 required tables exist in database")
    void testAllRequiredTablesExist() throws SQLException {
        Assumptions.assumeTrue(dbAvailable, "Database connection not available; skipping schema verification test.");

        try (Connection conn = DBConnection.getConnection()) {
            DatabaseMetaData metaData = conn.getMetaData();
            String catalog = conn.getCatalog();
            Set<String> tables = new HashSet<>();

            try (ResultSet rs = metaData.getTables(catalog, null, "%", new String[]{"TABLE"})) {
                while (rs.next()) {
                    String name = rs.getString("TABLE_NAME");
                    if (name != null) {
                        tables.add(name.toLowerCase());
                    }
                }
            }

            for (String required : DatabaseInitializerListener.REQUIRED_TABLES) {
                assertTrue(tables.contains(required.toLowerCase()),
                    "Database is missing required table: " + required);
            }
        }
    }

    @Test
    @DisplayName("Verify ProductDAO fetches catalog items (fixes original HTTP 500 error)")
    void testProductDaoCatalogAccess() throws SQLException {
        Assumptions.assumeTrue(dbAvailable, "Database connection not available; skipping DAO test.");

        ProductDAO productDAO = new ProductDAO();
        List<Product> products = productDAO.findAllActive(20, 0);

        assertNotNull(products, "Product list should not be null");
        assertFalse(products.isEmpty(), "Product catalog should contain seeded products");

        Product first = products.get(0);
        assertNotNull(first.getProductId(), "Product ID should be present");
        assertNotNull(first.getName(), "Product name should be present");
        assertNotNull(first.getPrice(), "Product price should be present");
    }

    @Test
    @DisplayName("Verify UserDAO retrieves pre-seeded users")
    void testUserDaoSeedAccount() throws SQLException {
        Assumptions.assumeTrue(dbAvailable, "Database connection not available; skipping DAO test.");

        UserDAO userDAO = new UserDAO();
        Optional<User> adminOpt = userDAO.findByEmail("admin@shopsphere.com");

        assertTrue(adminOpt.isPresent(), "Admin user should exist in seeded database");
        User admin = adminOpt.get();
        assertEquals("admin", admin.getRole());
        assertEquals("active", admin.getStatus());
    }

    @Test
    @DisplayName("Verify CouponDAO retrieves pre-seeded coupons")
    void testCouponDaoSeedData() throws SQLException {
        Assumptions.assumeTrue(dbAvailable, "Database connection not available; skipping DAO test.");

        CouponDAO couponDAO = new CouponDAO();
        Optional<Coupon> couponOpt = couponDAO.findByCode("BIKE10");

        assertTrue(couponOpt.isPresent(), "Coupon 'BIKE10' should exist in seeded database");
        Coupon coupon = couponOpt.get();
        assertEquals("percentage", coupon.getDiscountType());
        assertTrue(coupon.getIsActive());
    }
}
