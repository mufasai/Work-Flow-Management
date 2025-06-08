package com.wfm.controller;

import java.io.IOException;
import java.util.List;

import com.wfm.dao.TicketDao;
import com.wfm.dao.TicketDao.TicketStatistics;
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
        HttpSession session = req.getSession(false);

        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");

            if ("admin".equals(user.getRole())) {
                try {
                    // === DATA USER ===
                    List<User> allUsers = UserDao.getAllUsers();

                    req.setAttribute("allUsers", allUsers);

                    // User statistics
                    long totalUsers = allUsers.size();
                    long adminCount = allUsers.stream()
                            .filter(u -> "admin".equals(u.getRole())).count();
                    long userCount = allUsers.stream()
                            .filter(u -> "user".equals(u.getRole())).count();
                    long technicianCount = allUsers.stream()
                            .filter(u -> "technician".equals(u.getRole())).count();
                    long activeUsers = allUsers.stream()
                            .filter(u -> "active".equalsIgnoreCase(u.getStatus())).count();

                    // === DATA TICKET (DINAMIS) ===
                    TicketStatistics ticketStats = TicketDao.getTicketStatistics();

                    // Set attributes untuk statistik cards
                    req.setAttribute("totalUsers", totalUsers);
                    req.setAttribute("activeTickets", ticketStats.getActiveTickets()); // Status 'open'
                    req.setAttribute("technicians", technicianCount);
                    req.setAttribute("completedTickets", ticketStats.getCompletedTickets()); // Status 'approved'

                    // Set attributes untuk user statistics
                    req.setAttribute("adminCount", adminCount);
                    req.setAttribute("userCount", userCount);
                    req.setAttribute("technicianCount", technicianCount);
                    req.setAttribute("activeUsers", activeUsers);

                    // Set attributes untuk ticket statistics (detail)
                    req.setAttribute("totalTickets", ticketStats.getTotal());
                    req.setAttribute("openTickets", ticketStats.getOpenCount());
                    req.setAttribute("assignedTickets", ticketStats.getAssignedCount());
                    req.setAttribute("inProgressTickets", ticketStats.getInProgressCount());
                    req.setAttribute("doneTickets", ticketStats.getDoneCount());
                    req.setAttribute("approvedTickets", ticketStats.getApprovedCount());

                    // Optional: Debug information
                    System.out.println("=== DASHBOARD STATISTICS ===");
                    System.out.println("Total Users: " + totalUsers);
                    System.out.println("Active Tickets (open): " + ticketStats.getActiveTickets());
                    System.out.println("Technicians: " + technicianCount);
                    System.out.println("Completed Tickets (approved): " + ticketStats.getCompletedTickets());
                    System.out.println("Total Tickets: " + ticketStats.getTotal());

                } catch (Exception e) {
                    e.printStackTrace();
                    req.setAttribute("error", "Gagal mengambil data dari database: " + e.getMessage());

                    // Set default values jika terjadi error
                    req.setAttribute("totalUsers", 0);
                    req.setAttribute("activeTickets", 0);
                    req.setAttribute("technicians", 0);
                    req.setAttribute("completedTickets", 0);
                }

                // Forward ke halaman dashboard admin
                req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
                return;
            }
        }

        // Jika belum login atau bukan admin, redirect ke halaman login
        resp.sendRedirect(req.getContextPath() + "/login");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Handle POST requests jika diperlukan
        doGet(req, resp);
    }
}
