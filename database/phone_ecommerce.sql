-- ╔══════════════════════════════════════════════════════════════════╗
-- ║          PRJ301 — ASSIGNMENT: PHONE E-COMMERCE DATABASE        ║
-- ║          Topic 1: Quản lý Thương Mại Điện Tử Điện Thoại       ║
-- ║          Database: SQL Server                                   ║
-- ╚══════════════════════════════════════════════════════════════════╝

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- 📌 STEP 1: Tạo Database
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'PhoneEcommerce')
BEGIN
    CREATE DATABASE PhoneEcommerce;
END
GO

USE PhoneEcommerce;
GO

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- 📌 STEP 2: Xóa bảng cũ (nếu có) - theo thứ tự phụ thuộc
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

IF OBJECT_ID('Reviews', 'U') IS NOT NULL DROP TABLE Reviews;
IF OBJECT_ID('Cart', 'U') IS NOT NULL DROP TABLE Cart;
IF OBJECT_ID('OrderDetails', 'U') IS NOT NULL DROP TABLE OrderDetails;
IF OBJECT_ID('Orders', 'U') IS NOT NULL DROP TABLE Orders;
IF OBJECT_ID('ProductImages', 'U') IS NOT NULL DROP TABLE ProductImages;
IF OBJECT_ID('Products', 'U') IS NOT NULL DROP TABLE Products;
IF OBJECT_ID('Categories', 'U') IS NOT NULL DROP TABLE Categories;
IF OBJECT_ID('Brands', 'U') IS NOT NULL DROP TABLE Brands;
IF OBJECT_ID('Users', 'U') IS NOT NULL DROP TABLE Users;
GO


-- ╔══════════════════════════════════════════════════════════════════╗
-- ║                    🔐 BẢNG USERS (Người dùng)                  ║
-- ╚══════════════════════════════════════════════════════════════════╝

CREATE TABLE Users (
    userId        INT IDENTITY(1,1) PRIMARY KEY,
    username      NVARCHAR(50)   NOT NULL UNIQUE,
    password      NVARCHAR(255)  NOT NULL,
    fullName      NVARCHAR(100)  NOT NULL,
    email         NVARCHAR(100)  NOT NULL UNIQUE,
    phone         NVARCHAR(15)   NULL,
    address       NVARCHAR(255)  NULL,
    avatar        NVARCHAR(255)  NULL,                -- Đường dẫn ảnh đại diện
    role          NVARCHAR(10)   NOT NULL DEFAULT 'user'
                  CHECK (role IN ('admin', 'user')),
    createdDate   DATETIME       NOT NULL DEFAULT GETDATE()
);
GO


-- ╔══════════════════════════════════════════════════════════════════╗
-- ║                 📂 BẢNG CATEGORIES (Danh mục)                  ║
-- ╚══════════════════════════════════════════════════════════════════╝

CREATE TABLE Categories (
    categoryId    INT IDENTITY(1,1) PRIMARY KEY,
    categoryName  NVARCHAR(100)  NOT NULL UNIQUE,
    description   NVARCHAR(500)  NULL,
    isActive      BIT            NOT NULL DEFAULT 1
);
GO


-- ╔══════════════════════════════════════════════════════════════════╗
-- ║                 🏷️ BẢNG BRANDS (Thương hiệu)                  ║
-- ╚══════════════════════════════════════════════════════════════════╝

CREATE TABLE Brands (
    brandId       INT IDENTITY(1,1) PRIMARY KEY,
    brandName     NVARCHAR(100)  NOT NULL UNIQUE,
    logo          NVARCHAR(255)  NULL,                -- Đường dẫn logo thương hiệu
    isActive      BIT            NOT NULL DEFAULT 1
);
GO


-- ╔══════════════════════════════════════════════════════════════════╗
-- ║                📱 BẢNG PRODUCTS (Sản phẩm)                    ║
-- ╚══════════════════════════════════════════════════════════════════╝

