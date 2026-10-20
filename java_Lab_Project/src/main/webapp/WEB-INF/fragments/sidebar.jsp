<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<aside class="sidebar-wrapper">
    <!-- Category Navigation Card -->
    <div class="filter-card">
        <div class="filter-title">
            <i class="bi bi-bicycle text-warning fs-5"></i>
            <span>Bike Categories</span>
        </div>
        <div class="d-flex flex-column">
            <a href="<c:url value='/products' />" 
               class="category-filter-item ${empty param.category ? 'active' : ''}">
                <span>All Bikes &amp; Gear</span>
                <span class="badge rounded-pill ${empty param.category ? 'bg-light text-dark' : 'bg-secondary'}">All</span>
            </a>
            <a href="<c:url value='/products?category=1' />" 
               class="category-filter-item ${param.category == '1' ? 'active' : ''}">
                <span>Mountain (MTB)</span>
                <span class="badge rounded-pill bg-light text-secondary">Trail</span>
            </a>
            <a href="<c:url value='/products?category=2' />" 
               class="category-filter-item ${param.category == '2' ? 'active' : ''}">
                <span>Road &amp; Racing</span>
                <span class="badge rounded-pill bg-light text-secondary">Speed</span>
            </a>
            <a href="<c:url value='/products?category=3' />" 
               class="category-filter-item ${param.category == '3' ? 'active' : ''}">
                <span>Electric (E-Bikes)</span>
                <span class="badge rounded-pill bg-light text-secondary">750W</span>
            </a>
            <a href="<c:url value='/products?category=4' />" 
               class="category-filter-item ${param.category == '4' ? 'active' : ''}">
                <span>Gravel &amp; Hybrid</span>
                <span class="badge rounded-pill bg-light text-secondary">All-Road</span>
            </a>
            <a href="<c:url value='/products?category=5' />" 
               class="category-filter-item ${param.category == '5' ? 'active' : ''}">
                <span>Gear &amp; Helmets</span>
                <span class="badge rounded-pill bg-light text-secondary">Gear</span>
            </a>
        </div>
    </div>

    <!-- Price Range Filter Card -->
    <div class="filter-card">
        <div class="filter-title">
            <i class="bi bi-funnel text-warning fs-5"></i>
            <span>Filter by Price</span>
        </div>
        <form method="GET" action="<c:url value='/products' />">
            <c:if test="${not empty param.category}">
                <input type="hidden" name="category" value="<c:out value='${param.category}' />"/>
            </c:if>
            <c:if test="${not empty param.q}">
                <input type="hidden" name="q" value="<c:out value='${param.q}' />"/>
            </c:if>

            <div class="mb-3">
                <label class="form-label text-muted small">Price Range (USD)</label>
                <div class="d-flex align-items-center gap-2">
                    <input type="number" name="minPrice" class="form-control form-control-sm" 
                           placeholder="Min $" value="<c:out value='${param.minPrice}' />" min="0">
                    <span class="text-muted">&ndash;</span>
                    <input type="number" name="maxPrice" class="form-control form-control-sm" 
                           placeholder="Max $" value="<c:out value='${param.maxPrice}' />" min="0">
                </div>
            </div>

            <button type="submit" class="btn btn-outline-primary btn-sm w-100 fw-semibold">
                <i class="bi bi-funnel-fill me-1"></i> Apply Price
            </button>
            <c:if test="${not empty param.minPrice || not empty param.maxPrice}">
                <a href="<c:url value='/products${not empty param.category ? \"?category=\" += param.category : \"\"}' />" 
                   class="btn btn-link btn-sm w-100 text-muted mt-1 text-decoration-none">
                    Clear Price Filter
                </a>
            </c:if>
        </form>
    </div>

    <!-- Active Promo Voucher Callout -->
    <div class="card border-0 bg-dark text-white rounded-3 p-3 shadow-sm">
        <div class="d-flex align-items-center gap-2 mb-2">
            <i class="bi bi-ticket-perforated-fill text-warning fs-4"></i>
            <h6 class="mb-0 fw-bold text-white">Rider Promo Voucher</h6>
        </div>
        <p class="small text-white-50 mb-2">
            Apply this voucher code at checkout to receive 10% off your entire bicycle or gear order:
        </p>
        <div class="bg-warning text-dark py-1 px-3 rounded text-center font-monospace fw-bold small">
            BIKE10
        </div>
        <div class="small text-white-50 text-center mt-2" style="font-size: 0.72rem;">
            Or use <strong>RIDE50</strong> for $50 off orders over $500
        </div>
    </div>
</aside>
