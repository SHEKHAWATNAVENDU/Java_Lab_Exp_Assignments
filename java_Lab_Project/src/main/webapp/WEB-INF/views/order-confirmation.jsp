<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Order Confirmed | ShopSphere Pro Cycling" scope="request" />
<jsp:include page="/fragments/header.jsp" />
<jsp:include page="/fragments/navbar.jsp" />

<main class="py-5">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <!-- Confirmation Success Card -->
                <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white text-center mb-4">
                    <div class="d-inline-flex align-items-center justify-content-center bg-success-subtle text-success rounded-circle mx-auto mb-3" 
                         style="width: 72px; height: 72px;">
                        <i class="bi bi-check2-circle fs-1"></i>
                    </div>

                    <h2 class="fw-bold mb-2">Order Confirmed!</h2>
                    <p class="text-muted mb-4">
                        Thank you for your order. We are preparing your bike for specialized pre-assembly, tuning, and freight dispatch.
                    </p>

                    <div class="bg-light rounded-3 p-3 mb-4 text-start border">
                        <div class="row g-2 align-items-center">
                            <div class="col-sm-6">
                                <span class="text-muted small">Order Number:</span>
                                <div class="fw-bold font-monospace text-primary fs-5">
                                    <c:out value="${order.orderNumber}" />
                                </div>
                            </div>
                            <div class="col-sm-6 text-sm-end">
                                <span class="text-muted small">Transaction ID:</span>
                                <div class="fw-semibold font-monospace small text-secondary">
                                    <c:out value="${checkoutResult.payment.transactionId}" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Financial Summary Breakdown -->
                    <div class="card border-0 bg-light rounded-3 p-4 mb-4 text-start">
                        <h6 class="fw-bold mb-3 border-bottom pb-2">Order Breakdown (Server-Verified)</h6>
                        
                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Item Subtotal</span>
                            <span class="fw-semibold">$<c:out value="${checkoutResult.subtotal}" /></span>
                        </div>

                        <c:if test="${checkoutResult.discountAmount gt 0}">
                            <div class="d-flex justify-content-between mb-2 text-success">
                                <span>Promotional Coupon Discount</span>
                                <span class="fw-bold">-$<c:out value="${checkoutResult.discountAmount}" /></span>
                            </div>
                        </c:if>

                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Specialized Freight</span>
                            <c:choose>
                                <c:when test="${checkoutResult.shippingFee le 0}">
                                    <span class="text-success fw-semibold">FREE</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="fw-semibold">$<c:out value="${checkoutResult.shippingFee}" /></span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="d-flex justify-content-between mb-3">
                            <span class="text-muted">Sales Tax</span>
                            <span class="fw-semibold">$<c:out value="${checkoutResult.taxAmount}" /></span>
                        </div>

                        <hr class="my-2">

                        <div class="d-flex justify-content-between align-items-baseline mt-3">
                            <span class="fs-5 fw-bold">Total Charged</span>
                            <span class="fs-4 fw-bold text-primary">$<c:out value="${checkoutResult.totalAmount}" /></span>
                        </div>
                    </div>

                    <!-- Dispatch Assurance -->
                    <div class="p-3 bg-white rounded-3 border text-start d-flex gap-3 align-items-center mb-4">
                        <i class="bi bi-box-seam fs-3 text-warning"></i>
                        <div class="small text-muted">
                            <strong>Warehouse Fleet Notice:</strong> Your bicycle will undergo multi-point mechanical inspection, frame alignment, and gear tuning before being packed into a heavy-duty reinforced carton.
                        </div>
                    </div>

                    <!-- Action CTAs -->
                    <div class="d-flex flex-wrap justify-content-center gap-3">
                        <a href="<c:url value='/products' />" class="btn btn-primary px-4 py-2 fw-semibold">
                            <i class="bi bi-bicycle me-2"></i> Continue Shopping
                        </a>
                        <a href="<c:url value='/orders' />" class="btn btn-outline-secondary px-4 py-2">
                            <i class="bi bi-receipt me-1"></i> View My Orders
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/fragments/footer.jsp" />
