<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Sản Phẩm - PhoneShop Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="admin-layout">
    <jsp:include page="/common/admin-sidebar.jsp">
        <jsp:param name="active" value="products"/>
    </jsp:include>

    <main class="admin-content">
        <div class="d-flex justify-between align-center mb-20">
            <h2>📱 Quản Lý Sản Phẩm (${products.size()})</h2>
            <a href="${pageContext.request.contextPath}/admin/products?action=add" class="btn-primary">+ Thêm sản phẩm</a>
        </div>

        <table class="admin-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Sản phẩm</th>
                    <th>Thương hiệu</th>
                    <th>Giá</th>
                    <th>Giá sale</th>
                    <th>Kho</th>
                    <th>Đã bán</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${products}">
                    <tr>
                        <td>${p.productId}</td>
                        <td>
                            <div class="product-cell">
                                <img src="${pageContext.request.contextPath}/${p.thumbnail != null ? p.thumbnail : 'uploads/products/default.jpg'}" alt="${p.productName}">
                                <span style="font-weight: 600; max-width: 200px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                                    ${p.productName}
                                </span>
                            </div>
                        </td>
                        <td>${p.brandName}</td>
                        <td><fmt:formatNumber value="${p.price}" pattern="#,###"/>đ</td>
                        <td>
                            <c:if test="${p.salePrice > 0}">
                                <span class="text-danger"><fmt:formatNumber value="${p.salePrice}" pattern="#,###"/>đ</span>
                            </c:if>
                            <c:if test="${p.salePrice <= 0}">-</c:if>
                        </td>
                        <td>${p.quantity}</td>
                        <td>${p.soldCount}</td>
                        <td>
                            <c:choose>
                                <c:when test="${p.isActive}">
                                    <span class="status-badge" style="background: var(--success);">Active</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-badge" style="background: var(--gray-500);">Inactive</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="action-btns">
                                <a href="${pageContext.request.contextPath}/admin/products?action=edit&id=${p.productId}" class="btn-primary btn-sm">✏️ Sửa</a>
                                <a href="${pageContext.request.contextPath}/admin/products?action=delete&id=${p.productId}"
                                   class="btn-danger btn-sm"
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa sản phẩm này?')">🗑️</a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </main>
</div>

</body>
</html>