CREATE TABLE Products (
    productId     INT IDENTITY(1,1) PRIMARY KEY,
    productName   NVARCHAR(200)  NOT NULL,
    description   NVARCHAR(MAX)  NULL,
    price         DECIMAL(18,0)  NOT NULL CHECK (price >= 0),
    salePrice     DECIMAL(18,0)  NULL CHECK (salePrice >= 0),       -- Giá khuyến mãi
    quantity      INT            NOT NULL DEFAULT 0 CHECK (quantity >= 0),
    soldCount     INT            NOT NULL DEFAULT 0,
    thumbnail     NVARCHAR(255)  NULL,                              -- Ảnh chính (lưu trong uploads/)
    
    -- Thông số kỹ thuật điện thoại
    screenSize    NVARCHAR(50)   NULL,      -- VD: "6.7 inch"
    ram           NVARCHAR(20)   NULL,      -- VD: "8GB"
    storage       NVARCHAR(20)   NULL,      -- VD: "256GB"
    battery       NVARCHAR(50)   NULL,      -- VD: "5000 mAh"
    
    categoryId    INT            NOT NULL,
    brandId       INT            NOT NULL,
    isFeatured    BIT            NOT NULL DEFAULT 0,
    isActive      BIT            NOT NULL DEFAULT 1,
    createdDate   DATETIME       NOT NULL DEFAULT GETDATE(),
    updatedDate   DATETIME       NULL,

    CONSTRAINT FK_Products_Categories FOREIGN KEY (categoryId) REFERENCES Categories(categoryId),
    CONSTRAINT FK_Products_Brands     FOREIGN KEY (brandId)    REFERENCES Brands(brandId)
);
GO


-- ╔══════════════════════════════════════════════════════════════════╗
-- ║             🖼️ BẢNG PRODUCT IMAGES (Ảnh sản phẩm)             ║
-- ╚══════════════════════════════════════════════════════════════════╝

CREATE TABLE ProductImages (
    imageId       INT IDENTITY(1,1) PRIMARY KEY,
    productId     INT            NOT NULL,
    imagePath     NVARCHAR(255)  NOT NULL,              -- uploads/products/img_001.jpg
    displayOrder  INT            NOT NULL DEFAULT 0,

    CONSTRAINT FK_ProductImages_Products FOREIGN KEY (productId) REFERENCES Products(productId)
        ON DELETE CASCADE
);
GO


-- ╔══════════════════════════════════════════════════════════════════╗
-- ║                 🛒 BẢNG CART (Giỏ hàng)                       ║
-- ╚══════════════════════════════════════════════════════════════════╝

CREATE TABLE Cart (
    cartId        INT IDENTITY(1,1) PRIMARY KEY,
    userId        INT            NOT NULL,
    productId     INT            NOT NULL,
    quantity      INT            NOT NULL DEFAULT 1 CHECK (quantity > 0),
    addedDate     DATETIME       NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Cart_Users    FOREIGN KEY (userId)    REFERENCES Users(userId)     ON DELETE CASCADE,
    CONSTRAINT FK_Cart_Products FOREIGN KEY (productId) REFERENCES Products(productId),
    CONSTRAINT UQ_Cart_User_Product UNIQUE (userId, productId)   -- Mỗi user chỉ 1 dòng/SP
);
GO


-- ╔══════════════════════════════════════════════════════════════════╗
-- ║                📋 BẢNG ORDERS (Đơn hàng)                      ║
-- ╚══════════════════════════════════════════════════════════════════╝

CREATE TABLE Orders (
    orderId       INT IDENTITY(1,1) PRIMARY KEY,
    userId        INT            NOT NULL,
    orderDate     DATETIME       NOT NULL DEFAULT GETDATE(),
    totalAmount   DECIMAL(18,0)  NOT NULL DEFAULT 0,
    shippingAddress NVARCHAR(255) NOT NULL,
    phone         NVARCHAR(15)   NOT NULL,
    note          NVARCHAR(500)  NULL,
    status        NVARCHAR(20)   NOT NULL DEFAULT 'pending'
                  CHECK (status IN ('pending', 'confirmed', 'shipping', 'delivered', 'cancelled')),

    CONSTRAINT FK_Orders_Users FOREIGN KEY (userId) REFERENCES Users(userId)
);
GO


