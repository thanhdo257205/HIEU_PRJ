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

@WebServlet(name = "SearchServlet", urlPatterns = {"/search"})
public class SearchServlet extends HttpServlet {

    private static final int PAGE_SIZE = 8;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String keyword = request.getParameter("keyword");
        int brandId = parseIntParam(request.getParameter("brandId"), 0);
        int categoryId = parseIntParam(request.getParameter("categoryId"), 0);
        double minPrice = parseDoubleParam(request.getParameter("minPrice"), 0);
        double maxPrice = parseDoubleParam(request.getParameter("maxPrice"), 0);
        String sortBy = request.getParameter("sortBy");
        int page = parseIntParam(request.getParameter("page"), 1);

        ProductDAO productDAO = new ProductDAO();
        BrandDAO brandDAO = new BrandDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        List<Product> products = productDAO.searchProducts(keyword, brandId, categoryId,
                minPrice, maxPrice, sortBy, page, PAGE_SIZE);
        int totalProducts = productDAO.countProducts(keyword, brandId, categoryId, minPrice, maxPrice);
        int totalPages = (int) Math.ceil((double) totalProducts / PAGE_SIZE);

        List<Brand> brands = brandDAO.getAllBrands();
        List<Category> categories = categoryDAO.getAllCategories();

        request.setAttribute("products", products);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("brands", brands);
        request.setAttribute("categories", categories);

        // Giu lai cac filter
        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedBrandId", brandId);
        request.setAttribute("selectedCategoryId", categoryId);
        request.setAttribute("minPrice", minPrice > 0 ? minPrice : "");
        request.setAttribute("maxPrice", maxPrice > 0 ? maxPrice : "");
        request.setAttribute("sortBy", sortBy);

        request.getRequestDispatcher("views/search.jsp").forward(request, response);
    }

    private int parseIntParam(String value, int defaultVal) {
        try { return Integer.parseInt(value); } catch (Exception e) { return defaultVal; }
    }

    private double parseDoubleParam(String value, double defaultVal) {
        try { return Double.parseDouble(value); } catch (Exception e) { return defaultVal; }
    }
}
