<%-- 
    Document   : login
    Created on : 6 Jun 2026, 5:37:11 pm
    Author     : adamr
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>System Entrance - Login</title>
    <style>
        body { font-family: Arial, sans-serif; background: #edf2f7; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .card { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); width: 100%; max-width: 400px; }
        .form-group { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input { width: 100%; padding: 10px; border: 1px solid #cbd5e0; border-radius: 4px; box-sizing: border-box; }
        button { background: #2b6cb0; color: white; border: none; padding: 12px; width: 100%; border-radius: 4px; cursor: pointer; font-size: 16px; }
        .msg { color: #2f855a; background: #c6f6d5; padding: 10px; border-radius: 4px; margin-bottom: 15px; text-align: center; }
        .error { color: #e53e3e; background: #fed7d7; padding: 10px; border-radius: 4px; margin-bottom: 15px; text-align: center; }
    </style>
</head>
<body>
    <div class="card">
        <h2>Account Login</h2>
        <% if ("registration_success".equals(request.getParameter("msg"))) { %>
            <div class="msg">Registration successful! Please log in below.</div>
        <% } %>
        <% if ("invalid_credentials".equals(request.getParameter("error"))) { %>
            <div class="error">Invalid email or password parameters.</div>
        <% } %>
        <form action="AuthServlet" method="POST">
            <input type="hidden" name="action" value="login">
            <div class="form-group">
                <label>Email Address:</label>
                <input type="email" name="email" required>
            </div>
            <div class="form-group">
                <label>Password:</label>
                <input type="password" name="password" required>
            </div>
            <button type="submit">Sign In</button>
        </form>
        <p style="text-align: center; margin-top: 15px;"><a href="register.jsp">New here? Create an account</a></p>
    </div>
</body>
</html>
