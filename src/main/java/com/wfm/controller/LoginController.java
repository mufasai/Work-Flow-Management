package com.wfm.controller;

import java.io.IOException;

import com.wfm.dao.UserDao;
import com.wfm.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    private final UserDao userDAO = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Redirect ke halaman login
        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        // Validasi input
        if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
            req.setAttribute("error", "Username dan password harus diisi");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
            return;
        }

        // Proses login
        User user = userDAO.login(username, password);

        if (user != null) {
            // Login berhasil
            HttpSession session = req.getSession();
            session.setAttribute("user", user);

            if (null == user.getRole()) {
                // Role tidak dikenal
                resp.sendRedirect(req.getContextPath() + "/");
            } else // Redirect berdasarkan role
            {
                switch (user.getRole()) {
                    case "technician" ->
                        resp.sendRedirect(req.getContextPath() + "/technician/dashboard");
                    case "admin" ->
                        resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                    default -> // Role tidak dikenal
                        resp.sendRedirect(req.getContextPath() + "/");
                }
            }
        } else {
            // Login gagal
            req.setAttribute("error", "Username atau password salah");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
        }
    }
}