-- ╔══════════════════════════════════════════════════════════════════╗
-- ║           📝 BẢNG ORDER DETAILS (Chi tiết đơn hàng)           ║
-- ╚══════════════════════════════════════════════════════════════════╝

CREATE TABLE OrderDetails (
    orderDetailId INT IDENTITY(1,1) PRIMARY KEY,
    orderId       INT            NOT NULL,
    productId     INT            NOT NULL,
    quantity      INT            NOT NULL CHECK (quantity > 0),
    unitPrice     DECIMAL(18,0)  NOT NULL,                          -- Giá tại thời điểm mua

    CONSTRAINT FK_OrderDetails_Orders   FOREIGN KEY (orderId)   REFERENCES Orders(orderId)   ON DELETE CASCADE,
    CONSTRAINT FK_OrderDetails_Products FOREIGN KEY (productId) REFERENCES Products(productId)
);
GO


-- ╔══════════════════════════════════════════════════════════════════╗
-- ║                ⭐ BẢNG REVIEWS (Đánh giá)                     ║
-- ╚══════════════════════════════════════════════════════════════════╝

CREATE TABLE Reviews (
    reviewId      INT IDENTITY(1,1) PRIMARY KEY,
    userId        INT            NOT NULL,
    productId     INT            NOT NULL,
    rating        INT            NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment       NVARCHAR(1000) NULL,
    createdDate   DATETIME       NOT NULL DEFAULT GETDATE(),

    CONSTRAINT FK_Reviews_Users    FOREIGN KEY (userId)    REFERENCES Users(userId),
    CONSTRAINT FK_Reviews_Products FOREIGN KEY (productId) REFERENCES Products(productId) ON DELETE CASCADE,
    CONSTRAINT UQ_Reviews_User_Product UNIQUE (userId, productId)   -- Mỗi user chỉ đánh giá 1 lần/SP
);
GO


-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- 📌 STEP 3: Tạo Index để tối ưu truy vấn
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

CREATE INDEX IX_Products_CategoryId ON Products(categoryId);
CREATE INDEX IX_Products_BrandId    ON Products(brandId);
CREATE INDEX IX_Products_IsFeatured ON Products(isFeatured) WHERE isFeatured = 1;
CREATE INDEX IX_Products_CreatedDate ON Products(createdDate DESC);
CREATE INDEX IX_Products_SoldCount  ON Products(soldCount DESC);
CREATE INDEX IX_Orders_UserId       ON Orders(userId);
CREATE INDEX IX_Orders_Status       ON Orders(status);
CREATE INDEX IX_Cart_UserId         ON Cart(userId);
GO


-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- 📌 STEP 4: Dữ liệu mẫu (Sample Data)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━


-- ─────────────────────────────────────────────────
-- 👤 Users (2 admin + 5 users)
-- ─────────────────────────────────────────────────

INSERT INTO Users (username, password, fullName, email, phone, address, role) VALUES
('admin',      '123456', N'Quản Trị Viên',      'admin@phoneshop.vn',   '0901000001', N'Hà Nội',            'admin'),
('manager',    '123456', N'Quản Lý',             'manager@phoneshop.vn', '0901000002', N'Hồ Chí Minh',      'admin'),
('nguyenvana', '123456', N'Nguyễn Văn A',        'nguyenvana@gmail.com', '0912345678', N'123 Trần Phú, Hà Nội',       'user'),
('tranthib',   '123456', N'Trần Thị B',          'tranthib@gmail.com',   '0923456789', N'456 Lê Lợi, TP.HCM',        'user'),
('levanc',     '123456', N'Lê Văn C',            'levanc@gmail.com',     '0934567890', N'789 Nguyễn Huệ, Đà Nẵng',   'user'),
('phamthid',   '123456', N'Phạm Thị D',          'phamthid@gmail.com',   '0945678901', N'321 Hai Bà Trưng, Huế',     'user'),
('hoangvane',  '123456', N'Hoàng Văn E',         'hoangvane@gmail.com',  '0956789012', N'654 Phan Chu Trinh, Cần Thơ','user');
GO


