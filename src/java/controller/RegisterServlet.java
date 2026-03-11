package controller;

import dao.UserDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("views/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        UserDAO dao = new UserDAO();

        // Validate
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            keepFormData(request, username, fullName, email, phone, address);
            request.getRequestDispatcher("views/register.jsp").forward(request, response);
            return;
        }

        if (dao.isUsernameExists(username)) {
            request.setAttribute("error", "Tên đăng nhập đã tồn tại!");
            keepFormData(request, username, fullName, email, phone, address);
            request.getRequestDispatcher("views/register.jsp").forward(request, response);
            return;
        }

        if (dao.isEmailExists(email)) {
            request.setAttribute("error", "Email đã được sử dụng!");
            keepFormData(request, username, fullName, email, phone, address);
            request.getRequestDispatcher("views/register.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setAddress(address);

        if (dao.register(user)) {
            request.setAttribute("success", "Đăng ký thành công! Hãy đăng nhập.");
            request.getRequestDispatcher("views/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Đăng ký thất bại! Vui lòng thử lại.");
            keepFormData(request, username, fullName, email, phone, address);
            request.getRequestDispatcher("views/register.jsp").forward(request, response);
        }
    }

    private void keepFormData(HttpServletRequest request, String username,
            String fullName, String email, String phone, String address) {
        request.setAttribute("username", username);
        request.setAttribute("fullName", fullName);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
        request.setAttribute("address", address);
    }
}
