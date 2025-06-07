package com.wfm.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/logout")

public class LogoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Dapatkan session dan invalidate
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // Redirect ke halaman login
        resp.sendRedirect(req.getContextPath() + "/login");
    }
}
