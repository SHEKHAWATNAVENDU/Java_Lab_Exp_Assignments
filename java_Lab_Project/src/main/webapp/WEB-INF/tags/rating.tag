<%@ tag language="java" pageEncoding="UTF-8" description="ShopSphere Star Rating Visualizer Component" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="value" type="java.lang.Double" required="false" description="Numeric rating value (e.g. 4.5)" %>
<%@ attribute name="max" type="java.lang.Integer" required="false" description="Maximum number of stars, defaults to 5" %>

<c:set var="ratingVal" value="${not empty value ? value : 4.8}" />
<c:set var="maxStars" value="${not empty max ? max : 5}" />

<div class="d-inline-flex align-items-center gap-1" title="Rated ${ratingVal} out of ${maxStars}">
    <div class="d-flex align-items-center text-warning" style="font-size: 0.8rem; gap: 2px;">
        <c:forEach var="i" begin="1" end="${maxStars}">
            <c:choose>
                <c:when test="${ratingVal ge i}">
                    <i class="bi bi-star-fill"></i>
                </c:when>
                <c:when test="${ratingVal ge (i - 0.5)}">
                    <i class="bi bi-star-half"></i>
                </c:when>
                <c:otherwise>
                    <i class="bi bi-star text-secondary opacity-25"></i>
                </c:otherwise>
            </c:choose>
        </c:forEach>
    </div>
    <span class="text-muted small ms-1" style="font-size: 0.78rem; font-weight: 600;">
        <c:out value="${ratingVal}" />
    </span>
</div>