-- ─────────────────────────────────────────────────
-- 📂 Categories
-- ─────────────────────────────────────────────────

INSERT INTO Categories (categoryName, description) VALUES
(N'Smartphone',         N'Điện thoại thông minh các hãng'),
(N'Điện thoại phổ thông', N'Điện thoại cơ bản, giá rẻ'),
(N'Máy tính bảng',     N'Tablet các hãng'),
(N'Phụ kiện',          N'Ốp lưng, sạc, tai nghe, cáp...');
GO


-- ─────────────────────────────────────────────────
-- 🏷️ Brands
-- ─────────────────────────────────────────────────

INSERT INTO Brands (brandName, logo) VALUES
(N'Apple',      'uploads/brands/apple.png'),
(N'Samsung',    'uploads/brands/samsung.png'),
(N'Xiaomi',     'uploads/brands/xiaomi.png'),
(N'OPPO',       'uploads/brands/oppo.png'),
(N'Vivo',       'uploads/brands/vivo.png'),
(N'Realme',     'uploads/brands/realme.png'),
(N'Nokia',      'uploads/brands/nokia.png'),
(N'OnePlus',    'uploads/brands/oneplus.png');
GO


-- ─────────────────────────────────────────────────
-- 📱 Products (20 sản phẩm mẫu)
-- ─────────────────────────────────────────────────

INSERT INTO Products (productName, description, price, salePrice, quantity, soldCount, thumbnail, screenSize, ram, storage, battery, categoryId, brandId, isFeatured) VALUES
-- Apple
(N'iPhone 15 Pro Max',     N'iPhone 15 Pro Max chính hãng VN/A. Chip A17 Pro, camera 48MP, USB-C, khung Titan.', 
    34990000, 32990000, 50, 120, 'uploads/products/iphone15promax.jpg', '6.7 inch', '8GB', '256GB', '4422 mAh', 1, 1, 1),

(N'iPhone 15',             N'iPhone 15 chính hãng. Dynamic Island, camera 48MP, chip A16 Bionic.', 
    22990000, 21490000, 80, 95, 'uploads/products/iphone15.jpg', '6.1 inch', '6GB', '128GB', '3349 mAh', 1, 1, 1),

(N'iPhone 14',             N'iPhone 14 chính hãng. Chip A15 Bionic, camera kép 12MP.', 
    17990000, 16490000, 60, 150, 'uploads/products/iphone14.jpg', '6.1 inch', '6GB', '128GB', '3279 mAh', 1, 1, 0),

-- Samsung
(N'Samsung Galaxy S24 Ultra', N'Galaxy S24 Ultra với Galaxy AI, S Pen tích hợp, camera 200MP.', 
    33990000, 31990000, 45, 88, 'uploads/products/s24ultra.jpg', '6.8 inch', '12GB', '256GB', '5000 mAh', 1, 2, 1),

(N'Samsung Galaxy S24',    N'Galaxy S24 với Galaxy AI, màn hình Dynamic AMOLED 2X.', 
    22990000, 20990000, 70, 65, 'uploads/products/s24.jpg', '6.2 inch', '8GB', '256GB', '4000 mAh', 1, 2, 1),

(N'Samsung Galaxy A55',    N'Galaxy A55 5G, thiết kế thời trang, camera 50MP OIS.', 
    9990000, 8990000, 100, 200, 'uploads/products/a55.jpg', '6.6 inch', '8GB', '128GB', '5000 mAh', 1, 2, 0),

(N'Samsung Galaxy Z Flip5', N'Galaxy Z Flip5 - Điện thoại gập thời trang, Flex Window lớn hơn.', 
    25990000, 22990000, 30, 45, 'uploads/products/zflip5.jpg', '6.7 inch', '8GB', '256GB', '3700 mAh', 1, 2, 0),

