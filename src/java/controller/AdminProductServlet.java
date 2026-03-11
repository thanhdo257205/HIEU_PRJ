package controller;

import dao.ProductDAO;
import dao.BrandDAO;
import dao.CategoryDAO;
import model.Product;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

@WebServlet(name = "AdminProductServlet", urlPatterns = {"/admin/products"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,     // 1 MB
    maxFileSize = 1024 * 1024 * 10,       // 10 MB
    maxRequestSize = 1024 * 1024 * 50     // 50 MB
)
public class AdminProductServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kiem tra quyen admin
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action) || "edit".equals(action)) {
            // Form them/sua san pham
            BrandDAO brandDAO = new BrandDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            request.setAttribute("brands", brandDAO.getAllBrands());
            request.setAttribute("categories", categoryDAO.getAllCategories());

            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                ProductDAO productDAO = new ProductDAO();
                Product product = productDAO.getProductById(id);
                request.setAttribute("product", product);
            }
            request.getRequestDispatcher("/views/admin/product-form.jsp").forward(request, response);

        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            ProductDAO productDAO = new ProductDAO();
            productDAO.deleteProduct(id);
            response.sendRedirect("products");

        } else {
            // Danh sach san pham
            ProductDAO productDAO = new ProductDAO();
            List<Product> products = productDAO.getAllProducts();
            request.setAttribute("products", products);
            request.getRequestDispatcher("/views/admin/product-manage.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        ProductDAO productDAO = new ProductDAO();
        Product p = new Product();

        String productIdStr = request.getParameter("productId");
        if (productIdStr != null && !productIdStr.isEmpty()) {
            p.setProductId(Integer.parseInt(productIdStr));
        }
        p.setProductName(request.getParameter("productName"));
        p.setDescription(request.getParameter("description"));
        p.setPrice(Double.parseDouble(request.getParameter("price")));
        String salePriceStr = request.getParameter("salePrice");
        p.setSalePrice(salePriceStr != null && !salePriceStr.isEmpty() ? Double.parseDouble(salePriceStr) : 0);
        p.setQuantity(Integer.parseInt(request.getParameter("quantity")));
        p.setScreenSize(request.getParameter("screenSize"));
        p.setRam(request.getParameter("ram"));
        p.setStorage(request.getParameter("storage"));
        p.setBattery(request.getParameter("battery"));
        p.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
        p.setBrandId(Integer.parseInt(request.getParameter("brandId")));
        p.setIsFeatured("on".equals(request.getParameter("isFeatured")));

        // Xu ly upload anh
        Part filePart = request.getPart("thumbnail");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            // Them timestamp de tranh trung ten
            String newFileName = System.currentTimeMillis() + "_" + fileName;
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "products";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();
            filePart.write(uploadPath + File.separator + newFileName);
            p.setThumbnail("uploads/products/" + newFileName);
        } else if (p.getProductId() > 0) {
            // Giu anh cu khi sua
            Product existing = productDAO.getProductById(p.getProductId());
            if (existing != null) {
                p.setThumbnail(existing.getThumbnail());
            }
        }

        if (p.getProductId() > 0) {
            productDAO.updateProduct(p);
        } else {
            productDAO.addProduct(p);
        }

        response.sendRedirect("products");
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        User user = (User) session.getAttribute("user");
        return user != null && user.isAdmin();
    }
}
