<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Đơn Hàng #${order.orderId} - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="admin-layout">
    <jsp:include page="/common/admin-sidebar.jsp">
        <jsp:param name="active" value="orders"/>
    </jsp:include>

    <main class="admin-content">
        <a href="${pageContext.request.contextPath}/admin/orders" style="color: var(--primary); font-weight: 600; margin-bottom: 16px; display: inline-block;">
            ← Quay lại danh sách
        </a>

        <div class="review-section">
            <div class="d-flex justify-between align-center mb-20">
                <h2 style="margin-bottom: 0;">Đơn hàng #${order.orderId}</h2>
                <span class="status-badge" style="background: ${order.statusColor}; font-size: 0.9rem; padding: 6px 16px;">${order.statusText}</span>
            </div>

            <!-- Order Info -->
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 24px; padding: 20px; background: var(--gray-100); border-radius: var(--radius);">
                <div><span class="text-muted">Khách hàng:</span><br><strong>${order.customerName}</strong></div>
                <div><span class="text-muted">Ngày đặt:</span><br><strong><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></strong></div>
                <div><span class="text-muted">Số điện thoại:</span><br><strong>${order.phone}</strong></div>
                <div><span class="text-muted">Địa chỉ:</span><br><strong>${order.shippingAddress}</strong></div>
                <c:if test="${order.note != null && !order.note.isEmpty()}">
                    <div style="grid-column: 1 / -1;"><span class="text-muted">Ghi chú:</span><br><strong>${order.note}</strong></div>
                </c:if>
            </div>

            <!-- Update Status -->
            <div style="margin-bottom: 24px; padding: 20px; background: #eff6ff; border-radius: var(--radius);">
                <h4 style="margin-bottom: 12px;">🔄 Cập nhật trạng thái</h4>
                <form action="${pageContext.request.contextPath}/admin/orders" method="post" class="d-flex gap-10 align-center">
                    <input type="hidden" name="orderId" value="${order.orderId}">
                    <select name="status" style="padding: 10px 16px; border: 2px solid var(--gray-300); border-radius: var(--radius-sm); font-size: 0.9rem;">
                        <option value="pending" ${order.status == 'pending' ? 'selected' : ''}>Chờ xác nhận</option>
                        <option value="confirmed" ${order.status == 'confirmed' ? 'selected' : ''}>Đã xác nhận</option>
                        <option value="shipping" ${order.status == 'shipping' ? 'selected' : ''}>Đang giao</option>
                        <option value="delivered" ${order.status == 'delivered' ? 'selected' : ''}>Đã giao</option>
                        <option value="cancelled" ${order.status == 'cancelled' ? 'selected' : ''}>Đã hủy</option>
                    </select>
                    <button type="submit" class="btn-primary">Cập nhật</button>
                </form>
            </div>

            <!-- Order Items -->
            <h3 style="margin-bottom: 12px;">📦 Sản phẩm</h3>
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Sản phẩm</th>
                        <th>Đơn giá</th>
                        <th>Số lượng</th>
                        <th>Thành tiền</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="detail" items="${order.orderDetails}">
                        <tr>
                            <td>
                                <div class="product-cell">
                                    <img src="${pageContext.request.contextPath}/${detail.thumbnail}" alt="${detail.productName}">
                                    <span class="fw-bold">${detail.productName}</span>
                                </div>
                            </td>
                            <td><fmt:formatNumber value="${detail.unitPrice}" pattern="#,###"/>đ</td>
                            <td>${detail.quantity}</td>
                            <td class="fw-bold text-danger"><fmt:formatNumber value="${detail.subtotal}" pattern="#,###"/>đ</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <div style="text-align: right; padding: 20px 0; font-size: 1.4rem; font-weight: 800;">
                Tổng: <span class="text-danger"><fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/>đ</span>
            </div>
        </div>
    </main>
</div>

</body>
</html>
