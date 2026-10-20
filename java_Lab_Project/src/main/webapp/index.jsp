<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>

<c:if test="${products == null}">
    <c:redirect url="/products" />
</c:if>

<c:set var="pageTitle" value="ShopSphere | Premium Bicycles, E-Bikes &amp; Pro Cycling Gear" scope="request" />
<jsp:include page="/WEB-INF/fragments/header.jsp" />
<jsp:include page="/WEB-INF/fragments/navbar.jsp" />

<main class="py-4">
    <div class="container">
        <!-- Hero Section -->
        <section class="hero-premium">
            <div class="row align-items-center">
                <div class="col-lg-8 position-relative z-2">
                    <div class="hero-badge">
                        <i class="bi bi-bicycle"></i>
                        <span>Engineered for Performance</span>
                    </div>
                    <h1 class="hero-title">
                        Engineered for Speed.<br>Built for the Trail.
                    </h1>
                    <p class="hero-lead">
                        Discover pro-grade carbon road racers, rugged full-suspension 29er mountain bikes, 750W commuter e-bikes, and certified safety gear.
                    </p>
                    <div class="hero-actions">
                        <a href="#catalogSection" class="btn btn-accent btn-lg">
                            <i class="bi bi-bicycle me-1"></i> Explore Collection
                        </a>
                        <a href="<c:url value='/products?category=3' />" class="btn btn-outline-light btn-lg">
                            <i class="bi bi-lightning-charge-fill me-1 text-warning"></i> View 750W E-Bikes
                        </a>
                    </div>
                </div>
                <div class="col-lg-4 d-none d-lg-flex justify-content-center align-items-center position-relative">
                    <div class="text-center opacity-75">
                        <i class="bi bi-bicycle text-white" style="font-size: 11rem; display: inline-block; filter: drop-shadow(0 20px 30px rgba(0,0,0,0.5));"></i>
                    </div>
                </div>
            </div>
        </section>

        <!-- Feature Pillars Strip -->
        <section class="features-strip">
            <div class="feature-pill-card">
                <div class="feature-pill-icon">
                    <i class="bi bi-truck"></i>
                </div>
                <div>
                    <h6 class="mb-0 fw-bold">Specialized Freight</h6>
                    <small class="text-muted">Complimentary on orders over $100</small>
                </div>
            </div>

            <div class="feature-pill-card">
                <div class="feature-pill-icon">
                    <i class="bi bi-tools"></i>
                </div>
                <div>
                    <h6 class="mb-0 fw-bold">85% Pre-Assembled</h6>
                    <small class="text-muted">Includes pro tuning &amp; multi-tool</small>
                </div>
            </div>

            <div class="feature-pill-card">
                <div class="feature-pill-icon">
                    <i class="bi bi-shield-check"></i>
                </div>
                <div>
                    <h6 class="mb-0 fw-bold">2-Year Frame Warranty</h6>
                    <small class="text-muted">Certified carbon &amp; alloy protection</small>
                </div>
            </div>

            <div class="feature-pill-card">
                <div class="feature-pill-icon">
                    <i class="bi bi-arrow-repeat"></i>
                </div>
                <div>
                    <h6 class="mb-0 fw-bold">30-Day Ride Guarantee</h6>
                    <small class="text-muted">Love your ride or return it hassle-free</small>
                </div>
            </div>
        </section>

        <!-- Main Catalog Section -->
        <div class="row g-4" id="catalogSection">
            <!-- Sidebar Filters -->
            <div class="col-lg-3">
                <jsp:include page="/WEB-INF/fragments/sidebar.jsp" />
            </div>

            <!-- Product Grid -->
            <div class="col-lg-9">
                <!-- Sorting & Results Header -->
                <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-3 border-bottom">
                    <div>
                        <h3 class="fw-bold mb-1">Featured Bikes &amp; Gear</h3>
                        <p class="text-muted small mb-0">
                            <c:choose>
                                <c:when test="${not empty products}">Showing <strong><c:out value="${products.size()}" /></strong> verified models in warehouse inventory</c:when>
                                <c:otherwise>0 products found</c:otherwise>
                            </c:choose>
                        </p>
                    </div>

                    <div class="d-flex align-items-center gap-2 mt-3 mt-md-0">
                        <label for="sortSelector" class="small text-muted fw-semibold text-nowrap">Sort:</label>
                        <select id="sortSelector" class="form-select form-select-sm" style="width: auto;" onchange="location = this.value;">
                            <option value="<c:url value='/products?sort=newest' />" ${param.sort == 'newest' ? 'selected' : ''}>Newest Releases</option>
                            <option value="<c:url value='/products?sort=price_asc' />" ${param.sort == 'price_asc' ? 'selected' : ''}>Price: Low to High</option>
                            <option value="<c:url value='/products?sort=price_desc' />" ${param.sort == 'price_desc' ? 'selected' : ''}>Price: High to Low</option>
                        </select>
                    </div>
                </div>

                <!-- Product Grid -->
                <c:choose>
                    <c:when test="${not empty products}">
                        <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-4">
                            <c:forEach items="${products}" var="product">
                                <div class="col">
                                    <tags:productCard product="${product}" />
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Pagination -->
                        <nav aria-label="Page navigation" class="mt-5">
                            <ul class="pagination justify-content-center">
                                <li class="page-item ${param.page le 1 || empty param.page ? 'disabled' : ''}">
                                    <a class="page-link" href="<c:url value='/products?page=${(param.page != null ? param.page : 1) - 1}' />">
                                        <i class="bi bi-chevron-left me-1"></i> Previous
                                    </a>
                                </li>
                                <li class="page-item active">
                                    <span class="page-link"><c:out value="${param.page != null ? param.page : 1}" /></span>
                                </li>
                                <li class="page-item">
                                    <a class="page-link" href="<c:url value='/products?page=${(param.page != null ? param.page : 1) + 1}' />">
                                        Next <i class="bi bi-chevron-right ms-1"></i>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </c:when>
                    <c:otherwise>
                        <!-- Empty State -->
                        <div class="card border-0 shadow-sm rounded-4 p-5 text-center bg-white">
                            <i class="bi bi-search text-muted mb-3" style="font-size: 3rem;"></i>
                            <h4 class="fw-bold mb-2">No Matching Models Found</h4>
                            <p class="text-muted mb-4">We could not find any bicycle or gear matching your current filter criteria.</p>
                            <div>
                                <a href="<c:url value='/products' />" class="btn btn-outline-primary btn-sm px-4">
                                    Reset Filters
                                </a>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/WEB-INF/fragments/footer.jsp" />
