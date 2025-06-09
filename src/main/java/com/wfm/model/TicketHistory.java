package com.wfm.model;

import java.sql.Timestamp;

public class TicketHistory {
    private String id;
    private Ticket ticket;          // Relasi ke Ticket.java
    private User technician;        // Relasi ke User.java
    private String action;          // Contoh: "assigned", "in_progress", "done", "approved", "declined"
    private String notes;
    private Timestamp timestamp;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Constructor kosong
    public TicketHistory() {
    }

    // Constructor lengkap
    public TicketHistory(String id, Ticket ticket, User technician, String action, String notes,
                         Timestamp timestamp, Timestamp createdAt, Timestamp updatedAt) {
        this.id = id;
        this.ticket = ticket;
        this.technician = technician;
        this.action = action;
        this.notes = notes;
        this.timestamp = timestamp;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getter dan Setter
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Ticket getTicket() {
        return ticket;
    }

    public void setTicket(Ticket ticket) {
        this.ticket = ticket;
    }

    public User getTechnician() {
        return technician;
    }

    public void setTechnician(User technician) {
        this.technician = technician;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public Timestamp getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Timestamp timestamp) {
        this.timestamp = timestamp;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}