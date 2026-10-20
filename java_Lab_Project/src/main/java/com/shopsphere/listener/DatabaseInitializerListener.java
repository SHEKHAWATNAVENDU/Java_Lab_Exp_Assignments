package com.shopsphere.listener;

import com.shopsphere.util.DBConnection;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Validates the database connection and schema integrity during application startup.
 *
 * Rules:
 * - Does NOT automatically drop or recreate tables on startup.
 * - Preserves existing data.
 * - Fails initialization with a clear, actionable error message if required tables are missing.
 * - Does not log passwords or secrets.
 */
@WebListener
public class DatabaseInitializerListener implements ServletContextListener {

    private static final Logger LOGGER = Logger.getLogger(DatabaseInitializerListener.class.getName());

    public static final List<String> REQUIRED_TABLES = Arrays.asList(
        "users",
        "addresses",
        "categories",
        "products",
        "cart",
        "wishlist",
        "coupons",
        "orders",
        "order_items",
        "payments",
        "reviews",
        "coupon_usage"
    );

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        LOGGER.info("ShopSphere: Validating database connection and schema integrity...");

        try (Connection conn = DBConnection.getConnection()) {
            DatabaseMetaData metaData = conn.getMetaData();
            String catalog = conn.getCatalog();
            Set<String> existingTables = new HashSet<>();

            try (ResultSet rs = metaData.getTables(catalog, null, "%", new String[]{"TABLE"})) {
                while (rs.next()) {
                    String tableName = rs.getString("TABLE_NAME");
                    if (tableName != null) {
                        existingTables.add(tableName.toLowerCase());
                    }
                }
            }

            List<String> missingTables = new ArrayList<>();
            for (String requiredTable : REQUIRED_TABLES) {
                if (!existingTables.contains(requiredTable.toLowerCase())) {
                    missingTables.add(requiredTable);
                }
            }

            if (!missingTables.isEmpty()) {
                String targetDb = (catalog != null && !catalog.isBlank()) ? catalog : DBConnection.getDbName();
                String errorMsg = String.format(
                    "ShopSphere Database Schema Incomplete: Database '%s' is missing required tables: %s. " +
                    "Existing tables in database: %s. " +
                    "To fix this, initialize the database schema non-destructively using 'schema-init.sql' " +
                    "(or 'scripts/init-db.ps1') via MySQL Workbench or the MySQL CLI before starting the application.",
                    targetDb,
                    missingTables,
                    existingTables.isEmpty() ? "[none]" : existingTables
                );
                LOGGER.severe(errorMsg);
                throw new IllegalStateException(errorMsg);
            }

            String targetDb = (catalog != null && !catalog.isBlank()) ? catalog : DBConnection.getDbName();
            LOGGER.info(String.format(
                "ShopSphere: Database schema validated successfully. All %d required tables are present in '%s'.",
                REQUIRED_TABLES.size(),
                targetDb
            ));

        } catch (IllegalStateException e) {
            LOGGER.log(Level.SEVERE, "ShopSphere Database Configuration Error: " + e.getMessage());
            throw e;
        } catch (SQLException e) {
            String errorMsg = "ShopSphere Database Connection Error: " + e.getMessage();
            LOGGER.log(Level.SEVERE, errorMsg);
            throw new IllegalStateException(errorMsg, e);
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        LOGGER.info("ShopSphere: Application context destroyed.");
    }
}
