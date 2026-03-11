<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký - PhoneShop</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/common/header.jsp" />

<div class="auth-page">
    <div class="auth-card" style="max-width: 520px;">
        <h2>Đăng Ký</h2>
        <p class="subtitle">Tạo tài khoản để mua sắm tại PhoneShop 🎉</p>

        <c:if test="${error != null}">
            <div class="alert alert-error">⚠️ ${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/register" method="post">
            <div class="form-row">
                <div class="form-group">
                    <label for="username">Tên đăng nhập *</label>
                    <input type="text" id="username" name="username" value="${username}" required placeholder="Nhập username">
                </div>
                <div class="form-group">
                    <label for="fullName">Họ và tên *</label>
                    <input type="text" id="fullName" name="fullName" value="${fullName}" required placeholder="Nguyễn Văn A">
                </div>
            </div>

            <div class="form-group">
                <label for="email">Email *</label>
                <input type="email" id="email" name="email" value="${email}" required placeholder="example@email.com">
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="password">Mật khẩu *</label>
                    <input type="password" id="password" name="password" required placeholder="Ít nhất 6 ký tự">
                </div>
                <div class="form-group">
                    <label for="confirmPassword">Xác nhận mật khẩu *</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required placeholder="Nhập lại mật khẩu">
                </div>
            </div>

            <div class="form-group">
                <label for="phone">Số điện thoại</label>
                <input type="tel" id="phone" name="phone" value="${phone}" placeholder="0901234567">
            </div>

            <div class="form-group">
                <label for="address">Địa chỉ</label>
                <input type="text" id="address" name="address" value="${address}" placeholder="Số nhà, đường, quận/huyện, thành phố">
            </div>

            <button type="submit" class="form-btn">Đăng Ký</button>
        </form>

        <p class="auth-link">
            Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
        </p>
    </div>
</div>

</body>
</html>
