package com.boatsafari.model;

public interface User {
    String getFirstName();
    void setFirstName(String firstName);
    String getLastName();
    void setLastName(String lastName);

    String getRole();

    String getEmail();

    void setId(Long id);

    Long getId();

    void setPassword(String newPassword);
}