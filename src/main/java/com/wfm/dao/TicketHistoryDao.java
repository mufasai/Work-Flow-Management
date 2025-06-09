package com.wfm.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.wfm.model.Ticket;
import com.wfm.model.TicketHistory;
import com.wfm.model.User;

public class TicketHistoryDao {
    private Connection conn;

    public TicketHistoryDao(Connection conn) {
        this.conn = conn;
    }

    // Insert TicketHistory
    public void insert(TicketHistory ticketHistory) throws SQLException {
        String sql = "INSERT INTO ticket_history (id, ticket_id, technician_id, action, notes, timestamp, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, ticketHistory.getId());
            stmt.setInt(2, ticketHistory.getTicket().getId());
            stmt.setInt(3, ticketHistory.getTechnician().getId());
            stmt.setString(4, ticketHistory.getAction());
            stmt.setString(5, ticketHistory.getNotes());
            stmt.setTimestamp(6, ticketHistory.getTimestamp());
            stmt.setTimestamp(7, ticketHistory.getCreatedAt());
            stmt.setTimestamp(8, ticketHistory.getUpdatedAt());
            stmt.executeUpdate();
        }
    }

    // Get TicketHistory by ID
    public TicketHistory getById(String id) throws SQLException {
        String sql = "SELECT th.*, t.*, u.* FROM ticket_history th " +
                "JOIN ticket t ON th.ticket_id = t.id " +
                "JOIN user u ON th.technician_id = u.id " +
                "WHERE th.id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        }
        return null;
    }

    // Get all TicketHistory by ticketId
    public List<TicketHistory> getByTicketId(int ticketId) throws SQLException {
        List<TicketHistory> list = new ArrayList<>();
        String sql = "SELECT th.*, t.*, u.* FROM ticket_history th " +
                "JOIN ticket t ON th.ticket_id = t.id " +
                "JOIN user u ON th.technician_id = u.id " +
                "WHERE th.ticket_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, ticketId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    // Helper method to map ResultSet to TicketHistory
    private TicketHistory mapRow(ResultSet rs) throws SQLException {
        Ticket t = new Ticket();
        t.setId(rs.getInt("ticket_id"));
        t.setTitle(rs.getString("title"));
        t.setDescription(rs.getString("description"));
        t.setCreatedBy(rs.getString("createdBy"));
        t.setAssignTo(rs.getString("assignTo"));
        t.setStatus(rs.getString("status"));
        t.setCreatedAt(rs.getTimestamp("createdAt"));
        t.setUpdatedAt(rs.getTimestamp("updatedAt"));
        t.setDeclinedReason(rs.getString("declinedReason"));
        t.setAddress(rs.getString("address"));
        t.setMaps(rs.getString("maps"));

        User u = new User();
        u.setId(rs.getInt("technician_id"));
        u.setUsername(rs.getString("username"));
        u.setPassword(rs.getString("password"));
        u.setStatus(rs.getString("status"));
        u.setRole(rs.getString("role"));
        u.setWhatsapp(rs.getString("whatsapp"));

        TicketHistory th = new TicketHistory();
        th.setId(rs.getString("id"));
        th.setTicket(t);
        th.setTechnician(u);
        th.setAction(rs.getString("action"));
        th.setNotes(rs.getString("notes"));
        th.setTimestamp(rs.getTimestamp("timestamp"));
        th.setCreatedAt(rs.getTimestamp("created_at"));
        th.setUpdatedAt(rs.getTimestamp("updated_at"));
        return th;
    }
}