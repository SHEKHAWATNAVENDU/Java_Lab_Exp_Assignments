# ShopSphere — Pro Cycling E-Commerce Application

**ShopSphere** is a full-stack Java e-commerce web application specializing in performance bicycles, commuter e-bikes, and cycling gear. The application is built using **Java 21**, **javax.servlet (Servlet 4.0 / JSP 2.3 / JSTL 1.2)**, **JDBC**, and **MySQL 8**, designed and configured for deployment on **Apache Tomcat 9.0.121**.

This document is your complete, beginner-friendly guide to setting up, configuring, running, and troubleshooting ShopSphere whenever you open your laptop.

---

## Table of Contents
1. [Project Overview & Key Paths](#1-project-overview--key-paths)
2. [Implemented Application Features](#2-implemented-application-features)
3. [Verified Technology Stack](#3-verified-technology-stack)
4. [Prerequisites & Verification](#4-prerequisites--verification)
5. [Actual Project Folder Structure](#5-actual-project-folder-structure)
6. [Database Setup & Safety Guidelines](#6-database-setup--safety-guidelines)
7. [Configuring Permanent Database Environment Variables](#7-configuring-permanent-database-environment-variables)
8. [Daily Startup Procedure](#8-daily-startup-procedure)
   - [Scenario A: Starting the Already-Deployed Application](#scenario-a-starting-the-already-deployed-application)
   - [Scenario B: Building and Deploying Code Changes](#scenario-b-building-and-deploying-code-changes)
9. [How to Open and Use the Website](#9-how-to-open-and-use-the-website)
10. [How to Stop the Project Gracefully](#10-how-to-stop-the-project-gracefully)
11. [Troubleshooting Guide](#11-troubleshooting-guide)
12. [GitHub Repository & Version Control](#12-github-repository--version-control)
13. [Useful Commands Quick Reference](#13-useful-commands-quick-reference)

---

## 1. Project Overview & Key Paths

- **Application Name:** ShopSphere
- **Domain:** Performance Bicycles & Cycling Gear (Road, Mountain, E-Bikes, Gravel, Accessories)
- **Local Project Root:** `F:\java_Lab\java_Lab_Project`
- **Tomcat 9 Root:** `F:\java_Lab\apache-tomcat-9.0.121`
- **Application Context Path:** `/shopsphere`
- **Primary Web URL:** `http://localhost:8080/shopsphere/products`
- **Servlet Namespace:** `javax.servlet.*` (required for Tomcat 9 compatibility)
- **Packaging:** Web Application Archive (`target\shopsphere.war`)

---

## 2. Implemented Application Features

Every feature listed below is verified directly against the project source code, servlets, and JSP views:

### A. Storefront & Catalog
- **Storefront Homepage (`index.jsp`):** Hero showcase banner, 4 feature assurance badges (Specialized Freight, 85% Pre-Assembly with tools, 2-Year Frame Warranty, 30-Day Ride Guarantee), and featured inventory grid.
- **Product Catalog (`products.jsp` / `ProductServlet.java`):**
  - **Category Filtering:** Filter across 5 active categories: Mountain Bikes (MTB), Road & Racing Bikes, Electric Bikes (E-Bikes), Gravel & Hybrid Bikes, and Cycling Gear & Accessories.
  - **Keyword Search:** Case-insensitive search query matching model name, description, and SKU (`?q=...`).
  - **Price Range Filter:** Filter catalog by minimum and maximum price (`minPrice` and `maxPrice`).
  - **Catalog Sorting:** Server-side sorting dropdown supporting `newest`, `price_asc` (Low to High), and `price_desc` (High to Low).
  - **Pagination:** Multi-page catalog navigation displaying 20 items per page with active page tracking (`page=...`).
- **Product Cards Component (`WEB-INF/tags/productCard.tag`):** Displays product name, SKU, calculated savings badge (`-X% OFF`), stock status badge (`In Stock` / `Sold Out`), star rating visualizer (`rating.tag`), and Add to Cart form.
- **Product Details Page (`WEB-INF/views/product-detail.jsp`):**
  - Showcase view with category breadcrumb navigation.
  - Specifications table (Frame Class, Brakes, Drivetrain, Frame Warranty).
  - Price display showing regular price, sale price (when applicable), and calculated discount savings.
  - Quantity picker with server-side stock limit validation (`max="${product.stockQuantity}"`).
  - Direct Add to Cart action submitting to `/cart`.

### B. Shopping Cart & Checkout
- **Shopping Cart (`cart.jsp` / `CartServlet.java`):**
  - Cart item display showing thumbnail, bike model, SKU, unit price, quantity input, and line subtotal.
  - Actions supported: Add (`action=add`), Update quantity (`action=update`), Remove item (`action=delete`), and Clear cart (`action=clear`).
  - Dual cart mode: Session-based cart for guest visitors; persistent database cart (`cart` table) for authenticated users.
  - Order summary sidebar with live subtotal calculation, free shipping indicator ($100 threshold), and checkout progression button.
- **3-Step Checkout Flow (`checkout.jsp` / `CheckoutServlet.java` / `CheckoutService.java`):**
  - **Step 1 — Shipping Address:** Recipient shipping and delivery address fields (Name, Phone, Street, City, State, ZIP).
  - **Step 2 — Voucher Coupon Redemption:** Validates coupon eligibility and applies discounts (`BIKE10` for 10% off, `RIDE50` for $50 off orders over $500).
  - **Step 3 — Payment Method Selector & Transaction Simulation:** Select payment method (Credit Card, PayPal, Cash on Delivery) and add optional order notes.
  - **Payment Processing Note:** Checkout utilizes an internal **payment method selector and simulation** (generates a unique `TXN-...` transaction ID and records payment status as `completed` in the `payments` table). It does **not** connect to an external banking gateway or third-party payment API.
  - **Server-Side Price & Calculation Integrity:** Subtotals, active product prices, coupon validity, shipping fees ($100 free shipping threshold, otherwise $10.00), and 8% sales tax are strictly calculated on the server in `CheckoutService` from authoritative database records. Client-side price tampering is prevented.
  - **Stock Deduction:** Validates available inventory before checkout and atomically decrements product stock (`productDAO.updateStock`) with a non-negative guard check.
  - **Cart Clearance:** Automatically clears the customer's cart in the database upon successful order placement.
- **Order Confirmation Receipt (`WEB-INF/views/order-confirmation.jsp`):**
  - Displays generated order number (e.g. `ORD-<timestamp>-<UUID>`) and simulated transaction reference ID.
  - Itemized financial breakdown (Subtotal, Discount, Shipping, Tax, Total Charged).
  - Order status tracking link and return button to product catalog.

### C. Authentication & Role-Based Access Control
- **Customer & Administrator Login (`WEB-INF/views/login.jsp` / `LoginServlet.java`):**
  - Email and password authentication verified against PBKDF2 cryptographic hashes.
  - Session fixation protection via `req.changeSessionId()` on successful login.
  - Guest cart migration: Items added to the guest session cart are automatically merged into the user's database cart upon logging in.
  - Role-based post-login redirection: Administrators are routed to `/admin/dashboard.jsp`, while regular customers are routed to `/products`.
- **Account Registration (`WEB-INF/views/register.jsp` / `RegisterServlet.java`):**
  - New user registration with email uniqueness validation and password hashing (default role: `customer`).
- **Security Interceptors (`com.shopsphere.filter`):**
  - `AuthenticationFilter`: Intercepts unauthenticated requests to `/checkout`, `/orders`, `/profile`, and `/admin/*`, redirecting to `/login` with the original URL preserved in `redirect`.
  - `AdminFilter`: Validates that the logged-in user possesses the `ADMIN` role before granting access to `/admin/*`, returning HTTP 403 Forbidden for unauthorized users.

### D. Store Operations & Healthcheck
- **Manager Dashboard (`admin/dashboard.jsp`):** High-level metric cards (Total Sales, Active Riders, Total Orders, Inventory Alerts) and low-stock inventory table.
- **Orders Management (`admin/orders.jsp`):** Order timeline tracking with status filter pills (`Delivered`, `Pending`, `Processing`, `Cancelled`).
- **Database Startup Validator (`DatabaseInitializerListener.java`):** Startup `ServletContextListener` declared in `web.xml` that checks database connectivity and validates that all 12 required tables exist before traffic is accepted. If tables are missing, it logs a descriptive error and halts initialization safely.

---

## 3. Verified Technology Stack

| Layer | Component | Version | Verification Source |
|---|---|---|---|
| **Language** | Java (JDK) | 21 LTS | Verified in `pom.xml` (`<maven.compiler.release>21</maven.compiler.release>`) |
| **Servlet Standard** | javax.servlet-api | 4.0.1 | Verified in `pom.xml` (scope: `provided` by Tomcat 9) |
| **Web Container** | Apache Tomcat | 9.0.121 | Verified at `F:\java_Lab\apache-tomcat-9.0.121` |
| **Build Tool** | Apache Maven | 3.10.0 / 3.9+ | Verified from command line (`mvn -version`) |
| **Database** | MySQL Server | 8.0+ / 8.4 LTS | Windows Service `MySQL80`, port `3306` |
| **JDBC Driver** | MySQL Connector/J | 8.4.0 | Runtime driver (`com.mysql.cj.jdbc.Driver`) in `pom.xml` |
| **Connection Pooling** | HikariCP | 5.1.0 | Declared in `pom.xml` (Current connection utility `DBConnection` uses standard JDBC `DriverManager`) |
| **Templating** | JSTL | 1.2 | `javax.servlet:jstl:1.2` in `pom.xml` |
| **Password Hashing** | PBKDF2 (HMAC-SHA256) | 65,536 iterations | `PasswordUtil.java` (jBCrypt 0.4 also present in `pom.xml`) |
| **Testing** | JUnit Jupiter | 5.10.3 | `src/test/java/com/shopsphere/DatabaseSchemaTest.java` |
| **Final Artifact** | WAR File | `shopsphere.war` | `<finalName>${project.artifactId}</finalName>` in `pom.xml` |

---

## 4. Prerequisites & Verification

Before running the application, verify that your local development tools are working in Windows PowerShell:

### 1. Verify Java JDK
```powershell
java -version
javac -version
```
*Requirement:* Must report your installed JDK version (e.g. `21` or `26`). `JAVA_HOME` should point to your JDK root directory (e.g. `C:\Program Files\Java\jdk-26.0.2.1`).

### 2. Verify Apache Maven
```powershell
mvn -version
```
*Requirement:* Must report Apache Maven version (e.g. `Apache Maven 3.10.0`).

### 3. Verify MySQL Windows Service (`MySQL80`)
```powershell
Get-Service -Name MySQL80
```
If the status is `Stopped`, start it from PowerShell:
```powershell
Start-Service -Name MySQL80
```

### 4. Verify Apache Tomcat 9
Confirm the directory exists:
```powershell
Test-Path "F:\java_Lab\apache-tomcat-9.0.121\bin\startup.bat"
```
*Requirement:* Must return `True`.

---

## 5. Actual Project Folder Structure

Every file and directory below has been verified against the physical filesystem:

```
F:\java_Lab\java_Lab_Project/
├── pom.xml                               # Maven build configuration (Java 21, Tomcat 9 dependencies)
├── README.md                             # Comprehensive project documentation
├── schema-init.sql                       # Non-destructive database setup (CREATE TABLE IF NOT EXISTS)
├── shopsphere.sql                        # Destructive reset script (Contains DROP TABLE IF EXISTS)
│
├── src/
│   ├── main/
│   │   ├── java/com/shopsphere/
│   │   │   ├── controller/               # Servlets: Cart, Checkout, Login, Logout, Product, Register
│   │   │   ├── dao/                      # 6 DAOs: CartDAO, CouponDAO, OrderDAO, PaymentDAO, ProductDAO, UserDAO
│   │   │   ├── filter/                   # Security filters: AuthenticationFilter, AdminFilter
│   │   │   ├── listener/                 # Startup listener: DatabaseInitializerListener (verifies 12 tables)
│   │   │   ├── model/                    # 12 Entities: Address, CartItem, Category, Coupon, CouponUsage, Order,
│   │   │   │                             #             OrderItem, Payment, Product, Review, User, WishlistItem
│   │   │   ├── service/                  # Business services: CheckoutService, OrderService, ProductService
│   │   │   ├── util/                     # Utilities: DBConnection (environment-based), PasswordUtil (PBKDF2)
│   │   │   ├── desktop/                  # Supplementary course lab module (AdminDashboard, LoginFrame)
│   │   │   └── network/                  # Supplementary course lab module (RMI, Socket networking)
│   │   │
│   │   └── webapp/                       # Web application root
│   │       ├── WEB-INF/
│   │       │   ├── web.xml               # Servlet mappings, security filters & startup listener
│   │       │   ├── tags/                 # Custom tags: productCard.tag, rating.tag
│   │       │   ├── fragments/            # Layout templates: header.jsp, navbar.jsp, footer.jsp, sidebar.jsp
│   │       │   └── views/                # MVC views: product-detail.jsp, login.jsp, register.jsp, order-confirmation.jsp
│   │       ├── fragments/                # Public layout templates: header.jsp, navbar.jsp, footer.jsp, sidebar.jsp
│   │       ├── css/styles.css            # ShopSphere design system tokens & UI styling
│   │       ├── index.jsp                 # Storefront homepage & hero showcase
│   │       ├── products.jsp              # Product catalog with filter, sort & pagination controls
│   │       ├── cart.jsp                  # Shopping cart review & quantity controls
│   │       ├── checkout.jsp              # 3-step checkout & payment selector
│   │       └── admin/                    # Admin views: dashboard.jsp, orders.jsp, sidebar.jsp
│   │
│   └── test/java/com/shopsphere/
│       └── DatabaseSchemaTest.java       # JUnit 5 schema and seed data validation tests
│
├── scripts/
│   ├── run-local.ps1                     # Interactive launcher script setting env vars and starting Tomcat
│   ├── init-db.ps1                       # Helper script applying schema-init.sql non-destructively
│   └── setenv.bat.template               # Template for Tomcat bin\setenv.bat
│
└── target/
    └── shopsphere.war                    # Maven-generated deployable WAR file
```

---

## 6. Database Setup & Safety Guidelines

### ⚠️ Critical Database Safety Warning

The project root contains two SQL files. Understand the difference before running either script:

| Script Name | SQL Statements Present | Operation Type | When to Use |
|---|---|---|---|
| **`schema-init.sql`** | `CREATE DATABASE IF NOT EXISTS`<br>`CREATE TABLE IF NOT EXISTS`<br>`INSERT IGNORE INTO` | **Safe / Non-Destructive** | **Recommended.** Never drops tables, never truncates, and never deletes user data. Preserves existing tables and records intact. |
| **`shopsphere.sql`** | `DROP TABLE IF EXISTS` (all 12 tables)<br>`CREATE TABLE`<br>`INSERT INTO` | **Destructive Reset** | Contains `DROP TABLE IF EXISTS` for all 12 tables. **Executing this script will permanently erase all products, users, shopping carts, and customer orders!** |

> **IMPORTANT:**
> - Never execute `shopsphere.sql` against an existing database without taking a backup first.
> - If you ever need to back up your database before maintenance, run:
>   ```powershell
>   # Run in PowerShell (replace with your MySQL bin path if mysql is not on PATH):
>   & "mysqldump" -u root -p shopsphere > "F:\java_Lab\shopsphere_backup.sql"
>   ```

---

### How to Initialize the Database

If your `shopsphere` database has no tables, initialize it using one of the methods below:

#### Option 1: MySQL Workbench (Recommended Visual Interface)
1. Open **MySQL Workbench** and connect to your local MySQL server.
2. In a new query tab, create the database schema if it doesn't already exist:
   ```sql
   CREATE DATABASE IF NOT EXISTS `shopsphere`
       CHARACTER SET utf8mb4
       COLLATE utf8mb4_unicode_ci;
   ```
3. Go to **File** &rarr; **Open SQL Script...** (or press `Ctrl + Shift + O`).
4. Select `F:\java_Lab\java_Lab_Project\schema-init.sql`.
5. Click the yellow **Execute** lightning bolt icon (⚡).
6. In the left **Navigator** pane under **Schemas**, right-click and select **Refresh All**.
7. Confirm that all **12 verified tables** appear:
   - `users`
   - `addresses`
   - `categories`
   - `products`
   - `cart`
   - `wishlist`
   - `coupons`
   - `orders`
   - `order_items`
   - `payments`
   - `reviews`
   - `coupon_usage`

#### Option 2: Using the Included Non-Destructive PowerShell Helper
Run the provided helper script from PowerShell:
```powershell
powershell -ExecutionPolicy Bypass -File "F:\java_Lab\java_Lab_Project\scripts\init-db.ps1"
```
The script locates your MySQL client, prompts for credentials via a non-echoing password prompt, applies `schema-init.sql` non-destructively, and verifies all 12 tables.

#### Option 3: MySQL Command Line in Windows PowerShell
> **Windows PowerShell Syntax Note:** Do not use the `<` redirection operator in Windows PowerShell (PowerShell reserves `<` for future use). Instead, pipe file contents using `Get-Content` or use MySQL's `-e "source ..."` flag:

```powershell
# Method A: Pipe file contents into mysql (works in PowerShell):
Get-Content "F:\java_Lab\java_Lab_Project\schema-init.sql" | & mysql -u root -p shopsphere

# Method B: Use MySQL execute source flag (use forward slashes for the path):
& mysql -u root -p --default-character-set=utf8mb4 -e "source F:/java_Lab/java_Lab_Project/schema-init.sql"
```
Enter your MySQL password when prompted.

---

### Seed Demo Accounts & Vouchers

The seed data in `schema-init.sql` (and `shopsphere.sql`) inserts test accounts with verified PBKDF2 password hashes (tested in `DatabaseSchemaTest.java` and `PasswordUtil`):

| Account | Email | Password | Role / Access |
|---|---|---|---|
| **Administrator** | `admin@shopsphere.com` | `Password123!` | Access to `/admin/dashboard.jsp` & `/admin/orders.jsp` |
| **Customer** | `customer@shopsphere.com` | `Password123!` | Customer account with pre-seeded address in Springfield, OR |

| Voucher Code | Discount Type | Discount Value | Minimum Order | Cap / Limit |
|---|---|---|---|---|
| `BIKE10` | Percentage | 10% Off | $100.00 | Up to $200.00 max discount |
| `RIDE50` | Fixed Amount | $50.00 Off | $500.00 | No cap |
| `SAVE10` | Percentage | 10% Off | $50.00 | Up to $25.00 max discount |
| `WELCOME20` | Fixed Amount | $20.00 Off | $100.00 | No cap |

---

## 7. Configuring Permanent Database Environment Variables

ShopSphere's `DBConnection` utility reads database connection parameters directly from environment variables:

| Variable Name | Required Value | Notes |
|---|---|---|
| `DB_URL` | `jdbc:mysql://localhost:3306/shopsphere` | Optional direct JDBC URL (overrides DB_HOST/PORT/NAME) |
| `DB_USER` | Your MySQL username | e.g. `root` (no default, must be set) |
| `DB_PASSWORD` | Your MySQL password | Your actual local MySQL password (no default, must be set) |

> **Security Rule:** Passwords are never hardcoded in source files, checked into Git, or printed to the console.

---

### Permanent vs. Temporary Environment Variables

- **Temporary PowerShell Variables (`$env:... = "..."`):** Live only within that specific open terminal tab and disappear when the window is closed.
- **Permanent Windows User Variables:** Stored in the Windows Registry. Every *newly opened* PowerShell window, Command Prompt, or background Tomcat process automatically inherits them.

To ensure ShopSphere runs whenever you open your laptop, set **Permanent Windows User Variables**.

#### How to Set Permanent User Variables via Windows GUI:

1. Press `Win + R`, type `sysdm.cpl`, and press **Enter** (opens System Properties).
2. Go to the **Advanced** tab and click **Environment Variables...**.
3. Under the top section (**User variables for <YourUsername>**), click **New...** for each variable:

   - **Variable name:** `DB_URL`  
     **Variable value:** `jdbc:mysql://localhost:3306/shopsphere`

   - **Variable name:** `DB_USER`  
     **Variable value:** `root` *(or your actual MySQL username)*

   - **Variable name:** `DB_PASSWORD`  
     **Variable value:** *(Enter your actual local MySQL password)*

4. Click **OK** on all dialog windows to save.
5. Close and reopen any open PowerShell windows so they inherit the newly saved variables.

#### Alternative: Set Permanent Variables via PowerShell (Run Once):
```powershell
[System.Environment]::SetEnvironmentVariable("DB_URL", "jdbc:mysql://localhost:3306/shopsphere", "User")
[System.Environment]::SetEnvironmentVariable("DB_USER", "root", "User")
# Replace YOUR_ACTUAL_PASSWORD with your real MySQL password:
[System.Environment]::SetEnvironmentVariable("DB_PASSWORD", "YOUR_ACTUAL_PASSWORD", "User")
```

---

### How to Verify Environment Variables (Without Exposing Passwords)

Open a **new PowerShell window** and run this verification snippet:

```powershell
Write-Output "DB_URL:      $env:DB_URL"
Write-Output "DB_USER:     $env:DB_USER"

if ($env:DB_PASSWORD) {
    Write-Output "DB_PASSWORD: [Configured - $($env:DB_PASSWORD.Length) characters]"
} else {
    Write-Output "DB_PASSWORD: [MISSING - Not set in this session]"
}
```

If `DB_URL` and `DB_USER` are printed and `DB_PASSWORD: [Configured ...]` appears, your environment is ready.

---

### Server-Scoped Alternative: Tomcat `setenv.bat`

If you prefer keeping credentials scoped only to Apache Tomcat without setting user-wide environment variables:
1. Copy the provided template file:
   ```powershell
   Copy-Item "F:\java_Lab\java_Lab_Project\scripts\setenv.bat.template" "F:\java_Lab\apache-tomcat-9.0.121\bin\setenv.bat"
   ```
2. Open `F:\java_Lab\apache-tomcat-9.0.121\bin\setenv.bat` in a text editor and enter your actual MySQL password.
3. Tomcat's `catalina.bat` will execute `setenv.bat` automatically whenever Tomcat starts.

---

## 8. Daily Startup Procedure

Follow these simple steps whenever you open your laptop:

### Scenario A: Starting the Already-Deployed Application

Use this procedure when you have already built the application and just want to start the website.

#### Step 1: Ensure MySQL Service is Running
1. Press `Win + R`, type `services.msc`, and press **Enter**.
2. Find **MySQL80** in the list.
3. If it is not running, right-click and select **Start**.  
*(Or run `Start-Service -Name MySQL80` in PowerShell).*

#### Step 2: Start Apache Tomcat
Open Windows PowerShell:
```powershell
cd F:\java_Lab\apache-tomcat-9.0.121\bin
.\startup.bat
```
A new console window titled **Tomcat** will appear. Wait 3–6 seconds until the console displays:
```
Server startup in [XXXX] milliseconds
```
*Note:* Because Tomcat opens in a new process, it inherits the permanent `DB_URL`, `DB_USER`, and `DB_PASSWORD` variables configured in Windows.

#### Step 3: Open the Website
Open your browser and navigate to:
**[http://localhost:8080/shopsphere/products](http://localhost:8080/shopsphere/products)**

---

### Scenario B: Building and Deploying Code Changes

Use this procedure whenever you have modified Java code, JSP pages, or CSS styling and need a fresh build.

#### Step 1: Ensure MySQL is Running
```powershell
Start-Service -Name MySQL80
```

#### Step 2: Build the Application with Maven
Open PowerShell in the project directory:
```powershell
cd F:\java_Lab\java_Lab_Project
mvn clean package
```
Ensure the build completes with:
```
[INFO] BUILD SUCCESS
```
The packaged archive is created at: `F:\java_Lab\java_Lab_Project\target\shopsphere.war`.

#### Step 3: Stop Tomcat Gracefully Before Deploying
> **Windows File Lock Safeguard:** Always stop Tomcat before copying a new WAR file over an active deployment. On Windows, the JVM locks JARs and compiled classes inside `webapps/shopsphere/WEB-INF/lib/`. Overwriting while running can cause file permission errors or corrupt the running deployment.

```powershell
cd F:\java_Lab\apache-tomcat-9.0.121\bin
.\shutdown.bat
```

#### Step 4: Copy the WAR File to Tomcat
```powershell
Copy-Item "F:\java_Lab\java_Lab_Project\target\shopsphere.war" "F:\java_Lab\apache-tomcat-9.0.121\webapps\shopsphere.war" -Force
```

#### Step 5: Start Tomcat
```powershell
cd F:\java_Lab\apache-tomcat-9.0.121\bin
.\startup.bat
```

#### Step 6: Open the Website
Navigate to: **[http://localhost:8080/shopsphere/products](http://localhost:8080/shopsphere/products)**

---

## 9. How to Open and Use the Website

Once Tomcat reports server startup, open your web browser (Chrome, Edge, Firefox) and visit:

**[http://localhost:8080/shopsphere/products](http://localhost:8080/shopsphere/products)**

> **What does `localhost` mean?**  
> `localhost` refers to your local machine. The Tomcat web server is running directly on port `8080`. No internet connection is needed to browse the catalog, register users, or simulate checkouts.

### Direct Navigation Links

| Page | URL | Functionality |
|---|---|---|
| **Product Catalog** | `http://localhost:8080/shopsphere/products` | Browse cycling catalog, filter by category/price, search, sort |
| **Product Detail** | `http://localhost:8080/shopsphere/products/1` | Product specs, gallery, quantity picker, add to cart |
| **Shopping Cart** | `http://localhost:8080/shopsphere/cart` | Cart review, update quantities, remove items, clear cart |
| **Checkout Flow** | `http://localhost:8080/shopsphere/checkout` | Shipping form, coupon entry (`BIKE10`), payment method selection (requires login) |
| **Customer Sign In** | `http://localhost:8080/shopsphere/login` | Account login (customer or admin) |
| **Create Account** | `http://localhost:8080/shopsphere/register` | New rider account registration |
| **Admin Dashboard** | `http://localhost:8080/shopsphere/admin/dashboard.jsp` | Store KPI metrics & inventory alerts (requires admin login) |
| **Admin Orders** | `http://localhost:8080/shopsphere/admin/orders.jsp` | Customer order timeline & status tracking (requires admin login) |

---

## 10. How to Stop the Project Gracefully

When you are done developing or want to shut down the server:

### Normal Graceful Shutdown
In Windows PowerShell:
```powershell
cd F:\java_Lab\apache-tomcat-9.0.121\bin
.\shutdown.bat
```
The separate Tomcat console window will close cleanly.

### What to Do if Tomcat Does Not Stop
If the window does not close or port 8080 remains bound:
1. Identify the exact process ID (PID) listening on port 8080:
   ```powershell
   $procId = (Get-NetTCPConnection -LocalPort 8080 -State Listen -ErrorAction SilentlyContinue).OwningProcess
   Write-Output "Process using port 8080: $procId"
   ```
2. Terminate **only that specific process**:
   ```powershell
   if ($procId) {
       Stop-Process -Id $procId -Force
       Write-Output "Terminated process $procId"
   }
   ```
> **Warning:** Do not use `Stop-Process -Name java -Force` as a routine shutdown command. Doing so indiscriminately kills all Java processes running on your computer, including your IDE, Maven builds, and other developer tools.

---

## 11. Troubleshooting Guide

### 1. `mvn is not recognized as an internal or external command`
- **Cause:** Maven's `bin\` folder is not included in your Windows system `PATH`.
- **Solution:** Add Maven to your current session or permanent `PATH`:
  ```powershell
  $env:Path += ";C:\Program Files\Apache\Maven\apache-maven-3.10.0\bin"
  ```
  To make it permanent, add `C:\Program Files\Apache\Maven\apache-maven-3.10.0\bin` to your System `PATH` in `sysdm.cpl`.

### 2. Maven Build Failure (`BUILD FAILURE`)
- **Cause:** Compilation error, incompatible JDK version, or file permission locks on `target\`.
- **Solution:**
  - Verify your compiler: `javac -version` (must report JDK 21+).
  - Check that Tomcat or another program is not locking files in `target\`.
  - Run `mvn clean package -e` to view the full stack trace.

### 3. MySQL Service Stopped (`CommunicationsLinkException`)
- **Cause:** The MySQL Windows service is inactive, or MySQL is not listening on port 3306.
- **Solution:**
  - Start the service: `Start-Service -Name MySQL80`.
  - Test port connectivity: `Test-NetConnection -ComputerName localhost -Port 3306`.

### 4. `DB_URL`, `DB_USER`, or `DB_PASSWORD` is Missing
- **Cause:** Tomcat was started from a terminal session or environment that did not inherit the environment variables.
- **Solution:**
  - Run the verification check from [Section 7](#how-to-verify-environment-variables-without-exposing-passwords).
  - Set the permanent User variables in `sysdm.cpl` and restart your terminal before starting Tomcat.
  - Alternatively, use the `setenv.bat` method described in Section 7.

### 5. `Access denied for user 'root'@'localhost'`
- **Cause:** The password stored in `DB_PASSWORD` does not match your real MySQL database password.
- **Solution:** Test logging into MySQL from PowerShell to confirm your password:
  ```powershell
  mysql -u root -p
  ```
  Once confirmed, update your `DB_PASSWORD` environment variable accordingly and restart Tomcat.

### 6. `Table 'shopsphere.products' doesn't exist`
- **Cause:** The database was created, but schema tables were not imported.
- **Solution:** Run `schema-init.sql` non-destructively using MySQL Workbench or PowerShell (see [Section 6](#how-to-initialize-the-database)).

### 7. HTTP Status 404 — Not Found
- **Cause:** `shopsphere.war` has not been deployed, or you accessed `http://localhost:8080/` without the `/shopsphere/` context path.
- **Solution:**
  - Verify that `F:\java_Lab\apache-tomcat-9.0.121\webapps\shopsphere.war` exists.
  - Always use the full URL: `http://localhost:8080/shopsphere/products`.

### 8. HTTP Status 500 — Internal Server Error
- **Cause:** An uncaught exception occurred on the server (typically database connectivity or SQL query failure).
- **Solution:** Check Tomcat's actual log files for the stack trace:
  - `F:\java_Lab\apache-tomcat-9.0.121\logs\catalina.<YYYY-MM-DD>.log`
  - `F:\java_Lab\apache-tomcat-9.0.121\logs\localhost.<YYYY-MM-DD>.log`

### 9. Port 8080 Conflicts
- **Cause:** Another program or a previous instance of Tomcat is already using port 8080.
- **Solution:**
  - Find and terminate the occupying process using the safe shutdown procedure in [Section 10](#what-to-do-if-tomcat-does-not-stop).
  - Alternatively, edit `F:\java_Lab\apache-tomcat-9.0.121\conf\server.xml` and change port `8080` to `8088`.

### 10. Old UI Appears After Deploying Updated Code
- **Cause:** Browser stylesheet caching or Tomcat caching compiled JSP servlet classes.
- **Solution:**
  - Hard-refresh your browser: press `Ctrl + F5`.
  - If JSP caching persists:
    1. Stop Tomcat: `cd F:\java_Lab\apache-tomcat-9.0.121\bin; .\shutdown.bat`
    2. Clear Tomcat's compiled work folder:
       ```powershell
       Remove-Item "F:\java_Lab\apache-tomcat-9.0.121\work\Catalina\localhost\shopsphere" -Recurse -Force -ErrorAction SilentlyContinue
       ```
    3. Start Tomcat again: `.\startup.bat`

---

## 12. GitHub Repository & Version Control

- **Official Repository URL:** [https://github.com/RahulSN7/java_lab](https://github.com/RahulSN7/java_lab)
- **Active Branch:** `main`

### Saving Changes with Git

When you make changes to your project and want to save them in Git:

1. Check what files have been modified:
   ```powershell
   git status
   ```
2. Stage your project source code changes:
   ```powershell
   git add src/ pom.xml README.md
   ```
   *(Note: `target/` and local credentials are protected and ignored by `.gitignore`).*
3. Commit your changes:
   ```powershell
   git commit -m "Describe your changes here"
   ```
4. Push to your GitHub repository:
   ```powershell
   git push origin main
   ```

---

## 13. Useful Commands Quick Reference

| Action | PowerShell Command |
|---|---|
| **Navigate to Project** | `cd F:\java_Lab\java_Lab_Project` |
| **Check MySQL Service** | `Get-Service -Name MySQL80` |
| **Start MySQL Service** | `Start-Service -Name MySQL80` |
| **Verify Environment** | `Write-Output "URL: $env:DB_URL | User: $env:DB_USER | PW Set: $([bool]$env:DB_PASSWORD)"` |
| **Build WAR** | `mvn clean package` |
| **Deploy WAR (Tomcat Stopped)** | `Copy-Item ".\target\shopsphere.war" "F:\java_Lab\apache-tomcat-9.0.121\webapps\" -Force` |
| **Start Tomcat** | `cd F:\java_Lab\apache-tomcat-9.0.121\bin; .\startup.bat` |
| **Stop Tomcat** | `cd F:\java_Lab\apache-tomcat-9.0.121\bin; .\shutdown.bat` |
| **Open Storefront** | `Start-Process "http://localhost:8080/shopsphere/products"` |
| **View Today's Log** | `Get-Content "F:\java_Lab\apache-tomcat-9.0.121\logs\catalina.$(Get-Date -Format 'yyyy-MM-dd').log" -Tail 50` |

---

*ShopSphere — Precision Engineered for Performance & Reliability.*
