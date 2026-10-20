<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Customer Orders Management | ShopSphere Admin" scope="request" />
<jsp:include page="/fragments/header.jsp" />
<jsp:include page="/fragments/navbar.jsp" />

<main class="py-4">
    <div class="container-fluid px-lg-5">
        <!-- Header -->
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-3 border-bottom">
            <div>
                <h2 class="fw-bold mb-1"><i class="bi bi-receipt me-2 text-warning"></i>Customer Orders</h2>
                <p class="text-muted small mb-0">Track order fulfillments, manage shipment statuses, and view transaction records.</p>
            </div>
            <div class="mt-2 mt-md-0">
                <button class="btn btn-outline-primary btn-sm d-flex align-items-center gap-2" onclick="alert('Exporting verified order list CSV...');">
                    <i class="bi bi-download"></i> Export Orders CSV
                </button>
            </div>
        </div>

        <div class="row g-4">
            <!-- Left: Admin Sidebar -->
            <div class="col-lg-3 col-xl-2">
                <jsp:include page="/admin/sidebar.jsp" />
            </div>

            <!-- Right: Orders Table & Status Indicators -->
            <div class="col-lg-9 col-xl-10">
                <!-- Status Filter Pills -->
                <div class="d-flex flex-wrap gap-2 mb-3">
                    <button class="btn btn-primary btn-sm rounded-pill px-3">All Orders (384)</button>
                    <button class="btn btn-outline-primary btn-sm rounded-pill px-3">Pending (12)</button>
                    <button class="btn btn-outline-primary btn-sm rounded-pill px-3">Processing (24)</button>
                    <button class="btn btn-outline-primary btn-sm rounded-pill px-3">Shipped (45)</button>
                    <button class="btn btn-outline-primary btn-sm rounded-pill px-3">Delivered (285)</button>
                    <button class="btn btn-outline-primary btn-sm rounded-pill px-3">Cancelled (18)</button>
                </div>

                <!-- Orders Table Card -->
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden bg-white">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light small text-uppercase text-secondary">
                                <tr>
                                    <th scope="col" class="ps-4">Order ID</th>
                                    <th scope="col">Customer</th>
                                    <th scope="col">Date Placed</th>
                                    <th scope="col" class="text-center">Items</th>
                                    <th scope="col" class="text-end">Total Amount</th>
                                    <th scope="col" class="text-center">Status</th>
                                    <th scope="col" class="text-center pe-4">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- Example 1: Delivered -->
                                <tr>
                                    <td class="font-monospace fw-bold ps-4 text-dark">ORD-2026-1001</td>
                                    <td>
                                        <div class="fw-bold text-dark">Jane Doe</div>
                                        <small class="text-muted">customer@shopsphere.com</small>
                                    </td>
                                    <td class="small text-muted">Oct 05, 2026 14:22</td>
                                    <td class="text-center">2 items</td>
                                    <td class="text-end fw-bold text-dark">$1,049.49</td>
                                    <td class="text-center">
                                        <span class="badge bg-success-subtle text-success border border-success-subtle px-3 py-1">
                                            <i class="bi bi-check2-circle me-1"></i> Delivered
                                        </span>
                                    </td>
                                    <td class="text-center pe-4">
                                        <div class="btn-group btn-group-sm">
                                            <button class="btn btn-outline-secondary" title="View Order Details"><i class="bi bi-eye"></i></button>
                                            <button class="btn btn-outline-secondary" title="Print Invoice"><i class="bi bi-printer"></i></button>
                                        </div>
                                    </td>
                                </tr>

                                <!-- Example 2: Pending -->
                                <tr>
                                    <td class="font-monospace fw-bold ps-4 text-dark">ORD-2026-1002</td>
                                    <td>
                                        <div class="fw-bold text-dark">Michael Smith</div>
                                        <small class="text-muted">michael.s@example.com</small>
                                    </td>
                                    <td class="small text-muted">Oct 06, 2026 08:15</td>
                                    <td class="text-center">1 item</td>
                                    <td class="text-end fw-bold text-dark">$699.00</td>
                                    <td class="text-center">
                                        <span class="badge bg-warning-subtle text-dark border border-warning px-3 py-1">
                                            <i class="bi bi-hourglass-split me-1"></i> Pending
                                        </span>
                                    </td>
                                    <td class="text-center pe-4">
                                        <div class="btn-group btn-group-sm">
                                            <button class="btn btn-outline-secondary" title="View Order Details"><i class="bi bi-eye"></i></button>
                                            <button class="btn btn-accent" title="Approve Order"><i class="bi bi-check-lg"></i></button>
                                        </div>
                                    </td>
                                </tr>

                                <!-- Example 3: Processing -->
                                <tr>
                                    <td class="font-monospace fw-bold ps-4 text-dark">ORD-2026-1003</td>
                                    <td>
                                        <div class="fw-bold text-dark">Sarah Jenkins</div>
                                        <small class="text-muted">sarah.j@example.com</small>
                                    </td>
                                    <td class="small text-muted">Oct 06, 2026 02:40</td>
                                    <td class="text-center">3 items</td>
                                    <td class="text-end fw-bold text-dark">$249.98</td>
                                    <td class="text-center">
                                        <span class="badge bg-info-subtle text-dark border border-info-subtle px-3 py-1">
                                            <i class="bi bi-gear-fill me-1"></i> Processing
                                        </span>
                                    </td>
                                    <td class="text-center pe-4">
                                        <div class="btn-group btn-group-sm">
                                            <button class="btn btn-outline-secondary" title="View Order Details"><i class="bi bi-eye"></i></button>
                                            <button class="btn btn-primary" title="Mark Dispatched"><i class="bi bi-truck"></i></button>
                                        </div>
                                    </td>
                                </tr>

                                <!-- Example 4: Cancelled -->
                                <tr>
                                    <td class="font-monospace fw-bold ps-4 text-dark">ORD-2026-1004</td>
                                    <td>
                                        <div class="fw-bold text-dark">Robert Davis</div>
                                        <small class="text-muted">rdavis@example.org</small>
                                    </td>
                                    <td class="small text-muted">Oct 04, 2026 19:10</td>
                                    <td class="text-center">1 item</td>
                                    <td class="text-end fw-bold text-dark">$129.99</td>
                                    <td class="text-center">
                                        <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-3 py-1">
                                            <i class="bi bi-x-circle-fill me-1"></i> Cancelled
                                        </span>
                                    </td>
                                    <td class="text-center pe-4">
                                        <div class="btn-group btn-group-sm">
                                            <button class="btn btn-outline-secondary" title="View Order Details"><i class="bi bi-eye"></i></button>
                                            <button class="btn btn-outline-danger" title="Refund Log"><i class="bi bi-arrow-counterclockwise"></i></button>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/fragments/footer.jsp" />
