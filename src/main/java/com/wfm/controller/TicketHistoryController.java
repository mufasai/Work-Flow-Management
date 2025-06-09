package com.wfm.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Timestamp;
import java.util.List;

import com.wfm.dao.TicketHistoryDao;
import com.wfm.model.Ticket;
import com.wfm.model.TicketHistory;
import com.wfm.model.User;
import com.wfm.util.DatabaseConnector;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ticket/history")
public class TicketHistoryController extends HttpServlet {

    // Ambil riwayat berdasarkan ticketId (GET)
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String ticketIdParam = req.getParameter("ticketId");
        if (ticketIdParam != null && !ticketIdParam.isEmpty()) {
            try (Connection conn = DatabaseConnector.getConnection()) {
                int ticketId = Integer.parseInt(ticketIdParam);
                TicketHistoryDao dao = new TicketHistoryDao(conn);
                List<TicketHistory> histories = dao.getByTicketId(ticketId);
                req.setAttribute("ticketHistories", histories);
            } catch (Exception e) {
                req.setAttribute("error", "Gagal mengambil riwayat tiket: " + e.getMessage());
            }
        } else {
            req.setAttribute("error", "Parameter ticketId wajib diisi!");
        }
        req.getRequestDispatcher("/WEB-INF/views/ticket/history.jsp").forward(req, resp);
    }

    // logAction untuk menambah riwayat (POST)
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try (Connection conn = DatabaseConnector.getConnection()) {
            TicketHistoryDao dao = new TicketHistoryDao(conn);
            TicketHistory history = new TicketHistory();
            // Jika kolom id auto increment, tidak perlu diisi manual
            history.setId(req.getParameter("id")); // atau generate UUID jika perlu

            // Ambil id ticket dan id technician dari parameter request
            int ticketId = Integer.parseInt(req.getParameter("ticketId"));
            int technicianId = Integer.parseInt(req.getParameter("technicianId"));

            Ticket ticket = new Ticket();
            ticket.setId(ticketId);
            history.setTicket(ticket);

            User technician = new User();
            technician.setId(technicianId);
            history.setTechnician(technician);

            history.setAction(req.getParameter("action"));
            history.setNotes(req.getParameter("notes"));
            history.setTimestamp(new Timestamp(System.currentTimeMillis()));
            history.setCreatedAt(new Timestamp(System.currentTimeMillis()));
            history.setUpdatedAt(new Timestamp(System.currentTimeMillis()));

            dao.insert(history);
            resp.sendRedirect(req.getContextPath() + "/ticket/history?ticketId=" + ticketId);
        } catch (Exception e) {
            req.setAttribute("error", "Gagal mencatat aksi tiket: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/ticket/history.jsp").forward(req, resp);
        }
    }
}
