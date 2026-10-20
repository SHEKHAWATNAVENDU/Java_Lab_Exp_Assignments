# Advanced Java Programming Laboratory (ADJ Lab)

A comprehensive collection of **Advanced Java Programming** laboratory practicals and projects, arranged chronologically from **Experiment 1 to the final Capstone Project (ShopSphere)**.

---

## 📋 Table of Contents

- [Index of Experiments](#-index-of-experiments)
- [Prerequisites & System Setup](#-prerequisites--system-setup)
- [Servlet Container Compatibility Guide](#-servlet-container-compatibility-guide)
- [Experiment 1: GUI Form Development using Java Swing](#-experiment-1-gui-form-development-using-java-swing)
- [Experiment 2: Model-View-Controller (MVC) Architecture](#-experiment-2-model-view-controller-mvc-architecture)
- [Experiment 3: TCP Socket Programming (Client-Server Communication)](#-experiment-3-tcp-socket-programming-client-server-communication)
- [Experiment 4: Java Database Connectivity (JDBC) CRUD Operations](#-experiment-4-java-database-connectivity-jdbc-crud-operations)
- [Experiment 5: Database-Driven GUI Application (Swing + JDBC Integration)](#-experiment-5-database-driven-gui-application-swing--jdbc-integration)
- [Experiment 6: Remote Method Invocation (Java RMI Distributed Computing)](#-experiment-6-remote-method-invocation-java-rmi-distributed-computing)
- [Experiment 7: Web Server Environment Setup & Application Deployment (Apache Tomcat 9)](#-experiment-7-web-server-environment-setup--application-deployment-apache-tomcat-9)
- [Experiment 8: Java Web Development with Servlets, Filters, and Listeners](#-experiment-8-java-web-development-with-servlets-filters-and-listeners)
- [Experiment 9 / Capstone: ShopSphere E-Commerce Platform (shopsphere)](#-experiment-9--capstone-shopsphere-e-commerce-platform-shopsphere)
- [Troubleshooting Guide](#-troubleshooting-guide)
- [Repository & Author Information](#-repository--author-information)

---

## 📑 Index of Experiments

| Exp No. | Experiment Title | Core Technologies | Directory |
|:---:|---|---|---|
| **01** | **Student Registration GUI Form** | Java Swing, AWT, Event Handling | [`exp1/`](exp1/) |
| **02** | **MVC Pattern Calculator Application** | Java Swing, MVC Architecture | [`calc/`](calc/) |
| **03** | **TCP Socket Client-Server Echo System** | Java Networking (`java.net`), Sockets, I/O Streams | [`server-client/`](server-client/) |
| **04** | **Database Connectivity & SQL Operations (JDBC)** | JDBC 4.2, MySQL Connector/J, PreparedStatements | [`jdbc/exp3/`](jdbc/exp3/) |
| **05** | **Integrated GUI with Database Storage** | Swing GUI, JDBC, MySQL, Input Validation | [`strjdbc/`](strjdbc/) |
| **06** | **Distributed Computing via Java RMI** | Java RMI, Remote Interfaces, RMI Registry | [`Remote-Method-Invocation/`](Remote-Method-Invocation/) |
| **07** | **Servlet Container & Web Server Deployment** | Apache Tomcat 9.0.121, WAR Deployment, Web XML | [`apache-tomcat-9.0.121/`](apache-tomcat-9.0.121/) |
| **08** | **Java Web Development with Servlets, Filters, and Listeners** | Jakarta EE Servlet API 6.1, Session Tracking, Filters | [`servent/`](servent/) |
| **09** | **ShopSphere Pro Cycling E-Commerce Platform (Capstone)** | Java 21, javax.servlet (Servlet 4.0 / JSP 2.3 / JSTL 1.2), JDBC, MySQL 8, Tomcat 9, Swing Desktop Admin, Sockets & RMI | [`java_Lab_Project/`](java_Lab_Project/) |

---

## 🛠️ Prerequisites & System Setup

Ensure the following tools and runtimes are installed on your workstation:

1. **Java Development Kit (JDK 21 LTS or 26):**
   ```powershell
   java -version
   javac -version
   ```
2. **Apache Maven (3.9+ / 3.10.0):**
   ```powershell
   mvn -version
   ```
3. **MySQL Database Server (8.0+ / 8.4 LTS):**
   ```powershell
   # Windows PowerShell: Check Windows Service status
   Get-Service -Name MySQL80

   # Start service if stopped
   Start-Service -Name MySQL80
   ```
4. **Apache Tomcat Server 9.0.121:**
   Bundled directly within the workspace at [`apache-tomcat-9.0.121/`](apache-tomcat-9.0.121/).

---

## 🌐 Servlet Container Compatibility Guide

When developing Java web applications, understanding the transition between the `javax.servlet` and `jakarta.servlet` namespaces is essential:

| Specification | Package Namespace | Compatible Tomcat Versions | Projects in this Repository |
|---|---|---|---|
| **Java EE / Servlet 4.0** | `javax.servlet.*` | **Apache Tomcat 9.0.x** (Bundled: `9.0.121`) | **ShopSphere Capstone** ([`java_Lab_Project/`](java_Lab_Project/)) |
| **Jakarta EE 10+ / Servlet 6.0+** | `jakarta.servlet.*` | **Apache Tomcat 10.1.x / 11.0.x** | **Experiment 8** ([`servent/`](servent/)) |

> **Key Rule for this Laboratory:**  
> - [`apache-tomcat-9.0.121/`](apache-tomcat-9.0.121/) runs on **Servlet 4.0 (`javax.servlet`)**.
> - The **ShopSphere** capstone in [`java_Lab_Project/`](java_Lab_Project/) is configured for **Tomcat 9.0.121** using `javax.servlet-api` 4.0.1 and JSTL 1.2.
> - The standalone exercise in [`servent/`](servent/) demonstrates the modern **Jakarta EE Servlet API 6.1** specification.

---

## 🧪 Experiment 1: GUI Form Development using Java Swing

### 🎯 Aim & Objective
To design and implement an interactive desktop Graphical User Interface (GUI) for a **Student Registration Form** using Java Swing components and event listeners.

### 📂 Directory & File Structure
```
exp1/
├── StudentRegistration.java    # Swing GUI class with ActionListener
└── StudentRegistration.class   # Compiled bytecode
```

### 💡 Key Concepts & Implementation Details
- **Components Used**: `JFrame`, `JLabel`, `JTextField`, `JRadioButton`, `ButtonGroup`, `JCheckBox`, `JButton`.
- **Layout Management**: Absolute positioning with `setLayout(null)` and `setBounds(x, y, width, height)`.
- **Event Handling**: Implements `ActionListener` to capture button clicks on **Submit** and **Reset**.
- **User Validation**: Validates required fields and terms acceptance, rendering user details via `JOptionPane.showMessageDialog()`.

### 🚀 Compilation & Execution

#### Windows PowerShell:
```powershell
cd F:\java_Lab\exp1
javac StudentRegistration.java
java StudentRegistration
```

#### Linux / macOS:
```bash
cd exp1
javac StudentRegistration.java
java StudentRegistration
```

---

## 🧪 Experiment 2: Model-View-Controller (MVC) Architecture

### 🎯 Aim & Objective
To design and implement an interactive desktop Calculator adhering strictly to the **Model-View-Controller (MVC)** architectural design pattern, separating business logic, user interface, and event handling.

### 📂 Directory & File Structure
```
calc/
├── ModelsCalculator.java       # Model: Contains arithmetic calculation logic
├── ViewsCalculator.java        # View: Builds Swing GUI components & layouts
├── ControllerCalculator.java   # Controller: Binds View events to Model methods
├── Runmain.java                # Application Entry Point
└── README.md                   # Module documentation
```

### 💡 Key Concepts & Implementation Details
- **Model (`ModelsCalculator`)**: Encapsulates arithmetic operations (`add`, `sub`, `multiply`, `divide`) and edge-case handling (e.g. division by zero).
- **View (`ViewsCalculator`)**: Constructs the UI with `JTextField` for input/display and operator buttons (`+`, `-`, `*`, `/`).
- **Controller (`ControllerCalculator`)**: Attaches action listeners to the view buttons, parses inputs, triggers Model operations, and updates the view display.
- **Benefits**: Loose coupling, high maintainability, and clean code separation.

### 🚀 Compilation & Execution

#### Windows PowerShell:
```powershell
cd F:\java_Lab\calc
javac *.java
java Runmain
```

#### Linux / macOS:
```bash
cd calc
javac *.java
java Runmain
```

---

## 🧪 Experiment 3: TCP Socket Programming (Client-Server Communication)

### 🎯 Aim & Objective
To implement two-way network communication over a TCP connection using Java Sockets (`java.net` package) with a dedicated Server and Client echo protocol.

### 📂 Directory & File Structure
```
server-client/
├── server.java     # TCP Server listening on port 5000
└── client.java     # TCP Client connecting to localhost:5000
```

### 💡 Key Concepts & Implementation Details
- **TCP Socket Architecture**: Utilizes `ServerSocket` on port `5000` to listen for incoming connections and `Socket` to establish client-server streams.
- **I/O Streams**: Uses `BufferedReader` wrapping `InputStreamReader` for receiving messages and `PrintWriter` with auto-flush for sending text over the stream.
- **Communication Protocol**:
  - The server echoes every message back with an `"Echo: <message>"` prefix.
  - Graceful disconnection protocol when the client transmits `"bye"`.

### 🚀 Compilation & Execution
Open two terminal windows:

#### Windows PowerShell:
```powershell
# In both terminals, navigate to experiment directory:
cd F:\java_Lab\server-client

# Compile both programs (run once):
javac server.java client.java

# Terminal 1: Start Server
java server

# Terminal 2: Start Client
java client
```

#### Linux / macOS:
```bash
cd server-client
javac server.java client.java

# Terminal 1: Start Server
java server

# Terminal 2: Start Client
java client
```

---

## 🧪 Experiment 4: Java Database Connectivity (JDBC) CRUD Operations

### 🎯 Aim & Objective
To establish a connection between a Java program and a MySQL relational database using JDBC (Type-4 Driver), execute parameterized queries, and perform basic CRUD operations.

### 📂 Directory & File Structure
```
jdbc/exp3/
├── lib/
│   └── mysql-connector-j-26.7.0.jar   # MySQL JDBC Driver library
├── src/
│   └── Main.java                      # JDBC connection, insert & query execution
├── bin/                               # Compiled classes
└── README.md                          # Configuration notes
```

### 💡 Key Concepts & Implementation Details
- **Driver Registration**: Loading the MySQL driver class `Class.forName("com.mysql.cj.jdbc.Driver")`.
- **Connection Management**: Connecting via `DriverManager.getConnection(url, user, password)`.
- **Parameterized SQL with `PreparedStatement`**: Safe query execution for inserting student records into the database.
- **Data Retrieval with `Statement` & `ResultSet`**: Executing `SELECT` queries and reading result records via cursor traversal (`rs.next()`).

### 🗄️ Database Setup
Execute in MySQL Workbench or the MySQL Command Line:
```sql
CREATE DATABASE IF NOT EXISTS collage_db;
USE collage_db;

CREATE TABLE IF NOT EXISTS Student (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    branch VARCHAR(50)
);
```

### 🚀 Compilation & Execution

#### Windows PowerShell:
> Note: On Windows, use a semicolon (`;`) as the classpath separator.
```powershell
cd F:\java_Lab\jdbc\exp3

# Compile with JDBC Driver in classpath
javac -cp "lib/*;src" src/Main.java -d bin

# Run program
java -cp "lib/*;bin" Main
```

#### Linux / macOS:
```bash
cd jdbc/exp3

# Compile with JDBC Driver in classpath (colon separator)
javac -cp "lib/*:src" src/Main.java -d bin

# Run program
java -cp "lib/*:bin" Main
```

---

## 🧪 Experiment 5: Database-Driven GUI Application (Swing + JDBC Integration)

### 🎯 Aim & Objective
To develop a database-integrated desktop application by connecting a Java Swing GUI form to a MySQL database, persisting user registration data through JDBC.

### 📂 Directory & File Structure
```
strjdbc/
├── lib/
│   └── mysql-connector-j-26.7.0.jar   # MySQL JDBC Driver
├── src/
│   └── StudentRegistration.java       # Full Swing GUI with JDBC persistence
├── bin/                               # Compiled classes
└── README.md
```

### 💡 Key Concepts & Implementation Details
- **Integrated Architecture**: Merges interactive Swing UI (`JFrame`, `JTextField`, `JRadioButton`, `JCheckBox`) with a JDBC data persistence layer.
- **Robust Input Validation**: Verifies that required fields are non-empty and terms are accepted before executing database calls.
- **Database Persistence**: Employs `PreparedStatement` to insert sanitized student records (`name`, `roll`, `gender`, `branch`) into table `streg`.
- **Thread Safety**: Dispatches UI rendering via `SwingUtilities.invokeLater()`.

### 🗄️ Database Setup
Execute in MySQL Workbench or the MySQL Command Line:
```sql
CREATE DATABASE IF NOT EXISTS collage_db;
USE collage_db;

CREATE TABLE IF NOT EXISTS streg (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    roll VARCHAR(50) NOT NULL,
    gender VARCHAR(10),
    branch VARCHAR(50)
);
```

### 🚀 Compilation & Execution

#### Windows PowerShell:
```powershell
cd F:\java_Lab\strjdbc

# Compile
javac -cp "lib/*;src" src/StudentRegistration.java -d bin

# Run
java -cp "lib/*;bin" StudentRegistration
```

#### Linux / macOS:
```bash
cd strjdbc

# Compile
javac -cp "lib/*:src" src/StudentRegistration.java -d bin

# Run
java -cp "lib/*:bin" StudentRegistration
```

---

## 🧪 Experiment 6: Remote Method Invocation (Java RMI Distributed Computing)

### 🎯 Aim & Objective
To build a distributed client-server application using Java Remote Method Invocation (RMI), allowing a remote client to execute object methods hosted on a remote server.

### 📂 Directory & File Structure
```
Remote-Method-Invocation/
├── Calculator.java         # Remote Interface (extends java.rmi.Remote)
├── CalculatorImpl.java     # Remote Implementation (extends UnicastRemoteObject)
├── Server.java             # RMI Server (binds service to RMI Registry)
└── client.java             # RMI Client (performs lookup and calls remote methods)
```

### 💡 Key Concepts & Implementation Details
- **Remote Interface (`Calculator`)**: Declares remote methods (`add`, `subtract`) throwing `RemoteException`.
- **Remote Implementation (`CalculatorImpl`)**: Extends `UnicastRemoteObject` to export the object for remote communication.
- **RMI Registry & Binding**: `Server` creates the implementation and registers it via `Naming.rebind("rmi://localhost/CalculatorService", calc)`.
- **Client Lookup & Invocation**: `client` resolves the remote stub via `Naming.lookup(...)` and transparently invokes arithmetic operations across JVMs.

### 🚀 Compilation & Execution

#### Windows PowerShell:
Open three terminal windows (or run `rmiregistry` as a background process):
```powershell
cd F:\java_Lab\Remote-Method-Invocation

# Compile all source files
javac *.java

# Terminal 1: Start RMI Registry
Start-Process rmiregistry

# Terminal 2: Start RMI Server
java Server

# Terminal 3: Run RMI Client
java client
```

#### Linux / macOS:
```bash
cd Remote-Method-Invocation
javac *.java

# Start RMI Registry in background
rmiregistry &

# Terminal 1: Start Server
java Server

# Terminal 2: Run Client
java client
```

---

## 🧪 Experiment 7: Web Server Environment Setup & Application Deployment (Apache Tomcat 9)

### 🎯 Aim & Objective
To configure and manage an enterprise Java Servlet Container and Web Server (**Apache Tomcat 9.0.121**), understand the container directory structure, configure deployment descriptors, and deploy web applications.

### 📂 Directory & File Structure
```
apache-tomcat-9.0.121/
├── bin/                    # Server lifecycle scripts (startup.bat/.sh, shutdown.bat/.sh)
├── conf/                   # Configuration files (server.xml, web.xml, context.xml)
├── lib/                    # Servlet API & container libraries (servlet-api.jar, jsp-api.jar)
├── logs/                   # Catalina and access log files (catalina.<YYYY-MM-DD>.log)
├── webapps/                # Deployment folder for web applications
│   ├── myWebapp/           # Static and dynamic test webapp
│   └── shopsphere.war      # Deployed ShopSphere Web Archive
└── work/                   # Compiled JSP servlets and temporary runtime files
```

### 💡 Key Concepts & Implementation Details
- **Servlet Container Lifecycle**: Starting, stopping, and inspecting server logs.
- **Port & Connector Configuration**: Configuring HTTP connectors in `conf/server.xml` (default port `8080`).
- **WAR Deployment**: Automated unpacking and deployment of Web Application Archives in `webapps/`.

### 🚀 Running the Tomcat Server

#### Windows PowerShell:
```powershell
cd F:\java_Lab\apache-tomcat-9.0.121\bin

# Start Tomcat Server (opens separate console window)
.\startup.bat

# Open browser: http://localhost:8080/

# Stop Tomcat Server gracefully
.\shutdown.bat
```

#### Linux / macOS:
```bash
cd apache-tomcat-9.0.121/bin
chmod +x *.sh
./startup.sh
./shutdown.sh
```

---

## 🧪 Experiment 8: Java Web Development with Servlets, Filters, and Listeners

### 🎯 Aim & Objective
To develop a dynamic Java Web Application utilizing the **Jakarta EE Servlet API 6.1**, demonstrating form processing, session tracking (`HttpSession`), request filtering (`@WebFilter`), and application lifecycle events (`@WebListener`).

### 📂 Directory & File Structure
```
servent/
├── pom.xml                 # Maven build file configured for Jakarta Servlet API 6.1
└── src/
    └── main/
        ├── java/com/servelent/
        │   ├── HelloServlet.java   # Form processing & RequestDispatcher forward
        │   ├── LoginServlet.java   # Authentication & session creation
        │   ├── HomeServlet.java    # Protected user home page
        │   ├── AuthFilter.java     # Security filter restricting /home
        │   ├── AppListener.java    # ServletContextListener lifecycle logger
        │   └── Main.java           # Runner / helper
        └── webapp/
            └── index.html          # Login and entry HTML form
```

### 💡 Key Concepts & Implementation Details
- **`HelloServlet` (`@WebServlet("/hello")`)**: Extracts form parameters (`request.getParameter()`), sets request attributes (`request.setAttribute()`), and dispatches to views.
- **`LoginServlet` (`@WebServlet("/login")`)**: Authenticates credentials, creates a user session via `request.getSession()`, and sets session attributes.
- **`HomeServlet` (`@WebServlet("/home")`)**: Displays personalized content for authenticated users with active sessions.
- **`AuthFilter` (`@WebFilter("/home")`)**: Intercepts requests to `/home`, checks for valid user sessions, and redirects unauthorized users back to `index.html`.
- **`AppListener` (`@WebListener`)**: Implements `ServletContextListener` to log messages upon application startup (`contextInitialized`) and shutdown (`contextDestroyed`).

### 🚀 Building with Maven
```powershell
cd F:\java_Lab\servent

# Build WAR archive using Maven
mvn clean package
```
*Note: Because `servent` targets Jakarta EE Servlet 6.1 (`jakarta.servlet.*`), deployment requires a Jakarta-compatible container such as Apache Tomcat 10.1+ or Tomcat 11.*

---

## 🚴 Experiment 9 / Capstone: ShopSphere E-Commerce Platform (java_Lab_Project)

### 🎯 Aim & Objective

To architect and implement a full-stack Java web application and distributed system, **ShopSphere**, synthesizing advanced Java concepts:
- **Web Layer:** Java Servlets using `javax.servlet` (Servlet 4.0 / JSP 2.3), JSTL 1.2, and custom JSP tags (`productCard.tag`, `rating.tag`).
- **Persistence Layer:** Relational MySQL 8 database with JDBC DAO pattern (`CartDAO`, `CouponDAO`, `OrderDAO`, `PaymentDAO`, `ProductDAO`, `UserDAO`).
- **Security & Lifecycle:** Cryptographic PBKDF2 password hashing, session fixation mitigation (`req.changeSessionId()`), request interceptor filters (`AuthenticationFilter`, `AdminFilter`), and startup schema validation (`DatabaseInitializerListener`).
- **Desktop Administration:** Swing administrative desktop GUI (`LoginFrame`, `AdminDashboard` using `JTabbedPane`, `JTable`, `JScrollPane`).
- **Distributed Networking:** Standalone TCP Socket and Java RMI inventory management modules demonstrating inter-process communication.

---

### 📂 Directory & File Structure

```
java_Lab_Project/
├── pom.xml                               # Maven build configuration (Java 21, Tomcat 9 dependencies)
├── README.md                             # Dedicated ShopSphere project documentation
├── schema-init.sql                       # Non-destructive database setup (CREATE TABLE IF NOT EXISTS)
├── shopsphere.sql                        # Destructive reset script (Contains DROP TABLE IF EXISTS)
├── test-networking.sh                    # Standalone shell script for networking demonstration
│
├── src/main/
│   ├── java/com/shopsphere/
│   │   ├── controller/                   # Servlets: Cart, Checkout, Login, Logout, Product, Register
│   │   ├── dao/                          # 6 DAOs: CartDAO, CouponDAO, OrderDAO, PaymentDAO, ProductDAO, UserDAO
│   │   ├── filter/                       # Security filters: AuthenticationFilter, AdminFilter
│   │   ├── listener/                     # Startup listener: DatabaseInitializerListener (validates 12 tables)
│   │   ├── model/                        # 12 Entities: Address, CartItem, Category, Coupon, CouponUsage,
│   │   │                                 #             Order, OrderItem, Payment, Product, Review, User, WishlistItem
│   │   ├── service/                      # Business services: CheckoutService, OrderService, ProductService
│   │   ├── util/                         # DBConnection (environment-based), PasswordUtil (PBKDF2)
│   │   ├── desktop/                      # Swing desktop GUI: LoginFrame, AdminDashboard
│   │   └── network/                      # Distributed networking:
│   │       ├── socket/                   # TCP Socket Inventory Server & Client
│   │       └── rmi/                      # Java RMI Inventory Service, Server & Client
│   │
│   └── webapp/                           # Web application root
│       ├── WEB-INF/
│       │   ├── web.xml                   # Servlet mappings, filters, and startup listener
│       │   ├── tags/                     # Custom tags: productCard.tag, rating.tag
│       │   ├── fragments/                # Layout fragments: header, navbar, footer, sidebar
│       │   └── views/                    # Views: product-detail.jsp, login.jsp, register.jsp, order-confirmation.jsp
│       ├── fragments/                    # Public layout fragments: header, navbar, footer, sidebar
│       ├── css/styles.css                # ShopSphere UI stylesheet and design tokens
│       ├── index.jsp                     # Storefront homepage & hero showcase
│       ├── products.jsp                  # Product catalog with search, category/price filter, sorting, pagination
│       ├── cart.jsp                      # Shopping cart view with quantity adjustments and line totals
│       ├── checkout.jsp                  # 3-step checkout flow (shipping, coupon redemption, payment selection)
│       └── admin/                        # Admin JSP views: dashboard.jsp, orders.jsp, sidebar.jsp
│
├── src/test/java/com/shopsphere/
│   └── DatabaseSchemaTest.java           # JUnit 5 schema and seed data validation tests
│
├── scripts/
│   ├── run-local.ps1                     # Interactive launcher setting env vars and starting Tomcat
│   ├── init-db.ps1                       # Helper applying schema-init.sql non-destructively
│   └── setenv.bat.template               # Template for Tomcat bin\setenv.bat
│
└── target/
    └── shopsphere.war                    # Maven-generated deployable WAR file
```

---

### 💡 Verified Application Features

#### 1. Storefront & Product Catalog
- **Storefront (`index.jsp`):** Executive hero showcase, assurance badges, and featured cycling inventory.
- **Product Catalog (`products.jsp` / `ProductServlet.java`):**
  - **Category Filtering:** 5 categories: Mountain Bikes (MTB), Road & Racing Bikes, Electric Bikes (E-Bikes), Gravel & Hybrid Bikes, and Cycling Gear & Accessories.
  - **Keyword Search:** Query matching across product name, description, and SKU (`?q=...`).
  - **Price Range Filter:** Filter catalog by minimum and maximum price (`minPrice` / `maxPrice`).
  - **Sorting:** Server-side sorting supporting `newest`, `price_asc` (Low to High), and `price_desc` (High to Low).
  - **Pagination:** Multi-page catalog navigation displaying 20 items per page with active page tracking (`page=...`).
- **Product Details (`WEB-INF/views/product-detail.jsp`):** High-resolution view with specs table, dynamic pricing, and stock-capped quantity picker.

#### 2. Cart & 3-Step Checkout Flow
- **Shopping Cart (`cart.jsp` / `CartServlet.java`):** Dual mode supporting guest session carts and persistent user database carts. Supports Add, Update quantity, Remove item, and Clear cart actions.
- **3-Step Checkout Flow (`checkout.jsp` / `CheckoutServlet.java` / `CheckoutService.java`):**
  - **Step 1:** Recipient delivery and billing address selection.
  - **Step 2:** Coupon redemption supporting percentage (`BIKE10`) and flat-rate (`RIDE50`) vouchers.
  - **Step 3:** Payment method selector (Credit Card, PayPal, Cash on Delivery) and custom delivery notes.
  - **Payment Clarification:** The application provides an internal **payment method selector and simulation** (generates a unique `TXN-...` transaction ID and updates records in the `payments` table). It does **not** connect to an external commercial payment gateway API.
  - **Calculation Integrity:** Subtotals, discount caps, freight rules ($100 free shipping threshold, otherwise $10.00), and 8% tax are calculated strictly on the server in `CheckoutService` from database records.
  - **Stock Deduction:** Verifies available inventory before checkout and decrements stock atomically via `productDAO.updateStock`.

#### 3. Authentication & Access Control
- **Authentication (`LoginServlet.java` / `login.jsp`):** Cryptographic verification against PBKDF2 hashes (`65536` iterations), session fixation protection via `req.changeSessionId()`, and automatic guest-cart migration.
- **Role Enforcement (`AdminFilter.java`):** Protects `/admin/*` views, validating that authenticated users possess the `ADMIN` role. Non-admins receive HTTP 403 Forbidden.
- **Startup Integrity (`DatabaseInitializerListener.java`):** Validates all 12 required tables at Tomcat startup before accepting user traffic.

#### 4. Desktop Administration GUI
- Native Swing GUI application ([`LoginFrame.java`](file:///F:/java_Lab/java_Lab_Project/src/main/java/com/shopsphere/desktop/LoginFrame.java) and [`AdminDashboard.java`](file:///F:/java_Lab/java_Lab_Project/src/main/java/com/shopsphere/desktop/AdminDashboard.java)) utilizing system Look-and-Feel (PLAF), `JTabbedPane`, `JTable`, and `JScrollPane` for managing products, orders, and customer accounts.

#### 5. Distributed Networking Modules
- **TCP Socket Module (`com.shopsphere.network.socket`):** Multi-threaded `SocketInventoryServer` handling concurrent client requests (`GET_STOCK`, `UPDATE_STOCK`, `LIST_ALL`, `PING`) paired with `SocketInventoryClient`.
- **Java RMI Module (`com.shopsphere.network.rmi`):** `RmiInventoryServer` programmatically initializing an RMI Registry on port 1099 and binding `InventoryService`, consumed by `RmiInventoryClient`.

---

### 🗄️ Database Setup & Safety Guidelines

#### ⚠️ Critical Safety Notice: Two SQL Scripts

| Script Name | Operation Type | Safety Profile |
|---|---|---|
| **[`schema-init.sql`](file:///F:/java_Lab/java_Lab_Project/schema-init.sql)** | `CREATE TABLE IF NOT EXISTS`<br>`INSERT IGNORE INTO` | **Safe / Non-Destructive (Recommended).** Contains 0 DROP, 0 TRUNCATE, and 0 DELETE statements. Never drops tables or erases existing records. |
| **[`shopsphere.sql`](file:///F:/java_Lab/java_Lab_Project/shopsphere.sql)** | `DROP TABLE IF EXISTS` (12 tables)<br>`CREATE TABLE`<br>`INSERT INTO` | **Destructive Reset.** Drops and recreates all 12 tables. **Will erase all products, users, carts, and customer orders!** |

#### Verified Tables (12 Required)
`users`, `addresses`, `categories`, `products`, `cart`, `wishlist`, `coupons`, `orders`, `order_items`, `payments`, `reviews`, `coupon_usage`.

#### Seed Accounts & Vouchers
- **Administrator:** `admin@shopsphere.com` | Password: `Password123!` (Role: `admin`)
- **Customer:** `customer@shopsphere.com` | Password: `Password123!` (Role: `customer`)
- **Vouchers:** `BIKE10` (10% off orders $100+), `RIDE50` ($50 off orders $500+), `SAVE10` (10% off orders $50+), `WELCOME20` ($20 off orders $100+).

#### Initializing the Database in Windows PowerShell
> Note: Do not use `<` redirection in Windows PowerShell (PowerShell reserves `<`). Use either of the working methods below:

```powershell
# Method 1: Using the provided non-destructive PowerShell helper (Recommended)
powershell -ExecutionPolicy Bypass -File "F:\java_Lab\java_Lab_Project\scripts\init-db.ps1"

# Method 2: Pipe schema-init.sql into mysql client
Get-Content "F:\java_Lab\java_Lab_Project\schema-init.sql" | & mysql -u root -p shopsphere

# Method 3: Using MySQL execute source command (use forward slashes)
& mysql -u root -p --default-character-set=utf8mb4 -e "source F:/java_Lab/java_Lab_Project/schema-init.sql"
```

---

### 🔐 Configuring Database Environment Variables

ShopSphere's [`DBConnection.java`](file:///F:/java_Lab/java_Lab_Project/src/main/java/com/shopsphere/util/DBConnection.java) reads credentials directly from environment variables:

| Variable Name | Required Value | Notes |
|---|---|---|
| `DB_URL` | `jdbc:mysql://localhost:3306/shopsphere` | Direct JDBC URL (overrides DB_HOST/PORT/NAME) |
| `DB_USER` | Your MySQL username | e.g. `root` |
| `DB_PASSWORD` | Your MySQL password | Your actual local MySQL password |

#### Setting Permanent User Variables in Windows:
1. Press `Win + R`, type `sysdm.cpl`, and press **Enter**.
2. Go to **Advanced** &rarr; **Environment Variables...**.
3. Under **User variables**, click **New...** and add `DB_URL`, `DB_USER`, and `DB_PASSWORD`.
4. Click **OK** to save, then restart any open PowerShell windows.

#### Safe Verification Command (No Password Exposure):
```powershell
Write-Output "DB_URL:      $env:DB_URL"
Write-Output "DB_USER:     $env:DB_USER"
if ($env:DB_PASSWORD) {
    Write-Output "DB_PASSWORD: [Configured - $($env:DB_PASSWORD.Length) characters]"
} else {
    Write-Output "DB_PASSWORD: [MISSING]"
}
```

---

### 🚀 Running the ShopSphere Platform

#### Step 1: Ensure MySQL is Running
```powershell
Start-Service -Name MySQL80
```

#### Step 2: Build the Web Application
```powershell
cd F:\java_Lab\java_Lab_Project
mvn clean package
```
*Output artifact:* `F:\java_Lab\java_Lab_Project\target\shopsphere.war`.

#### Step 3: Deploy WAR to Tomcat 9
> **Windows File Lock Precaution:** Always stop Tomcat before deploying to prevent file lock errors on extracted JARs.

```powershell
# Stop Tomcat if running
cd F:\java_Lab\apache-tomcat-9.0.121\bin
.\shutdown.bat

# Copy WAR to webapps
Copy-Item "F:\java_Lab\java_Lab_Project\target\shopsphere.war" "F:\java_Lab\apache-tomcat-9.0.121\webapps\shopsphere.war" -Force

# Start Tomcat
.\startup.bat
```

#### Step 4: Open the Web Application
Visit in your web browser:  
**[http://localhost:8080/shopsphere/products](http://localhost:8080/shopsphere/products)**

#### Step 5: Run the Swing Desktop Admin Application (Optional)
```powershell
cd F:\java_Lab\java_Lab_Project
java -cp target/classes com.shopsphere.desktop.LoginFrame
```

#### Step 6: Run Distributed Networking Demonstrations (Optional)

##### TCP Socket Inventory Server & Client:
```powershell
# Terminal 1: Launch Socket Server on port 8092
cd F:\java_Lab\java_Lab_Project
java -cp target/classes com.shopsphere.network.socket.SocketInventoryServer 8092

# Terminal 2: Run Socket Client
cd F:\java_Lab\java_Lab_Project
java -cp target/classes com.shopsphere.network.socket.SocketInventoryClient localhost 8092
```

##### Java RMI Inventory Server & Client:
```powershell
# Terminal 1: Launch RMI Server (programmatically creates registry on port 1099)
cd F:\java_Lab\java_Lab_Project
java -cp target/classes com.shopsphere.network.rmi.RmiInventoryServer

# Terminal 2: Run RMI Client
cd F:\java_Lab\java_Lab_Project
java -cp target/classes com.shopsphere.network.rmi.RmiInventoryClient localhost 1099
```

---

## 🔧 Troubleshooting Guide

### 1. `ClassNotFoundException: com.mysql.cj.jdbc.Driver` in Exp 4 or 5
- **Cause:** Classpath delimiter is incorrect for your operating system.
- **Solution:**
  - On **Windows**: use a semicolon: `java -cp "lib/*;bin" Main`
  - On **Linux / macOS**: use a colon: `java -cp "lib/*:bin" Main`

### 2. HTTP Status 500 — `Table 'shopsphere.products' doesn't exist`
- **Cause:** The `shopsphere` database was created, but schema tables were not imported.
- **Solution:** Execute `schema-init.sql` non-destructively using MySQL Workbench or run:
  ```powershell
  powershell -ExecutionPolicy Bypass -File F:\java_Lab\java_Lab_Project\scripts\init-db.ps1
  ```

### 3. `DB_PASSWORD` or `DB_USER` Missing Error on Tomcat Startup
- **Cause:** Tomcat was started from an environment that did not inherit user environment variables.
- **Solution:** Set permanent variables in `sysdm.cpl` and restart terminal before running `.\startup.bat`, or configure credentials in `F:\java_Lab\apache-tomcat-9.0.121\bin\setenv.bat`.

### 4. Tomcat Port 8080 Conflict
- **Cause:** A previously running Tomcat instance or another process occupies port 8080.
- **Safe Solution (Target only the specific PID):**
  ```powershell
  $pid8080 = (Get-NetTCPConnection -LocalPort 8080 -State Listen -ErrorAction SilentlyContinue).OwningProcess
  if ($pid8080) { Stop-Process -Id $pid8080 -Force }
  ```
  *(Never use `Stop-Process -Name java -Force` as it terminates IDEs and build tools).*

### 5. `The origin server did not find a current representation for the target resource` (404)
- **Cause:** Accessing `http://localhost:8080/` without the webapp context path.
- **Solution:** Always use the full URL: `http://localhost:8080/shopsphere/products`.

---

## 👨‍💻 Repository & Author Information

- **Course:** Advanced Java Programming Laboratory (ADJ Lab)
- **Repository:** https://github.com/SHEKHAWATNAVENDU/Java_Lab_Assignments
- **Active Branch:** `main`
- **Author:** Navendu Pratap Singh
