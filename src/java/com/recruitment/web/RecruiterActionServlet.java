/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package com.recruitment.web;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.recruitment.config.DBConnection;

@WebServlet("/RecruiterActionServlet")
public class RecruiterActionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        long applicationId = Long.parseLong(request.getParameter("appId"));
        String targetStatus = request.getParameter("status"); // 'SHORTLISTED', 'REJECTED'

        String sql = "UPDATE applications SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, targetStatus);
            ps.setLong(2, applicationId);
            ps.executeUpdate();
            
            response.sendRedirect("recruiter-workspace.jsp?msg=status_updated");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("recruiter-workspace.jsp?error=action_failed");
        }
    }
}