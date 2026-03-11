package controller;

import dao.OrderDAO;
import dao.ProductDAO;
import model.User;
import utils.DBContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try (Connection conn = DBContext.getConnection()) {
            // Thong ke tong quan
            String sql = "SELECT "
                    + "(SELECT COUNT(*) FROM Products WHERE isActive = 1) AS totalProducts, "
                    + "(SELECT ISNULL(SUM(soldCount), 0) FROM Products) AS totalSold, "
                    + "(SELECT COUNT(*) FROM Orders) AS totalOrders, "
                    + "(SELECT ISNULL(SUM(totalAmount), 0) FROM Orders WHERE status = 'delivered') AS totalRevenue, "
                    + "(SELECT COUNT(*) FROM Users WHERE role = 'user') AS totalCustomers";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                request.setAttribute("totalProducts", rs.getInt("totalProducts"));
                request.setAttribute("totalSold", rs.getInt("totalSold"));
                request.setAttribute("totalOrders", rs.getInt("totalOrders"));
                request.setAttribute("totalRevenue", rs.getDouble("totalRevenue"));
                request.setAttribute("totalCustomers", rs.getInt("totalCustomers"));
            }

            // Dem theo trang thai don hang
            String statusSql = "SELECT status, COUNT(*) AS cnt FROM Orders GROUP BY status";
            PreparedStatement statusPs = conn.prepareStatement(statusSql);
            ResultSet statusRs = statusPs.executeQuery();
            int pending = 0, confirmed = 0, shipping = 0, delivered = 0, cancelled = 0;
            while (statusRs.next()) {
                switch (statusRs.getString("status")) {
                    case "pending": pending = statusRs.getInt("cnt"); break;
                    case "confirmed": confirmed = statusRs.getInt("cnt"); break;
                    case "shipping": shipping = statusRs.getInt("cnt"); break;
                    case "delivered": delivered = statusRs.getInt("cnt"); break;
                    case "cancelled": cancelled = statusRs.getInt("cnt"); break;
                }
            }
            request.setAttribute("pendingOrders", pending);
            request.setAttribute("confirmedOrders", confirmed);
            request.setAttribute("shippingOrders", shipping);
            request.setAttribute("deliveredOrders", delivered);
            request.setAttribute("cancelledOrders", cancelled);

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        User user = (User) session.getAttribute("user");
        return user != null && user.isAdmin();
    }
}
