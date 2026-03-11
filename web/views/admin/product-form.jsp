<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product != null ? 'Sửa' : 'Thêm'} Sản Phẩm - PhoneShop Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="admin-layout">
    <jsp:include page="/common/admin-sidebar.jsp">
        <jsp:param name="active" value="products"/>
    </jsp:include>

    <main class="admin-content">
        <a href="${pageContext.request.contextPath}/admin/products" style="color: var(--primary); font-weight: 600; margin-bottom: 16px; display: inline-block;">
            ← Quay lại danh sách
        </a>
        <h2>${product != null ? '✏️ Sửa Sản Phẩm' : '➕ Thêm Sản Phẩm Mới'}</h2>

        <form action="${pageContext.request.contextPath}/admin/products" method="post" enctype="multipart/form-data" class="admin-form">
            <c:if test="${product != null}">
                <input type="hidden" name="productId" value="${product.productId}">
            </c:if>

            <div class="form-group">
                <label for="productName">Tên sản phẩm *</label>
                <input type="text" id="productName" name="productName" value="${product.productName}" required placeholder="iPhone 15 Pro Max 256GB">
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="brandId">Thương hiệu *</label>
                    <select id="brandId" name="brandId" required>
                        <option value="">-- Chọn thương hiệu --</option>
                        <c:forEach var="b" items="${brands}">
                            <option value="${b.brandId}" ${product != null && product.brandId == b.brandId ? 'selected' : ''}>${b.brandName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="categoryId">Danh mục *</label>
                    <select id="categoryId" name="categoryId" required>
                        <option value="">-- Chọn danh mục --</option>
                        <c:forEach var="c" items="${categories}">
                            <option value="${c.categoryId}" ${product != null && product.categoryId == c.categoryId ? 'selected' : ''}>${c.categoryName}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="price">Giá gốc (VNĐ) *</label>
                    <input type="number" id="price" name="price" value="${product != null ? product.price : ''}" required placeholder="34990000" min="0">
                </div>
                <div class="form-group">
                    <label for="salePrice">Giá khuyến mãi (VNĐ)</label>
                    <input type="number" id="salePrice" name="salePrice" value="${product != null && product.salePrice > 0 ? product.salePrice : ''}" placeholder="32990000" min="0">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="quantity">Số lượng tồn kho *</label>
                    <input type="number" id="quantity" name="quantity" value="${product != null ? product.quantity : '0'}" required min="0">
                </div>
                <div class="form-group">
                    <label for="screenSize">Kích thước màn hình</label>
                    <input type="text" id="screenSize" name="screenSize" value="${product.screenSize}" placeholder="6.7 inch">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="ram">RAM</label>
                    <input type="text" id="ram" name="ram" value="${product.ram}" placeholder="8GB">
                </div>
                <div class="form-group">
                    <label for="storage">Bộ nhớ trong</label>
                    <input type="text" id="storage" name="storage" value="${product.storage}" placeholder="256GB">
                </div>
            </div>

            <div class="form-group">
                <label for="battery">Pin</label>
                <input type="text" id="battery" name="battery" value="${product.battery}" placeholder="5000 mAh">
            </div>

            <div class="form-group">
                <label for="description">Mô tả sản phẩm</label>
                <textarea id="description" name="description" rows="5" placeholder="Mô tả chi tiết sản phẩm...">${product.description}</textarea>
            </div>

            <!-- Upload ảnh -->
            <div class="form-group">
                <label for="thumbnail">Ảnh sản phẩm</label>
                <input type="file" id="thumbnail" name="thumbnail" accept="image/*" onchange="previewImage(this, 'imgPreview')">
                <c:if test="${product != null && product.thumbnail != null}">
                    <div style="margin-top: 10px;">
                        <span class="text-muted" style="font-size: 0.85rem;">Ảnh hiện tại:</span>
                        <img id="imgPreview" src="${pageContext.request.contextPath}/${product.thumbnail}" alt="Preview"
                             style="max-width: 200px; margin-top: 8px; border-radius: 8px; border: 2px solid var(--gray-300);">
                    </div>
                </c:if>
                <c:if test="${product == null}">
                    <img id="imgPreview" src="" alt="Preview" style="max-width: 200px; margin-top: 8px; border-radius: 8px; display: none;">
                </c:if>
            </div>

            <div class="checkbox-group mb-20">
                <input type="checkbox" id="isFeatured" name="isFeatured" ${product != null && product.isFeatured ? 'checked' : ''}>
                <label for="isFeatured" style="margin-bottom: 0;">⭐ Đánh dấu là sản phẩm nổi bật</label>
            </div>

            <div class="d-flex gap-10">
                <button type="submit" class="btn-primary">${product != null ? '💾 Cập nhật' : '➕ Thêm sản phẩm'}</button>
                <a href="${pageContext.request.contextPath}/admin/products" class="btn-secondary">Hủy</a>
            </div>
        </form>
    </main>
</div>

<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
