<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<nav class="navbar">
    <div class="container">
        <a href="${pageContext.request.contextPath}/home" class="navbar-brand">
            <div class="logo-icon">📱</div>
            PhoneShop
        </a>

        <form class="navbar-search" id="navbar-search-form" action="${pageContext.request.contextPath}/search" method="get">
            <span class="search-icon">🔍</span>
            <input type="text" name="keyword" placeholder="Tìm kiếm điện thoại..." value="${param.keyword}">
        </form>

        <div class="navbar-actions">
            <c:if test="${sessionScope.user != null}">
                <a href="${pageContext.request.contextPath}/cart" class="nav-btn cart-btn">
                    🛒 Giỏ hàng
                </a>
                <a href="${pageContext.request.contextPath}/orders" class="nav-btn">📋 Đơn hàng</a>
                <c:if test="${sessionScope.user.admin}">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-btn" style="color: var(--secondary);">
                        ⚙️ Admin
                    </a>
                </c:if>
                <span class="nav-btn" style="font-weight: 600;">👤 ${sessionScope.user.fullName}</span>
                <a href="${pageContext.request.contextPath}/logout" class="nav-btn" style="color:var(--danger);">Đăng xuất</a>
            </c:if>
            <c:if test="${sessionScope.user == null}">
                <a href="${pageContext.request.contextPath}/login" class="btn-primary">Đăng nhập</a>
                <a href="${pageContext.request.contextPath}/register" class="btn-outline" style="padding: 10px 24px;">Đăng ký</a>
            </c:if>
        </div>
    </div>
</nav>
