<%@page import="java.sql.*"%>
<% if(session.getAttribute("user_id") == null) { response.sendRedirect("login.jsp"); return; } %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Profile - Social Media</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #fafafa; }
        .navbar { background: white; border-bottom: 1px solid #dbdbdb; padding: 15px 20px; }
        .navbar a { margin: 0 15px; text-decoration: none; color: #262626; }
        .container { max-width: 600px; margin: 50px auto; padding: 40px; background: white; border: 1px solid #dbdbdb; border-radius: 5px; }
        h2 { margin-bottom: 20px; }
        label { display: block; margin-top: 15px; font-weight: bold; }
        input, textarea { width: 100%; padding: 12px; margin: 8px 0; border: 1px solid #dbdbdb; border-radius: 3px; font-family: inherit; }
        textarea { height: 80px; }
        button { width: 100%; padding: 12px; margin-top: 15px; background: #0095f6; color: white; border: none; border-radius: 3px; font-weight: bold; cursor: pointer; }
        .success { color: #00a400; background: #e8f5e9; padding: 10px; border-radius: 3px; margin: 10px 0; text-align: center; }
    </style>
</head>
<body>
    <div class="navbar">
        <a href="index.jsp">🏠 Home</a>
        <a href="profile.jsp">👤 Profile</a>
        <a href="logout.jsp">🚪 Logout</a>
    </div>
    
    <div class="container">
        <h2>Edit Profile Settings</h2>
        <%
        int uid = (Integer)session.getAttribute("user_id");
        
        if(request.getMethod().equals("POST")){
            String email = request.getParameter("email");
            String bio = request.getParameter("bio");
            String profilePic = request.getParameter("profile_pic");
            
            try{
                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost/social_media", "root", "");
                PreparedStatement ps = con.prepareStatement("UPDATE users SET email=?, bio=?, profile_pic=? WHERE id=?");
                ps.setString(1, email);
                ps.setString(2, bio);
                ps.setString(3, profilePic);
                ps.setInt(4, uid);
                int i = ps.executeUpdate();
                if(i > 0){
                    out.println("<p class='success'>Profile updated successfully!</p>");
                }
                con.close();
            }catch(Exception e){
                out.println("<p>Error: " + e.getMessage() + "</p>");
            }
        }
        
        try{
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/social_media", "root", "");
            PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE id=?");
            ps.setInt(1, uid);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
        %>
                <form method="post">
                    <label>Email:</label>
                    <input type="email" name="email" value="<%= rs.getString("email") %>">
                    
                    <label>Bio:</label>
                    <textarea name="bio"><%= rs.getString("bio") != null ? rs.getString("bio") : "" %></textarea>
                    
                    <label>Profile Picture URL:</label>
                    <input type="text" name="profile_pic" value="<%= rs.getString("profile_pic") != null ? rs.getString("profile_pic") : "" %>">
                    
                    <button type="submit">Update Profile</button>
                </form>
        <%
            }
            con.close();
        }catch(Exception e){
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
        %>
        <br><a href="profile.jsp">Back to Profile</a>
    </div>
</body>
</html>
