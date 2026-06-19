/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package com.recruitment.web;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.recruitment.config.DBConnection;
import com.recruitment.event.EventDispatcher;

@WebServlet("/JobServlet")
public class JobServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"RECRUITER".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        long recruiterId = (Long) session.getAttribute("userId");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String skills = request.getParameter("required_skills");
        String salary = request.getParameter("salary_range");
        String location = request.getParameter("location");

        String eventId = UUID.randomUUID().toString();
        String payload = String.format("{\"title\":\"%s\",\"recruiterId\":%d,\"location\":\"%s\"}", title, recruiterId, location);

        String jobSql = "INSERT INTO jobs (recruiter_id, title, description, required_skills, salary_range, location, status) VALUES (?, ?, ?, ?, ?, ?, 'PUBLISHED')";
        String logSql = "INSERT INTO event_log (event_id, event_type, payload, state) VALUES (?, 'JOB_CREATED', ?, 'PENDING')";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            try (PreparedStatement psJob = conn.prepareStatement(jobSql);
                 PreparedStatement psLog = conn.prepareStatement(logSql)) {
                
                psJob.setLong(1, recruiterId);
                psJob.setString(2, title);
                psJob.setString(3, description);
                psJob.setString(4, skills);
                psJob.setString(5, salary);
                psJob.setString(6, location);
                psJob.executeUpdate();

                psLog.setString(1, eventId);
                psLog.setString(2, payload);
                psLog.executeUpdate();

                conn.commit();
                
                // Dispatch outbox log asynchronously to the internal event bus
                EventDispatcher.getInstance().dispatch(eventId, "JOB_CREATED", payload);
                response.sendRedirect("recruiter-workspace.jsp?msg=job_posted");
            }
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            response.sendRedirect("post-job.jsp?error=failed");
        } finally {
            if (conn != null) { try { conn.close(); } catch (SQLException e) {} }
        }
    }
}