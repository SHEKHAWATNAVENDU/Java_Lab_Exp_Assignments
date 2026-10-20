<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header>
    <!-- Top Announcement Strip -->
    <div class="top-announcement-bar d-none d-md-block">
        <div class="container d-flex justify-content-between align-items-center">
            <div class="d-flex align-items-center gap-3">
                <span><i class="bi bi-truck me-1 text-warning"></i> Complimentary freight delivery on orders over $100</span>
                <span class="text-secondary opacity-50">&bull;</span>
                <span><i class="bi bi-shield-check me-1 text-warning"></i> 2-Year Frame Warranty &amp; Pro Pre-Assembly</span>
            </div>
            <div class="d-flex align-items-center gap-3">
                <a href="tel:+18005552453" class="text-decoration-none">
                    <i class="bi bi-telephone me-1"></i> 1-800-555-BIKE
                </a>
                <span class="text-secondary opacity-50">&bull;</span>
                <a href="<c:url value='/products?category=3' />" class="text-warning text-decoration-none fw-semibold">
                    <i class="bi bi-lightning-charge-fill me-1"></i> New 750W E-Bikes
                </a>
            </div>
        </div>
    </div>

    <!-- Main Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom sticky-top">
        <div class="container">
            <!-- Brand Wordmark -->
            <a class="brand-wordmark navbar-brand text-decoration-none me-4" href="<c:url value='/products' />">
                <span class="d-inline-flex align-items-center gap-2">
                    <i class="bi bi-bicycle text-warning fs-3"></i>
                    <span>Shop<span class="text-warning">Sphere</span></span>
                </span>
                <span class="brand-subtitle d-none d-sm-inline">PRO CYCLING</span>
            </a>

            <!-- Mobile Hamburger Toggle -->
            <button class="navbar-toggler border-0 shadow-none px-2 py-1" type="button" data-bs-toggle="collapse" 
                    data-bs-target="#shopSphereNavbar" aria-controls="shopSphereNavbar" 
                    aria-expanded="false" aria-label="Toggle navigation">
                <i class="bi bi-list fs-2 text-white"></i>
            </button>

            <!-- Navbar Collapsible Menu -->
            <div class="collapse navbar-collapse" id="shopSphereNavbar">
                <!-- Category Nav Links -->
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <li class="nav-item">
                        <a class="nav-link nav-link-custom ${empty param.category ? 'active' : ''}" 
                           href="<c:url value='/products' />">
                            All Bikes
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link nav-link-custom ${param.category == '1' ? 'active' : ''}" 
                           href="<c:url value='/products?category=1' />">
                            Mountain (MTB)
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link nav-link-custom ${param.category == '2' ? 'active' : ''}" 
                           href="<c:url value='/products?category=2' />">
                            Road &amp; Race
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link nav-link-custom ${param.category == '3' ? 'active' : ''}" 
                           href="<c:url value='/products?category=3' />">
                            E-Bikes
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link nav-link-custom ${param.category == '4' ? 'active' : ''}" 
                           href="<c:url value='/products?category=4' />">
                            Gravel
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link nav-link-custom ${param.category == '5' ? 'active' : ''}" 
                           href="<c:url value='/products?category=5' />">
                            Gear &amp; Helmets
                        </a>
                    </li>
                </ul>

                <!-- Search Input Form -->
                <form class="header-search-wrap mx-lg-3 my-2 my-lg-0" method="GET" action="<c:url value='/products' />" role="search">
                    <input class="form-control header-search-input" type="search" name="q" 
                           placeholder="Search bikes, gear, SKU..." 
                           value="<c:out value='${param.q}' />" aria-label="Search Catalog">
                    <button class="header-search-btn" type="submit" aria-label="Submit search">
                        <i class="bi bi-search"></i>
                    </button>
                </form>

                <!-- Right Action Icons: Cart & Profile -->
                <div class="d-flex align-items-center gap-2 mt-3 mt-lg-0 ms-lg-2">
                    <!-- Cart Button with Pill Badge -->
                    <a href="<c:url value='/cart' />" class="nav-cart-btn text-decoration-none" title="Shopping Cart">
                        <i class="bi bi-cart3 fs-6"></i>
                        <span class="d-none d-xl-inline">Cart</span>
                        <c:choose>
                            <c:when test="${not empty sessionScope.cartCount && sessionScope.cartCount gt 0}">
                                <span class="nav-cart-pill">
                                    <c:out value="${sessionScope.cartCount}" />
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="nav-cart-pill opacity-75">0</span>
                            </c:otherwise>
                        </c:choose>
                    </a>

                    <!-- User Account Dropdown -->
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <div class="dropdown">
                                <button class="btn nav-user-btn dropdown-toggle d-flex align-items-center gap-2 border-0" 
                                        type="button" id="userAccountMenu" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="bi bi-person-circle fs-6 text-warning"></i>
                                    <span><c:out value="${sessionScope.user.firstName}" /></span>
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end dropdown-menu-custom" aria-labelledby="userAccountMenu">
                                    <li class="px-3 py-2 border-bottom mb-1">
                                        <div class="small text-muted">Signed in as</div>
                                        <div class="fw-bold text-truncate" style="max-width: 180px;">
                                            <c:out value="${sessionScope.user.email}" />
                                        </div>
                                    </li>
                                    <li>
                                        <a class="dropdown-item d-flex align-items-center gap-2" href="<c:url value='/orders' />">
                                            <i class="bi bi-box-seam text-secondary"></i> My Orders
                                        </a>
                                    </li>
                                    <c:if test="${'ADMIN'.equalsIgnoreCase(sessionScope.user.role)}">
                                        <li>
                                            <a class="dropdown-item d-flex align-items-center gap-2 text-danger fw-semibold" 
                                               href="<c:url value='/admin/dashboard.jsp' />">
                                                <i class="bi bi-speedometer2"></i> Admin Console
                                            </a>
                                        </li>
                                    </c:if>
                                    <li><hr class="dropdown-divider my-1"></li>
                                    <li>
                                        <a class="dropdown-item d-flex align-items-center gap-2 text-danger" href="<c:url value='/logout' />">
                                            <i class="bi bi-box-arrow-right"></i> Sign Out
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Guest User: Sign In & Register -->
                            <div class="d-flex align-items-center gap-2">
                                <a href="<c:url value='/login' />" class="btn btn-outline-light btn-sm px-3">
                                    <i class="bi bi-person me-1"></i> Sign In
                                </a>
                                <a href="<c:url value='/register' />" class="btn btn-accent btn-sm px-3">
                                    Join
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>
</header>
