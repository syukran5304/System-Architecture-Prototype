/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package com.recruitment.web;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.recruitment.config.DBConnection;

@WebServlet("/SearchServlet")
public class SearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String keyword = request.getParameter("query");
        List<String[]> results = new ArrayList<>();

        // Leverages the fx_job_search FULLTEXT index configuration across columns
        String sql = "SELECT id, title, salary_range, location, description FROM jobs " +
                     "WHERE MATCH(title, description, required_skills) AGAINST(? IN BOOLEAN MODE) AND status = 'PUBLISHED'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, keyword + "*"); // Wildcard appender for fast parsing
            long startTime = System.currentTimeMillis();
            ResultSet rs = ps.executeQuery();
            long duration = System.currentTimeMillis() - startTime;
            
            while (rs.next()) {
                results.add(new String[]{
                    rs.getString("id"),
                    rs.getString("title"),
                    rs.getString("salary_range"),
                    rs.getString("location"),
                    rs.getString("description")
                });
            }
            
            request.setAttribute("jobResults", results);
            request.setAttribute("searchDuration", duration);
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=search_fault");
        }
    }
}
