package com.wfm.controller;

import java.io.IOException;
import java.util.List;

import com.wfm.dao.TicketDao;
import com.wfm.dao.TicketDao.TicketStatistics;
import com.wfm.dao.UserDao;
import com.wfm.model.Ticket;
import com.wfm.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/ticket")
@MultipartConfig
public class TicketControllerAdmin extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);

        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");

            if ("admin".equals(user.getRole())) {
                // Handle AJAX request untuk view ticket
                String action = req.getParameter("action");
                if ("view".equals(action)) {
                    handleViewTicket(req, resp);
                    return;
                }

                try {
                    // === DATA TICKETS ===
                    List<Ticket> tickets = TicketDao.getAllTickets();
                    req.setAttribute("tickets", tickets);

                    // === LOAD TECHNICIANS FOR DROPDOWN ===
                    List<User> technicians = UserDao.getUsersByRole("technician");
                    req.setAttribute("technicians", technicians);

                    // === TICKET STATISTICS ===
                    TicketStatistics ticketStats = TicketDao.getTicketStatistics();

                    // Set attributes untuk statistik cards
                    req.setAttribute("totalTickets", ticketStats.getTotal());
                    req.setAttribute("openTickets", ticketStats.getOpenCount());
                    req.setAttribute("assignedTickets", ticketStats.getAssignedCount());
                    req.setAttribute("inProgressTickets", ticketStats.getInProgressCount());
                    req.setAttribute("doneTickets", ticketStats.getDoneCount());
                    req.setAttribute("approvedTickets", ticketStats.getApprovedCount());

                    // Additional attributes for compatibility
                    req.setAttribute("activeTickets", ticketStats.getActiveTickets()); // Status 'open'
                    req.setAttribute("completedTickets", ticketStats.getCompletedTickets()); // Status 'approved'
                    req.setAttribute("totalUsers", tickets.size()); // For backward compatibility

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

                // Forward ke halaman ticket admin
                req.getRequestDispatcher("/WEB-INF/views/admin/ticket.jsp").forward(req, resp);
                return;
            }
        }

        // Jika belum login atau bukan admin, redirect ke halaman login
        resp.sendRedirect(req.getContextPath() + "/login");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            resp.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Unauthorized");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"admin".equals(user.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String action = req.getParameter("action");
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            switch (action) {
                case "create" ->
                    handleCreateTicket(req, resp, user);
                case "update" ->
                    handleUpdateTicket(req, resp);
                case "view" ->
                    handleViewTicket(req, resp);
                case "delete" ->
                    handleDeleteTicket(req, resp);
                default ->
                    resp.getWriter().write("{\"success\":false,\"message\":\"Invalid action\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("{\"success\":false,\"message\":\"Error: " + e.getMessage() + "\"}");
        }
    }

    private void handleCreateTicket(HttpServletRequest req, HttpServletResponse resp, User admin) throws IOException {
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String assignTo = req.getParameter("assignTo");
        String address = req.getParameter("address");
        String maps = req.getParameter("maps");

        // Validation
        if (title == null || title.trim().isEmpty()) {
            resp.getWriter().write("{\"success\":false,\"message\":\"Title is required\"}");
            return;
        }

        if (description == null || description.trim().isEmpty()) {
            resp.getWriter().write("{\"success\":false,\"message\":\"Description is required\"}");
            return;
        }

        try {
            // Create new ticket
            Ticket ticket = new Ticket();
            ticket.setTitle(title.trim());
            ticket.setDescription(description.trim());

            // FIX: Use admin.getId() instead of admin.getUsername()
            // created_by should store user ID (integer), not username (string)
            ticket.setCreatedBy(String.valueOf(admin.getId()));

            ticket.setStatus("open"); // Default status
            ticket.setAddress(address != null ? address.trim() : "");
            ticket.setMaps(maps != null ? maps.trim() : "");

            // If assignTo is provided, set it and change status to assigned
            if (assignTo != null && !assignTo.trim().isEmpty() && !assignTo.equals("0")) {
                ticket.setAssignTo(assignTo.trim());
            }

            boolean success = TicketDao.createTicket(ticket);

            if (success) {
                resp.getWriter().write("{\"success\":true,\"message\":\"Ticket created successfully\"}");
            } else {
                resp.getWriter().write("{\"success\":false,\"message\":\"Failed to create ticket\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("{\"success\":false,\"message\":\"Error creating ticket: " + e.getMessage() + "\"}");
        }
    }

    private void handleUpdateTicket(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String ticketId = req.getParameter("ticketId");
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String status = req.getParameter("status");
        String assignTo = req.getParameter("assignTo");
        String address = req.getParameter("address");
        String maps = req.getParameter("maps");

        // Validation
        if (ticketId == null || ticketId.trim().isEmpty()) {
            resp.getWriter().write("{\"success\":false,\"message\":\"Ticket ID is required\"}");
            return;
        }

        if (title == null || title.trim().isEmpty()) {
            resp.getWriter().write("{\"success\":false,\"message\":\"Title is required\"}");
            return;
        }

        if (description == null || description.trim().isEmpty()) {
            resp.getWriter().write("{\"success\":false,\"message\":\"Description is required\"}");
            return;
        }

        try {
            int id = Integer.parseInt(ticketId);

            // Get existing ticket
            Ticket ticket = TicketDao.getTicketById(id);
            if (ticket == null) {
                resp.getWriter().write("{\"success\":false,\"message\":\"Ticket not found\"}");
                return;
            }

            // Update ticket data
            ticket.setTitle(title.trim());
            ticket.setDescription(description.trim());
            ticket.setStatus(status != null ? status.trim() : ticket.getStatus());
            ticket.setAddress(address != null ? address.trim() : "");
            ticket.setMaps(maps != null ? maps.trim() : "");

            // Handle assignment
            if (assignTo != null && !assignTo.trim().isEmpty() && !assignTo.equals("0")) {
                ticket.setAssignTo(assignTo.trim());
                // If assigning to someone and status is open, change to assigned
                if ("open".equals(ticket.getStatus())) {
                    ticket.setStatus("assigned");
                }
            } else {
                ticket.setAssignTo(null);
            }

            boolean success = TicketDao.updateTicket(ticket);

            if (success) {
                resp.getWriter().write("{\"success\":true,\"message\":\"Ticket updated successfully\"}");
            } else {
                resp.getWriter().write("{\"success\":false,\"message\":\"Failed to update ticket\"}");
            }

        } catch (NumberFormatException e) {
            resp.getWriter().write("{\"success\":false,\"message\":\"Invalid ticket ID\"}");
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("{\"success\":false,\"message\":\"Error updating ticket: " + e.getMessage() + "\"}");
        }
    }

    private void handleViewTicket(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String ticketId = req.getParameter("ticketId");

        if (ticketId == null || ticketId.trim().isEmpty()) {
            resp.getWriter().write("{\"success\":false,\"message\":\"Ticket ID is required\"}");
            return;
        }

        try {
            int id = Integer.parseInt(ticketId);
            Ticket ticket = TicketDao.getTicketById(id);

            if (ticket != null) {
                // Convert ticket to JSON format
                String json = String.format(
                        "{\"success\":true,\"ticket\":{\"id\":%d,\"title\":\"%s\",\"description\":\"%s\",\"createdBy\":\"%s\",\"assignTo\":\"%s\",\"status\":\"%s\",\"address\":\"%s\",\"maps\":\"%s\",\"createdAt\":\"%s\",\"updatedAt\":\"%s\"}}",
                        ticket.getId(),
                        escapeJson(ticket.getTitle()),
                        escapeJson(ticket.getDescription()),
                        escapeJson(ticket.getCreatedBy()),
                        ticket.getAssignTo() != null ? escapeJson(ticket.getAssignTo()) : "",
                        escapeJson(ticket.getStatus()),
                        ticket.getAddress() != null ? escapeJson(ticket.getAddress()) : "",
                        ticket.getMaps() != null ? escapeJson(ticket.getMaps()) : "",
                        ticket.getCreatedAt() != null ? ticket.getCreatedAt().toString() : "",
                        ticket.getUpdatedAt() != null ? ticket.getUpdatedAt().toString() : ""
                );
                resp.getWriter().write(json);
            } else {
                resp.getWriter().write("{\"success\":false,\"message\":\"Ticket not found\"}");
            }

        } catch (NumberFormatException e) {
            resp.getWriter().write("{\"success\":false,\"message\":\"Invalid ticket ID\"}");
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("{\"success\":false,\"message\":\"Error retrieving ticket: " + e.getMessage() + "\"}");
        }
    }

    private void handleDeleteTicket(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String ticketId = req.getParameter("ticketId");

        if (ticketId == null || ticketId.trim().isEmpty()) {
            resp.getWriter().write("{\"success\":false,\"message\":\"Ticket ID is required\"}");
            return;
        }

        try {
            int id = Integer.parseInt(ticketId);
            boolean success = TicketDao.deleteTicket(id);

            if (success) {
                resp.getWriter().write("{\"success\":true,\"message\":\"Ticket deleted successfully\"}");
            } else {
                resp.getWriter().write("{\"success\":false,\"message\":\"Failed to delete ticket\"}");
            }

        } catch (NumberFormatException e) {
            resp.getWriter().write("{\"success\":false,\"message\":\"Invalid ticket ID\"}");
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("{\"success\":false,\"message\":\"Error deleting ticket: " + e.getMessage() + "\"}");
        }
    }

    private String escapeJson(String str) {
        if (str == null) {
            return "";
        }
        return str.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n")
                .replace("\t", "\\t");
    }
}
