<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- Admin Sidebar -->
<div class="admin-sidebar">
    <div style="padding: 0 24px 20px; border-bottom: 1px solid rgba(255,255,255,0.1);">
        <a href="${pageContext.request.contextPath}/home" class="navbar-brand" style="color: white; font-size: 1.2rem;">
            <div class="logo-icon" style="width: 32px; height: 32px; font-size: 1rem;">📱</div>
            PhoneShop
        </a>
    </div>

    <div class="sidebar-title">Tổng quan</div>
    <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-link ${param.active == 'dashboard' ? 'active' : ''}">
        📊 Dashboard
    </a>

    <div class="sidebar-title">Quản lý</div>
    <a href="${pageContext.request.contextPath}/admin/products" class="sidebar-link ${param.active == 'products' ? 'active' : ''}">
        📱 Sản phẩm
    </a>
    <a href="${pageContext.request.contextPath}/admin/orders" class="sidebar-link ${param.active == 'orders' ? 'active' : ''}">
        📋 Đơn hàng
    </a>

    <div class="sidebar-title">Tài khoản</div>
    <a href="${pageContext.request.contextPath}/home" class="sidebar-link">🏠 Về trang chủ</a>
    <a href="${pageContext.request.contextPath}/logout" class="sidebar-link">🚪 Đăng xuất</a>
</div>
