<%-- 
    Document   : recruiter-workspace
    Created on : 7 Jun 2026, 4:16:21 pm
    Author     : adamr
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, com.recruitment.config.DBConnection"%>
<%
    // Ensure session validity and role authorization
    HttpSession sess = request.getSession(false);
    if (sess == null || !"RECRUITER".equals(sess.getAttribute("userRole"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    long recruiterId = (Long) sess.getAttribute("userId");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Recruiter Management Workspace</title>
    <style>
        body { font-family: Arial, sans-serif; background: #edf2f7; margin: 0; padding: 20px; }
        .nav { display: flex; justify-content: space-between; align-items: center; background: #2b6cb0; color: white; padding: 10px 20px; border-radius: 4px; }
        .nav a { color: white; text-decoration: none; font-weight: bold; margin-left: 15px; }
        .grid { display: flex; gap: 20px; margin-top: 20px; }
        .main-panel { flex: 3; background: white; padding: 20px; border-radius: 6px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .side-panel { flex: 1; background: #1a202c; color: white; padding: 20px; border-radius: 6px; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { padding: 12px; border: 1px solid #e2e8f0; text-align: left; }
        th { background: #edf2f7; }
        .btn-s { background: #48bb78; color: white; border: none; padding: 5px 10px; border-radius: 3px; cursor: pointer; }
        .btn-r { background: #f56565; color: white; border: none; padding: 5px 10px; border-radius: 3px; cursor: pointer; }
        .metric { font-size: 24px; font-weight: bold; color: #4299e1; margin-bottom: 10px; }
    </style>
</head>
<body>
    <div class="nav">
        <span>Recruiter Studio: <strong><%= sess.getAttribute("userName") %></strong></span>
        <div>
            <a href="post-job.jsp">+ Post Job Vacancy</a>
            <a href="login.jsp" style="color: #fed7d7;">Logout</a>
        </div>
    </div>

    <div class="grid">
        <div class="main-panel">
            <h3>Incoming Candidate Job Applications</h3>
            <table>
                <thead>
                    <tr>
                        <th>Job Title</th>
                        <th>Applicant Name</th>
                        <th>Resume Storage Path</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String query = "SELECT a.id, j.title, u.name, a.resume_path, a.status " +
                                       "FROM applications a JOIN jobs j ON a.job_id = j.id " +
                                       "JOIN users u ON a.candidate_id = u.id " +
                                       "WHERE j.recruiter_id = ?";
                        
                        try (Connection conn = DBConnection.getConnection();
                             PreparedStatement ps = conn.prepareStatement(query)) {
                            
                            ps.setLong(1, recruiterId);
                            try (ResultSet rs = ps.executeQuery()) {
                                while(rs.next()) {
                                    String appId = rs.getString("id");
                                    String jobTitle = rs.getString("title");
                                    String applicantName = rs.getString("name");
                                    String resumePath = rs.getString("resume_path");
                                    String appStatus = rs.getString("status");
                    %>
                        <tr>
                            <td><%= jobTitle %></td>
                            <td><%= applicantName %></td>
                            <td><code><%= resumePath %></code></td>
                            <td><strong><%= appStatus %></strong></td>
                            <td>
                                <% if("SUBMITTED".equals(appStatus)) { %>
                                <form action="RecruiterActionServlet" method="POST" style="display:inline;">
                                    <input type="hidden" name="appId" value="<%= appId %>">
                                    <button type="submit" name="status" value="SHORTLISTED" class="btn-s">Shortlist</button>
                                    <button type="submit" name="status" value="REJECTED" class="btn-r">Reject</button>
                                </form>
                                <% } else { %>
                                 Decision Closed
                                <% } %>
                            </td>
                        </tr>
                    <% 
                                }
                            }
                        } catch(Exception e) { 
                            e.printStackTrace(); 
                        } // FIXED: Explicitly added curly braces to enclose split scriptlet blocks cleanly
                    %>
                </tbody>
            </table>
        </div>

        <div class="side-panel">
            <h3>Analytics Widget</h3>
            <hr style="border-color: #4a5568;">
            <%
                int totalJobs = 0;
                int totalApps = 0;
                try (Connection conn = DBConnection.getConnection()) {
                    Statement s = conn.createStatement();
                    ResultSet r1 = s.executeQuery("SELECT COUNT(*) FROM jobs WHERE recruiter_id = " + recruiterId);
                    if(r1.next()) totalJobs = r1.getInt(1);
                    ResultSet r2 = s.executeQuery("SELECT COUNT(*) FROM applications a JOIN jobs j ON a.job_id = j.id WHERE j.recruiter_id = " + recruiterId);
                    if(r2.next()) totalApps = r2.getInt(1);
                } catch(Exception e) {
                    e.printStackTrace();
                }
            %>
            <p>Active Job Postings:</p>
            <div class="metric"><%= totalJobs %></div>
            <p>Total Submissions Evaluated:</p>
            <div class="metric"><%= totalApps %></div>
        </div>
    </div>
</body>
</html>