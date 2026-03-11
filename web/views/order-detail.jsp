<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Đơn Hàng #${order.orderId} - PhoneShop</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/common/header.jsp" />

<div class="container" style="padding: 30px 20px; max-width: 900px;">
    <a href="${pageContext.request.contextPath}/orders" style="color: var(--primary); font-weight: 600; margin-bottom: 20px; display: inline-block;">← Quay lại đơn hàng</a>

    <div class="review-section">
        <div class="d-flex justify-between align-center mb-20">
            <h2 style="font-size: 1.3rem;">Đơn hàng #${order.orderId}</h2>
            <span class="status-badge" style="background: ${order.statusColor};">${order.statusText}</span>
        </div>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 24px;">
            <div><span class="text-muted">Ngày đặt:</span><br><strong><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></strong></div>
            <div><span class="text-muted">Số điện thoại:</span><br><strong>${order.phone}</strong></div>
            <div><span class="text-muted">Địa chỉ:</span><br><strong>${order.shippingAddress}</strong></div>
            <c:if test="${order.note != null}">
                <div><span class="text-muted">Ghi chú:</span><br><strong>${order.note}</strong></div>
            </c:if>
        </div>

        <h3 style="margin-bottom: 12px;">Sản phẩm</h3>
        <c:forEach var="detail" items="${order.orderDetails}">
            <div style="display: flex; align-items: center; gap: 16px; padding: 12px 0; border-bottom: 1px solid var(--gray-200);">
                <img src="${pageContext.request.contextPath}/${detail.thumbnail}" alt="${detail.productName}"
                     style="width: 60px; height: 60px; object-fit: contain; background: var(--gray-100); border-radius: 8px; padding: 4px;">
                <div style="flex: 1;">
                    <a href="${pageContext.request.contextPath}/product?id=${detail.productId}" class="fw-bold">${detail.productName}</a>
                    <div class="text-muted" style="font-size: 0.85rem;">
                        <fmt:formatNumber value="${detail.unitPrice}" pattern="#,###"/>đ x ${detail.quantity}
                    </div>
                </div>
                <div class="fw-bold text-danger"><fmt:formatNumber value="${detail.subtotal}" pattern="#,###"/>đ</div>
            </div>
        </c:forEach>

        <div style="text-align: right; padding: 16px 0; font-size: 1.3rem; font-weight: 700;">
            Tổng: <span class="text-danger"><fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/>đ</span>
        </div>

        <c:if test="${order.status == 'pending'}">
            <div style="text-align: right; padding-bottom: 16px;">
                <form action="${pageContext.request.contextPath}/orders" method="post" style="display:inline;">
                    <input type="hidden" name="action" value="cancel">
                    <input type="hidden" name="id" value="${order.orderId}">
                    <button type="submit" class="btn-primary"
                            style="background: #ef4444; border-color: #ef4444;"
                            onclick="return confirm('Bạn có chắc muốn hủy đơn hàng này?')">
                        ❌ Hủy đơn hàng
                    </button>
                </form>
            </div>
        </c:if>
    </div>
</div>

<jsp:include page="/common/footer.jsp" />
</body>
</html>
