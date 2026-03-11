package controller;

import dao.CartDAO;
import model.CartItem;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

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

        double totalAmount = 0;
        for (CartItem item : cartItems) {
            totalAmount += item.getSubtotal();
        }

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("totalAmount", totalAmount);
        request.getRequestDispatcher("views/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");
        CartDAO cartDAO = new CartDAO();
        String action = request.getParameter("action");

        switch (action != null ? action : "") {
            case "add":
                int productId = Integer.parseInt(request.getParameter("productId"));
                int quantity = 1;
                try { quantity = Integer.parseInt(request.getParameter("quantity")); } catch (Exception e) {}
                cartDAO.addToCart(user.getUserId(), productId, quantity);
                session.setAttribute("cartMessage", "Sản phẩm đã được thêm vào giỏ hàng!");
                // Redirect lai trang truoc do
                String referer = request.getHeader("Referer");
                response.sendRedirect(referer != null ? referer : "home");
                break;

            case "update":
                int updateProductId = Integer.parseInt(request.getParameter("productId"));
                int newQuantity = Integer.parseInt(request.getParameter("quantity"));
                cartDAO.updateQuantity(user.getUserId(), updateProductId, newQuantity);
                response.sendRedirect("cart");
                break;

            case "remove":
                int removeProductId = Integer.parseInt(request.getParameter("productId"));
                cartDAO.removeFromCart(user.getUserId(), removeProductId);
                response.sendRedirect("cart");
                break;

            case "clear":
                cartDAO.clearCart(user.getUserId());
                response.sendRedirect("cart");
                break;

            default:
                response.sendRedirect("cart");
        }
    }
}
