package com.wfm.controller;


import java.util.List;

import com.wfm.dao.TicketDao;
import com.wfm.model.Ticket;
import com.wfm.model.User;


public class TicketController {

    private final TicketDao ticketDao = new TicketDao();

    //membuat ticket 
    public void createTicket(String title, String description, User createdBy, String address, String maps){
        
        Ticket ticket = new Ticket();
        ticket.setTitle(title);

        ticket.setDescription(description);
        ticket.setCreatedBy(createdBy);
        ticket.setAddress(address);
        ticket.setMaps(maps);
        
        ticketDao.createTicket(ticket);
    }

    public void assignTechnician(int ticketId, User technician){
        ticketDao.assignTechnician(ticketId, technician); 
    }

    public void updateTicketStatus(int ticketId, String status, String declineReason){
        ticketDao.updateTicketStatus(ticketId, status, declineReason);
    }


    // mengambil tiket berdasarkan status
    public List<Ticket> getTicketByStatus(String status){
        return ticketDao.getTicketByStatus(status);

    }

    public List<Ticket> getAllTicket(){
        return ticketDao.getAllTickets();
    }
    
}
