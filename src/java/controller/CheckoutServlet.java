package controller;

import dao.CartDAO;
import dao.OrderDAO;
import model.CartItem;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");
        CartDAO cartDAO = new CartDAO();
        List<CartItem> cartItems = cartDAO.getCartByUser(user.getUserId());

        if (cartItems.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }

        double totalAmount = 0;
        for (CartItem item : cartItems) {
            totalAmount += item.getSubtotal();
        }

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("totalAmount", totalAmount);
        request.getRequestDispatcher("views/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String shippingAddress = request.getParameter("shippingAddress");
        String phone = request.getParameter("phone");
        String note = request.getParameter("note");

        CartDAO cartDAO = new CartDAO();
        List<CartItem> cartItems = cartDAO.getCartByUser(user.getUserId());

        if (cartItems.isEmpty()) {
            response.sendRedirect("cart");
            return;
        }

        OrderDAO orderDAO = new OrderDAO();
        boolean success = orderDAO.createOrder(user.getUserId(), shippingAddress, phone, note, cartItems);

        if (success) {
            request.setAttribute("success", "Đặt hàng thành công! Cảm ơn bạn đã mua sắm.");
            request.getRequestDispatcher("views/order-success.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Đặt hàng thất bại! Vui lòng thử lại.");
            doGet(request, response);
        }
    }
}