-- Xiaomi
(N'Xiaomi 14 Ultra',       N'Xiaomi 14 Ultra với camera Leica chuyên nghiệp, Snapdragon 8 Gen 3.', 
    23990000, 21990000, 35, 40, 'uploads/products/xiaomi14ultra.jpg', '6.73 inch', '16GB', '512GB', '5000 mAh', 1, 3, 1),

(N'Redmi Note 13 Pro+',    N'Redmi Note 13 Pro+ 5G, camera 200MP, sạc nhanh 120W.', 
    8990000, 7990000, 120, 300, 'uploads/products/redminote13proplus.jpg', '6.67 inch', '8GB', '256GB', '5000 mAh', 1, 3, 0),

(N'Xiaomi Redmi 13C',      N'Redmi 13C giá rẻ, pin trâu, camera 50MP.', 
    3290000, 2990000, 200, 500, 'uploads/products/redmi13c.jpg', '6.74 inch', '4GB', '128GB', '5000 mAh', 1, 3, 0),

-- OPPO
(N'OPPO Find X7 Ultra',    N'OPPO Find X7 Ultra - Camera Hasselblad, Dimensity 9300.', 
    22990000, 20990000, 25, 30, 'uploads/products/findx7ultra.jpg', '6.82 inch', '16GB', '512GB', '5400 mAh', 1, 4, 1),

(N'OPPO Reno11 5G',        N'OPPO Reno11 5G, chân dung AI sinh động, thiết kế cosmos.', 
    10990000, 9490000, 90, 110, 'uploads/products/reno11.jpg', '6.7 inch', '12GB', '256GB', '5000 mAh', 1, 4, 0),

(N'OPPO A78',              N'OPPO A78 5G, màn hình 90Hz, sạc nhanh 33W.', 
    5990000, 4990000, 150, 250, 'uploads/products/a78.jpg', '6.56 inch', '8GB', '128GB', '5000 mAh', 1, 4, 0),

-- Vivo   
(N'Vivo X100 Pro',         N'Vivo X100 Pro - Camera ZEISS, Dimensity 9300, ảnh đêm xuất sắc.', 
    19990000, 17990000, 40, 35, 'uploads/products/vivox100pro.jpg', '6.78 inch', '16GB', '512GB', '5400 mAh', 1, 5, 0),

(N'Vivo V30e',             N'Vivo V30e - Aura Light Portrait, thiết kế mỏng nhẹ.', 
    8990000, 7990000, 85, 90, 'uploads/products/v30e.jpg', '6.78 inch', '8GB', '256GB', '4800 mAh', 1, 5, 0),

-- Realme
(N'Realme GT5 Pro',        N'Realme GT5 Pro - Snapdragon 8 Gen 3, camera periscope 64MP.', 
    13990000, 11990000, 55, 70, 'uploads/products/gt5pro.jpg', '6.78 inch', '16GB', '256GB', '5400 mAh', 1, 6, 0),

(N'Realme C67',            N'Realme C67 - Camera 108MP, pin 5000mAh, giá sinh viên.', 
    3990000, 3490000, 180, 400, 'uploads/products/c67.jpg', '6.72 inch', '6GB', '128GB', '5000 mAh', 1, 6, 0),

-- Nokia
(N'Nokia 105 4G',          N'Nokia 105 4G, điện thoại phổ thông, pin lâu, bền bỉ.', 
    590000, NULL, 300, 800, 'uploads/products/nokia105.jpg', '1.8 inch', NULL, NULL, '1020 mAh', 2, 7, 0),

-- OnePlus
(N'OnePlus 12',            N'OnePlus 12 - Snapdragon 8 Gen 3, sạc nhanh 100W SUPERVOOC.', 
    19990000, 17990000, 30, 25, 'uploads/products/oneplus12.jpg', '6.82 inch', '16GB', '256GB', '5400 mAh', 1, 8, 0),

-- Phụ kiện
(N'Tai nghe AirPods Pro 2', N'Apple AirPods Pro 2 với USB-C, chống ồn chủ động ANC.', 
    6190000, 5490000, 100, 180, 'uploads/products/airpodspro2.jpg', NULL, NULL, NULL, NULL, 4, 1, 1);
