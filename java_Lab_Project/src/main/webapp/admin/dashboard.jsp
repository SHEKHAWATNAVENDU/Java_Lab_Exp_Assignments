<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Store Manager Dashboard | ShopSphere Admin" scope="request" />
<jsp:include page="/fragments/header.jsp" />
<jsp:include page="/fragments/navbar.jsp" />

<main class="py-4">
    <div class="container-fluid px-lg-5">
        <!-- Dashboard Header -->
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 pb-3 border-bottom">
            <div>
                <h2 class="fw-bold mb-1"><i class="bi bi-speedometer2 me-2 text-warning"></i>Store Operations Dashboard</h2>
                <p class="text-muted small mb-0">Live fleet inventory levels, order dispatch pipeline, and verified store analytics.</p>
            </div>
            <div class="mt-2 mt-md-0">
                <span class="badge bg-dark text-white px-3 py-2 fw-semibold border">
                    <i class="bi bi-shield-check text-warning me-1"></i> Administrator Role Active
                </span>
            </div>
        </div>

        <div class="row g-4">
            <!-- Left: Admin Sidebar -->
            <div class="col-lg-3 col-xl-2">
                <jsp:include page="/admin/sidebar.jsp" />
            </div>

            <!-- Right: Metric KPI Cards & Tables -->
            <div class="col-lg-9 col-xl-10">
                <!-- KPI Metric Cards Grid -->
                <div class="row g-3 mb-4">
                    <div class="col-sm-6 col-xl-3">
                        <div class="admin-metric-card h-100">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <span class="text-muted small text-uppercase fw-bold" style="letter-spacing: 0.05em;">Total Sales</span>
                                    <h3 class="fw-bold mb-1 mt-2 text-dark">$48,920.50</h3>
                                    <span class="small text-success fw-semibold"><i class="bi bi-arrow-up-right me-1"></i>+12.4% vs last mo</span>
                                </div>
                                <div class="admin-metric-icon bg-light text-primary border">
                                    <i class="bi bi-currency-dollar"></i>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-6 col-xl-3">
                        <div class="admin-metric-card h-100">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <span class="text-muted small text-uppercase fw-bold" style="letter-spacing: 0.05em;">Active Riders</span>
                                    <h3 class="fw-bold mb-1 mt-2 text-dark">1,428</h3>
                                    <span class="small text-muted"><i class="bi bi-people me-1"></i>Verified Cyclists</span>
                                </div>
                                <div class="admin-metric-icon bg-light text-warning border">
                                    <i class="bi bi-bicycle"></i>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-6 col-xl-3">
                        <div class="admin-metric-card h-100">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <span class="text-muted small text-uppercase fw-bold" style="letter-spacing: 0.05em;">Total Orders</span>
                                    <h3 class="fw-bold mb-1 mt-2 text-dark">384</h3>
                                    <span class="small text-warning fw-semibold"><i class="bi bi-clock-history me-1"></i>12 Pending Dispatch</span>
                                </div>
                                <div class="admin-metric-icon bg-light text-warning border">
                                    <i class="bi bi-box-seam"></i>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-6 col-xl-3">
                        <div class="admin-metric-card h-100">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <span class="text-muted small text-uppercase fw-bold" style="letter-spacing: 0.05em;">Inventory Alerts</span>
                                    <h3 class="fw-bold mb-1 mt-2 text-danger">3 Models</h3>
                                    <span class="small text-danger fw-semibold"><i class="bi bi-exclamation-triangle me-1"></i>Restock Required</span>
                                </div>
                                <div class="admin-metric-icon bg-danger-subtle text-danger border border-danger-subtle">
                                    <i class="bi bi-graph-down-arrow"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Low Stock Fleet Inventory Table -->
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4 bg-white">
                    <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center border-bottom">
                        <h5 class="fw-bold mb-0 text-dark d-flex align-items-center gap-2">
                            <i class="bi bi-exclamation-octagon-fill text-warning"></i>
                            Warehouse Fleet Inventory Monitor
                        </h5>
                        <span class="badge bg-warning-subtle text-dark border border-warning px-2 py-1">Threshold: &le; 15 Units</span>
                    </div>

                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-light small text-uppercase text-secondary">
                                <tr>
                                    <th scope="col" class="ps-4">SKU</th>
                                    <th scope="col">Bike Model &amp; Spec</th>
                                    <th scope="col">Category</th>
                                    <th scope="col" class="text-center">Current Stock</th>
                                    <th scope="col" class="text-end">Unit Price</th>
                                    <th scope="col" class="text-center">Status</th>
                                    <th scope="col" class="text-center pe-4">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td class="font-monospace fw-bold ps-4">BIKE-EBK-003</td>
                                    <td>
                                        <div class="fw-bold text-dark">VoltDrive Commuter E-Bike 750W</div>
                                        <small class="text-muted">48V 14Ah battery, 45-mile pedal assist range</small>
                                    </td>
                                    <td><span class="badge bg-light text-secondary border">E-Bikes</span></td>
                                    <td class="text-center">
                                        <span class="badge bg-warning-subtle text-dark border border-warning px-2 py-1 fw-bold">8 Units</span>
                                    </td>
                                    <td class="text-end fw-bold">$1,499.00</td>
                                    <td class="text-center">
                                        <span class="badge bg-success-subtle text-success">Active</span>
                                    </td>
                                    <td class="text-center pe-4">
                                        <button class="btn btn-outline-primary btn-sm px-3">
                                            <i class="bi bi-plus-circle me-1"></i> Restock
                                        </button>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="font-monospace fw-bold ps-4">BIKE-MTB-002</td>
                                    <td>
                                        <div class="fw-bold text-dark">TrailBlazer Full-Suspension 29er MTB</div>
                                        <small class="text-muted">150mm air travel, hydraulic disc brakes, 1x12 drivetrain</small>
                                    </td>
                                    <td><span class="badge bg-light text-secondary border">Mountain (MTB)</span></td>
                                    <td class="text-center">
                                        <span class="badge bg-warning-subtle text-dark border border-warning px-2 py-1 fw-bold">12 Units</span>
                                    </td>
                                    <td class="text-end fw-bold">$1,899.00</td>
                                    <td class="text-center">
                                        <span class="badge bg-success-subtle text-success">Active</span>
                                    </td>
                                    <td class="text-center pe-4">
                                        <button class="btn btn-outline-primary btn-sm px-3">
                                            <i class="bi bi-plus-circle me-1"></i> Restock
                                        </button>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="font-monospace fw-bold ps-4">BIKE-ACC-009</td>
                                    <td>
                                        <div class="fw-bold text-dark">PhotonBeast 1200LM Bike Light Set</div>
                                        <small class="text-muted">IPX6 waterproof USB-C rechargeable headlight &amp; taillight</small>
                                    </td>
                                    <td><span class="badge bg-light text-secondary border">Gear &amp; Helmets</span></td>
                                    <td class="text-center">
                                        <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-2 py-1 fw-bold">4 Units</span>
                                    </td>
                                    <td class="text-end fw-bold">$69.99</td>
                                    <td class="text-center">
                                        <span class="badge bg-danger-subtle text-danger">Critical</span>
                                    </td>
                                    <td class="text-center pe-4">
                                        <button class="btn btn-accent btn-sm px-3">
                                            <i class="bi bi-arrow-repeat me-1"></i> Urgent Reorder
                                        </button>
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
