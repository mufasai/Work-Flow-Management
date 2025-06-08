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
        String query = "SELECT * FROM tickets ORDER BY created_at DESC";

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