GO


-- ─────────────────────────────────────────────────
-- 🖼️ Product Images (mỗi SP có thêm 2-3 ảnh)
-- ─────────────────────────────────────────────────

INSERT INTO ProductImages (productId, imagePath, displayOrder) VALUES
(1, 'uploads/products/iphone15promax_1.jpg', 1),
(1, 'uploads/products/iphone15promax_2.jpg', 2),
(1, 'uploads/products/iphone15promax_3.jpg', 3),
(2, 'uploads/products/iphone15_1.jpg', 1),
(2, 'uploads/products/iphone15_2.jpg', 2),
(4, 'uploads/products/s24ultra_1.jpg', 1),
(4, 'uploads/products/s24ultra_2.jpg', 2),
(4, 'uploads/products/s24ultra_3.jpg', 3),
(5, 'uploads/products/s24_1.jpg', 1),
(8, 'uploads/products/xiaomi14ultra_1.jpg', 1),
(8, 'uploads/products/xiaomi14ultra_2.jpg', 2),
(11, 'uploads/products/findx7ultra_1.jpg', 1),
(11, 'uploads/products/findx7ultra_2.jpg', 2);
GO


-- ─────────────────────────────────────────────────
-- 📋 Orders + OrderDetails (đơn hàng mẫu)
-- ─────────────────────────────────────────────────

-- Đơn hàng 1: Nguyễn Văn A mua iPhone 15 Pro Max + AirPods
INSERT INTO Orders (userId, totalAmount, shippingAddress, phone, note, status) VALUES
(3, 38480000, N'123 Trần Phú, Ba Đình, Hà Nội', '0912345678', N'Giao giờ hành chính', 'delivered');

INSERT INTO OrderDetails (orderId, productId, quantity, unitPrice) VALUES
(1, 1, 1, 32990000),
(1, 20, 1, 5490000);

-- Đơn hàng 2: Trần Thị B mua Galaxy S24 Ultra
INSERT INTO Orders (userId, totalAmount, shippingAddress, phone, note, status) VALUES
(4, 31990000, N'456 Lê Lợi, Quận 1, TP.HCM', '0923456789', N'Gọi trước khi giao', 'shipping');

INSERT INTO OrderDetails (orderId, productId, quantity, unitPrice) VALUES
(2, 4, 1, 31990000);

-- Đơn hàng 3: Lê Văn C mua Redmi Note 13 Pro+ x2 + Redmi 13C
INSERT INTO Orders (userId, totalAmount, shippingAddress, phone, note, status) VALUES
(5, 18970000, N'789 Nguyễn Huệ, Hải Châu, Đà Nẵng', '0934567890', NULL, 'confirmed');

INSERT INTO OrderDetails (orderId, productId, quantity, unitPrice) VALUES
(3, 9,  2, 7990000),
(3, 10, 1, 2990000);

-- Đơn hàng 4: Phạm Thị D mua OPPO A78 + Vivo V30e
INSERT INTO Orders (userId, totalAmount, shippingAddress, phone, note, status) VALUES
(6, 12980000, N'321 Hai Bà Trưng, Huế', '0945678901', N'Ship COD', 'pending');

INSERT INTO OrderDetails (orderId, productId, quantity, unitPrice) VALUES
(4, 13, 1, 4990000),
(4, 15, 1, 7990000);

-- Đơn hàng 5: Hoàng Văn E mua OnePlus 12
INSERT INTO Orders (userId, totalAmount, shippingAddress, phone, note, status) VALUES
(7, 17990000, N'654 Phan Chu Trinh, Ninh Kiều, Cần Thơ', '0956789012', NULL, 'delivered');

INSERT INTO OrderDetails (orderId, productId, quantity, unitPrice) VALUES
(5, 19, 1, 17990000);
GO


-- ─────────────────────────────────────────────────
-- ⭐ Reviews (Đánh giá mẫu)
-- ─────────────────────────────────────────────────

