<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - PhoneShop</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/common/header.jsp" />

<div class="auth-page">
    <div class="auth-card">
        <h2>Đăng Nhập</h2>
        <p class="subtitle">Chào mừng bạn quay lại PhoneShop 👋</p>

        <c:if test="${error != null}">
            <div class="alert alert-error">⚠️ ${error}</div>
        </c:if>
        <c:if test="${success != null}">
            <div class="alert alert-success">✅ ${success}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <label for="username">Tên đăng nhập</label>
                <input type="text" id="username" name="username" value="${username}" required placeholder="Nhập tên đăng nhập">
            </div>
            <div class="form-group">
                <label for="password">Mật khẩu</label>
                <input type="password" id="password" name="password" required placeholder="Nhập mật khẩu">
            </div>
            <button type="submit" class="form-btn">Đăng Nhập</button>
        </form>

        <p class="auth-link">
            Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
        </p>
    </div>
</div>

</body>
</html>
