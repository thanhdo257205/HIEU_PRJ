package dao;

import model.Product;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    // Lay san pham noi bat
    public List<Product> getFeaturedProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*, b.brandName, c.categoryName FROM Products p "
                + "JOIN Brands b ON p.brandId = b.brandId "
                + "JOIN Categories c ON p.categoryId = c.categoryId "
                + "WHERE p.isFeatured = 1 AND p.isActive = 1";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lay san pham moi nhat
    public List<Product> getLatestProducts(int top) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT TOP (?) p.*, b.brandName, c.categoryName FROM Products p "
                + "JOIN Brands b ON p.brandId = b.brandId "
                + "JOIN Categories c ON p.categoryId = c.categoryId "
                + "WHERE p.isActive = 1 ORDER BY p.createdDate DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, top);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lay san pham ban chay
    public List<Product> getBestSellers(int top) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT TOP (?) p.*, b.brandName, c.categoryName FROM Products p "
                + "JOIN Brands b ON p.brandId = b.brandId "
                + "JOIN Categories c ON p.categoryId = c.categoryId "
                + "WHERE p.isActive = 1 ORDER BY p.soldCount DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, top);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lay san pham theo ID
    public Product getProductById(int id) {
        String sql = "SELECT p.*, b.brandName, c.categoryName, "
                + "ISNULL(AVG(CAST(r.rating AS FLOAT)), 0) AS avgRating, "
                + "COUNT(r.reviewId) AS totalReviews "
                + "FROM Products p "
                + "JOIN Brands b ON p.brandId = b.brandId "
                + "JOIN Categories c ON p.categoryId = c.categoryId "
                + "LEFT JOIN Reviews r ON p.productId = r.productId "
                + "WHERE p.productId = ? "
                + "GROUP BY p.productId, p.productName, p.description, p.price, p.salePrice, "
                + "p.quantity, p.soldCount, p.thumbnail, p.screenSize, p.ram, p.storage, "
                + "p.battery, p.categoryId, p.brandId, p.isFeatured, p.isActive, "
                + "p.createdDate, p.updatedDate, b.brandName, c.categoryName";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Product p = mapProduct(rs);
                p.setAvgRating(rs.getDouble("avgRating"));
                p.setTotalReviews(rs.getInt("totalReviews"));
                return p;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Tim kiem + phan trang
    public List<Product> searchProducts(String keyword, int brandId, int categoryId,
            double minPrice, double maxPrice, String sortBy, int page, int pageSize) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT p.*, b.brandName, c.categoryName FROM Products p ");
        sql.append("JOIN Brands b ON p.brandId = b.brandId ");
        sql.append("JOIN Categories c ON p.categoryId = c.categoryId ");
        sql.append("WHERE p.isActive = 1 ");

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND p.productName LIKE ? ");
            params.add("%" + keyword.trim() + "%");
        }
        if (brandId > 0) {
            sql.append("AND p.brandId = ? ");
            params.add(brandId);
        }
        if (categoryId > 0) {
            sql.append("AND p.categoryId = ? ");
            params.add(categoryId);
        }
        if (minPrice > 0) {
            sql.append("AND p.price >= ? ");
            params.add(minPrice);
        }
        if (maxPrice > 0) {
            sql.append("AND p.price <= ? ");
            params.add(maxPrice);
        }

        // Sort
        switch (sortBy != null ? sortBy : "newest") {
            case "price_asc":
                sql.append("ORDER BY ISNULL(p.salePrice, p.price) ASC ");
                break;
            case "price_desc":
                sql.append("ORDER BY ISNULL(p.salePrice, p.price) DESC ");
                break;
            case "name_asc":
                sql.append("ORDER BY p.productName ASC ");
                break;
            case "name_desc":
                sql.append("ORDER BY p.productName DESC ");
                break;
            case "best_seller":
                sql.append("ORDER BY p.soldCount DESC ");
                break;
            default:
                sql.append("ORDER BY p.createdDate DESC ");
        }

        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((page - 1) * pageSize);
        params.add(pageSize);

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    ps.setString(i + 1, (String) param);
                } else if (param instanceof Integer) {
                    ps.setInt(i + 1, (Integer) param);
                } else if (param instanceof Double) {
                    ps.setDouble(i + 1, (Double) param);
                }
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Dem tong so san pham (cho phan trang)
    public int countProducts(String keyword, int brandId, int categoryId, double minPrice, double maxPrice) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM Products p WHERE p.isActive = 1 ");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND p.productName LIKE ? ");
            params.add("%" + keyword.trim() + "%");
        }
        if (brandId > 0) {
            sql.append("AND p.brandId = ? ");
            params.add(brandId);
        }
        if (categoryId > 0) {
            sql.append("AND p.categoryId = ? ");
            params.add(categoryId);
        }
        if (minPrice > 0) {
            sql.append("AND p.price >= ? ");
            params.add(minPrice);
        }
        if (maxPrice > 0) {
            sql.append("AND p.price <= ? ");
            params.add(maxPrice);
        }

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) ps.setString(i + 1, (String) param);
                else if (param instanceof Integer) ps.setInt(i + 1, (Integer) param);
                else if (param instanceof Double) ps.setDouble(i + 1, (Double) param);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Them san pham (Admin)
    public boolean addProduct(Product p) {
        String sql = "INSERT INTO Products (productName, description, price, salePrice, quantity, "
                + "thumbnail, screenSize, ram, storage, battery, categoryId, brandId, isFeatured) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getProductName());
            ps.setString(2, p.getDescription());
            ps.setDouble(3, p.getPrice());
            ps.setDouble(4, p.getSalePrice());
            ps.setInt(5, p.getQuantity());
            ps.setString(6, p.getThumbnail());
            ps.setString(7, p.getScreenSize());
            ps.setString(8, p.getRam());
            ps.setString(9, p.getStorage());
            ps.setString(10, p.getBattery());
            ps.setInt(11, p.getCategoryId());
            ps.setInt(12, p.getBrandId());
            ps.setBoolean(13, p.isIsFeatured());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cap nhat san pham (Admin)
    public boolean updateProduct(Product p) {
        String sql = "UPDATE Products SET productName = ?, description = ?, price = ?, salePrice = ?, "
                + "quantity = ?, thumbnail = ?, screenSize = ?, ram = ?, storage = ?, battery = ?, "
                + "categoryId = ?, brandId = ?, isFeatured = ?, updatedDate = GETDATE() WHERE productId = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, p.getProductName());
            ps.setString(2, p.getDescription());
            ps.setDouble(3, p.getPrice());
            ps.setDouble(4, p.getSalePrice());
            ps.setInt(5, p.getQuantity());
            ps.setString(6, p.getThumbnail());
            ps.setString(7, p.getScreenSize());
            ps.setString(8, p.getRam());
            ps.setString(9, p.getStorage());
            ps.setString(10, p.getBattery());
            ps.setInt(11, p.getCategoryId());
            ps.setInt(12, p.getBrandId());
            ps.setBoolean(13, p.isIsFeatured());
            ps.setInt(14, p.getProductId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xoa san pham (Admin)
    public boolean deleteProduct(int productId) {
        String sql = "UPDATE Products SET isActive = 0 WHERE productId = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lay tat ca san pham (Admin - bao gom ca inactive)
    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*, b.brandName, c.categoryName FROM Products p "
                + "JOIN Brands b ON p.brandId = b.brandId "
                + "JOIN Categories c ON p.categoryId = c.categoryId "
                + "ORDER BY p.createdDate DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private Product mapProduct(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setProductId(rs.getInt("productId"));
        p.setProductName(rs.getString("productName"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getDouble("price"));
        p.setSalePrice(rs.getDouble("salePrice"));
        p.setQuantity(rs.getInt("quantity"));
        p.setSoldCount(rs.getInt("soldCount"));
        p.setThumbnail(rs.getString("thumbnail"));
        p.setScreenSize(rs.getString("screenSize"));
        p.setRam(rs.getString("ram"));
        p.setStorage(rs.getString("storage"));
        p.setBattery(rs.getString("battery"));
        p.setCategoryId(rs.getInt("categoryId"));
        p.setBrandId(rs.getInt("brandId"));
        p.setIsFeatured(rs.getBoolean("isFeatured"));
        p.setIsActive(rs.getBoolean("isActive"));
        p.setCreatedDate(rs.getTimestamp("createdDate"));
        p.setUpdatedDate(rs.getTimestamp("updatedDate"));
        try {
            p.setBrandName(rs.getString("brandName"));
            p.setCategoryName(rs.getString("categoryName"));
        } catch (SQLException e) {
            // Columns not in result set
        }
        return p;
    }
}