INSERT INTO Reviews (userId, productId, rating, comment) VALUES
(3, 1, 5, N'iPhone 15 Pro Max quá đỉnh! Camera chụp đêm rất đẹp, chip A17 Pro mượt mà.'),
(4, 4, 5, N'Galaxy S24 Ultra tuyệt vời, Galaxy AI rất hữu ích, S Pen tiện lợi.'),
(5, 9, 4, N'Redmi Note 13 Pro+ giá hời, camera 200MP chụp rõ nét, chỉ hơi nóng khi chơi game.'),
(6, 13, 4, N'OPPO A78 tầm giá này rất ổn, thiết kế đẹp, pin dùng cả ngày.'),
(7, 19, 5, N'OnePlus 12 hiệu năng quái vật, sạc 100W cực nhanh, rất hài lòng!'),
(3, 20, 4, N'AirPods Pro 2 chống ồn tốt, âm thanh spatial audio rất hay.'),
(5, 10, 3, N'Redmi 13C tạm ổn cho nhu cầu cơ bản, giá rẻ nên không đòi hỏi nhiều.');
GO


-- ─────────────────────────────────────────────────
-- 🛒 Cart (Giỏ hàng mẫu - Nguyễn Văn A đang chọn thêm SP)
-- ─────────────────────────────────────────────────

INSERT INTO Cart (userId, productId, quantity) VALUES
(3, 8, 1),     -- Xiaomi 14 Ultra
(3, 5, 1),     -- Galaxy S24
(4, 2, 1),     -- iPhone 15
(4, 11, 1);    -- OPPO Find X7 Ultra
GO


-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- 📌 STEP 5: Các truy vấn mẫu (Useful Queries)
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━


-- ✅ 1. Lấy sản phẩm nổi bật (Featured Products)
SELECT p.productId, p.productName, p.price, p.salePrice, p.thumbnail, b.brandName
FROM Products p
JOIN Brands b ON p.brandId = b.brandId
WHERE p.isFeatured = 1 AND p.isActive = 1;


-- ✅ 2. Lấy sản phẩm mới nhất (Latest Products) - Top 10
SELECT TOP 10 p.productId, p.productName, p.price, p.salePrice, p.thumbnail, b.brandName
FROM Products p
JOIN Brands b ON p.brandId = b.brandId
WHERE p.isActive = 1
ORDER BY p.createdDate DESC;


-- ✅ 3. Sản phẩm bán chạy nhất (Best Sellers) - Top 10
SELECT TOP 10 p.productId, p.productName, p.price, p.salePrice, p.soldCount, p.thumbnail, b.brandName
FROM Products p
JOIN Brands b ON p.brandId = b.brandId
WHERE p.isActive = 1
ORDER BY p.soldCount DESC;


-- ✅ 4. Tìm kiếm sản phẩm theo tên
SELECT p.productId, p.productName, p.price, p.salePrice, p.thumbnail, b.brandName, c.categoryName
FROM Products p
JOIN Brands b ON p.brandId = b.brandId
JOIN Categories c ON p.categoryId = c.categoryId
WHERE p.productName LIKE N'%iPhone%' AND p.isActive = 1;


-- ✅ 5. Tìm kiếm theo khoảng giá
SELECT p.productId, p.productName, p.price, p.salePrice, b.brandName
FROM Products p
JOIN Brands b ON p.brandId = b.brandId
WHERE p.price BETWEEN 5000000 AND 15000000 AND p.isActive = 1
ORDER BY p.price ASC;


-- ✅ 6. Phân trang sản phẩm (trang 1, mỗi trang 8 SP)
SELECT p.productId, p.productName, p.price, p.salePrice, p.thumbnail, b.brandName
FROM Products p
JOIN Brands b ON p.brandId = b.brandId
WHERE p.isActive = 1
ORDER BY p.createdDate DESC
OFFSET 0 ROWS FETCH NEXT 8 ROWS ONLY;
-- Trang 2: OFFSET 8 ROWS FETCH NEXT 8 ROWS ONLY;


