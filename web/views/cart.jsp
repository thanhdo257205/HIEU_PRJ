<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ Hàng - PhoneShop</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/common/header.jsp" />

<div class="container cart-page">
    <h2 style="font-size: 1.5rem; font-weight: 700; margin-bottom: 24px;">🛒 Giỏ Hàng Của Bạn</h2>

    <c:if test="${not empty cartItems}">
        <table class="cart-table">
            <thead>
                <tr>
                    <th>Sản phẩm</th>
                    <th>Đơn giá</th>
                    <th>Số lượng</th>
                    <th>Thành tiền</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${cartItems}">
                    <tr>
                        <td>
                            <div class="cart-item-info">
                                <img src="${pageContext.request.contextPath}/${item.thumbnail != null ? item.thumbnail : 'uploads/products/default.jpg'}" alt="${item.productName}">
                                <div>
                                    <a href="${pageContext.request.contextPath}/product?id=${item.productId}" class="item-name">${item.productName}</a>
                                </div>
                            </div>
                        </td>
                        <td><fmt:formatNumber value="${item.displayPrice}" pattern="#,###"/>đ</td>
                        <td>
                            <form id="update-form-${item.productId}" action="${pageContext.request.contextPath}/cart" method="post" style="display: inline;">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="productId" value="${item.productId}">
                                <div class="quantity-selector">
                                    <button type="button" onclick="updateQuantity(${item.productId}, -1)">−</button>
                                    <input type="number" id="qty-${item.productId}" name="quantity"
                                           value="${item.quantity}" min="1" max="${item.stockQuantity}">
                                    <button type="button" onclick="updateQuantity(${item.productId}, 1)">+</button>
                                </div>
                            </form>
                        </td>
                        <td class="fw-bold text-danger">
                            <fmt:formatNumber value="${item.subtotal}" pattern="#,###"/>đ
                        </td>
                        <td>
                            <form action="${pageContext.request.contextPath}/cart" method="post" style="display:inline;"
                                  onsubmit="return confirm('Xóa sản phẩm này khỏi giỏ hàng?')">
                                <input type="hidden" name="action" value="remove">
                                <input type="hidden" name="productId" value="${item.productId}">
                                <button type="submit" class="btn-danger btn-sm">🗑️ Xóa</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <div class="cart-summary">
            <div class="summary-row">
                <span>Số lượng sản phẩm:</span>
                <span class="fw-bold">${cartItems.size()} sản phẩm</span>
            </div>
            <div class="summary-row summary-total">
                <span>Tổng cộng:</span>
                <span><fmt:formatNumber value="${totalAmount}" pattern="#,###"/>đ</span>
            </div>
            <div class="d-flex gap-10 mt-20" style="justify-content: flex-end;">
                <form action="${pageContext.request.contextPath}/cart" method="post"
                      onsubmit="return confirm('Xóa toàn bộ giỏ hàng?')">
                    <input type="hidden" name="action" value="clear">
                    <button type="submit" class="btn-secondary">🗑️ Xóa tất cả</button>
                </form>
                <a href="${pageContext.request.contextPath}/search" class="btn-secondary">← Tiếp tục mua</a>
                <a href="${pageContext.request.contextPath}/checkout" class="btn-primary">Thanh toán →</a>
            </div>
        </div>
    </c:if>

    <c:if test="${empty cartItems}">
        <div class="empty-state">
            <div class="empty-icon">🛒</div>
            <h3>Giỏ hàng trống</h3>
            <p>Hãy thêm sản phẩm vào giỏ hàng để mua sắm!</p>
            <a href="${pageContext.request.contextPath}/search" class="btn-primary mt-20">🛍️ Mua sắm ngay</a>
        </div>
    </c:if>
</div>

<jsp:include page="/common/footer.jsp" />
<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
