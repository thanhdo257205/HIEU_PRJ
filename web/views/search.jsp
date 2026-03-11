<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tìm kiếm - PhoneShop</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="/common/header.jsp" />

<div class="container">
    <div class="search-layout">
        <!-- Filter Sidebar -->
        <aside class="filter-sidebar">
            <h3>🔍 Bộ lọc</h3>
            <form action="${pageContext.request.contextPath}/search" method="get">
                <input type="hidden" name="keyword" value="${keyword}">

                <div class="filter-group">
                    <label>Thương hiệu</label>
                    <select name="brandId">
                        <option value="0">-- Tất cả --</option>
                        <c:forEach var="b" items="${brands}">
                            <option value="${b.brandId}" ${b.brandId == selectedBrandId ? 'selected' : ''}>${b.brandName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="filter-group">
                    <label>Danh mục</label>
                    <select name="categoryId">
                        <option value="0">-- Tất cả --</option>
                        <c:forEach var="c" items="${categories}">
                            <option value="${c.categoryId}" ${c.categoryId == selectedCategoryId ? 'selected' : ''}>${c.categoryName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="filter-group">
                    <label>Khoảng giá (VNĐ)</label>
                    <div class="price-range">
                        <input type="number" name="minPrice" placeholder="Từ" value="${minPrice}">
                        <span>-</span>
                        <input type="number" name="maxPrice" placeholder="Đến" value="${maxPrice}">
                    </div>
                </div>

                <div class="filter-group">
                    <label>Sắp xếp</label>
                    <select name="sortBy">
                        <option value="newest" ${sortBy == 'newest' ? 'selected' : ''}>Mới nhất</option>
                        <option value="price_asc" ${sortBy == 'price_asc' ? 'selected' : ''}>Giá thấp → cao</option>
                        <option value="price_desc" ${sortBy == 'price_desc' ? 'selected' : ''}>Giá cao → thấp</option>
                        <option value="best_seller" ${sortBy == 'best_seller' ? 'selected' : ''}>Bán chạy nhất</option>
                        <option value="name_asc" ${sortBy == 'name_asc' ? 'selected' : ''}>Tên A → Z</option>
                    </select>
                </div>

                <button type="submit" class="btn-primary" style="width: 100%; justify-content: center;">Áp dụng</button>
                <a href="${pageContext.request.contextPath}/search" class="btn-secondary mt-20" style="width: 100%; justify-content: center; text-align: center;">Xóa bộ lọc</a>
            </form>
        </aside>

        <!-- Search Results -->
        <main>
            <div class="search-results-header">
                <span class="results-count">
                    <c:if test="${keyword != null && !keyword.isEmpty()}">
                        Kết quả cho "<strong>${keyword}</strong>" -
                    </c:if>
                    Tìm thấy <strong>${totalProducts}</strong> sản phẩm
                </span>
            </div>

            <c:if test="${not empty products}">
                <div class="product-grid">
                    <c:forEach var="p" items="${products}">
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
                                    <button type="submit" class="add-cart-btn">🛒 Thêm</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <div class="pagination">
                        <c:if test="${currentPage > 1}">
                            <a href="${pageContext.request.contextPath}/search?keyword=${keyword}&brandId=${selectedBrandId}&categoryId=${selectedCategoryId}&minPrice=${minPrice}&maxPrice=${maxPrice}&sortBy=${sortBy}&page=${currentPage - 1}">← Trước</a>
                        </c:if>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <c:choose>
                                <c:when test="${i == currentPage}">
                                    <span class="active">${i}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/search?keyword=${keyword}&brandId=${selectedBrandId}&categoryId=${selectedCategoryId}&minPrice=${minPrice}&maxPrice=${maxPrice}&sortBy=${sortBy}&page=${i}">${i}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages}">
                            <a href="${pageContext.request.contextPath}/search?keyword=${keyword}&brandId=${selectedBrandId}&categoryId=${selectedCategoryId}&minPrice=${minPrice}&maxPrice=${maxPrice}&sortBy=${sortBy}&page=${currentPage + 1}">Sau →</a>
                        </c:if>
                    </div>
                </c:if>
            </c:if>

            <c:if test="${empty products}">
                <div class="empty-state">
                    <div class="empty-icon">🔍</div>
                    <h3>Không tìm thấy sản phẩm</h3>
                    <p>Thử thay đổi bộ lọc hoặc từ khóa tìm kiếm</p>
                </div>
            </c:if>
        </main>
    </div>
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
