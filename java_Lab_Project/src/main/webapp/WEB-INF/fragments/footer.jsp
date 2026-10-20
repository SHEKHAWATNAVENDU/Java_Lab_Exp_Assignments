<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<footer class="footer-premium">
    <div class="container">
        <div class="row g-4 g-lg-5">
            <!-- Brand Column -->
            <div class="col-lg-4 col-md-6">
                <a class="brand-wordmark text-decoration-none mb-3 d-inline-block" href="<c:url value='/products' />">
                    <span class="d-inline-flex align-items-center gap-2">
                        <i class="bi bi-bicycle text-warning fs-3"></i>
                        <span>Shop<span class="text-warning">Sphere</span></span>
                    </span>
                    <span class="brand-subtitle">PRO CYCLING</span>
                </a>
                <p class="small text-muted pe-lg-4">
                    Precision-engineered carbon road machines, rugged trail enduro rigs, smart electric commuter bikes, and certified pro gear. Tested and delivered to your doorstep.
                </p>
                <div class="d-flex gap-3 fs-5 mt-3">
                    <a href="#" class="text-secondary hover-light" aria-label="Follow us on Strava"><i class="bi bi-strava text-warning"></i></a>
                    <a href="#" class="text-secondary hover-light" aria-label="Follow us on Instagram"><i class="bi bi-instagram"></i></a>
                    <a href="#" class="text-secondary hover-light" aria-label="Follow us on YouTube"><i class="bi bi-youtube"></i></a>
                    <a href="#" class="text-secondary hover-light" aria-label="Follow us on X"><i class="bi bi-twitter-x"></i></a>
                </div>
            </div>

            <!-- Categories -->
            <div class="col-lg-2 col-6">
                <h6>Collections</h6>
                <ul class="list-unstyled mb-0">
                    <li><a href="<c:url value='/products?category=1' />" class="footer-link">Mountain Bikes</a></li>
                    <li><a href="<c:url value='/products?category=2' />" class="footer-link">Road &amp; Racing</a></li>
                    <li><a href="<c:url value='/products?category=3' />" class="footer-link">Electric (E-Bikes)</a></li>
                    <li><a href="<c:url value='/products?category=4' />" class="footer-link">Gravel &amp; Adventure</a></li>
                    <li><a href="<c:url value='/products?category=5' />" class="footer-link">Helmets &amp; Gear</a></li>
                </ul>
            </div>

            <!-- Rider Support -->
            <div class="col-lg-2 col-6">
                <h6>Rider Support</h6>
                <ul class="list-unstyled mb-0">
                    <li><a href="#" class="footer-link">Frame Sizing Guide</a></li>
                    <li><a href="#" class="footer-link">Pre-Assembly Info</a></li>
                    <li><a href="#" class="footer-link">2-Year Frame Warranty</a></li>
                    <li><a href="#" class="footer-link">30-Day Ride Guarantee</a></li>
                    <li><a href="#" class="footer-link">Workshop Support</a></li>
                </ul>
            </div>

            <!-- Newsletter Subscription -->
            <div class="col-lg-4 col-md-6">
                <h6>Stay in the Peloton</h6>
                <p class="small text-muted">Subscribe for private launch invites, seasonal route guides, and exclusive discount codes.</p>
                <form class="d-flex gap-2" onsubmit="event.preventDefault(); alert('Thank you for subscribing to ShopSphere Pro Cycling updates!');">
                    <input type="email" class="form-control form-control-sm bg-dark border-secondary text-white" 
                           placeholder="Enter your email address" required>
                    <button class="btn btn-accent btn-sm px-3 text-nowrap" type="submit">Subscribe</button>
                </form>
                <div class="small text-muted mt-2">
                    <i class="bi bi-shield-lock me-1"></i> No spam. Unsubscribe at any time.
                </div>
            </div>
        </div>

        <div class="footer-bottom-bar d-flex flex-column flex-md-row justify-content-between align-items-center gap-3">
            <div class="text-center text-md-start">
                &copy; 2026 ShopSphere Pro Cycling Inc. All rights reserved.
            </div>
            <div class="d-flex align-items-center gap-3">
                <span class="text-muted small">Encrypted Checkout:</span>
                <span class="badge bg-secondary-subtle text-light border border-secondary px-2 py-1 small">
                    <i class="bi bi-shield-check text-success me-1"></i> SSL 256-Bit
                </span>
                <span class="text-secondary fs-5"><i class="bi bi-credit-card-2-front"></i></span>
                <span class="text-secondary fs-5"><i class="bi bi-paypal"></i></span>
            </div>
        </div>
    </div>
</footer>

<!-- Bootstrap 5.3.3 JavaScript Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/bundle.min.js" 
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
</body>
</html>
