package com.wfm.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.wfm.model.Ticket;
import com.wfm.util.DatabaseConnector;

public class TicketDao {

    // Method untuk mendapatkan semua tickets
    public static List<Ticket> getAllTickets() {
        List<Ticket> tickets = new ArrayList<>();
        String query = "SELECT * FROM tickets ";

        try (Connection conn = DatabaseConnector.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

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
        } catch (SQLException | ClassNotFoundException e) {
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

    public static Ticket getTicketById(int ticketId) {
        String query = "SELECT * FROM tickets WHERE id = ?";
        Ticket ticket = null;

        try (Connection conn = DatabaseConnector.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, ticketId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    ticket = new Ticket();
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
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return ticket;
    }

    /**
     * Method untuk mendapatkan tickets berdasarkan status
     */
    public static List<Ticket> getTicketsByStatus(String status) {
        List<Ticket> tickets = new ArrayList<>();
        String query = "SELECT * FROM tickets WHERE status = ? ORDER BY created_at DESC";

        try (Connection conn = DatabaseConnector.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, status);

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
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return tickets;
    }

    /**
     * Method untuk mendapatkan tickets berdasarkan user yang membuat
     */
    public static List<Ticket> getTicketsByCreatedBy(String createdBy) {
        List<Ticket> tickets = new ArrayList<>();
        String query = "SELECT * FROM tickets WHERE created_by = ? ORDER BY created_at DESC";

        try (Connection conn = DatabaseConnector.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, createdBy);

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
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return tickets;
    }

    /**
     * Method untuk mendapatkan tickets berdasarkan user yang ditugaskan
     */
    public static List<Ticket> getTicketsByAssignTo(int assignTo) {
        List<Ticket> tickets = new ArrayList<>();
        String query = "SELECT * FROM tickets WHERE assign_to = ?";

        try (Connection conn = DatabaseConnector.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, assignTo);

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
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return tickets;
    }

    /**
     * Method untuk update status ticket
     */
    public static boolean updateTicketStatus(int ticketId, String newStatus) {
        String query = "UPDATE tickets SET status = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";

        try (Connection conn = DatabaseConnector.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, newStatus);
            stmt.setInt(2, ticketId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Method untuk assign ticket ke technician
     */
    public static boolean assignTicket(int ticketId, String assignTo) {
        String query = "UPDATE tickets SET assign_to = ?, status = 'assigned', updated_at = CURRENT_TIMESTAMP WHERE id = ?";

        try (Connection conn = DatabaseConnector.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, assignTo);
            stmt.setInt(2, ticketId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    // NEW METHOD: Method untuk mendapatkan statistik ticket berdasarkan technician yang di-assign
    public static TicketStatistics getTicketStatisticsByTechnician(int assignTo) {
        TicketStatistics stats = new TicketStatistics();

        // Query yang BENAR - filter berdasarkan assign_to
        String query = "SELECT status, COUNT(*) as count FROM tickets WHERE assign_to = ? GROUP BY status";

        try (Connection conn = DatabaseConnector.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, assignTo); // Filter berdasarkan technician ID

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    String status = rs.getString("status");
                    int count = rs.getInt("count");

                    switch (status) {
                        case "open" ->
                            stats.setOpenCount(count);
                        case "assigned" ->
                            stats.setAssignedCount(count);
                        case "in_progress" ->
                            stats.setInProgressCount(count);
                        case "done" ->
                            stats.setDoneCount(count);
                        case "approved" ->
                            stats.setApprovedCount(count);
                    }

                    stats.setTotal(stats.getTotal() + count);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return stats;
    }

    /**
     * Method untuk membuat ticket baru
     */
    public static boolean createTicket(Ticket ticket) {
        String query = "INSERT INTO tickets (title, description, created_by, assign_to, status, address, maps, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)";

        try (Connection conn = DatabaseConnector.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, ticket.getTitle());
            stmt.setString(2, ticket.getDescription());

            // FIX: created_by should be set as INTEGER (user ID)
            if (ticket.getCreatedBy() != null && !ticket.getCreatedBy().trim().isEmpty()) {
                try {
                    int createdById = Integer.parseInt(ticket.getCreatedBy());
                    stmt.setInt(3, createdById);
                } catch (NumberFormatException e) {
                    stmt.setNull(3, java.sql.Types.INTEGER);
                }
            } else {
                stmt.setNull(3, java.sql.Types.INTEGER);
            }

            // FIX: assign_to should be set as INTEGER (user ID)
            if (ticket.getAssignTo() != null && !ticket.getAssignTo().trim().isEmpty()) {
                try {
                    int assignToId = Integer.parseInt(ticket.getAssignTo());
                    stmt.setInt(4, assignToId);
                } catch (NumberFormatException e) {
                    stmt.setNull(4, java.sql.Types.INTEGER);
                }
            } else {
                stmt.setNull(4, java.sql.Types.INTEGER);
            }

            stmt.setString(5, ticket.getStatus());
            stmt.setString(6, ticket.getAddress());
            stmt.setString(7, ticket.getMaps());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Method untuk update ticket
     */
    public static boolean updateTicket(Ticket ticket) {
        String query = "UPDATE tickets SET title = ?, description = ?, assign_to = ?, status = ?, address = ?, maps = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?";

        try (Connection conn = DatabaseConnector.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, ticket.getTitle());
            stmt.setString(2, ticket.getDescription());
            stmt.setString(3, ticket.getAssignTo());
            stmt.setString(4, ticket.getStatus());
            stmt.setString(5, ticket.getAddress());
            stmt.setString(6, ticket.getMaps());
            stmt.setInt(7, ticket.getId());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Method untuk menghapus ticket
     */
    public static boolean deleteTicket(int ticketId) {
        String query = "DELETE FROM tickets WHERE id = ?";

        try (Connection conn = DatabaseConnector.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, ticketId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    // NEW METHOD: Accept ticket by technician
    /**
     * Method untuk accept ticket oleh technician - Update status menjadi
     * 'in_progress' untuk technician view - Update status menjadi 'assigned'
     * untuk admin view - Set assign_to ke technician yang accept
     */
    public static boolean acceptTicketByTechnician(int ticketId, int technicianId) {
        String query = "UPDATE tickets SET assign_to = ?, status = 'in_progress', updated_at = CURRENT_TIMESTAMP WHERE id = ? AND status = 'open'";

        try (Connection conn = DatabaseConnector.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, technicianId);
            stmt.setInt(2, ticketId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    // NEW METHOD: Decline ticket by technician  
    /**
     * Method untuk decline ticket oleh technician - Update status menjadi
     * 'open' (kembali ke pool untuk technician lain) - Set declined_reason -
     * Reset assign_to menjadi NULL
     */
    public static boolean declineTicketByTechnician(int ticketId, String declineReason) {
        String query = "UPDATE tickets SET assign_to = NULL, status = 'open', declined_reason = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ? AND status = 'open'";

        try (Connection conn = DatabaseConnector.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, declineReason);
            stmt.setInt(2, ticketId);

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    // METHOD YANG DIPERBAIKI: Untuk mendapatkan tickets yang bisa di-accept/decline oleh technician
    /**
     * Method untuk mendapatkan open tickets yang bisa di-accept oleh technician
     * Ini akan menampilkan semua tickets dengan status 'open' yang belum
     * di-assign
     */
    public static List<Ticket> getAvailableTicketsForTechnician() {
        List<Ticket> tickets = new ArrayList<>();
        String query = "SELECT * FROM tickets WHERE status = 'open' ORDER BY created_at ASC";

        try (Connection conn = DatabaseConnector.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

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
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return tickets;
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
