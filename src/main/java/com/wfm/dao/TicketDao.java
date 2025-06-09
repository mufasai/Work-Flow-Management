package com.wfm.dao;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
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
        PreparedStatement stmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, ticket.getTitle());
            stmt.setString(2, ticket.getDescription());
            //stmt.setInt(3, ticket.getId());
            stmt.setString(3, ticket.getCreatedBy());
            stmt.setString(4, ticket.getAddress());
            stmt.setString(5, ticket.getMaps());

            int affectedRows = stmt.executeUpdate();

            // untuk mengambil ID yang digenerate jika terdapat baris yang terpengaruh

            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()){
                    if (generatedKeys.next()){
                        ticket.setId(generatedKeys.getInt(1)); // mengset id yang dihasilkan objek ke Ticket 
                    }
                }
            }
            
            
        } catch (SQLException e) {
            System.err.println("Error Creating TIcket : " + e.getMessage());
            // TODO: handle exception
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            System.err.println("Error creating ticket (Driver not Found) : " + e.getMessage());
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
        ticket.setDeclinedReason(rs.getString("decline_reason"));
        ticket.setCreatedAt(rs.getTimestamp("created_at"));
        ticket.setUpdatedAt(rs.getTimestamp("updated_at"));

        /*
        Timestamp created = rs.getTimestamp("created_by");ticket.
        Timestamp updated = rs.getTimestamp("updated_by");
        
        int cretaedById = rs.getInt("created_by");
        int assignToId = rs.getInt("assign_to");
        */

        String createdBydb = rs.getString("created_by");
        if (createdBydb != null) {
            ticket.setCreatedBy(createdBydb);
        } else {
            ticket.setCreatedBy(null);
        }

        int assignToId = rs.getInt("assign_to");
        if (assignToId != 0) {
           User assignedUser = userDao.getUserById(assignToId);
           if (assignedUser != null) {
            ticket.setAssignTo(assignedUser.getUsername());
           } else {
            ticket.setAssignTo(String.valueOf(assignToId));
           }
        } else {
            ticket.setAssignTo(null);
        }
        return ticket;

    }


    // menambahkan method untuk getTicketBy Id 
    public Ticket getTicketById(int id){
        String query = "SELECT * FROM ticket WHERE id = ? ";
        try (Connection conn = DatabaseConnector.getConnection();
        PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()){
                if (rs.next()){
                    return mapResultSetTicket(rs);
                }
            }
            
        } catch (Exception e) {
            System.err.println("Error getting ticket by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public void assignTechnician(int ticketId, User technician){
        String query = "UPDATE tickets SET assign_to = ? , status 'assigned', update_at = NOW() WHERE id = ?";

        try(Connection conn = DatabaseConnector.getConnection();
        PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, technician.getId());
            stmt.setInt(2, ticketId);
            
            stmt.executeUpdate();
            
        } catch (SQLException e) {
            // TODO: handle exception
            System.err.println("Error assingning technician: " + e.getMessage());
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            System.err.println("Database driver not found: " + e.getMessage());
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

            stmt.executeUpdate();

            
        } catch (SQLException e) {
            // TODO: handle exception
            System.err.println("Error updating ticket status: "+e.getMessage());
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            System.err.println("Database driver not found: " + e.getMessage());

        }
    }


   public List<Ticket> getTicketByStatus(String status) {
        List<Ticket> tickets = new ArrayList<>();

        String query = "SELECT * FROM ticket WHERE status = ? ";

        try (Connection conn = DatabaseConnector.getConnection();
        PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, status);

            try(ResultSet rs = stmt.executeQuery()) {
                while(rs.next()){
                    tickets.add(mapResultSetTicket(rs));
                }
                
            } 
            
        } catch (SQLException e) {
            // TODO: handle exception
            System.err.println("Error getting ticket by status: " + e.getMessage());
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            System.err.println("Database driver not found: " + e.getMessage());
            e.printStackTrace();
        }
        return tickets;

   }
 


    // Method untuk mendapatkan semua tickets
    public static List<Ticket> getAllTickets() {
        List<Ticket> tickets = new ArrayList<>();
        String query = "SELECT * FROM tickets ORDER BY created_at DESC";

        try (Connection conn = DatabaseConnector.getConnection();
         PreparedStatement stmt = conn.prepareStatement(query)) {

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    
                    Ticket ticket = new Ticket();
                    ticket.setId(rs.getInt("id"));
                    ticket.setTitle(rs.getString("title"));
                    ticket.setDescription(rs.getString("description"));
                    ticket.setCreatedBy(rs.getString("created_by"));
                    ticket.setAssignTo(rs.getString("assign_to"));
                    ticket.setStatus(rs.getString("status"));
                    ticket.setCreatedAt(rs.getTimestamp("created_at"));
                    ticket.setUpdatedAt(rs.getTimestamp("updated_at"));
                    ticket.setDeclinedReason(rs.getString("declined_reason"));
                    ticket.setAddress(rs.getString("address"));
                    ticket.setMaps(rs.getString("maps"));
                    tickets.add(ticket);
                    
                }
            }
        } catch (SQLException  e) {
            System.err.println("Error getting all tickets: " + e.getMessage());
            e.printStackTrace();
        } catch (ClassNotFoundException e) {
            System.err.println("Database driver not found: " + e.getMessage());
            e.printStackTrace();
        }

        return tickets;
    }

    // Method untuk menghitung tickets berdasarkan status
    public static int getTicketCountByStatus(String status) {
        String query = "SELECT COUNT(*) as count FROM tickets WHERE status = ?";
        int count = 0;

        try (Connection conn = DatabaseConnector.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, status);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt("count");
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return count;
    }

    // Method untuk menghitung total tickets dengan multiple status
    public static int getTicketCountByMultipleStatus(String... statuses) {
        if (statuses.length == 0) {
            return 0;
        }

        // Build query dengan placeholders
        StringBuilder query = new StringBuilder("SELECT COUNT(*) as count FROM tickets WHERE status IN (");
        for (int i = 0; i < statuses.length; i++) {
            query.append("?");
            if (i < statuses.length - 1) {
                query.append(",");
            }
        }
        query.append(")");

        int count = 0;

        try (Connection conn = DatabaseConnector.getConnection(); PreparedStatement stmt = conn.prepareStatement(query.toString())) {

            // Set parameters
            for (int i = 0; i < statuses.length; i++) {
                stmt.setString(i + 1, statuses[i]);
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt("count");
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return count;
    }

    // Method untuk mendapatkan statistik lengkap
    public static TicketStatistics getTicketStatistics() {
        TicketStatistics stats = new TicketStatistics();
        String query = """
            SELECT 
                COUNT(*) as total,
                SUM(CASE WHEN status = 'open' THEN 1 ELSE 0 END) as open_count,
                SUM(CASE WHEN status = 'assigned' THEN 1 ELSE 0 END) as assigned_count,
                SUM(CASE WHEN status = 'in_progress' THEN 1 ELSE 0 END) as in_progress_count,
                SUM(CASE WHEN status = 'done' THEN 1 ELSE 0 END) as done_count,
                SUM(CASE WHEN status = 'approved' THEN 1 ELSE 0 END) as approved_count
            FROM tickets
        """;

        try (Connection conn = DatabaseConnector.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.setTotal(rs.getInt("total"));
                    stats.setOpenCount(rs.getInt("open_count"));
                    stats.setAssignedCount(rs.getInt("assigned_count"));
                    stats.setInProgressCount(rs.getInt("in_progress_count"));
                    stats.setDoneCount(rs.getInt("done_count"));
                    stats.setApprovedCount(rs.getInt("approved_count"));
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return stats;
    }

    // Inner class untuk statistik ticket
    public static class TicketStatistics {

        private int total;
        private int openCount;
        private int assignedCount;
        private int inProgressCount;
        private int doneCount;
        private int approvedCount;

        // Getters and Setters
        public int getTotal() {
            return total;
        }

        public void setTotal(int total) {
            this.total = total;
        }

        public int getOpenCount() {
            return openCount;
        }

        public void setOpenCount(int openCount) {
            this.openCount = openCount;
        }

        public int getAssignedCount() {
            return assignedCount;
        }

        public void setAssignedCount(int assignedCount) {
            this.assignedCount = assignedCount;
        }

        public int getInProgressCount() {
            return inProgressCount;
        }

        public void setInProgressCount(int inProgressCount) {
            this.inProgressCount = inProgressCount;
        }

        public int getDoneCount() {
            return doneCount;
        }

        public void setDoneCount(int doneCount) {
            this.doneCount = doneCount;
        }

        public int getApprovedCount() {
            return approvedCount;
        }

        public void setApprovedCount(int approvedCount) {
            this.approvedCount = approvedCount;
        }

        // Helper methods
        public int getActiveTickets() {
            return openCount; // Active tickets = tickets dengan status 'open'
        }

        public int getCompletedTickets() {
            return approvedCount; // Completed tickets = tickets dengan status 'approved'
        }
    }
}
