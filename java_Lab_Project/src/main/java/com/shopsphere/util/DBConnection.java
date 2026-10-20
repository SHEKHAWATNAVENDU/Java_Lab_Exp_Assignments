package com.shopsphere.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBConnection — reads all database parameters from environment variables.
 *
 * Required environment variables:
 *   DB_URL       – Direct JDBC URL         (optional; overrides DB_HOST/PORT/NAME)
 *   DB_HOST      – MySQL hostname          (default: localhost)
 *   DB_PORT      – MySQL port              (default: 3306)
 *   DB_NAME      – MySQL database name     (default: shopsphere)
 *   DB_USER      – MySQL username          (no default — must be set)
 *   DB_PASSWORD  – MySQL password          (no default — must be set)
 *
 * Use scripts/run-local.ps1 to set these variables securely before
 * starting Tomcat, or configure them in Tomcat's setenv.bat.
 *
 * The password is NEVER logged, printed, or embedded in source code.
 */
public class DBConnection {

    private static final String DRIVER_CLASS = "com.mysql.cj.jdbc.Driver";

    // ── Read individual host/port/name variables ──────────────────────────────
    private static final String DB_HOST =
            System.getenv().getOrDefault("DB_HOST", "localhost");

    private static final String DB_PORT =
            System.getenv().getOrDefault("DB_PORT", "3306");

    private static final String DB_NAME =
            System.getenv().getOrDefault("DB_NAME", "shopsphere");

    // ── Credentials — no silent fallback to a fake password ──────────────────
    private static final String DB_USER     = System.getenv("DB_USER");
    private static final String DB_PASSWORD = System.getenv("DB_PASSWORD");

    // ── Build the JDBC URL from DB_URL if set, else construct from parts ──────
    private static final String DB_URL_ENV  = System.getenv("DB_URL");
    private static final String JDBC_URL    = (DB_URL_ENV != null && !DB_URL_ENV.isBlank())
            ? DB_URL_ENV.trim()
            : String.format(
                "jdbc:mysql://%s:%s/%s?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true",
                DB_HOST, DB_PORT, DB_NAME
            );

    // ── Load the driver (JDBC SPI auto-loads it in modern versions too) ───────
    static {
        try {
            Class.forName(DRIVER_CLASS);
        } catch (ClassNotFoundException e) {
            // Handled gracefully: modern JDBC 4.0+ SPI loads the driver automatically.
            // If the driver JAR is missing entirely, getConnection() will throw a clear error.
        }
    }

    /** Utility class — not instantiable. */
    private DBConnection() {}

    /**
     * Returns the configured JDBC URL (contains host, port, database name, and connection parameters).
     */
    public static String getDbUrl() {
        return JDBC_URL;
    }

    /**
     * Returns the configured database username.
     */
    public static String getDbUser() {
        return DB_USER;
    }

    /**
     * Returns the configured database name.
     */
    public static String getDbName() {
        return DB_NAME;
    }

    /**
     * Returns a new JDBC {@link Connection} using the configured environment variables.
     *
     * @return an open JDBC Connection
     * @throws SQLException             if the connection cannot be established
     * @throws IllegalStateException    if DB_USER or DB_PASSWORD is not set
     */
    public static Connection getConnection() throws SQLException {
        // Validate credentials are present before attempting a connection
        if (DB_USER == null || DB_USER.isBlank()) {
            throw new IllegalStateException(
                "Database configuration error: DB_USER environment variable is not set. " +
                "Run scripts/run-local.ps1 or set DB_USER before starting Tomcat."
            );
        }
        if (DB_PASSWORD == null) {
            throw new IllegalStateException(
                "Database configuration error: DB_PASSWORD environment variable is not set. " +
                "Run scripts/run-local.ps1 or set DB_PASSWORD before starting Tomcat."
            );
        }

        try {
            return DriverManager.getConnection(JDBC_URL, DB_USER, DB_PASSWORD);
        } catch (SQLException e) {
            // Re-throw with a helpful message that does NOT include the password
            throw new SQLException(
                "Failed to connect to database at [" + JDBC_URL + "] as user [" + DB_USER + "]. " +
                "Check that MySQL is running, the database '" + DB_NAME + "' exists, " +
                "and DB_USER / DB_PASSWORD are correct. Original error: " + e.getMessage(),
                e.getSQLState(),
                e.getErrorCode(),
                e
            );
        }
    }
}
