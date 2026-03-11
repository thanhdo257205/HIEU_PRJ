package controller;

import dao.ProductDAO;
import dao.BrandDAO;
import dao.CategoryDAO;
import model.Product;
import model.Brand;
import model.Category;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        ProductDAO productDAO = new ProductDAO();
        BrandDAO brandDAO = new BrandDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        List<Product> featuredProducts = productDAO.getFeaturedProducts();
        List<Product> latestProducts = productDAO.getLatestProducts(8);
        List<Product> bestSellers = productDAO.getBestSellers(8);
        List<Brand> brands = brandDAO.getAllBrands();
        List<Category> categories = categoryDAO.getAllCategories();

        request.setAttribute("featuredProducts", featuredProducts);
        request.setAttribute("latestProducts", latestProducts);
        request.setAttribute("bestSellers", bestSellers);
        request.setAttribute("brands", brands);
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("views/home.jsp").forward(request, response);
    }
}
