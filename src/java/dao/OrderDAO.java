package dao;

import model.Order;
import model.OrderDetail;
import model.CartItem;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    // Tao don hang tu gio hang
    public boolean createOrder(int userId, String shippingAddress, String phone, String note, List<CartItem> cartItems) {
        Connection conn = null;
        try {
            conn = DBContext.getConnection();
            conn.setAutoCommit(false);

            // Tinh tong tien
            double totalAmount = 0;
            for (CartItem item : cartItems) {
                totalAmount += item.getSubtotal();
            }

            // Them don hang
            String orderSql = "INSERT INTO Orders (userId, totalAmount, shippingAddress, phone, note, status) "
                    + "VALUES (?, ?, ?, ?, ?, 'pending')";
            PreparedStatement orderPs = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
            orderPs.setInt(1, userId);
            orderPs.setDouble(2, totalAmount);
            orderPs.setString(3, shippingAddress);
            orderPs.setString(4, phone);
            orderPs.setString(5, note);
            orderPs.executeUpdate();

            ResultSet keys = orderPs.getGeneratedKeys();
            int orderId = 0;
            if (keys.next()) {
                orderId = keys.getInt(1);
            }

            // Them chi tiet don hang
            String detailSql = "INSERT INTO OrderDetails (orderId, productId, quantity, unitPrice) VALUES (?, ?, ?, ?)";
            PreparedStatement detailPs = conn.prepareStatement(detailSql);

            // Cap nhat so luong ton kho va so luong da ban
            String updateStockSql = "UPDATE Products SET quantity = quantity - ?, soldCount = soldCount + ? WHERE productId = ?";
            PreparedStatement stockPs = conn.prepareStatement(updateStockSql);

            for (CartItem item : cartItems) {
                detailPs.setInt(1, orderId);
                detailPs.setInt(2, item.getProductId());
                detailPs.setInt(3, item.getQuantity());
                detailPs.setDouble(4, item.getDisplayPrice());
                detailPs.addBatch();

                stockPs.setInt(1, item.getQuantity());
                stockPs.setInt(2, item.getQuantity());
                stockPs.setInt(3, item.getProductId());
                stockPs.addBatch();
            }
            detailPs.executeBatch();
            stockPs.executeBatch();

            // Xoa gio hang
            String clearCartSql = "DELETE FROM Cart WHERE userId = ?";
            PreparedStatement clearPs = conn.prepareStatement(clearCartSql);
            clearPs.setInt(1, userId);
            clearPs.executeUpdate();

            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        }
        return false;
    }

    // Lay don hang cua user
    public List<Order> getOrdersByUser(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.fullName AS customerName FROM Orders o "
                + "JOIN Users u ON o.userId = u.userId "
                + "WHERE o.userId = ? ORDER BY o.orderDate DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapOrder(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lay tat ca don hang (Admin)
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.fullName AS customerName FROM Orders o "
                + "JOIN Users u ON o.userId = u.userId ORDER BY o.orderDate DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapOrder(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lay chi tiet don hang
    public Order getOrderById(int orderId) {
        String sql = "SELECT o.*, u.fullName AS customerName FROM Orders o "
                + "JOIN Users u ON o.userId = u.userId WHERE o.orderId = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Order order = mapOrder(rs);
                order.setOrderDetails(getOrderDetails(orderId));
                return order;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lay chi tiet san pham trong don
    public List<OrderDetail> getOrderDetails(int orderId) {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT od.*, p.productName, p.thumbnail FROM OrderDetails od "
                + "JOIN Products p ON od.productId = p.productId WHERE od.orderId = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderDetail od = new OrderDetail();
                od.setOrderDetailId(rs.getInt("orderDetailId"));
                od.setOrderId(rs.getInt("orderId"));
                od.setProductId(rs.getInt("productId"));
                od.setQuantity(rs.getInt("quantity"));
                od.setUnitPrice(rs.getDouble("unitPrice"));
                od.setProductName(rs.getString("productName"));
                od.setThumbnail(rs.getString("thumbnail"));
                list.add(od);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Cap nhat trang thai don hang (Admin)
    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE Orders SET status = ? WHERE orderId = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Order mapOrder(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderId(rs.getInt("orderId"));
        o.setUserId(rs.getInt("userId"));
        o.setOrderDate(rs.getTimestamp("orderDate"));
        o.setTotalAmount(rs.getDouble("totalAmount"));
        o.setShippingAddress(rs.getString("shippingAddress"));
        o.setPhone(rs.getString("phone"));
        o.setNote(rs.getString("note"));
        o.setStatus(rs.getString("status"));
        try {
            o.setCustomerName(rs.getString("customerName"));
        } catch (SQLException e) {}
        return o;
    }
}
