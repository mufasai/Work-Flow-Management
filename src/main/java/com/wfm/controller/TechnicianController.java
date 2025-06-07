package com.wfm.controller;

import java.io.IOException;

import com.wfm.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/technician/dashboard")
public class TechnicianController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Dapatkan session
        HttpSession session = req.getSession(false);

        // Cek apakah user sudah login dan memiliki role dosen
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");

            if ("technician".equals(user.getRole())) {
                // Forward ke halaman dashboard dosen
                req.getRequestDispatcher("/WEB-INF/views/technician/dashboard.jsp").forward(req, resp);
                return;
            }
        }

        // Jika belum login atau bukan dosen, redirect ke halaman login
        resp.sendRedirect(req.getContextPath() + "/login");
    }
}
