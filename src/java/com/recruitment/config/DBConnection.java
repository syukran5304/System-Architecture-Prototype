/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author adamr
 */
package com.recruitment.config;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    // Inside com.recruitment.config.DBConnection
private static final String URL = "jdbc:mysql://localhost:3306/recruitment_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
private static final String USER = "root";       // XAMPP default user
private static final String PASSWORD = "";       // FIXED: XAMPP default password is an empty string

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver missing in classpath!");
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws Exception {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}