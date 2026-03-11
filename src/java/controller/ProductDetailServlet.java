package controller;

import dao.ProductDAO;
import dao.ReviewDAO;
import model.Product;
import model.Review;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductDetailServlet", urlPatterns = {"/product"})
public class ProductDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            ProductDAO productDAO = new ProductDAO();
            ReviewDAO reviewDAO = new ReviewDAO();

            Product product = productDAO.getProductById(id);
            if (product == null) {
                response.sendRedirect("home");
                return;
            }

            List<Review> reviews = reviewDAO.getReviewsByProduct(id);

            // Kiem tra user da danh gia chua
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("user") != null) {
                model.User user = (model.User) session.getAttribute("user");
                boolean hasReviewed = reviewDAO.hasReviewed(user.getUserId(), id);
                request.setAttribute("hasReviewed", hasReviewed);
            }

            // Lay san pham lien quan (cung thuong hieu)
            List<Product> relatedProducts = productDAO.searchProducts(
                    null, product.getBrandId(), 0, 0, 0, "best_seller", 1, 4);

            request.setAttribute("product", product);
            request.setAttribute("reviews", reviews);
            request.setAttribute("relatedProducts", relatedProducts);
            request.getRequestDispatcher("views/product-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("home");
        }
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

        model.User user = (model.User) session.getAttribute("user");
        int productId = Integer.parseInt(request.getParameter("productId"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String comment = request.getParameter("comment");

        ReviewDAO reviewDAO = new ReviewDAO();
        reviewDAO.addReview(user.getUserId(), productId, rating, comment);

        response.sendRedirect("product?id=" + productId);
    }
}
