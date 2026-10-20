<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Create Rider Account | ShopSphere Pro Cycling" scope="request" />
<jsp:include page="/fragments/header.jsp" />
<jsp:include page="/fragments/navbar.jsp" />

<main class="auth-wrapper">
    <div class="auth-card" style="max-width: 520px;">
        <div class="auth-header">
            <a class="auth-brand text-decoration-none" href="<c:url value='/products' />">
                <i class="bi bi-bicycle text-warning fs-2"></i>
                <span>Shop<span class="text-warning">Sphere</span></span>
            </a>
            <h4 class="fw-bold mt-2 mb-1">Create Your Account</h4>
            <p class="text-muted small mb-0">Join the ShopSphere cycling community for order tracking and exclusive discounts.</p>
        </div>

        <!-- Error Alert -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger d-flex align-items-center gap-2 small mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill fs-5"></i>
                <div><c:out value="${error}" /></div>
            </div>
        </c:if>

        <!-- Registration Form -->
        <form method="POST" action="<c:url value='/register' />">
            <div class="row g-3 mb-3">
                <div class="col-sm-6">
                    <label for="firstName" class="form-label">First Name</label>
                    <input type="text" id="firstName" name="firstName" class="form-control" 
                           placeholder="John" required autofocus>
                </div>
                <div class="col-sm-6">
                    <label for="lastName" class="form-label">Last Name</label>
                    <input type="text" id="lastName" name="lastName" class="form-control" 
                           placeholder="Doe" required>
                </div>
            </div>

            <div class="mb-3">
                <label for="regEmail" class="form-label">Email Address</label>
                <div class="input-group">
                    <span class="input-group-text bg-light text-muted"><i class="bi bi-envelope"></i></span>
                    <input type="email" id="regEmail" name="email" class="form-control" 
                           placeholder="rider@example.com" required>
                </div>
            </div>

            <div class="mb-3">
                <label for="regPassword" class="form-label">Password (Min. 8 characters)</label>
                <div class="input-group">
                    <span class="input-group-text bg-light text-muted"><i class="bi bi-lock"></i></span>
                    <input type="password" id="regPassword" name="password" class="form-control" 
                           placeholder="Create secure password" minlength="8" required>
                </div>
                <small class="text-muted" style="font-size: 0.75rem;">Must be at least 8 characters with letters and numbers.</small>
            </div>

            <div class="mb-4">
                <label for="phoneNumber" class="form-label">Phone Number (Optional)</label>
                <div class="input-group">
                    <span class="input-group-text bg-light text-muted"><i class="bi bi-telephone"></i></span>
                    <input type="tel" id="phoneNumber" name="phoneNumber" class="form-control" 
                           placeholder="+1 (555) 000-0000">
                </div>
            </div>

            <div class="d-grid mb-3">
                <button type="submit" class="btn btn-accent btn-lg fw-bold">
                    Create Account
                </button>
            </div>
        </form>

        <div class="text-center mt-4 pt-3 border-top small text-muted">
            Already have an account? 
            <a href="<c:url value='/login' />" class="fw-bold text-dark text-decoration-none ms-1">
                Sign In &rarr;
            </a>
        </div>
    </div>
</main>

<jsp:include page="/fragments/footer.jsp" />
