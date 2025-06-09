package com.wfm.controller;

import java.io.IOException;
import java.util.List;

import com.wfm.dao.TicketDao;
import com.wfm.dao.TicketDao.TicketStatistics;
import com.wfm.model.Ticket;
import com.wfm.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/technician/ticket")
@MultipartConfig
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
        // Handle POST requests for ticket operations
        String action = req.getParameter("action");

        switch (action) {
            case "view" ->
                handleViewTicket(req, resp);
            case "edit" ->
                handleEditTicket(req, resp);
            case "update" ->
                handleUpdateTicket(req, resp);
            case "accept" ->
                handleAcceptTicket(req, resp);
            case "decline" ->
                handleDeclineTicket(req, resp);
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

    // NEW METHOD: Handle Accept Ticket
    private void handleAcceptTicket(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"Unauthorized\"}");
            return;
        }

        User user = (User) session.getAttribute("user");
        String ticketIdStr = req.getParameter("ticketId");

        if (ticketIdStr == null || ticketIdStr.trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"Ticket ID is required\"}");
            return;
        }

        try {
            int ticketId = Integer.parseInt(ticketIdStr);

            // Verifikasi ticket exists dan statusnya open
            Ticket ticket = TicketDao.getTicketById(ticketId);
            if (ticket == null) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.getWriter().write("{\"status\":\"error\",\"message\":\"Ticket not found\"}");
                return;
            }

            if (!"open".equals(ticket.getStatus())) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"status\":\"error\",\"message\":\"Only open tickets can be accepted\"}");
                return;
            }

            // Update status ticket ke "in_progress" untuk technician view
            // Dan assign ticket ke technician yang login
            boolean success = TicketDao.acceptTicketByTechnician(ticketId, user.getId());

            if (success) {
                resp.setContentType("application/json");
                resp.getWriter().write("{\"status\":\"success\",\"message\":\"Ticket accepted successfully\"}");
            } else {
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.getWriter().write("{\"status\":\"error\",\"message\":\"Failed to accept ticket\"}");
            }

        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"Invalid ticket ID format\"}");
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"Internal server error: " + e.getMessage() + "\"}");
        }
    }

    // NEW METHOD: Handle Decline Ticket
    private void handleDeclineTicket(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"Unauthorized\"}");
            return;
        }

        User user = (User) session.getAttribute("user");
        String ticketIdStr = req.getParameter("ticketId");
        String declineReason = req.getParameter("reason");

        if (ticketIdStr == null || ticketIdStr.trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"Ticket ID is required\"}");
            return;
        }

        if (declineReason == null || declineReason.trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"Decline reason is required\"}");
            return;
        }

        try {
            int ticketId = Integer.parseInt(ticketIdStr);

            // Verifikasi ticket exists dan statusnya open
            Ticket ticket = TicketDao.getTicketById(ticketId);
            if (ticket == null) {
                resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
                resp.getWriter().write("{\"status\":\"error\",\"message\":\"Ticket not found\"}");
                return;
            }

            if (!"open".equals(ticket.getStatus())) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"status\":\"error\",\"message\":\"Only open tickets can be declined\"}");
                return;
            }

            // Decline ticket dan set reason
            boolean success = TicketDao.declineTicketByTechnician(ticketId, declineReason);

            if (success) {
                resp.setContentType("application/json");
                resp.getWriter().write("{\"status\":\"success\",\"message\":\"Ticket declined successfully\"}");
            } else {
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.getWriter().write("{\"status\":\"error\",\"message\":\"Failed to decline ticket\"}");
            }

        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"Invalid ticket ID format\"}");
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"status\":\"error\",\"message\":\"Internal server error: " + e.getMessage() + "\"}");
        }
    }
}
