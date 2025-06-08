package com.wfm.model;

import java.sql.Timestamp;

public class Ticket {

    private int id;
    private String title;
    private String description;
    private String createdBy;
    private String assignTo;
    private String status; // 'open', 'assigned', 'in_progress', 'done', 'approved'
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private String declinedReason;
    private String address;
    private String maps;

    // Constructors
    public Ticket() {
    }

    public Ticket(int id, String title, String description, String createdBy,
            String assignTo, String status, Timestamp createdAt,
            Timestamp updatedAt, String declinedReason, String address, String maps) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.createdBy = createdBy;
        this.assignTo = assignTo;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.declinedReason = declinedReason;
        this.address = address;
        this.maps = maps;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    public String getAssignTo() {
        return assignTo;
    }

    public void setAssignTo(String assignTo) {
        this.assignTo = assignTo;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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

    public String getDeclinedReason() {
        return declinedReason;
    }

    public void setDeclinedReason(String declinedReason) {
        this.declinedReason = declinedReason;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getMaps() {
        return maps;
    }

    public void setMaps(String maps) {
        this.maps = maps;
    }
}
