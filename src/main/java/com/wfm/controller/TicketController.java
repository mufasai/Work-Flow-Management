package com.wfm.controller;

import java.io.IOException;
import java.util.List;

import com.wfm.dao.TicketDao;
import com.wfm.dao.TicketDao.TicketStatistics;
import com.wfm.model.Ticket;
import com.wfm.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/technician/ticket")
public class TicketController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);

        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");

            if ("technician".equals(user.getRole())) {
                try {
                    // PERBAIKAN 1: Dapatkan ID technician yang sedang login
                    int technicianId = user.getId();

                    List<Ticket> tickets = TicketDao.getTicketsByAssignTo(technicianId);
                    req.setAttribute("tickets", tickets);
                    req.setAttribute("tickets", tickets);

                    // PERBAIKAN 3: TICKET STATISTICS - Gunakan technicianId yang benar
                    TicketStatistics ticketStats = TicketDao.getTicketStatisticsByTechnician(technicianId);

                    // Set attributes untuk statistik cards
                    req.setAttribute("totalTickets", ticketStats.getTotal());
                    req.setAttribute("openTickets", ticketStats.getOpenCount());
                    req.setAttribute("assignedTickets", ticketStats.getAssignedCount());
                    req.setAttribute("inProgressTickets", ticketStats.getInProgressCount());
                    req.setAttribute("doneTickets", ticketStats.getDoneCount());
                    req.setAttribute("approvedTickets", ticketStats.getApprovedCount());

                    // Additional attributes for compatibility
                    req.setAttribute("activeTickets", ticketStats.getOpenCount()); // Open tickets
                    req.setAttribute("completedTickets", ticketStats.getApprovedCount()); // Approved tickets
                    req.setAttribute("totalUsers", tickets.size()); // For backward compatibility

                    // TAMBAHAN: Debug info (opsional - bisa dihapus di production)
                    System.out.println("Technician ID: " + technicianId);
                    System.out.println("Tickets found: " + tickets.size());
                    System.out.println("Total tickets from stats: " + ticketStats.getTotal());

                } catch (Exception e) {
                    e.printStackTrace();
                    req.setAttribute("error", "Gagal mengambil data dari database: " + e.getMessage());

                    // Set default values jika terjadi error
                    req.setAttribute("totalTickets", 0);
                    req.setAttribute("openTickets", 0);
                    req.setAttribute("assignedTickets", 0);
                    req.setAttribute("inProgressTickets", 0);
                    req.setAttribute("doneTickets", 0);
                    req.setAttribute("approvedTickets", 0);
                    req.setAttribute("activeTickets", 0);
                    req.setAttribute("completedTickets", 0);
                    req.setAttribute("totalUsers", 0);
                }

                // Forward ke halaman ticket technician
                req.getRequestDispatcher("/WEB-INF/views/technician/ticket.jsp").forward(req, resp);
                return;
            }
        }

        // Jika belum login atau bukan technician, redirect ke halaman login
        resp.sendRedirect(req.getContextPath() + "/login");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Handle POST requests for ticket operations (future implementation)
        String action = req.getParameter("action");

        switch (action) {
            case "view" ->
                handleViewTicket(req, resp);
            case "edit" ->
                handleEditTicket(req, resp);
            case "update" ->
                handleUpdateTicket(req, resp);
            default ->
                resp.sendRedirect(req.getRequestURI());
        }
    }

    private void handleViewTicket(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Implementation for viewing specific ticket
        String ticketId = req.getParameter("ticketId");
        resp.getWriter().write("{\"status\":\"success\",\"message\":\"View ticket " + ticketId + "\"}");
    }

    private void handleEditTicket(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Implementation for editing ticket
        String ticketId = req.getParameter("ticketId");
        resp.getWriter().write("{\"status\":\"success\",\"message\":\"Edit ticket " + ticketId + "\"}");
    }

    private void handleUpdateTicket(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Implementation for updating ticket
        String ticketId = req.getParameter("ticketId");
        String status = req.getParameter("status");
        resp.getWriter().write("{\"status\":\"success\",\"message\":\"Updated ticket " + ticketId + " to " + status + "\"}");
    }
}
