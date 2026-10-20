<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Secure Checkout | ShopSphere Pro Cycling" scope="request" />
<jsp:include page="/fragments/header.jsp" />
<jsp:include page="/fragments/navbar.jsp" />

<main class="py-5">
    <div class="container">
        <!-- Title & Breadcrumb -->
        <div class="mb-4 pb-3 border-bottom">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb small mb-1">
                    <li class="breadcrumb-item"><a href="<c:url value='/products' />" class="text-decoration-none text-muted">ShopSphere</a></li>
                    <li class="breadcrumb-item"><a href="<c:url value='/cart' />" class="text-decoration-none text-muted">Cart</a></li>
                    <li class="breadcrumb-item active" aria-current="page">Secure Checkout</li>
                </ol>
            </nav>
            <h2 class="fw-bold mb-1">Secure Checkout</h2>
            <p class="text-muted small mb-0">Complete your delivery address and choose your payment method.</p>
        </div>

        <!-- Validation Alerts -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show shadow-sm d-flex align-items-center gap-2 mb-4" role="alert">
                <i class="bi bi-check-circle-fill fs-5"></i>
                <div><c:out value="${successMessage}" /></div>
                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show shadow-sm d-flex align-items-center gap-2 mb-4" role="alert">
                <i class="bi bi-exclamation-octagon-fill fs-5"></i>
                <div><c:out value="${errorMessage}" /></div>
                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- Checkout Form -->
        <form method="POST" action="<c:url value='/checkout' />" id="checkoutForm">
            <div class="row g-4">
                <!-- Left: Checkout Steps -->
                <div class="col-lg-8">
                    <!-- Step 1: Shipping Address -->
                    <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white mb-4">
                        <div class="d-flex align-items-center gap-2 mb-4 pb-2 border-bottom">
                            <span class="badge bg-dark rounded-circle p-2 text-white" style="width: 32px; height: 32px; display: inline-flex; align-items: center; justify-content: center;">1</span>
                            <h5 class="fw-bold mb-0">Delivery &amp; Shipping Address</h5>
                        </div>

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Recipient Full Name</label>
                                <input type="text" name="recipientName" class="form-control" 
                                       value="<c:out value='${sessionScope.user.firstName} ${sessionScope.user.lastName}' />" required>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label">Contact Phone</label>
                                <input type="tel" name="phoneNumber" class="form-control" 
                                       placeholder="+1 (555) 000-0000" 
                                       value="<c:out value='${sessionScope.user.phoneNumber}' />" required>
                            </div>

                            <div class="col-12">
                                <label class="form-label">Street Address</label>
                                <input type="text" name="streetAddress" class="form-control" 
                                       placeholder="1234 Cycling Blvd, Suite 400" required>
                            </div>

                            <div class="col-md-5">
                                <label class="form-label">City</label>
                                <input type="text" name="city" class="form-control" placeholder="Seattle" required>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label">State / Province</label>
                                <input type="text" name="state" class="form-control" placeholder="WA" required>
                            </div>

                            <div class="col-md-3">
                                <label class="form-label">Postal / ZIP Code</label>
                                <input type="text" name="postalCode" class="form-control" placeholder="98101" required>
                            </div>
                        </div>

                        <!-- Retain database foreign key references -->
                        <input type="hidden" name="shippingAddressId" value="1"/>
                        <input type="hidden" name="billingAddressId" value="1"/>
                    </div>

                    <!-- Step 2: Promotional Coupon Voucher -->
                    <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white mb-4">
                        <div class="d-flex align-items-center gap-2 mb-4 pb-2 border-bottom">
                            <span class="badge bg-dark rounded-circle p-2 text-white" style="width: 32px; height: 32px; display: inline-flex; align-items: center; justify-content: center;">2</span>
                            <h5 class="fw-bold mb-0">Promotional Voucher Code</h5>
                        </div>

                        <div class="row g-3 align-items-center">
                            <div class="col-md-8">
                                <label for="couponCode" class="form-label">Have a cycling discount voucher?</label>
                                <div class="input-group">
                                    <span class="input-group-text bg-light"><i class="bi bi-tag text-muted"></i></span>
                                    <input type="text" name="couponCode" id="couponCode" class="form-control font-monospace text-uppercase" 
                                           placeholder="e.g. BIKE10 or RIDE50" value="<c:out value='${param.couponCode}' />">
                                </div>
                                <small class="text-muted">Discounts are calculated and verified server-side on submission.</small>
                            </div>
                            <div class="col-md-4 text-md-end mt-md-4">
                                <div class="badge bg-warning-subtle text-dark border border-warning p-2 small">
                                    <i class="bi bi-ticket-perforated me-1"></i> Try 'BIKE10' or 'RIDE50'
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Step 3: Payment Method -->
                    <div class="card border-0 shadow-sm rounded-4 p-4 p-md-5 bg-white">
                        <div class="d-flex align-items-center gap-2 mb-4 pb-2 border-bottom">
                            <span class="badge bg-dark rounded-circle p-2 text-white" style="width: 32px; height: 32px; display: inline-flex; align-items: center; justify-content: center;">3</span>
                            <h5 class="fw-bold mb-0">Payment Method</h5>
                        </div>

                        <div class="row g-3 mb-4">
                            <div class="col-md-4">
                                <label class="payment-method-card d-block h-100" for="payCreditCard">
                                    <div class="form-check p-0 m-0">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <i class="bi bi-credit-card-2-front text-primary fs-3"></i>
                                            <input class="form-check-input" type="radio" name="paymentMethod" id="payCreditCard" value="credit_card" checked>
                                        </div>
                                        <div class="fw-bold text-dark">Credit Card</div>
                                        <small class="text-muted">Visa, Mastercard, Amex</small>
                                    </div>
                                </label>
                            </div>

                            <div class="col-md-4">
                                <label class="payment-method-card d-block h-100" for="payPayPal">
                                    <div class="form-check p-0 m-0">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <i class="bi bi-paypal text-primary fs-3"></i>
                                            <input class="form-check-input" type="radio" name="paymentMethod" id="payPayPal" value="paypal">
                                        </div>
                                        <div class="fw-bold text-dark">PayPal</div>
                                        <small class="text-muted">Instant account debit</small>
                                    </div>
                                </label>
                            </div>

                            <div class="col-md-4">
                                <label class="payment-method-card d-block h-100" for="payCOD">
                                    <div class="form-check p-0 m-0">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <i class="bi bi-cash-stack text-success fs-3"></i>
                                            <input class="form-check-input" type="radio" name="paymentMethod" id="payCOD" value="cod">
                                        </div>
                                        <div class="fw-bold text-dark">Cash on Delivery</div>
                                        <small class="text-muted">Pay on bike arrival</small>
                                    </div>
                                </label>
                            </div>
                        </div>

                        <!-- Delivery Notes -->
                        <div>
                            <label for="orderNotes" class="form-label text-muted">Delivery Notes or Assembly Instructions (Optional)</label>
                            <textarea id="orderNotes" name="notes" class="form-control" rows="2" 
                                      placeholder="Gate instructions, preferred delivery schedule, or rider fit notes..."></textarea>
                        </div>
                    </div>
                </div>

                <!-- Right: Sticky Order Summary & Submission -->
                <div class="col-lg-4">
                    <div class="order-summary-card sticky-top" style="top: 100px;">
                        <h5 class="fw-bold mb-3 border-bottom pb-2">Order Summary</h5>

                        <div class="summary-row">
                            <span class="text-muted">Cart Subtotal</span>
                            <span class="fw-semibold">Calculated from Catalog</span>
                        </div>

                        <div class="summary-row">
                            <span class="text-muted">Promotional Voucher</span>
                            <span class="text-success fw-bold">Applied on submission</span>
                        </div>

                        <div class="summary-row">
                            <span class="text-muted">Specialized Freight</span>
                            <span class="text-success fw-semibold small">FREE on orders over $100</span>
                        </div>

                        <div class="summary-row mb-3">
                            <span class="text-muted">Estimated Tax</span>
                            <span class="text-muted small">8% Standard Rate</span>
                        </div>

                        <div class="p-3 bg-light rounded-3 border small text-muted mb-3">
                            <i class="bi bi-shield-lock-fill text-success me-1"></i>
                            <strong>Verified Checkout:</strong> Ships in reinforced bike carton with tuning instructions and assembly multi-tool.
                        </div>

                        <div class="d-grid mb-3">
                            <button type="submit" class="btn btn-accent btn-lg fw-bold d-flex align-items-center justify-content-center gap-2">
                                <i class="bi bi-shield-check fs-5"></i>
                                <span>Place Order</span>
                            </button>
                        </div>

                        <div class="text-center small text-muted">
                            <i class="bi bi-lock me-1"></i> SSL 256-Bit Encrypted Server Processing
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</main>

<jsp:include page="/fragments/footer.jsp" />
