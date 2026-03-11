<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Đơn Hàng - PhoneShop Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="admin-layout">
    <jsp:include page="/common/admin-sidebar.jsp">
        <jsp:param name="active" value="orders"/>
    </jsp:include>

    <main class="admin-content">
        <h2>📋 Quản Lý Đơn Hàng (${orders.size()})</h2>

        <table class="admin-table">
            <thead>
                <tr>
                    <th>Mã ĐH</th>
                    <th>Khách hàng</th>
                    <th>SĐT</th>
                    <th>Tổng tiền</th>
                    <th>Ngày đặt</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="order" items="${orders}">
                    <tr>
                        <td class="fw-bold">#${order.orderId}</td>
                        <td>${order.customerName}</td>
                        <td>${order.phone}</td>
                        <td class="fw-bold text-danger"><fmt:formatNumber value="${order.totalAmount}" pattern="#,###"/>đ</td>
                        <td><fmt:formatDate value="${order.orderDate}" pattern="dd/MM/yyyy HH:mm"/></td>
                        <td>
                            <span class="status-badge" style="background: ${order.statusColor};">
                                ${order.statusText}
                            </span>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/orders?action=detail&id=${order.orderId}" class="btn-primary btn-sm">
                                👁️ Chi tiết
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </main>
</div>

</body>
</html>
