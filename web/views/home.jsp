<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="PhoneShop - Cửa hàng điện thoại chính hãng, giá tốt nhất">
    <title>PhoneShop - Điện thoại chính hãng, giá tốt nhất</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/common/header.jsp" />

<!-- ═══ HERO SECTION ═══ -->
<section class="hero">
    <div class="container">
        <div class="hero-content">
            <div class="hero-badge">🔥 Ưu đãi đặc biệt tháng này</div>
            <h1>Chào Mừng Đến Với<br><span>PhoneShop</span></h1>
            <p class="hero-subtitle">Cửa Hàng Điện Thoại Số 1 Việt Nam</p>
            <p>Khám phá hàng ngàn sản phẩm điện thoại chính hãng từ Apple, Samsung, Xiaomi, OPPO... với giá ưu đãi tốt nhất và bảo hành chính hãng.</p>
            <div class="hero-buttons">
                <a href="${pageContext.request.contextPath}/search" class="btn-primary" style="padding: 14px 36px; font-size: 1rem;">
                    🛒 Mua Sắm Ngay
                </a>
                <a href="${pageContext.request.contextPath}/search?sortBy=best_seller" class="btn-outline" style="padding: 13px 36px; font-size: 1rem;">
                    Khám Phá Ưu Đãi
                </a>
            </div>
        </div>
        <div class="hero-features">
            <div class="hero-features-card">
                <div class="hero-feature-item">
                    <div class="feature-check">✓</div>
                    <span>Điện thoại chính hãng 100%</span>
                </div>
                <div class="hero-feature-item">
                    <div class="feature-check">✓</div>
                    <span>Thanh toán linh hoạt</span>
                </div>
                <div class="hero-feature-item">
                    <div class="feature-check">✓</div>
                    <span>Giao hàng nhanh chóng</span>
                </div>
                <div class="hero-feature-item">
                    <div class="feature-check">✓</div>
                    <span>Hỗ trợ khách hàng 24/7</span>
                </div>
                <div class="hero-feature-item">
                    <div class="feature-check">✓</div>
                    <span>Giá cạnh tranh nhất</span>
                </div>
                <div class="hero-feature-item">
                    <div class="feature-check">✓</div>
                    <span>Đổi trả dễ dàng</span>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ═══ BRAND BAR ═══ -->
<div class="brand-bar">
    <div class="container">
        <div class="brand-bar-item">🍎 Apple</div>
        <div class="brand-bar-item">Samsung</div>
        <div class="brand-bar-item">Xiaomi</div>
        <div class="brand-bar-item">OPPO</div>
        <div class="brand-bar-item">Vivo</div>
        <div class="brand-bar-item">Realme</div>
    </div>
</div>

