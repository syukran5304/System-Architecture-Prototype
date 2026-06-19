/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author adamr
 */
package com.recruitment.service;

import java.sql.*;
import java.util.UUID;
import com.recruitment.config.DBConnection;
import com.recruitment.event.EventDispatcher;

public class ApplicationService {

    public boolean submitApplication(long jobId, long candidateId, String resumePath) {
        Connection conn = null;
        PreparedStatement psApp = null;
        PreparedStatement psLog = null;
        String eventId = UUID.randomUUID().toString();
        String payload = "{\"jobId\":" + jobId + ",\"candidateId\":" + candidateId + ",\"resumePath\":\"" + resumePath + "\"}";

        String insertAppSql = "INSERT INTO applications (job_id, candidate_id, resume_path, status) VALUES (?, ?, ?, 'SUBMITTED')";
        String insertLogSql = "INSERT INTO event_log (event_id, event_type, payload, state) VALUES (?, 'APPLICATION_SUBMITTED', ?, 'PENDING')";

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Enable strict localized atomic transaction block

            // 1. Mutate Domain Layer state
            psApp = conn.prepareStatement(insertAppSql);
            psApp.setLong(1, jobId);
            psApp.setLong(2, candidateId);
            psApp.setString(3, resumePath);
            psApp.executeUpdate();

            // 2. Commit event structural state inside Outbox log
            psLog = conn.prepareStatement(insertLogSql);
            psLog.setString(1, eventId);
            psLog.setString(2, payload);
            psLog.executeUpdate();

            conn.commit(); // Atomic transactional boundary safely sealed

            // 3. Hand off directly to non-blocking memory framework engine 
            EventDispatcher.getInstance().dispatch(eventId, "APPLICATION_SUBMITTED", payload);
            return true;

        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return false;
        } finally {
            try { if(psApp != null) psApp.close(); if(psLog != null) psLog.close(); if(conn != null) conn.close(); } catch(Exception e){}
        }
    }
}
