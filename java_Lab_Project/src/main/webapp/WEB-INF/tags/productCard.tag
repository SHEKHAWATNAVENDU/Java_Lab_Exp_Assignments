<%@ tag language="java" pageEncoding="UTF-8" description="Reusable ShopSphere Product Card Component" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@ attribute name="product" type="com.shopsphere.model.Product" required="true" description="Product entity" %>

<div class="product-card">
    <!-- Image & Status Badges -->
    <div class="product-image-wrapper">
        <i class="bi bi-bicycle product-illustration-icon"></i>

        <!-- Discount Percentage Badge -->
        <c:if test="${not empty product.salePrice && product.salePrice gt 0 && product.salePrice lt product.price}">
            <c:set var="savings" value="${((product.price - product.salePrice) / product.price) * 100}" />
            <fmt:formatNumber var="discountPercent" value="${savings}" maxFractionDigits="0" />
            <span class="product-badge-sale">
                -<c:out value="${discountPercent}" />% OFF
            </span>
        </c:if>

        <!-- Stock Availability Badge -->
        <c:choose>
            <c:when test="${product.stockQuantity gt 0}">
                <span class="product-badge-stock product-badge-in-stock">
                    <i class="bi bi-check-circle-fill me-1"></i>In Stock
                </span>
            </c:when>
            <c:otherwise>
                <span class="product-badge-stock product-badge-out-stock">
                    Sold Out
                </span>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Product Details Body -->
    <div class="product-body">
        <div class="product-meta-header">
            <span class="product-category-tag">ShopSphere Pro</span>
            <span class="product-sku-tag"><c:out value="${product.sku}" /></span>
        </div>

        <h5 class="product-title">
            <a href="<c:url value='/products/${product.productId}' />">
                <c:out value="${product.name}" />
            </a>
        </h5>

        <p class="product-desc">
            <c:out value="${product.description != null ? product.description : 'Precision engineered pro bicycle built for speed, stability, and rugged all-terrain endurance.'}" />
        </p>

        <!-- Rating component -->
        <div class="mb-2">
            <tags:rating value="4.8" max="5" />
        </div>

        <!-- Pricing & Add to Cart -->
        <div class="product-pricing-wrap">
            <div class="price-display">
                <c:choose>
                    <c:when test="${not empty product.salePrice && product.salePrice gt 0 && product.salePrice lt product.price}">
                        <span class="price-current sale-price">$<c:out value="${product.salePrice}" /></span>
                        <span class="price-original">$<c:out value="${product.price}" /></span>
                    </c:when>
                    <c:otherwise>
                        <span class="price-current">$<c:out value="${product.price}" /></span>
                    </c:otherwise>
                </c:choose>
            </div>

            <c:choose>
                <c:when test="${product.stockQuantity gt 0}">
                    <form method="POST" action="<c:url value='/cart' />" class="d-grid">
                        <input type="hidden" name="action" value="add"/>
                        <input type="hidden" name="productId" value="<c:out value='${product.productId}' />"/>
                        <input type="hidden" name="quantity" value="1"/>
                        <button type="submit" class="btn btn-primary btn-sm">
                            <i class="bi bi-cart-plus me-1"></i> Add to Cart
                        </button>
                    </form>
                </c:when>
                <c:otherwise>
                    <div class="d-grid">
                        <button type="button" class="btn btn-outline-primary btn-sm disabled opacity-50" disabled>
                            <i class="bi bi-slash-circle me-1"></i> Out of Stock
                        </button>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
