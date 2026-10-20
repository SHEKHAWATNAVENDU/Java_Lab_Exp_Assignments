<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>

<c:set var="pageTitle" value="${product.name} | ShopSphere Pro Cycling" scope="request" />
<jsp:include page="/fragments/header.jsp" />
<jsp:include page="/fragments/navbar.jsp" />

<main class="py-5">
    <div class="container">
        <!-- Breadcrumb Navigation -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb small">
                <li class="breadcrumb-item"><a href="<c:url value='/products' />" class="text-decoration-none text-muted">ShopSphere</a></li>
                <li class="breadcrumb-item"><a href="<c:url value='/products' />" class="text-decoration-none text-muted">Bicycles</a></li>
                <li class="breadcrumb-item active text-dark fw-semibold" aria-current="page"><c:out value="${product.name}" /></li>
            </ol>
        </nav>

        <!-- Product Detail Card -->
        <div class="card border-0 shadow-sm rounded-4 p-4 p-lg-5 bg-white mb-5">
            <div class="row g-5 align-items-center">
                <!-- Left: Product Showcase Gallery -->
                <div class="col-lg-6">
                    <div class="product-detail-gallery">
                        <i class="bi bi-bicycle text-secondary" style="font-size: 10rem; opacity: 0.85;"></i>

                        <!-- Discount Badge -->
                        <c:if test="${not empty product.salePrice && product.salePrice gt 0 && product.salePrice lt product.price}">
                            <c:set var="savings" value="${((product.price - product.salePrice) / product.price) * 100}" />
                            <fmt:formatNumber var="discountPercent" value="${savings}" maxFractionDigits="0" />
                            <span class="product-badge-sale fs-6 px-3 py-2">
                                -<c:out value="${discountPercent}" />% OFF
                            </span>
                        </c:if>

                        <!-- Stock Badge -->
                        <c:choose>
                            <c:when test="${product.stockQuantity gt 0}">
                                <span class="product-badge-stock product-badge-in-stock px-3 py-1">
                                    <i class="bi bi-check-circle-fill me-1"></i> In Stock (<c:out value="${product.stockQuantity}" /> available)
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="product-badge-stock product-badge-out-stock px-3 py-1">
                                    Sold Out
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Built-in Spec Badges -->
                    <div class="product-detail-specs-grid">
                        <div class="product-spec-item">
                            <div class="product-spec-label"><i class="bi bi-speedometer2 text-warning me-1"></i> Frame Class</div>
                            <div class="product-spec-val">Pro Precision Alloy/Carbon</div>
                        </div>
                        <div class="product-spec-item">
                            <div class="product-spec-label"><i class="bi bi-disc text-warning me-1"></i> Brakes</div>
                            <div class="product-spec-val">Hydraulic Dual Disc</div>
                        </div>
                        <div class="product-spec-item">
                            <div class="product-spec-label"><i class="bi bi-gear-wide-connected text-warning me-1"></i> Drivetrain</div>
                            <div class="product-spec-val">Shimano Multi-Stage</div>
                        </div>
                        <div class="product-spec-item">
                            <div class="product-spec-label"><i class="bi bi-shield-check text-warning me-1"></i> Warranty</div>
                            <div class="product-spec-val">2 Years Comprehensive</div>
                        </div>
                    </div>
                </div>

                <!-- Right: Product Information & Purchase Panel -->
                <div class="col-lg-6">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <span class="badge bg-secondary-subtle text-secondary font-monospace px-2 py-1">
                            SKU: <c:out value="${product.sku}" />
                        </span>
                        <tags:rating value="4.9" max="5" />
                    </div>

                    <h1 class="display-6 fw-bold mb-3"><c:out value="${product.name}" /></h1>

                    <!-- Price Block -->
                    <div class="d-flex align-items-baseline gap-3 mb-4 pb-3 border-bottom">
                        <c:choose>
                            <c:when test="${not empty product.salePrice && product.salePrice gt 0 && product.salePrice lt product.price}">
                                <span class="fs-2 fw-bold text-danger">$<c:out value="${product.salePrice}" /></span>
                                <span class="fs-5 text-muted text-decoration-line-through">$<c:out value="${product.price}" /></span>
                                <span class="badge bg-danger-subtle text-danger px-2 py-1 small fw-bold">Special Promo Rate</span>
                            </c:when>
                            <c:otherwise>
                                <span class="fs-2 fw-bold text-dark">$<c:out value="${product.price}" /></span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Description -->
                    <div class="mb-4">
                        <h6 class="text-uppercase text-muted fw-bold small mb-2" style="letter-spacing: 0.05em;">Product Overview</h6>
                        <p class="text-secondary leading-relaxed">
                            <c:out value="${product.description != null ? product.description : 'High performance engineering meets uncompromising design. Built for demanding terrain, maximum aerodynamic efficiency, and peak riding comfort.'}" />
                        </p>
                    </div>

                    <!-- Purchase Actions -->
                    <c:choose>
                        <c:when test="${product.stockQuantity gt 0}">
                            <form method="POST" action="<c:url value='/cart' />" class="mb-4">
                                <input type="hidden" name="action" value="add"/>
                                <input type="hidden" name="productId" value="<c:out value='${product.productId}' />"/>

                                <div class="row g-3 align-items-center mb-3">
                                    <div class="col-sm-4">
                                        <label for="quantitySelect" class="form-label small text-muted">Quantity</label>
                                        <input type="number" id="quantitySelect" name="quantity" class="form-control text-center fw-bold" 
                                               value="1" min="1" max="<c:out value='${product.stockQuantity}' />" required>
                                    </div>
                                    <div class="col-sm-8 pt-sm-4">
                                        <button type="submit" class="btn btn-accent btn-lg w-100 fw-bold d-flex align-items-center justify-content-center gap-2">
                                            <i class="bi bi-cart-plus-fill fs-5"></i>
                                            <span>Add to Cart</span>
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-secondary d-flex align-items-center gap-2 mb-4" role="alert">
                                <i class="bi bi-exclamation-circle fs-5"></i>
                                <div>This item is currently sold out in warehouse stock. Check back soon for restock updates.</div>
                            </div>
                        </c:otherwise>
                    </c:choose>

                    <!-- Rider Trust Indicators -->
                    <div class="bg-light p-3 rounded-3 border d-flex flex-column gap-2 small text-secondary">
                        <div class="d-flex align-items-center gap-2">
                            <i class="bi bi-box-seam text-warning fs-5"></i>
                            <span><strong>Reinforced Bike Carton:</strong> Delivered 85% pre-assembled with tuning manual and pro hex multi-tool.</span>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <i class="bi bi-shield-check text-warning fs-5"></i>
                            <span><strong>Official Warranty:</strong> Full 2-year warranty coverage on frames and certified mechanical components.</span>
                        </div>
                    </div>

                    <div class="mt-4 pt-3 border-top">
                        <a href="<c:url value='/products' />" class="text-decoration-none text-muted small d-inline-flex align-items-center gap-1">
                            <i class="bi bi-arrow-left"></i> Return to Product Catalog
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/fragments/footer.jsp" />
