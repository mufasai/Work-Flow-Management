package com.wfm.model;

import java.time.LocalDateTime;


public class Ticket {

    private int id;
    private String title;
    private String description;
    private User createdBy;
    private User assignTo;
    private String status;
    private String address;
    private String maps;
    private String declineReason;
    private LocalDateTime createdAt;
    private LocalDateTime updateAt;
    

    public Ticket(){

    }

    public Ticket( int id, String title,String description, User createdBy, User assignTo, String status, String address, String maps, String declineReason ){
        this.id = id;
        this.title = title;
        this.description = description;
        this.createdBy = createdBy;
        this.assignTo = assignTo;
        this.status = status;
        this.address = address;
        this.maps = maps;
        this.declineReason = declineReason;

    }

     

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

    public User getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(User createdBy) {
        this.createdBy = createdBy;
    }

    public User getAssignTo() {
        return assignTo;
    }

    public void setAssignTo(User assignTo) {
        this.assignTo = assignTo;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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

    public String getDeclineReason() {
        return declineReason;
    }

    public void setDeclineReason(String declineReason) {
        this.declineReason = declineReason;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdateAt() {
        return updateAt;
    }

    public void setUpdateAt(LocalDateTime updateAt) {
        this.updateAt = updateAt;
    }



    
}
