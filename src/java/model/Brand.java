package model;

public class Brand {

    private int brandId;
    private String brandName;
    private String logo;
    private boolean isActive;

    public Brand() {
    }

    public Brand(int brandId, String brandName, String logo, boolean isActive) {
        this.brandId = brandId;
        this.brandName = brandName;
        this.logo = logo;
        this.isActive = isActive;
    }

    public int getBrandId() { return brandId; }
    public void setBrandId(int brandId) { this.brandId = brandId; }

    public String getBrandName() { return brandName; }
    public void setBrandName(String brandName) { this.brandName = brandName; }

    public String getLogo() { return logo; }
    public void setLogo(String logo) { this.logo = logo; }

    public boolean isIsActive() { return isActive; }
    public void setIsActive(boolean isActive) { this.isActive = isActive; }
}
