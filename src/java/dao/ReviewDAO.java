package dao;

import model.Review;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    public List<Review> getReviewsByProduct(int productId) {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.*, u.fullName, u.avatar FROM Reviews r "
                + "JOIN Users u ON r.userId = u.userId "
                + "WHERE r.productId = ? ORDER BY r.createdDate DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Review r = new Review();
                r.setReviewId(rs.getInt("reviewId"));
                r.setUserId(rs.getInt("userId"));
                r.setProductId(rs.getInt("productId"));
                r.setRating(rs.getInt("rating"));
                r.setComment(rs.getString("comment"));
                r.setCreatedDate(rs.getTimestamp("createdDate"));
                r.setFullName(rs.getString("fullName"));
                r.setAvatar(rs.getString("avatar"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addReview(int userId, int productId, int rating, String comment) {
        String sql = "INSERT INTO Reviews (userId, productId, rating, comment) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.setInt(3, rating);
            ps.setString(4, comment);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean hasReviewed(int userId, int productId) {
        String sql = "SELECT 1 FROM Reviews WHERE userId = ? AND productId = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            return ps.executeQuery().next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
