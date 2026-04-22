<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Social Media</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #fafafa; display: flex; justify-content: center; align-items: center; height: 100vh; }
        .auth-box { background: white; border: 1px solid #dbdbdb; border-radius: 5px; padding: 40px; width: 350px; text-align: center; }
        h2 { margin-bottom: 30px; color: #262626; }
        input { width: 100%; padding: 12px; margin: 8px 0; border: 1px solid #dbdbdb; border-radius: 3px; font-size: 14px; }
        button { width: 100%; padding: 12px; margin: 15px 0; background: #0095f6; color: white; border: none; border-radius: 3px; font-weight: bold; cursor: pointer; font-size: 14px; }
        button:hover { background: #0076cc; }
        a { color: #0095f6; text-decoration: none; font-weight: 600; }
        .error { color: #ed4956; margin-top: 10px; }
        .success { color: #00a400; margin-top: 10px; }
    </style>
</head>
<body>
    <div class="auth-box">
        <h2>📱 Social Media</h2>
        <h3>Login</h3>
        <form method="post">
            <input type="text" name="username" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Log In</button>
        </form>
        <p>Don't have an account? <a href="register.jsp">Sign up</a></p>
        <%
        if(request.getMethod().equals("POST")){
            String user = request.getParameter("username");
            String pass = request.getParameter("password");
            try{
                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost/social_media", "root", "");
                PreparedStatement ps = con.prepareStatement("SELECT id, username FROM users WHERE username=? AND password=?");
                ps.setString(1, user);
                ps.setString(2, pass);
                ResultSet rs = ps.executeQuery();
                if(rs.next()){
                    session.setAttribute("user_id", rs.getInt("id"));
                    session.setAttribute("username", rs.getString("username"));
                    response.sendRedirect("index.jsp");
                }else{
                    out.println("<p class='error'>Invalid username or password!</p>");
                }
                con.close();
            }catch(Exception e){
                out.println("<p class='error'>Error: " + e.getMessage() + "</p>");
            }
        }
        %>
    </div>
</body>
</html>
