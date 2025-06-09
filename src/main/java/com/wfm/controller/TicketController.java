package com.wfm.controller;

import java.io.IOException;
import java.util.List;

import com.wfm.dao.TicketDao;
import com.wfm.dao.UserDao;
import com.wfm.model.Ticket;
import com.wfm.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet({"/tickets", "/tickets/create", "/tickets/assign", "/tickets/updateStatus", "/tickets/filter"})
public class TicketController extends HttpServlet{
    
    private final TicketDao ticketDao = new TicketDao();
    private final UserDao userDao = new UserDao();
    
    @Override
    protected  void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException{
        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null){
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        String path = req.getServletPath();

        try {
            switch (path) {
                case "/tickets":
                    //menampilkan semua isi ticket
                    List<Ticket> allTickets = ticketDao.getAllTickets();
                    req.setAttribute("tickets", allTickets);
                    req.setAttribute("currentFilterStatus", "all"); // default filter
                    req.getRequestDispatcher("/WEB-INF/views/tickets/ticktes-list.jsp").forward(req, resp);
                    break;
                case "/tickets/create":
                    if ("admin".equals(currentUser.getRole()) || "user".equals(currentUser.getRole())){
                        req.getRequestDispatcher("WEB-INF/views/tickets/create-ticket.jsp").forward(req, resp);
                    } else {
                        resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Anda tidak memiliki ixin untuk membuat tiket");
                    }
                    break;
                case "/tickets/assign":
                    if ("admin".equals(currentUser.getRole())){
                        int ticketId = Integer.parseInt(req.getParameter("ticketId"));
                        Ticket ticketToAssign = ticketDao.getTicketById(ticketId);
                        List<User> technicians = userDao.getAllTechnician();

                        if (ticketToAssign != null) {
                            req.setAttribute("ticket", ticketToAssign);
                            req.setAttribute("technician", technicians);
                            req.getRequestDispatcher("WEB-INF/views/tickets/assign-technician.jsp").forward(req, resp);
                        } else {
                            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Ticket tidak ditemukan.");
                        }
                    } else {
                        resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Anda tidak memiliki izin untuk menugaskan tiket");
                    }
                    break;
                case "/ticket/filter":
                    String statusFilter = req.getParameter("status");
                    List<Ticket> filteredTickets;
                    if (statusFilter != null && !statusFilter.isEmpty() && !statusFilter.equals("all")){
                        filteredTickets = ticketDao.getTicketByStatus(statusFilter);
                    } else {
                        filteredTickets = ticketDao.getAllTickets();
                    }
                    req.setAttribute("tickets", filteredTickets);
                    req.setAttribute("currentFilterStatus", statusFilter);
                    req.getRequestDispatcher("WEB-INF/views/tickets/tickets/tickets-list.jsp").forward(req, resp);
                    break;
                default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
            }
            
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Format ID tidak valid");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Terjadi kesalahan : " + e.getMessage());
        }  
    }

  
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null){
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        String path = req.getServletPath();
        
        try {
            switch (path) {
                case "/tickets/create":
                    if ("admin".equals(currentUser.getRole()) || "user".equals(currentUser.getRole())){
                        String title = req.getParameter("title");
                        String description = req.getParameter("description");
                        String createdBy = req.getParameter("createdBy");
                        String address = req.getParameter("address");
                        String maps = req.getParameter("maps");

                        if (title == null || title.isEmpty() || description == null || description.isEmpty() || createdBy == null || createdBy.isEmpty()){
                            req.setAttribute("error", "Judul, deskripsi, dan pembuat harus diisi.");
                            req.getRequestDispatcher("/WEB-INF/views/tickets/create-ticket.jsp").forward(req, resp);
                            return;
                        }

                        Ticket ticket = new Ticket();
                        ticket.setTitle(title);
                        ticket.setDescription(description);
                        ticket.setCreatedBy(createdBy);
                        ticket.setAddress(address);
                        ticket.setMaps(maps);


                        ticketDao.createTicket(ticket); // Menggunakan instance ticketDao
                        resp.sendRedirect(req.getContextPath() + "/tickets?success=create");
                    } else {
                         resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Anda tidak memiliki izin untuk membuat tiket.");

                    }
                        
                    break;

                case "/tickets/assign":
                    if ("admin".equals(currentUser.getRole())){
                        int ticketId = Integer.parseInt(req.getParameter("ticketId"));
                        int technicianId = Integer.parseInt(req.getParameter("technician"));

                        User technician = userDao.getUserById(technicianId);
                        if (technician != null) {
                            ticketDao.assignTechnician(ticketId, technician);
                            resp.sendRedirect(req.getContextPath() + "/tickets?success=assign");
                        } else {
                            req.setAttribute("error", "Teknisi tidak ditemukan.");
                            Ticket ticketToAssign = ticketDao.getTicketById(ticketId);
                            List<User> techniciansList = userDao.getAllTechnician(); // Note: ini static method di UserDao Anda
                            req.setAttribute("ticket", ticketToAssign);
                            req.setAttribute("technicians", techniciansList);
                            req.getRequestDispatcher("/WEB-INF/views/tickets/assign-technician.jsp").forward(req, resp);
                        }
                    } else {
                        resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Anda tidak memiliki izin untuk menugaskan tiket.");
                    }
                case "/tickets/updateStatus":
                     // Memproses update status tiket
                    // Admin atau teknisi bisa update status
                    if ("admin".equals(currentUser.getRole()) || "technician".equals(currentUser.getRole())){
                        int ticketId = Integer.parseInt(req.getParameter("ticketId"));
                        String status = req.getParameter("status");
                        String declineReason = req.getParameter("declineReason");

                        if (status == null || status.isEmpty()){
                            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Status tiket tidak boleh kosong.");
                            return;
                        }
                        
                        ticketDao.updateTicketStatus(ticketId, status, declineReason);
                        resp.sendRedirect(req.getContextPath() + "/tickets?success=updateStatus");
                    } else {
                         resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Anda tidak memiliki izin untuk memperbarui status tiket.");
                    }
                default:
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND); // Path POST tidak dikenal
                    break;
            }
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Format ID tidak valid.");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Terjadi kesalahan: " + e.getMessage());
        }
       
    }
    
}
