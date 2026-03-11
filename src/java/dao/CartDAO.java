package dao;

import model.CartItem;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    public List<CartItem> getCartByUser(int userId) {
        List<CartItem> list = new ArrayList<>();
        String sql = "SELECT c.cartId, c.userId, c.productId, c.quantity, "
                + "p.productName, p.thumbnail, p.price, p.salePrice, p.quantity AS stockQuantity "
                + "FROM Cart c JOIN Products p ON c.productId = p.productId "
                + "WHERE c.userId = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CartItem item = new CartItem();
                item.setCartId(rs.getInt("cartId"));
                item.setUserId(rs.getInt("userId"));
                item.setProductId(rs.getInt("productId"));
                item.setQuantity(rs.getInt("quantity"));
                item.setProductName(rs.getString("productName"));
                item.setThumbnail(rs.getString("thumbnail"));
                item.setPrice(rs.getDouble("price"));
                item.setSalePrice(rs.getDouble("salePrice"));
                item.setStockQuantity(rs.getInt("stockQuantity"));
                list.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addToCart(int userId, int productId, int quantity) {
        // Kiem tra da co trong gio chua
        String checkSql = "SELECT cartId, quantity FROM Cart WHERE userId = ? AND productId = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement check = conn.prepareStatement(checkSql)) {
            check.setInt(1, userId);
            check.setInt(2, productId);
            ResultSet rs = check.executeQuery();
            if (rs.next()) {
                // Da co -> tang so luong
                int newQty = rs.getInt("quantity") + quantity;
                String updateSql = "UPDATE Cart SET quantity = ? WHERE userId = ? AND productId = ?";
                PreparedStatement update = conn.prepareStatement(updateSql);
                update.setInt(1, newQty);
                update.setInt(2, userId);
                update.setInt(3, productId);
                return update.executeUpdate() > 0;
            } else {
                // Chua co -> them moi
                String insertSql = "INSERT INTO Cart (userId, productId, quantity) VALUES (?, ?, ?)";
                PreparedStatement insert = conn.prepareStatement(insertSql);
                insert.setInt(1, userId);
                insert.setInt(2, productId);
                insert.setInt(3, quantity);
                return insert.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateQuantity(int userId, int productId, int quantity) {
        if (quantity <= 0) {
            return removeFromCart(userId, productId);
        }
        String sql = "UPDATE Cart SET quantity = ? WHERE userId = ? AND productId = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, userId);
            ps.setInt(3, productId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean removeFromCart(int userId, int productId) {
        String sql = "DELETE FROM Cart WHERE userId = ? AND productId = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean clearCart(int userId) {
        String sql = "DELETE FROM Cart WHERE userId = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getCartCount(int userId) {
        String sql = "SELECT ISNULL(SUM(quantity), 0) FROM Cart WHERE userId = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
