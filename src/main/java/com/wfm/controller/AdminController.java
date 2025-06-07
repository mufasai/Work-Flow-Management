package com.wfm.controller;

import java.io.IOException;
import java.util.List;

import com.wfm.dao.UserDao;
import com.wfm.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/dashboard")
public class AdminController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Dapatkan session
        HttpSession session = req.getSession(false);

        // Cek apakah user sudah login dan memiliki role admin
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");

            if ("admin".equals(user.getRole())) {
                try {
                    // Ambil semua user dari database
                    List<User> allUsers = UserDao.getAllUsers();

                    // Set data ke request attribute
                    req.setAttribute("allUsers", allUsers);
                    req.setAttribute("totalUsers", allUsers.size());

                    // Hitung statistik
                    long adminCount = allUsers.stream().filter(u -> "admin".equals(u.getRole())).count();
                    long userCount = allUsers.stream().filter(u -> "user".equals(u.getRole())).count();
                    long activeCount = allUsers.stream().filter(u -> "Active".equals(u.getStatus())).count();

                    req.setAttribute("adminCount", adminCount);
                    req.setAttribute("userCount", userCount);
                    req.setAttribute("activeCount", activeCount);

                } catch (Exception e) {
                    e.printStackTrace();
                    req.setAttribute("error", "Gagal mengambil data user dari database");
                }

                // Forward ke halaman dashboard admin
                req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
                return;
            }
        }

        // Jika belum login atau bukan admin, redirect ke halaman login
        resp.sendRedirect(req.getContextPath() + "/login");
    }
}
