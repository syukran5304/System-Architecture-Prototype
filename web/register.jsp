<%-- 
    Document   : register
    Created on : 6 Jun 2026, 5:36:54 pm
    Author     : adamr
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Join System - Register</title>
    <style>
        body { font-family: Arial, sans-serif; background: #edf2f7; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .card { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); width: 100%; max-width: 400px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input, select { width: 100%; padding: 10px; border: 1px solid #cbd5e0; border-radius: 4px; box-sizing: border-box; }
        button { background: #2b6cb0; color: white; border: none; padding: 12px; width: 100%; border-radius: 4px; cursor: pointer; font-size: 16px; }
        .error { color: #e53e3e; margin-bottom: 15px; text-align: center; font-weight: bold; }
    </style>
</head>
<body>
    <div class="card">
        <h2>Create an Account</h2>
        <% if ("registration_failed".equals(request.getParameter("error"))) { %>
            <div class="error">Registration failed. Email might already exist.</div>
        <% } %>
        <form action="AuthServlet" method="POST">
            <input type="hidden" name="action" value="register">
            <div class="form-group">
                <label>Full Name:</label>
                <input type="text" name="name" required>
            </div>
            <div class="form-group">
                <label>Email Address:</label>
                <input type="email" name="email" required>
            </div>
            <div class="form-group">
                <label>Password:</label>
                <input type="password" name="password" required>
            </div>
            <div class="form-group">
                <label>Account Role:</label>
                <select name="role">
                    <option value="CANDIDATE">Candidate (Job Seeker)</option>
                    <option value="RECRUITER">Recruiter (Hiring Team)</option>
                </select>
            </div>
            <button type="submit">Sign Up</button>
        </form>
        <p style="text-align: center; margin-top: 15px;"><a href="login.jsp">Already have an account? Login</a></p>
    </div>
</body>
</html>
