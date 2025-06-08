package com.wfm.dao;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.wfm.model.Ticket;
import com.wfm.model.User;
import com.wfm.util.DatabaseConnector;

public class TicketDao {
    
    private final UserDao userDao = new UserDao();
    
    public void createTicket(Ticket ticket){
        
        String query = "INSERT INTO ticket (title, description, created_by, status, address, maps, created_at, update_at)" 
        + "VALUES (?, ?, ?, 'open', ?, ?, NOW(), NOW())";

        try (Connection conn = DatabaseConnector.getConnection();
        PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, ticket.getTitle());
            stmt.setString(2, ticket.getDescription());
            stmt.setInt(3, ticket.getCreatedBy().getId());
            stmt.setString(4, ticket.getAddress());
            stmt.setString(5, ticket.getMaps());

            stmt.executeUpdate();
            
        } catch (Exception e) {
            // TODO: handle exception
            e.printStackTrace();
        }
    }

    public Ticket mapResultSetTicket(ResultSet rs) throws SQLException {

        Ticket ticket = new Ticket();
        ticket.setId(rs.getInt("id"));
        ticket.setTitle(rs.getString("title"));
        ticket.setDescription(rs.getString("description"));
        ticket.setStatus(rs.getString("status"));
        ticket.setAddress(rs.getString("address"));
        ticket.setMaps(rs.getString("maps"));
        ticket.setDeclineReason(rs.getString("decline_reason"));

        Timestamp created = rs.getTimestamp("created_at");
        Timestamp updated = rs.getTimestamp("updated_at");
        
        int cretaedById = rs.getInt("created_by");
        int assignToId = rs.getInt("assign_to");

        return ticket;

    }

    public void assignTechnician(int ticketId, User technician){
        String query = "UPDATE tickets SET assign_to = ? , status 'assigned', update_at = NOW() WHERE id = ?";

        try(Connection conn = DatabaseConnector.getConnection();
        PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, technician.getId());
            stmt.setInt(2, ticketId);
            
            stmt.executeUpdate();
            
        } catch (Exception e) {
            // TODO: handle exception
            e.printStackTrace();
        }
    }

    public void updateTicketStatus(int ticketId, String status, String declineReason){
        String query = "UPDATE ticket SET status = ?, decline_reason = ?, update_at = NOW() WHERE id = ?";

        try (Connection conn = DatabaseConnector.getConnection();
        PreparedStatement stmt = conn.prepareStatement(query)){

            stmt.setString(ticketId, status);
            stmt.setString(2, declineReason);
            stmt.setInt(3, ticketId);

            
        } catch (Exception e) {
            // TODO: handle exception
            e.printStackTrace();
        }
    }


   public List<Ticket> getTicketByStatus(String status) {
        List<Ticket> tickets = new ArrayList<>();

        String query = "SELECT * FROM ticket WHERE status = ? ";

        try (Connection conn = DatabaseConnector.getConnection();
        PreparedStatement stmt = conn.prepareStatement(query)) {

            try(ResultSet rs = stmt.executeQuery()) {
                while(rs.next()){
                    tickets.add(mapResultSetTicket(rs));
                }
                
            } 
            
        } catch (Exception e) {
            // TODO: handle exception
            e.printStackTrace();
        }
        return tickets;

   }

   public List<Ticket> getAllTickets(){
    List<Ticket> tickets = new ArrayList<>();

    String query = "SELECT * FROM ticket";

    try (Connection conn = DatabaseConnector.getConnection();
    PreparedStatement stmt = conn.prepareStatement(query);
    
    ResultSet rs = stmt.executeQuery()) {

        while (rs.next()){
            tickets.add(mapResultSetTicket(rs));
        }
        
    } catch (Exception e) {
        // TODO: handle exception
        e.printStackTrace();
    }

    return null;
   }


    
}
