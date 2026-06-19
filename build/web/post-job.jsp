<%-- 
    Document   : post-job
    Created on : 6 Jun 2026, 5:38:13 pm
    Author     : adamr
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Post a New Vacancy</title>
    <style>
        body { font-family: Arial, sans-serif; background: #edf2f7; padding: 30px; }
        .card { background: white; max-width: 600px; margin: 0 auto; padding: 30px; border-radius: 6px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; color: #4a5568; }
        input, theorists, textarea { width: 100%; padding: 10px; border: 1px solid #cbd5e0; border-radius: 4px; box-sizing: border-box; }
        textarea { height: 100px; resize: vertical; }
        button { background: #2b6cb0; color: white; border: none; padding: 12px 20px; border-radius: 4px; cursor: pointer; font-size: 16px; }
        a { color: #4a5568; text-decoration: none; margin-left: 15px; }
    </style>
</head>
<body>
    <div class="card">
        <h2>Publish a Job Opening</h2>
        <form action="JobServlet" method="POST">
            <div class="form-group">
                <label>Position Title:</label>
                <input type="text" name="title" required />
            </div>
            <div class="form-group">
                <label>Job Description:</label>
                <textarea name="description" required></textarea>
            </div>
            <div class="form-group">
                <label>Required Skills (Comma Separated):</label>
                <input type="text" name="required_skills" placeholder="e.g. Java, SQL, Spring" required />
            </div>
            <div class="form-group">
                <label>Salary Range:</label>
                <input type="text" name="salary_range" placeholder="e.g. RM3,000" />
            </div>
            <div class="form-group">
                <label>Location:</label>
                <input type="text" name="location" placeholder="e.g. WFH, Kuala Terengganu" required />
            </div>
            <button type="submit">Publish Opening</button>
            <a href="recruiter-workspace.jsp">Cancel</a>
        </form>
    </div>
</body>
</html>
