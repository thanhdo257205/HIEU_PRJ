<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - PhoneShop</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="admin-layout">
    <jsp:include page="/common/admin-sidebar.jsp">
        <jsp:param name="active" value="dashboard"/>
    </jsp:include>

    <main class="admin-content">
        <h2>📊 Dashboard</h2>

        <!-- Stats Cards -->
        <div class="stat-cards">
            <div class="stat-card">
                <div class="stat-icon" style="background: #dbeafe; color: #2563eb;">📱</div>
                <div class="stat-value">${totalProducts}</div>
                <div class="stat-label">Sản phẩm</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon" style="background: #dcfce7; color: #16a34a;">💰</div>
                <div class="stat-value"><fmt:formatNumber value="${totalRevenue}" pattern="#,###"/>đ</div>
                <div class="stat-label">Doanh thu</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon" style="background: #fef3c7; color: #d97706;">📋</div>
                <div class="stat-value">${totalOrders}</div>
                <div class="stat-label">Đơn hàng</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon" style="background: #fce7f3; color: #db2777;">🔥</div>
                <div class="stat-value">${totalSold}</div>
                <div class="stat-label">SP đã bán</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon" style="background: #e0e7ff; color: #4f46e5;">👤</div>
                <div class="stat-value">${totalCustomers}</div>
                <div class="stat-label">Khách hàng</div>
            </div>
        </div>

        <!-- Order Status -->
        <div class="review-section">
            <h3 style="margin-bottom: 20px;">📋 Tình trạng đơn hàng</h3>
            <div style="display: grid; grid-template-columns: repeat(5, 1fr); gap: 16px;">
                <div style="text-align: center; padding: 16px; background: #fef3c7; border-radius: var(--radius); ">
                    <div style="font-size: 1.5rem; font-weight: 800; color: #d97706;">${pendingOrders}</div>
                    <div style="font-size: 0.85rem; color: #92400e;">Chờ xác nhận</div>
                </div>
                <div style="text-align: center; padding: 16px; background: #dbeafe; border-radius: var(--radius);">
                    <div style="font-size: 1.5rem; font-weight: 800; color: #2563eb;">${confirmedOrders}</div>
                    <div style="font-size: 0.85rem; color: #1e40af;">Đã xác nhận</div>
                </div>
                <div style="text-align: center; padding: 16px; background: #ede9fe; border-radius: var(--radius);">
                    <div style="font-size: 1.5rem; font-weight: 800; color: #7c3aed;">${shippingOrders}</div>
                    <div style="font-size: 0.85rem; color: #5b21b6;">Đang giao</div>
                </div>
                <div style="text-align: center; padding: 16px; background: #dcfce7; border-radius: var(--radius);">
                    <div style="font-size: 1.5rem; font-weight: 800; color: #16a34a;">${deliveredOrders}</div>
                    <div style="font-size: 0.85rem; color: #15803d;">Đã giao</div>
                </div>
                <div style="text-align: center; padding: 16px; background: #fef2f2; border-radius: var(--radius);">
                    <div style="font-size: 1.5rem; font-weight: 800; color: #dc2626;">${cancelledOrders}</div>
                    <div style="font-size: 0.85rem; color: #991b1b;">Đã hủy</div>
                </div>
            </div>
        </div>

        <!-- Quick Links -->
        <div class="d-flex gap-20 mt-20">
            <a href="${pageContext.request.contextPath}/admin/products?action=add" class="btn-primary">+ Thêm sản phẩm mới</a>
            <a href="${pageContext.request.contextPath}/admin/orders" class="btn-secondary">📋 Quản lý đơn hàng</a>
        </div>
    </main>
</div>

</body>
</html>
