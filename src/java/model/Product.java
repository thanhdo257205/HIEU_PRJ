package model;

import java.util.Date;

public class Product {

    private int productId;
    private String productName;
    private String description;
    private double price;
    private double salePrice;
    private int quantity;
    private int soldCount;
    private String thumbnail;
    private String screenSize;
    private String ram;
    private String storage;
    private String battery;
    private int categoryId;
    private int brandId;
    private boolean isFeatured;
    private boolean isActive;
    private Date createdDate;
    private Date updatedDate;

    // Thong tin join
    private String brandName;
    private String categoryName;
    private double avgRating;
    private int totalReviews;

    public Product() {
    }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public double getSalePrice() { return salePrice; }
    public void setSalePrice(double salePrice) { this.salePrice = salePrice; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public int getSoldCount() { return soldCount; }
    public void setSoldCount(int soldCount) { this.soldCount = soldCount; }

    public String getThumbnail() { return thumbnail; }
    public void setThumbnail(String thumbnail) { this.thumbnail = thumbnail; }

    public String getScreenSize() { return screenSize; }
    public void setScreenSize(String screenSize) { this.screenSize = screenSize; }

    public String getRam() { return ram; }
    public void setRam(String ram) { this.ram = ram; }

    public String getStorage() { return storage; }
    public void setStorage(String storage) { this.storage = storage; }

    public String getBattery() { return battery; }
    public void setBattery(String battery) { this.battery = battery; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public int getBrandId() { return brandId; }
    public void setBrandId(int brandId) { this.brandId = brandId; }

    public boolean isIsFeatured() { return isFeatured; }
    public void setIsFeatured(boolean isFeatured) { this.isFeatured = isFeatured; }

    public boolean isIsActive() { return isActive; }
    public void setIsActive(boolean isActive) { this.isActive = isActive; }

    public Date getCreatedDate() { return createdDate; }
    public void setCreatedDate(Date createdDate) { this.createdDate = createdDate; }

    public Date getUpdatedDate() { return updatedDate; }
    public void setUpdatedDate(Date updatedDate) { this.updatedDate = updatedDate; }

    public String getBrandName() { return brandName; }
    public void setBrandName(String brandName) { this.brandName = brandName; }

    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }

    public double getAvgRating() { return avgRating; }
    public void setAvgRating(double avgRating) { this.avgRating = avgRating; }

    public int getTotalReviews() { return totalReviews; }
    public void setTotalReviews(int totalReviews) { this.totalReviews = totalReviews; }

    // Gia hien thi (uu tien gia sale)
    public double getDisplayPrice() {
        return salePrice > 0 ? salePrice : price;
    }

    // Tinh % giam gia
    public int getDiscountPercent() {
        if (salePrice > 0 && price > 0) {
            return (int) Math.round((1 - salePrice / price) * 100);
        }
        return 0;
    }
}