-- ✅ 7. Chi tiết sản phẩm + đánh giá trung bình
SELECT 
    p.*, 
    b.brandName, 
    c.categoryName,
    ISNULL(AVG(CAST(r.rating AS FLOAT)), 0) AS avgRating,
    COUNT(r.reviewId) AS totalReviews
FROM Products p
JOIN Brands b ON p.brandId = b.brandId
JOIN Categories c ON p.categoryId = c.categoryId
LEFT JOIN Reviews r ON p.productId = r.productId
WHERE p.productId = 1
GROUP BY p.productId, p.productName, p.description, p.price, p.salePrice, 
         p.quantity, p.soldCount, p.thumbnail, p.screenSize, p.ram, p.storage, 
         p.battery, p.categoryId, p.brandId, p.isFeatured, p.isActive, 
         p.createdDate, p.updatedDate, b.brandName, c.categoryName;


-- ✅ 8. Giỏ hàng của user (userId = 3)
SELECT 
    c.cartId, 
    p.productId, 
    p.productName, 
    p.thumbnail, 
    ISNULL(p.salePrice, p.price) AS currentPrice,
    c.quantity,
    ISNULL(p.salePrice, p.price) * c.quantity AS subtotal
FROM Cart c
JOIN Products p ON c.productId = p.productId
WHERE c.userId = 3;


-- ✅ 9. Lịch sử đơn hàng của user
SELECT 
    o.orderId, 
    o.orderDate, 
    o.totalAmount, 
    o.status,
    COUNT(od.orderDetailId) AS totalItems
FROM Orders o
JOIN OrderDetails od ON o.orderId = od.orderId
WHERE o.userId = 3
GROUP BY o.orderId, o.orderDate, o.totalAmount, o.status
ORDER BY o.orderDate DESC;


-- ✅ 10. Thống kê tổng quan (Dashboard Admin)
SELECT 
    (SELECT COUNT(*) FROM Products WHERE isActive = 1)  AS totalProducts,
    (SELECT SUM(soldCount) FROM Products)               AS totalSold,
    (SELECT COUNT(*) FROM Orders)                       AS totalOrders,
    (SELECT SUM(totalAmount) FROM Orders WHERE status = 'delivered') AS totalRevenue,
    (SELECT COUNT(*) FROM Users WHERE role = 'user')    AS totalCustomers;


-- ✅ 11. Thống kê doanh thu theo tháng
SELECT 
    YEAR(orderDate)  AS [year],
    MONTH(orderDate) AS [month],
    COUNT(*)         AS orderCount,
    SUM(totalAmount) AS revenue
FROM Orders
WHERE status = 'delivered'
GROUP BY YEAR(orderDate), MONTH(orderDate)
ORDER BY [year] DESC, [month] DESC;


-- ✅ 12. Top sản phẩm bán chạy theo doanh thu
SELECT TOP 5
    p.productName,
    b.brandName,
    SUM(od.quantity)             AS totalQuantitySold,
    SUM(od.quantity * od.unitPrice) AS totalRevenue
FROM OrderDetails od
JOIN Products p ON od.productId = p.productId
JOIN Brands b ON p.brandId = b.brandId
JOIN Orders o ON od.orderId = o.orderId
WHERE o.status IN ('delivered', 'shipping', 'confirmed')
GROUP BY p.productName, b.brandName
ORDER BY totalRevenue DESC;


-- ✅ 13. Sản phẩm theo thương hiệu
SELECT p.productId, p.productName, p.price, p.salePrice, p.thumbnail
FROM Products p
WHERE p.brandId = 1 AND p.isActive = 1    -- brandId = 1 = Apple
ORDER BY p.price DESC;


-- ✅ 14. Đánh giá của một sản phẩm
SELECT 
    r.rating, 
    r.comment, 
    r.createdDate, 
    u.fullName, 
    u.avatar
FROM Reviews r
JOIN Users u ON r.userId = u.userId
WHERE r.productId = 1
ORDER BY r.createdDate DESC;


-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- ✅ DONE! Database PhoneEcommerce đã sẵn sàng.
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
