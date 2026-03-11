<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Hàng Thành Công - PhoneShop</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/common/header.jsp" />

<div class="success-page">
    <div>
        <div class="success-icon">🎉</div>
        <h2>Đặt Hàng Thành Công!</h2>
        <p>Cảm ơn bạn đã mua sắm tại PhoneShop. Đơn hàng của bạn đang được xử lý.</p>
        <div class="d-flex gap-10" style="justify-content: center;">
            <a href="${pageContext.request.contextPath}/orders" class="btn-primary">📋 Xem đơn hàng</a>
            <a href="${pageContext.request.contextPath}/home" class="btn-secondary">🏠 Trang chủ</a>
        </div>
    </div>
</div>

<jsp:include page="/common/footer.jsp" />
</body>
</html>
