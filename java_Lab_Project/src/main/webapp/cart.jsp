<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Shopping Cart | ShopSphere Pro Cycling" scope="request" />
<jsp:include page="/fragments/header.jsp" />
<jsp:include page="/fragments/navbar.jsp" />

<main class="py-5">
    <div class="container">
        <!-- Header & Breadcrumbs -->
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-3 border-bottom">
            <div>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb small mb-1">
                        <li class="breadcrumb-item"><a href="<c:url value='/products' />" class="text-decoration-none text-muted">ShopSphere</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Shopping Cart</li>
                    </ol>
                </nav>
                <h2 class="fw-bold mb-0">Shopping Cart</h2>
            </div>
            <a href="<c:url value='/products' />" class="btn btn-outline-primary btn-sm mt-3 mt-sm-0">
                <i class="bi bi-arrow-left me-1"></i> Continue Shopping
            </a>
        </div>

        <!-- Alert Notifications -->
        <c:if test="${not empty message}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm d-flex align-items-center gap-2 mb-4" role="alert">
                <i class="bi bi-check-circle-fill fs-5"></i>
                <div><c:out value="${message}" /></div>
                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm d-flex align-items-center gap-2 mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill fs-5"></i>
                <div><c:out value="${errorMessage}" /></div>
                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <c:choose>
            <c:when test="${not empty cartItems}">
                <div class="row g-4">
                    <!-- Left: Cart Items Table -->
                    <div class="col-lg-8">
                        <div class="cart-table-card">
                            <div class="table-responsive">
                                <table class="table cart-table align-middle">
                                    <thead>
                                        <tr>
                                            <th scope="col" style="min-width: 70px;">Item</th>
                                            <th scope="col" style="min-width: 220px;">Model &amp; SKU</th>
                                            <th scope="col" class="text-center" style="min-width: 100px;">Price</th>
                                            <th scope="col" class="text-center" style="min-width: 130px;">Quantity</th>
                                            <th scope="col" class="text-end" style="min-width: 110px;">Subtotal</th>
                                            <th scope="col" class="text-center" style="width: 50px;"></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:set var="cartSubtotal" value="0" />
                                        <c:forEach items="${cartItems}" var="item">
                                            <tr>
                                                <!-- Product Thumbnail -->
                                                <td>
                                                    <div class="bg-light rounded-3 p-2 text-center d-flex align-items-center justify-content-center border" 
                                                         style="width: 54px; height: 54px;">
                                                        <i class="bi bi-bicycle fs-4 text-secondary"></i>
                                                    </div>
                                                </td>

                                                <!-- Model & SKU -->
                                                <td>
                                                    <h6 class="mb-1 fw-bold">
                                                        <a href="<c:url value='/products/${item.productId}' />" class="text-decoration-none text-dark hover-primary">
                                                            <c:out value="${itemProductMap[item.productId].name != null ? itemProductMap[item.productId].name : 'Product #' += item.productId}" />
                                                        </a>
                                                    </h6>
                                                    <small class="text-muted font-monospace" style="font-size: 0.72rem;">
                                                        SKU: <c:out value="${itemProductMap[item.productId].sku != null ? itemProductMap[item.productId].sku : item.productId}" />
                                                    </small>
                                                </td>

                                                <!-- Unit Price -->
                                                <td class="text-center fw-semibold">
                                                    <c:set var="currentPrice" value="${itemProductMap[item.productId].price != null ? itemProductMap[item.productId].price : 0.00}" />
                                                    $<c:out value="${currentPrice}" />
                                                </td>

                                                <!-- Quantity Form -->
                                                <td class="text-center">
                                                    <form method="POST" action="<c:url value='/cart' />" class="d-inline-flex align-items-center justify-content-center gap-1">
                                                        <input type="hidden" name="action" value="update"/>
                                                        <input type="hidden" name="cartId" value="<c:out value='${item.cartId}' />"/>
                                                        <input type="number" name="quantity" class="form-control form-control-sm text-center fw-bold"
                                                               value="<c:out value='${item.quantity}' />" min="1" max="99" style="width: 64px;" required>
                                                        <button type="submit" class="btn btn-outline-primary btn-sm px-2 py-1" title="Update Quantity">
                                                            <i class="bi bi-arrow-repeat"></i>
                                                        </button>
                                                    </form>
                                                </td>

                                                <!-- Subtotal -->
                                                <td class="text-end fw-bold text-dark">
                                                    $<c:out value="${currentPrice * item.quantity}" />
                                                    <c:set var="cartSubtotal" value="${cartSubtotal + (currentPrice * item.quantity)}" />
                                                </td>

                                                <!-- Remove Action -->
                                                <td class="text-center">
                                                    <form method="POST" action="<c:url value='/cart' />" class="d-inline">
                                                        <input type="hidden" name="action" value="delete"/>
                                                        <input type="hidden" name="cartId" value="<c:out value='${item.cartId}' />"/>
                                                        <button type="submit" class="btn btn-link text-muted hover-danger p-0 border-0" title="Remove item from cart">
                                                            <i class="bi bi-trash3"></i>
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <div class="card-footer bg-white d-flex justify-content-between align-items-center p-3 border-top">
                                <form method="POST" action="<c:url value='/cart' />" onsubmit="return confirm('Are you sure you want to empty your cart?');">
                                    <input type="hidden" name="action" value="clear"/>
                                    <button type="submit" class="btn btn-outline-danger btn-sm">
                                        <i class="bi bi-trash me-1"></i> Clear Cart
                                    </button>
                                </form>
                                <span class="text-muted small">
                                    <i class="bi bi-check-circle-fill text-success me-1"></i> Live inventory stock reserved
                                </span>
                            </div>
                        </div>
                    </div>

                    <!-- Right: Order Summary Sidebar -->
                    <div class="col-lg-4">
                        <div class="order-summary-card">
                            <h5 class="fw-bold mb-3 border-bottom pb-2">Order Summary</h5>

                            <div class="summary-row">
                                <span class="text-muted">Cart Subtotal</span>
                                <span class="fw-bold">$<c:out value="${cartSubtotal}" /></span>
                            </div>

                            <div class="summary-row">
                                <span class="text-muted">Specialized Freight</span>
                                <c:choose>
                                    <c:when test="${cartSubtotal ge 100}">
                                        <span class="text-success fw-bold small">FREE (Over $100)</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted small">Calculated at Checkout</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="summary-row">
                                <span class="text-muted">Estimated Tax (8%)</span>
                                <span class="text-muted small">Calculated at Checkout</span>
                            </div>

                            <div class="summary-total summary-row">
                                <span class="fs-5 fw-bold">Subtotal</span>
                                <span class="fs-4 fw-bold text-dark">$<c:out value="${cartSubtotal}" /></span>
                            </div>

                            <a href="<c:url value='/checkout' />" class="btn btn-accent btn-lg w-100 fw-bold d-flex align-items-center justify-content-center gap-2 mb-3">
                                <span>Proceed to Checkout</span>
                                <i class="bi bi-arrow-right"></i>
                            </a>

                            <div class="p-3 bg-light rounded-3 border">
                                <div class="d-flex gap-2 align-items-start text-muted small">
                                    <i class="bi bi-box-seam text-warning fs-5 flex-shrink-0"></i>
                                    <div>
                                        <strong>Specialized Freight:</strong> Bikes arrive 85% assembled in heavy-duty reinforced cartons with hex multi-tool and pedal wrench included.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Empty Cart State -->
                <div class="card border-0 shadow-sm rounded-4 p-5 text-center bg-white my-4">
                    <div class="d-inline-flex align-items-center justify-content-center bg-light text-muted rounded-circle mx-auto mb-3" 
                         style="width: 80px; height: 80px;">
                        <i class="bi bi-cart3 fs-1"></i>
                    </div>
                    <h3 class="fw-bold mb-2">Your Shopping Cart is Empty</h3>
                    <p class="text-muted mb-4">You have not selected any bicycles, e-bikes, or cycling gear yet.</p>
                    <div>
                        <a href="<c:url value='/products' />" class="btn btn-accent px-4 py-2 fw-semibold">
                            <i class="bi bi-bicycle me-2"></i> Explore Collection
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="/fragments/footer.jsp" />
