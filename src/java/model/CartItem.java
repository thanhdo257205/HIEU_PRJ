package model;

public class CartItem {

    private int cartId;
    private int userId;
    private int productId;
    private int quantity;

    // Join info
    private String productName;
    private String thumbnail;
    private double price;
    private double salePrice;
    private int stockQuantity;

    public CartItem() {
    }

    public int getCartId() { return cartId; }
    public void setCartId(int cartId) { this.cartId = cartId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getThumbnail() { return thumbnail; }
    public void setThumbnail(String thumbnail) { this.thumbnail = thumbnail; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public double getSalePrice() { return salePrice; }
    public void setSalePrice(double salePrice) { this.salePrice = salePrice; }

    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }

    public double getDisplayPrice() {
        return salePrice > 0 ? salePrice : price;
    }

    public double getSubtotal() {
        return getDisplayPrice() * quantity;
    }
}