<div class="container" style="padding-top: 40px;">

    <!-- Brand Filter Chips -->
    <div class="brand-ribbon">
        <a href="${pageContext.request.contextPath}/search" class="brand-chip active">📱 Tất cả</a>
        <c:forEach var="brand" items="${brands}">
            <a href="${pageContext.request.contextPath}/search?brandId=${brand.brandId}" class="brand-chip">
                ${brand.brandName}
            </a>
        </c:forEach>
    </div>

    <!-- ═══ FEATURED PRODUCTS ═══ -->
    <c:if test="${not empty featuredProducts}">
    <section class="section animate-on-scroll">
        <div class="section-header">
            <h2 class="section-title"><span class="icon">⭐</span> Sản Phẩm Nổi Bật</h2>
            <a href="${pageContext.request.contextPath}/search?sortBy=best_seller" class="view-all">Xem tất cả →</a>
        </div>
        <div class="product-grid">
            <c:forEach var="p" items="${featuredProducts}">
                <div class="product-card">
                    <a href="${pageContext.request.contextPath}/product?id=${p.productId}" class="card-image">
                        <c:if test="${p.discountPercent > 0}">
                            <span class="discount-badge">-${p.discountPercent}%</span>
                        </c:if>
                        <span class="featured-badge">Nổi bật</span>
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
                    <div class="card-footer">
                        <span class="text-muted" style="font-size:0.8rem;">Đã bán ${p.soldCount}</span>
                        <form action="${pageContext.request.contextPath}/cart" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="productId" value="${p.productId}">
                            <c:choose>
                                <c:when test="${sessionScope.user == null}">
                                    <button type="button" class="add-cart-btn" onclick="window.location.href='${pageContext.request.contextPath}/login'">
                                        🛒 Thêm
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button type="submit" class="add-cart-btn">
                                        🛒 Thêm
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </form>
                    </div>
                </div>
            </c:forEach>
        </div>
    </section>
    </c:if>

    <!-- ═══ LATEST PRODUCTS ═══ -->
    <section class="section animate-on-scroll">
        <div class="section-header">
            <h2 class="section-title"><span class="icon">🆕</span> Sản Phẩm Mới</h2>
            <a href="${pageContext.request.contextPath}/search?sortBy=newest" class="view-all">Xem tất cả →</a>
        </div>
        <div class="product-grid">
            <c:forEach var="p" items="${latestProducts}">
                <div class="product-card">
                    <a href="${pageContext.request.contextPath}/product?id=${p.productId}" class="card-image">
                        <c:if test="${p.discountPercent > 0}">
                            <span class="discount-badge">-${p.discountPercent}%</span>
                        </c:if>
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
                    <div class="card-footer">
                        <span class="text-muted" style="font-size:0.8rem;">Đã bán ${p.soldCount}</span>
                        <form action="${pageContext.request.contextPath}/cart" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="productId" value="${p.productId}">
                            <c:choose>
                                <c:when test="${sessionScope.user == null}">
                                    <button type="button" class="add-cart-btn" onclick="window.location.href='${pageContext.request.contextPath}/login'">
                                        🛒 Thêm
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button type="submit" class="add-cart-btn">
                                        🛒 Thêm
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </form>
                    </div>
                </div>
            </c:forEach>
        </div>
    </section>

    <!-- ═══ BEST SELLERS ═══ -->
    <section class="section animate-on-scroll">
        <div class="section-header">
            <h2 class="section-title"><span class="icon">🔥</span> Bán Chạy Nhất</h2>
            <a href="${pageContext.request.contextPath}/search?sortBy=best_seller" class="view-all">Xem tất cả →</a>
        </div>
        <div class="product-grid">
            <c:forEach var="p" items="${bestSellers}">
                <div class="product-card">
                    <a href="${pageContext.request.contextPath}/product?id=${p.productId}" class="card-image">
                        <c:if test="${p.discountPercent > 0}">
                            <span class="discount-badge">-${p.discountPercent}%</span>
                        </c:if>
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
                    <div class="card-footer">
                        <span class="text-muted" style="font-size:0.8rem;">Đã bán ${p.soldCount}</span>
                        <form action="${pageContext.request.contextPath}/cart" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="productId" value="${p.productId}">
                            <c:choose>
                                <c:when test="${sessionScope.user == null}">
                                    <button type="button" class="add-cart-btn" onclick="window.location.href='${pageContext.request.contextPath}/login'">
                                        🛒 Thêm
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button type="submit" class="add-cart-btn">
                                        🛒 Thêm
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </form>
                    </div>
                </div>
            </c:forEach>
        </div>
    </section>

</div>

<jsp:include page="/common/footer.jsp" />

<c:if test="${not empty sessionScope.cartMessage}">
    <div id="cartToast" style="position: fixed; top: 20px; right: 20px; background: #10b981; color: white; padding: 16px 24px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); z-index: 9999; font-weight: 600;">
        ✅ ${sessionScope.cartMessage}
    </div>
    <script>
        setTimeout(function() {
            const toast = document.getElementById('cartToast');
            if (toast) toast.style.display = 'none';
        }, 3000);
    </script>
    <% session.removeAttribute("cartMessage"); %>
</c:if>

<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
