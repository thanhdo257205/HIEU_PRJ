<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch Sử Đơn Hàng - PhoneShop</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/common/header.jsp" />

<div class="container" style="padding: 30px 20px; max-width: 900px;">
    <h2 style="font-size: 1.5rem; font-weight: 700; margin-bottom: 24px;">📋 Lịch Sử Đơn Hàng</h2>

    <c:if test="${not empty orders}">
        <c:forEach var="order" items="${orders}">
            <div class="order-card">
                <div class="order-card-header">
                    <div>
                        <span class="order-id">Đơn hàng #${order.orderId}</span>
                        <span class="text-muted" style="margin-left: 12px; font-size: 0.85rem;">
                            <fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/>
                        </span>
                    </div>
                    <span class="status-badge" style="background: ${order.statusColor};">
                        ${order.statusText}
                    </span>
                </div>
                <div class="d-flex justify-between align-center">
                    <span class="text-muted">📍 ${order.shippingAddress}</span>
                    <div class="d-flex align-center gap-10">
                        <span class="fw-bold text-danger" style="font-size: 1.1rem;">
                            <fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/>đ
                        </span>
                        <a href="${pageContext.request.contextPath}/orders?action=detail&id=${order.orderId}" class="btn-primary btn-sm">
                            Xem chi tiết
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </c:if>

    <c:if test="${empty orders}">
        <div class="empty-state">
            <div class="empty-icon">📋</div>
            <h3>Chưa có đơn hàng nào</h3>
            <p>Hãy mua sắm để có đơn hàng đầu tiên!</p>
            <a href="${pageContext.request.contextPath}/search" class="btn-primary mt-20">🛍️ Mua sắm ngay</a>
        </div>
    </c:if>
</div>

<jsp:include page="/common/footer.jsp" />
</body>
</html>
