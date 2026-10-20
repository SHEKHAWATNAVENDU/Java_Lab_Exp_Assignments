-- =====================================================================
-- Non-Destructive Database Schema Initialization for ShopSphere
-- Target Engine: MySQL 8.0+ / 8.4 LTS
-- Character Set: utf8mb4 / utf8mb4_unicode_ci
--
-- SAFETY NOTICE:
-- This script is completely NON-DESTRUCTIVE:
-- - It NEVER drops databases or tables.
-- - It uses CREATE TABLE IF NOT EXISTS.
-- - It uses INSERT IGNORE for seed data to avoid duplicating or overwriting.
-- - Existing tables, records, and modifications are preserved intact.
-- =====================================================================

CREATE DATABASE IF NOT EXISTS `shopsphere`
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE `shopsphere`;

-- Temporarily disable foreign key checks during creation to allow clean ordering
SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS;
SET FOREIGN_KEY_CHECKS = 0;

-- =====================================================================
-- 1. Table: users
-- Stores user accounts, authentication credentials, and roles.
-- =====================================================================
CREATE TABLE IF NOT EXISTS `users` (
    `user_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `first_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL,
    `email` VARCHAR(191) NOT NULL,
    `password_hash` VARCHAR(255) NOT NULL COMMENT 'Secure hash using PBKDF2 or BCrypt',
    `phone_number` VARCHAR(20) NULL,
    `role` ENUM('customer', 'admin', 'vendor') NOT NULL DEFAULT 'customer',
    `status` ENUM('active', 'inactive', 'suspended') NOT NULL DEFAULT 'active',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`user_id`),
    UNIQUE KEY `uq_users_email` (`email`),
    KEY `idx_users_role` (`role`),
    KEY `idx_users_status` (`status`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- =====================================================================
-- 2. Table: addresses
-- Stores shipping and billing addresses for users.
-- =====================================================================
CREATE TABLE IF NOT EXISTS `addresses` (
    `address_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `address_type` ENUM('shipping', 'billing', 'both') NOT NULL DEFAULT 'shipping',
    `is_default` BOOLEAN NOT NULL DEFAULT FALSE,
    `recipient_name` VARCHAR(100) NOT NULL,
    `phone_number` VARCHAR(20) NOT NULL,
    `street_address_line1` VARCHAR(255) NOT NULL,
    `street_address_line2` VARCHAR(255) NULL,
    `city` VARCHAR(100) NOT NULL,
    `state` VARCHAR(100) NOT NULL,
    `postal_code` VARCHAR(20) NOT NULL,
    `country` VARCHAR(100) NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`address_id`),
    KEY `idx_addresses_user_id` (`user_id`),
    CONSTRAINT `fk_addresses_user_id`
        FOREIGN KEY (`user_id`)
        REFERENCES `users` (`user_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- =====================================================================
-- 3. Table: categories
-- Product categories supporting hierarchical taxonomies.
-- =====================================================================
CREATE TABLE IF NOT EXISTS `categories` (
    `category_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `parent_id` INT UNSIGNED NULL,
    `name` VARCHAR(100) NOT NULL,
    `slug` VARCHAR(120) NOT NULL,
    `description` TEXT NULL,
    `is_active` BOOLEAN NOT NULL DEFAULT TRUE,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`category_id`),
    UNIQUE KEY `uq_categories_slug` (`slug`),
    KEY `idx_categories_parent_id` (`parent_id`),
    KEY `idx_categories_is_active` (`is_active`),
    CONSTRAINT `fk_categories_parent_id`
        FOREIGN KEY (`parent_id`)
        REFERENCES `categories` (`category_id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- =====================================================================
-- 4. Table: products
-- Catalog products including pricing, inventory, and status.
-- =====================================================================
CREATE TABLE IF NOT EXISTS `products` (
    `product_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `category_id` INT UNSIGNED NULL,
    `sku` VARCHAR(64) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `slug` VARCHAR(255) NOT NULL,
    `description` TEXT NULL,
    `price` DECIMAL(10, 2) NOT NULL,
    `sale_price` DECIMAL(10, 2) NULL,
    `stock_quantity` INT NOT NULL DEFAULT 0,
    `status` ENUM('draft', 'active', 'out_of_stock', 'archived') NOT NULL DEFAULT 'active',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`product_id`),
    UNIQUE KEY `uq_products_sku` (`sku`),
    UNIQUE KEY `uq_products_slug` (`slug`),
    KEY `idx_products_category_id` (`category_id`),
    KEY `idx_products_status` (`status`),
    KEY `idx_products_price` (`price`),
    CONSTRAINT `fk_products_category_id`
        FOREIGN KEY (`category_id`)
        REFERENCES `categories` (`category_id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- =====================================================================
-- 5. Table: cart
-- Stores shopping cart items associated with registered users.
-- =====================================================================
CREATE TABLE IF NOT EXISTS `cart` (
    `cart_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `product_id` BIGINT UNSIGNED NOT NULL,
    `quantity` INT UNSIGNED NOT NULL DEFAULT 1,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`cart_id`),
    UNIQUE KEY `uq_cart_user_product` (`user_id`, `product_id`),
    KEY `idx_cart_product_id` (`product_id`),
    CONSTRAINT `fk_cart_user_id`
        FOREIGN KEY (`user_id`)
        REFERENCES `users` (`user_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT `fk_cart_product_id`
        FOREIGN KEY (`product_id`)
        REFERENCES `products` (`product_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- =====================================================================
-- 6. Table: wishlist
-- Stores saved/bookmarked products for users.
-- =====================================================================
CREATE TABLE IF NOT EXISTS `wishlist` (
    `wishlist_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `product_id` BIGINT UNSIGNED NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`wishlist_id`),
    UNIQUE KEY `uq_wishlist_user_product` (`user_id`, `product_id`),
    KEY `idx_wishlist_product_id` (`product_id`),
    CONSTRAINT `fk_wishlist_user_id`
        FOREIGN KEY (`user_id`)
        REFERENCES `users` (`user_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT `fk_wishlist_product_id`
        FOREIGN KEY (`product_id`)
        REFERENCES `products` (`product_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- =====================================================================
-- 7. Table: coupons
-- Stores discount vouchers and promotional campaign rules.
-- =====================================================================
CREATE TABLE IF NOT EXISTS `coupons` (
    `coupon_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `code` VARCHAR(50) NOT NULL,
    `discount_type` ENUM('percentage', 'fixed_amount') NOT NULL,
    `discount_value` DECIMAL(10, 2) NOT NULL,
    `min_order_amount` DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    `max_discount_amount` DECIMAL(10, 2) NULL COMMENT 'Applies to percentage discounts',
    `usage_limit` INT UNSIGNED NULL COMMENT 'Total allowed redemption count; NULL for unlimited',
    `usage_per_user` INT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Allowed redemptions per customer',
    `start_date` DATETIME NOT NULL,
    `end_date` DATETIME NOT NULL,
    `is_active` BOOLEAN NOT NULL DEFAULT TRUE,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`coupon_id`),
    UNIQUE KEY `uq_coupons_code` (`code`),
    KEY `idx_coupons_active_dates` (`is_active`, `start_date`, `end_date`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- =====================================================================
-- 8. Table: orders
-- Stores purchase orders, financial totals, and lifecycle statuses.
-- =====================================================================
CREATE TABLE IF NOT EXISTS `orders` (
    `order_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `order_number` VARCHAR(64) NOT NULL,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `shipping_address_id` BIGINT UNSIGNED NULL,
    `billing_address_id` BIGINT UNSIGNED NULL,
    `coupon_id` INT UNSIGNED NULL,
    `order_status` ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled', 'refunded') NOT NULL DEFAULT 'pending',
    `subtotal` DECIMAL(10, 2) NOT NULL,
    `discount_amount` DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    `shipping_fee` DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    `tax_amount` DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    `total_amount` DECIMAL(10, 2) NOT NULL,
    `notes` TEXT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`order_id`),
    UNIQUE KEY `uq_orders_order_number` (`order_number`),
    KEY `idx_orders_user_id` (`user_id`),
    KEY `idx_orders_shipping_address` (`shipping_address_id`),
    KEY `idx_orders_billing_address` (`billing_address_id`),
    KEY `idx_orders_coupon_id` (`coupon_id`),
    KEY `idx_orders_status` (`order_status`),
    KEY `idx_orders_created_at` (`created_at`),
    CONSTRAINT `fk_orders_user_id`
        FOREIGN KEY (`user_id`)
        REFERENCES `users` (`user_id`)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT `fk_orders_shipping_address_id`
        FOREIGN KEY (`shipping_address_id`)
        REFERENCES `addresses` (`address_id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    CONSTRAINT `fk_orders_billing_address_id`
        FOREIGN KEY (`billing_address_id`)
        REFERENCES `addresses` (`address_id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    CONSTRAINT `fk_orders_coupon_id`
        FOREIGN KEY (`coupon_id`)
        REFERENCES `coupons` (`coupon_id`)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- =====================================================================
-- 9. Table: order_items
-- Line items associated with each order snapshotting historical pricing.
-- =====================================================================
CREATE TABLE IF NOT EXISTS `order_items` (
    `order_item_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `order_id` BIGINT UNSIGNED NOT NULL,
    `product_id` BIGINT UNSIGNED NOT NULL,
    `quantity` INT UNSIGNED NOT NULL,
    `unit_price` DECIMAL(10, 2) NOT NULL COMMENT 'Unit price at moment of purchase',
    `total_price` DECIMAL(10, 2) NOT NULL COMMENT 'quantity * unit_price',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`order_item_id`),
    KEY `idx_order_items_order_id` (`order_id`),
    KEY `idx_order_items_product_id` (`product_id`),
    CONSTRAINT `fk_order_items_order_id`
        FOREIGN KEY (`order_id`)
        REFERENCES `orders` (`order_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT `fk_order_items_product_id`
        FOREIGN KEY (`product_id`)
        REFERENCES `products` (`product_id`)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- =====================================================================
-- 10. Table: payments
-- Records payment attempts, transactions, and gateways.
-- =====================================================================
CREATE TABLE IF NOT EXISTS `payments` (
    `payment_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `order_id` BIGINT UNSIGNED NOT NULL,
    `payment_method` ENUM('credit_card', 'debit_card', 'paypal', 'stripe', 'cod', 'bank_transfer') NOT NULL,
    `transaction_id` VARCHAR(191) NULL,
    `amount` DECIMAL(10, 2) NOT NULL,
    `payment_status` ENUM('pending', 'completed', 'failed', 'refunded') NOT NULL DEFAULT 'pending',
    `payment_gateway_response` TEXT NULL,
    `paid_at` DATETIME NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`payment_id`),
    UNIQUE KEY `uq_payments_transaction_id` (`transaction_id`),
    KEY `idx_payments_order_id` (`order_id`),
    KEY `idx_payments_status` (`payment_status`),
    CONSTRAINT `fk_payments_order_id`
        FOREIGN KEY (`order_id`)
        REFERENCES `orders` (`order_id`)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- =====================================================================
-- 11. Table: reviews
-- Customer product reviews and 1-5 star ratings.
-- =====================================================================
CREATE TABLE IF NOT EXISTS `reviews` (
    `review_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `product_id` BIGINT UNSIGNED NOT NULL,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `rating` TINYINT UNSIGNED NOT NULL,
    `title` VARCHAR(150) NULL,
    `comment` TEXT NULL,
    `is_verified_purchase` BOOLEAN NOT NULL DEFAULT FALSE,
    `status` ENUM('pending', 'approved', 'rejected') NOT NULL DEFAULT 'approved',
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`review_id`),
    UNIQUE KEY `uq_reviews_user_product` (`user_id`, `product_id`),
    KEY `idx_reviews_product_id` (`product_id`),
    KEY `idx_reviews_rating` (`rating`),
    KEY `idx_reviews_status` (`status`),
    CONSTRAINT `fk_reviews_product_id`
        FOREIGN KEY (`product_id`)
        REFERENCES `products` (`product_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT `fk_reviews_user_id`
        FOREIGN KEY (`user_id`)
        REFERENCES `users` (`user_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT `chk_reviews_rating` CHECK (`rating` BETWEEN 1 AND 5)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- =====================================================================
-- 12. Table: coupon_usage
-- Tracks redemptions of promotional coupons per user and order.
-- =====================================================================
CREATE TABLE IF NOT EXISTS `coupon_usage` (
    `usage_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `coupon_id` INT UNSIGNED NOT NULL,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `order_id` BIGINT UNSIGNED NOT NULL,
    `discount_applied` DECIMAL(10, 2) NOT NULL,
    `used_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`usage_id`),
    UNIQUE KEY `uq_coupon_order` (`coupon_id`, `order_id`),
    KEY `idx_coupon_usage_user` (`user_id`),
    KEY `idx_coupon_usage_coupon` (`coupon_id`),
    CONSTRAINT `fk_coupon_usage_coupon_id`
        FOREIGN KEY (`coupon_id`)
        REFERENCES `coupons` (`coupon_id`)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT `fk_coupon_usage_user_id`
        FOREIGN KEY (`user_id`)
        REFERENCES `users` (`user_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT `fk_coupon_usage_order_id`
        FOREIGN KEY (`order_id`)
        REFERENCES `orders` (`order_id`)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- =====================================================================
-- Seed Initial Sample Data (Non-destructive: INSERT IGNORE)
-- =====================================================================

INSERT IGNORE INTO `categories` (`category_id`, `parent_id`, `name`, `slug`, `description`, `is_active`) VALUES
(1, NULL, 'Mountain Bikes (MTB)', 'mountain-bikes', 'Full-suspension and hardtail mountain bikes built for rugged trails, rock gardens, and steep descents.', TRUE),
(2, NULL, 'Road & Racing Bikes', 'road-racing', 'Ultralight carbon aerodynamic bikes built for road racing, criteriums, and endurance sportives.', TRUE),
(3, NULL, 'Electric Bikes (E-Bikes)', 'electric-bikes', 'High-torque pedal-assist commuter, cargo, and trail e-bikes with long-range lithium batteries.', TRUE),
(4, NULL, 'Gravel & Hybrid Bikes', 'gravel-hybrid', 'Versatile all-terrain adventure bikes engineered for dirt paths, gravel trails, and daily urban commuting.', TRUE),
(5, NULL, 'Cycling Gear & Accessories', 'cycling-gear', 'Pro-level MIPS helmets, clipless pedals, smart LED lights, heavy-duty locks, and cycling hydration packs.', TRUE);

INSERT IGNORE INTO `products` (`product_id`, `category_id`, `sku`, `name`, `slug`, `description`, `price`, `sale_price`, `stock_quantity`, `status`) VALUES
(1, 2, 'BIKE-RD-01', 'Apex Carbon Aero Road Bike', 'apex-carbon-aero-road-bike', 'Elite aerodynamic monocoque carbon frame featuring Shimano Ultegra Di2 12-speed electronic shifting, hydraulic disc brakes, and tubeless-ready 50mm carbon wheelsets.', 2499.99, 2199.99, 15, 'active'),
(2, 1, 'BIKE-MTB-02', 'TrailBlazer Full-Suspension 29er MTB', 'trailblazer-full-suspension-29er-mtb', 'Enduro-ready downhill trail machine featuring 160mm Fox Float Performance suspension, SRAM GX Eagle 1x12 drivetrain, 4-piston hydraulic disc brakes, and Maxxis Minion tires.', 1899.00, 1699.00, 20, 'active'),
(3, 3, 'BIKE-EB-03', 'VoltDrive Commuter E-Bike 750W', 'voltdrive-commuter-ebike-750w', 'Urban electric performance bike with a 750W high-torque Bafang motor, 48V Samsung removable battery (up to 65 miles per charge), puncture-resistant tires, and integrated LED lights.', 1499.50, 1299.50, 18, 'active'),
(4, 4, 'BIKE-GRV-04', 'TerraGravel Explorer All-Road Bike', 'terragravel-explorer-all-road-bike', 'Rugged all-weather gravel grinder with hydroformed lightweight aluminum frame, full carbon fork, 700x45c tubeless tires, Shimano GRX 2x11 gearing, and multiple rack mounts.', 1199.00, NULL, 25, 'active'),
(5, 1, 'BIKE-MTB-05', 'Summit Stealth Hardtail MTB 27.5\"', 'summit-stealth-hardtail-mtb', 'Nimble cross-country hardtail featuring a RockShox Judy 120mm air suspension fork, Shimano Deore 1x11 groupset, internal cable routing, and lightweight alloy rims.', 849.99, 749.99, 30, 'active'),
(6, 2, 'BIKE-RD-06', 'Velox Endurance Disc Road Bike', 'velox-endurance-disc-road-bike', 'Comfort-geometry road bike designed for century rides, featuring Shimano 105 mechanical groupset, vibration-damping carbon seatpost, and 32mm endurance road tires.', 1399.00, 1249.00, 22, 'active'),
(7, 5, 'GEAR-HLM-07', 'AeroVent MIPS Pro Cycling Helmet', 'aerovent-mips-pro-cycling-helmet', 'Dual-certified aerodynamic road and gravel helmet featuring MIPS rotational brain protection system, 21 wind-tunnel ventilation channels, and reflective micro-dial dial fit.', 159.99, 129.99, 45, 'active'),
(8, 5, 'GEAR-LCK-08', 'ProLock U-Shaped Heavy Duty Bike Lock', 'prolock-u-shaped-heavy-duty-bike-lock', 'Sold Secure Diamond rated 16mm hardened max-performance steel shackle with anti-pick double deadbolt lock cylinder and 4ft looped steel security cable.', 69.99, NULL, 60, 'active'),
(9, 5, 'GEAR-LGT-09', 'PhotonBeast 1200LM Smart Bike Light Set', 'photonbeast-1200lm-smart-bike-light-set', 'IPX6 waterproof USB-C rechargeable 1200-lumen front headlight paired with a smart braking auto-sensing red rear safety taillight.', 79.99, 59.99, 50, 'active'),
(10, 5, 'GEAR-PDL-10', 'ProGrip CNC Alloy MTB Flat Pedals', 'progrip-cnc-alloy-mtb-flat-pedals', 'Wide-platform CNC machined 6061 aluminum flat pedals with 12 replaceable traction pins per side, sealed cartridge bearings, and chromoly steel axles.', 54.99, NULL, 75, 'active');

INSERT IGNORE INTO `coupons` (`coupon_id`, `code`, `discount_type`, `discount_value`, `min_order_amount`, `max_discount_amount`, `usage_limit`, `usage_per_user`, `start_date`, `end_date`, `is_active`) VALUES
(1, 'BIKE10', 'percentage', 10.00, 100.00, 200.00, 500, 2, '2025-01-01 00:00:00', '2030-12-31 23:59:59', TRUE),
(2, 'RIDE50', 'fixed_amount', 50.00, 500.00, NULL, 1000, 1, '2025-01-01 00:00:00', '2030-12-31 23:59:59', TRUE),
(3, 'SAVE10', 'percentage', 10.00, 50.00, 25.00, 500, 2, '2025-01-01 00:00:00', '2030-12-31 23:59:59', TRUE),
(4, 'WELCOME20', 'fixed_amount', 20.00, 100.00, NULL, 1000, 1, '2025-01-01 00:00:00', '2030-12-31 23:59:59', TRUE);

-- Password for both accounts is 'Password123!' (hashed with PBKDF2)
INSERT IGNORE INTO `users` (`user_id`, `first_name`, `last_name`, `email`, `password_hash`, `phone_number`, `role`, `status`) VALUES
(1, 'Admin', 'User', 'admin@shopsphere.com', '65536:ghTroRzy33tcNtAfcs/Asg==:FVSp/KMrxrltfihcNPSugUaIhxhkfNtKL+iO0qii0Qc=', '555-0100', 'admin', 'active'),
(2, 'Jane', 'Doe', 'customer@shopsphere.com', '65536:ghTroRzy33tcNtAfcs/Asg==:FVSp/KMrxrltfihcNPSugUaIhxhkfNtKL+iO0qii0Qc=', '555-0101', 'customer', 'active');

INSERT IGNORE INTO `addresses` (`address_id`, `user_id`, `address_type`, `is_default`, `recipient_name`, `phone_number`, `street_address_line1`, `street_address_line2`, `city`, `state`, `postal_code`, `country`) VALUES
(1, 1, 'both', TRUE, 'System Administrator', '+1-555-0100', '100 Tech Blvd, Suite 400', NULL, 'San Jose', 'CA', '95113', 'United States'),
(2, 2, 'both', TRUE, 'Jane Customer', '+1-555-0200', '742 Evergreen Terrace', 'Apt 2B', 'Springfield', 'OR', '97477', 'United States');

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS;
