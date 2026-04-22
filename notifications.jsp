<%@page import="java.sql.*"%>
<% if(session.getAttribute("user_id") == null) { response.sendRedirect("login.jsp"); return; } %>
<!DOCTYPE html>
<html>
<head>
    <title>Notifications - Social Media</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #fafafa; }
        .navbar { background: white; border-bottom: 1px solid #dbdbdb; padding: 15px 20px; }
        .navbar a { margin: 0 15px; text-decoration: none; color: #262626; }
        .container { max-width: 700px; margin: 20px auto; padding: 30px; background: white; border: 1px solid #dbdbdb; border-radius: 5px; }
        .notification-item { padding: 15px; border-bottom: 1px solid #efefef; }
        .notification-item a { color: #0095f6; text-decoration: none; margin-left: 10px; }
    </style>
</head>
<body>
    <div class="navbar">
        <a href="index.jsp">🏠 Home</a>
        <a href="notifications.jsp">🔔 Notifications</a>
        <a href="profile.jsp">👤 Profile</a>
        <a href="logout.jsp">🚪 Logout</a>
    </div>
    
    <div class="container">
        <h2>Notifications</h2>
        <%
        int uid = (Integer)session.getAttribute("user_id");
        try{
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/social_media", "root", "");
            
            out.println("<h3>Recent Likes</h3>");
            PreparedStatement ps1 = con.prepareStatement("SELECT l.*, u.username, p.id as post_id FROM likes l JOIN users u ON l.user_id=u.id JOIN posts p ON l.post_id=p.id WHERE p.user_id=? ORDER BY l.created_at DESC LIMIT 10");
            ps1.setInt(1, uid);
            ResultSet rs1 = ps1.executeQuery();
            while(rs1.next()){
        %>
                <div class="notification-item">
                    <strong>@<%= rs1.getString("username") %></strong> liked your post
                    <a href="post-details.jsp?post_id=<%= rs1.getInt("post_id") %>">View</a>
                </div>
        <%
            }
            
            out.println("<h3>Recent Comments</h3>");
            PreparedStatement ps2 = con.prepareStatement("SELECT c.*, u.username, p.id as post_id FROM comments c JOIN users u ON c.user_id=u.id JOIN posts p ON c.post_id=p.id WHERE p.user_id=? ORDER BY c.created_at DESC LIMIT 10");
            ps2.setInt(1, uid);
            ResultSet rs2 = ps2.executeQuery();
            while(rs2.next()){
        %>
                <div class="notification-item">
                    <strong>@<%= rs2.getString("username") %></strong> commented: "<%= rs2.getString("comment") %>"
                    <a href="post-details.jsp?post_id=<%= rs2.getInt("post_id") %>">View</a>
                </div>
        <%
            }
            
            out.println("<h3>New Followers</h3>");
            PreparedStatement ps3 = con.prepareStatement("SELECT f.*, u.username, u.id as user_id FROM follows f JOIN users u ON f.follower_id=u.id WHERE f.following_id=? ORDER BY f.created_at DESC LIMIT 10");
            ps3.setInt(1, uid);
            ResultSet rs3 = ps3.executeQuery();
            while(rs3.next()){
        %>
                <div class="notification-item">
                    <strong>@<%= rs3.getString("username") %></strong> started following you
                    <a href="user-profile.jsp?user_id=<%= rs3.getInt("user_id") %>">View Profile</a>
                </div>
        <%
            }
            con.close();
        }catch(Exception e){
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
        %>
    </div>
</body>
</html>
