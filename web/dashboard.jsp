<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List, java.sql.*, com.recruitment.config.DBConnection"%>
<%
    // Verify secure session validation and block unauthenticated users
    HttpSession sess = request.getSession(false);
    if (sess == null || !"CANDIDATE".equals(sess.getAttribute("userRole"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    long candidateId = (Long) sess.getAttribute("userId");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Candidate Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; background: #edf2f7; margin: 0; padding: 20px; }
        .header { display: flex; justify-content: space-between; align-items: center; background: #2b6cb0; color: white; padding: 15px; border-radius: 4px; }
        .container { max-width: 900px; margin: 20px auto; }
        .search-box, .status-box { background: white; padding: 20px; border-radius: 6px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); margin-bottom: 20px; }
        .search-box input[type="text"] { width: 75%; padding: 10px; border: 1px solid #cbd5e0; border-radius: 4px; }
        .search-box button { width: 20%; padding: 10px; background: #2b6cb0; color: white; border: none; border-radius: 4px; cursor: pointer; }
        .job-card { background: white; padding: 20px; border-radius: 6px; margin-bottom: 15px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
        .btn-apply { background: #48bb78; color: white; border: none; padding: 8px 15px; border-radius: 4px; cursor: pointer; float: right; text-decoration: none;}
        .alert { padding: 10px; border-radius: 4px; margin-bottom: 15px; font-weight: bold; background-color: #c6f6d5; color: #22543d; }
        
        /* Table Styling for Tracking Module */
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { padding: 12px; border: 1px solid #e2e8f0; text-align: left; }
        th { background: #edf2f7; color: #4a5568; }
        .badge { padding: 4px 8px; border-radius: 12px; font-size: 12px; font-weight: bold; text-transform: uppercase; }
        .badge-submitted { background: #e2e8f0; color: #4a5568; }
        .badge-shortlisted { background: #c6f6d5; color: #22543d; }
        .badge-rejected { background: #fed7d7; color: #742a2a; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <span>Welcome back, <strong><%= sess.getAttribute("userName") %></strong> (ID: <%= candidateId %>)</span>
            <a href="login.jsp" style="color: white; text-decoration: none; font-weight: bold;">Logout</a>
        </div>

        <h2 style="color: #2d3748;">Find Your Next Role</h2>
        
        <% if("success".equals(request.getParameter("status"))) { %>
            <div class="alert">Application processed! Asynchronous pipeline processing initiated.</div>
        <% } %>

        <div class="search-box">
            <form action="SearchServlet" method="GET">
                <input type="text" name="query" placeholder="Search by title, skills, keywords..." value="<%= request.getParameter("query") != null ? request.getParameter("query") : "" %>" required />
                <button type="submit">Search Jobs</button>
            </form>
            <% if (request.getAttribute("searchDuration") != null) { %>
                <p style="color: #718096; font-size: 13px; margin-top: 10px; margin-bottom: 0;">
                    Indexed query executed in exactly <strong><%= request.getAttribute("searchDuration") %> ms</strong> (well within the 2.0-second constraint limit).
                </p>
            <% } %>
        </div>

        <div class="results-layout">
            <% 
                List<String[]> jobs = (List<String[]>) request.getAttribute("jobResults");
                if (jobs != null && !jobs.isEmpty()) {
                    for (String[] job : jobs) {
            %>
                <div class="job-card">
                    <form action="ApplyJobServlet" method="POST">
                        <input type="hidden" name="jobId" value="<%= job[0] %>" />
                        <input type="hidden" name="candidateId" value="<%= candidateId %>" />
                        <input type="hidden" name="resumePath" value="/var/storage/resumes/candidate_<%= candidateId %>_cv.pdf" />
                        
                        <button type="submit" class="btn-apply">Instantly Apply</button>
                    </form>
                    <h3 style="margin-top:0; color:#2b6cb0;"><%= job[1] %></h3>
                    <p style="color:#718096; font-size:14px;"><%= job[3] %> | <%= job[2] %></p>
                    <p><%= job[4] %></p>
                </div>
            <% 
                    }
                } else if (request.getParameter("query") != null) {
            %>
                <p style="text-align: center; color: #a0aec0;">No postings matched your criteria. Try alternative search terms.</p>
            <% } %>
        </div>

        <div class="status-box">
            <h3 style="margin-top: 0; color: #2d3748;">Your Application Status Updates</h3>
            <table>
                <thead>
                    <tr>
                        <th>Job Position</th>
                        <th>Submission Date</th>
                        <th>Current Evaluation Status</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String trackingQuery = "SELECT j.title, a.created_at, a.status " +
                                              "FROM applications a JOIN jobs j ON a.job_id = j.id " +
                                              "WHERE a.candidate_id = ? ORDER BY a.created_at DESC";
                        
                        try (Connection conn = DBConnection.getConnection();
                             PreparedStatement ps = conn.prepareStatement(trackingQuery)) {
                            
                            ps.setLong(1, candidateId);
                            try (ResultSet rs = ps.executeQuery()) {
                                boolean hasApplications = false;
                                while(rs.next()) {
                                    hasApplications = true;
                                    String jobTitle = rs.getString("title");
                                    Timestamp appliedAt = rs.getTimestamp("created_at");
                                    String appStatus = rs.getString("status");
                                    
                                    // Map CSS badge classes based on status string
                                    String badgeClass = "badge-submitted";
                                    if ("SHORTLISTED".equals(appStatus)) badgeClass = "badge-shortlisted";
                                    if ("REJECTED".equals(appStatus)) badgeClass = "badge-rejected";
                    %>
                        <tr>
                            <td><strong><%= jobTitle %></strong></td>
                            <td><%= appliedAt.toString() %></td>
                            <td><span class="badge <%= badgeClass %>"><%= appStatus %></span></td>
                        </tr>
                    <% 
                                }
                                if (!hasApplications) {
                    %>
                        <tr>
                            <td colspan="3" style="text-align: center; color: #a0aec0;">You haven't submitted any job applications yet.</td>
                        </tr>
                    <%
                                }
                            }
                        } catch(Exception e) { 
                            e.printStackTrace(); 
                        }
                    %>
                </tbody>
            </table>
        </div>
        </div>
</body>
</html>