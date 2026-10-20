<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="pageTitle" value="Sign In | ShopSphere Pro Cycling" scope="request" />
<jsp:include page="/fragments/header.jsp" />
<jsp:include page="/fragments/navbar.jsp" />

<main class="auth-wrapper">
    <div class="auth-card">
        <div class="auth-header">
            <a class="auth-brand text-decoration-none" href="<c:url value='/products' />">
                <i class="bi bi-bicycle text-warning fs-2"></i>
                <span>Shop<span class="text-warning">Sphere</span></span>
            </a>
            <h4 class="fw-bold mt-2 mb-1">Welcome Back</h4>
            <p class="text-muted small mb-0">Sign in to your rider account to access orders and checkout.</p>
        </div>

        <!-- Success Alert (Registration Redirect) -->
        <c:if test="${param.registered == 'true'}">
            <div class="alert alert-success d-flex align-items-center gap-2 small mb-4" role="alert">
                <i class="bi bi-check-circle-fill fs-5"></i>
                <div>Your account has been created successfully! Please sign in below.</div>
            </div>
        </c:if>

        <!-- Error Alert -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger d-flex align-items-center gap-2 small mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill fs-5"></i>
                <div><c:out value="${error}" /></div>
            </div>
        </c:if>

        <!-- Login Form -->
        <form method="POST" action="<c:url value='/login' />">
            <input type="hidden" name="redirect" value="<c:out value='${redirectUrl != null ? redirectUrl : param.redirect}' />"/>

            <div class="mb-3">
                <label for="email" class="form-label">Email Address</label>
                <div class="input-group">
                    <span class="input-group-text bg-light text-muted"><i class="bi bi-envelope"></i></span>
                    <input type="email" id="email" name="email" class="form-control" 
                           placeholder="rider@example.com" required autofocus>
                </div>
            </div>

            <div class="mb-4">
                <div class="d-flex justify-content-between align-items-center mb-1">
                    <label for="password" class="form-label mb-0">Password</label>
                    <a href="#" class="small text-muted text-decoration-none">Forgot password?</a>
                </div>
                <div class="input-group">
                    <span class="input-group-text bg-light text-muted"><i class="bi bi-lock"></i></span>
                    <input type="password" id="password" name="password" class="form-control" 
                           placeholder="Enter your password" required>
                </div>
            </div>

            <div class="d-grid mb-3">
                <button type="submit" class="btn btn-accent btn-lg fw-bold">
                    Sign In
                </button>
            </div>
        </form>

        <div class="text-center mt-4 pt-3 border-top small text-muted">
            Don't have an account yet? 
            <a href="<c:url value='/register' />" class="fw-bold text-dark text-decoration-none ms-1">
                Create Account &rarr;
            </a>
        </div>
    </div>
</main>

<jsp:include page="/fragments/footer.jsp" />
