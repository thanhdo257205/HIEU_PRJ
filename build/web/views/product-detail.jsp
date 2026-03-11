<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.productName} - PhoneShop</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/common/header.jsp" />

<div class="container" style="padding: 30px 20px;">

    <!-- Product Detail -->
    <div class="product-detail">
        <div class="detail-image">
            <img src="${pageContext.request.contextPath}/${product.thumbnail != null ? product.thumbnail : 'uploads/products/default.jpg'}" alt="${product.productName}">
        </div>
        <div class="detail-info">
            <span class="detail-brand">${product.brandName} | ${product.categoryName}</span>
            <h1>${product.productName}</h1>

            <div class="detail-rating">
                <c:forEach begin="1" end="5" var="i">
                    <c:choose>
                        <c:when test="${i <= product.avgRating}">⭐</c:when>
                        <c:otherwise>☆</c:otherwise>
                    </c:choose>
                </c:forEach>
                <span style="color: var(--gray-600); margin-left: 8px;">
                    <fmt:formatNumber value="${product.avgRating}" maxFractionDigits="1"/> / 5
                    (${product.totalReviews} đánh giá)
                </span>
            </div>

            <div class="detail-price">
                <c:choose>
                    <c:when test="${product.salePrice > 0}">
                        <span class="detail-sale-price"><fmt:formatNumber value="${product.salePrice}" pattern="#,###"/>đ</span>
                        <span class="detail-original-price"><fmt:formatNumber value="${product.price}" pattern="#,###"/>đ</span>
                        <span class="detail-discount">-${product.discountPercent}%</span>
                    </c:when>
                    <c:otherwise>
                        <span class="detail-sale-price" style="color: var(--dark);"><fmt:formatNumber value="${product.price}" pattern="#,###"/>đ</span>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Specs -->
            <table class="specs-table">
                <c:if test="${product.screenSize != null}">
                    <tr><td>📱 Màn hình</td><td>${product.screenSize}</td></tr>
                </c:if>
                <c:if test="${product.ram != null}">
                    <tr><td>💾 RAM</td><td>${product.ram}</td></tr>
                </c:if>
                <c:if test="${product.storage != null}">
                    <tr><td>💿 Bộ nhớ</td><td>${product.storage}</td></tr>
                </c:if>
                <c:if test="${product.battery != null}">
                    <tr><td>🔋 Pin</td><td>${product.battery}</td></tr>
                </c:if>
                <tr><td>📦 Kho hàng</td><td>${product.quantity > 0 ? 'Còn hàng' : 'Hết hàng'} (${product.quantity})</td></tr>
                <tr><td>🔥 Đã bán</td><td>${product.soldCount}</td></tr>
            </table>

            <!-- Add to Cart -->
            <c:if test="${product.quantity > 0}">
                <form action="${pageContext.request.contextPath}/cart" method="post">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="productId" value="${product.productId}">
                    <div class="quantity-selector">
                        <label style="font-weight: 600;">Số lượng:</label>
                        <button type="button" onclick="changeQty(-1)">−</button>
                        <input type="number" id="detailQty" name="quantity" value="1" min="1" max="${product.quantity}">
                        <button type="button" onclick="changeQty(1)">+</button>
                    </div>
                    <div class="d-flex gap-10 mt-20">
                        <c:choose>
                            <c:when test="${sessionScope.user == null}">
                                <button type="button" class="btn-primary" style="flex:1; justify-content: center;"
                                        onclick="window.location.href='${pageContext.request.contextPath}/login'">
                                    🛒 Thêm vào giỏ hàng
                                </button>
                            </c:when>
                            <c:otherwise>
                                <button type="submit" class="btn-primary" style="flex:1; justify-content: center;">
                                    🛒 Thêm vào giỏ hàng
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </form>
            </c:if>
        </div>
    </div>

    <!-- Description -->
    <div class="review-section mb-20">
        <h3 style="margin-bottom: 16px;">📝 Mô tả sản phẩm</h3>
        <p style="color: var(--gray-700); line-height: 1.8;">${product.description}</p>
    </div>

    <!-- Reviews -->
    <div class="review-section">
        <h3 style="margin-bottom: 20px;">⭐ Đánh giá sản phẩm (${reviews.size()})</h3>

        <!-- Review Form -->
        <c:if test="${sessionScope.user != null && !hasReviewed}">
            <form action="${pageContext.request.contextPath}/product" method="post" style="margin-bottom: 30px; padding: 20px; background: var(--gray-100); border-radius: var(--radius);">
                <input type="hidden" name="productId" value="${product.productId}">
                <h4 style="margin-bottom: 12px;">Viết đánh giá của bạn</h4>
                <div class="star-rating" style="margin-bottom: 12px;">
                    <input type="radio" id="star5" name="rating" value="5" required><label for="star5">⭐</label>
                    <input type="radio" id="star4" name="rating" value="4"><label for="star4">⭐</label>
                    <input type="radio" id="star3" name="rating" value="3"><label for="star3">⭐</label>
                    <input type="radio" id="star2" name="rating" value="2"><label for="star2">⭐</label>
                    <input type="radio" id="star1" name="rating" value="1"><label for="star1">⭐</label>
                </div>
                <div class="form-group">
                    <textarea name="comment" placeholder="Chia sẻ cảm nhận của bạn..." rows="3"></textarea>
                </div>
                <button type="submit" class="btn-primary">Gửi đánh giá</button>
            </form>
        </c:if>

        <!-- Review List -->
        <c:forEach var="r" items="${reviews}">
            <div class="review-item">
                <div class="review-header">
                    <div class="review-avatar">${r.fullName.substring(0,1)}</div>
                    <div>
                        <div class="review-name">${r.fullName}</div>
                        <div class="review-date"><fmt:formatDate value="${r.createdDate}" pattern="dd/MM/yyyy HH:mm"/></div>
                    </div>
                </div>
                <div class="review-stars">
                    <c:forEach begin="1" end="${r.rating}">⭐</c:forEach>
                </div>
                <p style="color: var(--gray-700);">${r.comment}</p>
            </div>
        </c:forEach>

        <c:if test="${empty reviews}">
            <div class="empty-state" style="padding: 30px;">
                <p>Chưa có đánh giá nào. Hãy là người đầu tiên!</p>
            </div>
        </c:if>
    </div>

    <!-- Related Products -->
    <c:if test="${not empty relatedProducts}">
    <section class="section mt-20">
        <div class="section-header">
            <h2 class="section-title">📱 Sản Phẩm Liên Quan</h2>
        </div>
        <div class="product-grid">
            <c:forEach var="p" items="${relatedProducts}">
                <c:if test="${p.productId != product.productId}">
                <div class="product-card">
                    <a href="${pageContext.request.contextPath}/product?id=${p.productId}" class="card-image">
                        <img src="${pageContext.request.contextPath}/${p.thumbnail != null ? p.thumbnail : 'uploads/products/default.jpg'}" alt="${p.productName}">
                    </a>
                    <div class="card-body">
                        <span class="brand-label">${p.brandName}</span>
                        <a href="${pageContext.request.contextPath}/product?id=${p.productId}" class="product-name">${p.productName}</a>
                        <div class="price-group">
                            <c:choose>
                                <c:when test="${p.salePrice > 0}">
                                    <span class="sale-price"><fmt:formatNumber value="${p.salePrice}" pattern="#,###"/>đ</span>
                                    <span class="original-price"><fmt:formatNumber value="${p.price}" pattern="#,###"/>đ</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="normal-price"><fmt:formatNumber value="${p.price}" pattern="#,###"/>đ</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                </c:if>
            </c:forEach>
        </div>
    </section>
    </c:if>

</div>

<jsp:include page="/common/footer.jsp" />

<script>
function changeQty(delta) {
    const input = document.getElementById('detailQty');
    let val = parseInt(input.value) + delta;
    if (val < 1) val = 1;
    if (val > parseInt(input.max)) val = parseInt(input.max);
    input.value = val;
}
</script>
</body>
</html>
