package com.wfm.model;

public class User {

    private int id;
    private String username;
    private String password;
    private String status;
    private String role;
    private String whatsapp;

    // Constructors
    public User() {
    }

    public User(int id, String username, String password, String status, String role, String whatsapp) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.status = status;
        this.role = role;
        this.whatsapp = whatsapp;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getWhatsapp() {
        return whatsapp;
    }

    public void setWhatsapp(String whatsapp) {
        this.whatsapp = whatsapp;
    }
}
