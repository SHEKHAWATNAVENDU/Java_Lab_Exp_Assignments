<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="admin-sidebar-nav">
    <div class="d-flex align-items-center gap-2 mb-3 pb-2 border-bottom">
        <i class="bi bi-shield-lock-fill text-danger fs-5"></i>
        <span class="fw-bold text-uppercase small" style="letter-spacing: 0.08em;">Store Admin</span>
    </div>

    <!-- Manager Navigation Links -->
    <div class="d-flex flex-column">
        <a href="<c:url value='/admin/dashboard.jsp' />" 
           class="admin-sidebar-link ${pageContext.request.requestURI.endsWith('dashboard.jsp') ? 'active' : ''}">
            <i class="bi bi-speedometer2"></i>
            <span>Dashboard</span>
        </a>
        <a href="<c:url value='/products' />" 
           class="admin-sidebar-link">
            <i class="bi bi-box-seam"></i>
            <span>Products Catalog</span>
        </a>
        <a href="<c:url value='/admin/orders.jsp' />" 
           class="admin-sidebar-link ${pageContext.request.requestURI.endsWith('orders.jsp') ? 'active' : ''}">
            <i class="bi bi-receipt"></i>
            <span>Customer Orders</span>
        </a>
    </div>

    <div class="mt-4 pt-3 border-top">
        <a href="<c:url value='/products' />" class="btn btn-outline-primary btn-sm w-100 d-flex align-items-center justify-content-center gap-2">
            <i class="bi bi-box-arrow-up-right"></i>
            <span>View Storefront</span>
        </a>
    </div>
</div>
