<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>

<c:set var="pageTitle" value="Bicycles &amp; Cycling Gear Catalog | ShopSphere" scope="request" />
<jsp:include page="/fragments/header.jsp" />
<jsp:include page="/fragments/navbar.jsp" />

<main class="py-4">
    <div class="container">
        <!-- Breadcrumb & Header Section -->
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-3 border-bottom">
            <div>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb small mb-1">
                        <li class="breadcrumb-item"><a href="<c:url value='/products' />" class="text-decoration-none text-muted">ShopSphere</a></li>
                        <li class="breadcrumb-item active" aria-current="page">Catalog</li>
                    </ol>
                </nav>
                <h2 class="fw-bold mb-1">
                    <c:choose>
                        <c:when test="${param.category == '1'}">Mountain Bikes (MTB)</c:when>
                        <c:when test="${param.category == '2'}">Road &amp; Racing Bikes</c:when>
                        <c:when test="${param.category == '3'}">Electric Bikes (E-Bikes)</c:when>
                        <c:when test="${param.category == '4'}">Gravel &amp; Adventure Bikes</c:when>
                        <c:when test="${param.category == '5'}">Helmets &amp; Pro Cycling Gear</c:when>
                        <c:when test="${not empty param.q}">Search Results for &ldquo;<c:out value="${param.q}" />&rdquo;</c:when>
                        <c:otherwise>Complete Bicycle &amp; Gear Collection</c:otherwise>
                    </c:choose>
                </h2>
                <p class="text-muted small mb-0">
                    <c:choose>
                        <c:when test="${not empty products}">Showing <strong class="text-dark"><c:out value="${products.size()}" /></strong> verified models in stock</c:when>
                        <c:otherwise>0 models currently available</c:otherwise>
                    </c:choose>
                </p>
            </div>

            <!-- Sorting Dropdown -->
            <div class="d-flex align-items-center gap-2 mt-3 mt-md-0">
                <label for="sortBySelect" class="small text-muted fw-semibold text-nowrap">Sort by:</label>
                <select id="sortBySelect" class="form-select form-select-sm" style="width: auto;" onchange="location = this.value;">
                    <option value="<c:url value='/products?sort=newest${not empty param.category ? \"&category=\" += param.category : \"\"}${not empty param.q ? \"&q=\" += param.q : \"\"}' />" 
                            ${param.sort == 'newest' || empty param.sort ? 'selected' : ''}>Newest First</option>
                    <option value="<c:url value='/products?sort=price_asc${not empty param.category ? \"&category=\" += param.category : \"\"}${not empty param.q ? \"&q=\" += param.q : \"\"}' />" 
                            ${param.sort == 'price_asc' ? 'selected' : ''}>Price: Low to High</option>
                    <option value="<c:url value='/products?sort=price_desc${not empty param.category ? \"&category=\" += param.category : \"\"}${not empty param.q ? \"&q=\" += param.q : \"\"}' />" 
                            ${param.sort == 'price_desc' ? 'selected' : ''}>Price: High to Low</option>
                </select>
            </div>
        </div>

        <div class="row g-4">
            <!-- Sidebar Filters -->
            <div class="col-lg-3">
                <jsp:include page="/fragments/sidebar.jsp" />
            </div>

            <!-- Product Grid -->
            <div class="col-lg-9">
                <c:choose>
                    <c:when test="${not empty products}">
                        <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 g-4">
                            <c:forEach items="${products}" var="product">
                                <div class="col">
                                    <tags:productCard product="${product}" />
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Pagination Controls -->
                        <nav aria-label="Catalog pagination" class="mt-5">
                            <ul class="pagination justify-content-center">
                                <li class="page-item ${param.page le 1 || empty param.page ? 'disabled' : ''}">
                                    <a class="page-link" href="<c:url value='/products?page=${(param.page != null ? param.page : 1) - 1}${not empty param.category ? \"&category=\" += param.category : \"\"}${not empty param.sort ? \"&sort=\" += param.sort : \"\"}' />">
                                        <i class="bi bi-chevron-left me-1"></i> Previous
                                    </a>
                                </li>
                                <li class="page-item active">
                                    <span class="page-link"><c:out value="${param.page != null ? param.page : 1}" /></span>
                                </li>
                                <li class="page-item">
                                    <a class="page-link" href="<c:url value='/products?page=${(param.page != null ? param.page : 1) + 1}${not empty param.category ? \"&category=\" += param.category : \"\"}${not empty param.sort ? \"&sort=\" += param.sort : \"\"}' />">
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
                            <h4 class="fw-bold mb-2">No Products Matched Your Criteria</h4>
                            <p class="text-muted mb-4">Try removing price filters or searching for another bike category.</p>
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

<jsp:include page="/fragments/footer.jsp" />
