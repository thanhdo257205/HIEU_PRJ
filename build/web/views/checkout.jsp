<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh Toán - PhoneShop</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/common/header.jsp" />

<div class="container" style="padding: 30px 20px; max-width: 800px;">
    <h2 style="font-size: 1.5rem; font-weight: 700; margin-bottom: 24px;">📋 Thanh Toán Đơn Hàng</h2>

    <c:if test="${error != null}">
        <div class="alert alert-error">⚠️ ${error}</div>
    </c:if>

    <!-- Order Items -->
    <div class="review-section mb-20">
        <h3 style="margin-bottom: 16px;">Sản phẩm đặt mua</h3>
        <c:forEach var="item" items="${cartItems}">
            <div style="display: flex; align-items: center; gap: 16px; padding: 12px 0; border-bottom: 1px solid var(--gray-200);">
                <img src="${pageContext.request.contextPath}/${item.thumbnail}" alt="${item.productName}"
                     style="width: 60px; height: 60px; object-fit: contain; background: var(--gray-100); border-radius: 8px; padding: 4px;">
                <div style="flex: 1;">
                    <div class="fw-bold">${item.productName}</div>
                    <div class="text-muted" style="font-size: 0.85rem;">x${item.quantity}</div>
                </div>
                <div class="fw-bold text-danger"><fmt:formatNumber value="${item.subtotal}" pattern="#,###"/>đ</div>
            </div>
        </c:forEach>
        <div style="display: flex; justify-content: space-between; padding: 16px 0; font-size: 1.2rem; font-weight: 700;">
            <span>Tổng cộng:</span>
            <span class="text-danger"><fmt:formatNumber value="${totalAmount}" pattern="#,###"/>đ</span>
        </div>
    </div>

    <!-- Shipping Info -->
    <form action="${pageContext.request.contextPath}/checkout" method="post" class="admin-form">
        <h3 style="margin-bottom: 20px;">Thông tin giao hàng</h3>

        <div class="form-group">
            <label for="shippingAddress">Địa chỉ giao hàng *</label>
            <input type="text" id="shippingAddress" name="shippingAddress"
                   value="${sessionScope.user.address}" required placeholder="Số nhà, đường, quận/huyện, thành phố">
        </div>

        <div class="form-group">
            <label for="phone">Số điện thoại *</label>
            <input type="tel" id="phone" name="phone" value="${sessionScope.user.phone}" required placeholder="0901234567">
        </div>

        <div class="form-group">
            <label for="note">Ghi chú</label>
            <textarea id="note" name="note" rows="3" placeholder="Ghi chú cho đơn hàng (giao giờ hành chính, gọi trước khi giao...)"></textarea>
        </div>

        <div class="d-flex gap-10" style="justify-content: flex-end;">
            <a href="${pageContext.request.contextPath}/cart" class="btn-secondary">← Quay lại</a>
            <button type="submit" class="btn-primary" style="font-size: 1rem; padding: 14px 32px;">
                ✅ Đặt Hàng (<fmt:formatNumber value="${totalAmount}" pattern="#,###"/>đ)
            </button>
        </div>
    </form>
</div>

<jsp:include page="/common/footer.jsp" />
</body>
</html>
