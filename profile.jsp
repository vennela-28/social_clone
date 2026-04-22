<%@page import="java.sql.*"%>
<% if(session.getAttribute("user_id") == null) { response.sendRedirect("login.jsp"); return; } %>
<!DOCTYPE html>
<html>
<head>
    <title>My Profile - Social Media</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #fafafa; }
        .navbar { background: white; border-bottom: 1px solid #dbdbdb; padding: 15px 20px; }
        .navbar a { margin: 0 15px; text-decoration: none; color: #262626; font-weight: 500; }
        .container { max-width: 800px; margin: 20px auto; padding: 20px; background: white; border: 1px solid #dbdbdb; border-radius: 5px; }
        .profile-header { padding: 20px 0; border-bottom: 1px solid #efefef; }
        .btn { display: inline-block; padding: 10px 20px; background: #0095f6; color: white; text-decoration: none; border-radius: 3px; margin: 10px 5px; }
        .btn:hover { background: #0076cc; }
        .posts-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-top: 20px; }
        .post-item { border: 1px solid #dbdbdb; border-radius: 3px; overflow: hidden; }
        .post-item img { width: 100%; height: 200px; object-fit: cover; }
        .post-item p { padding: 10px; }
        .post-item a { display: inline-block; margin: 5px; padding: 5px 10px; background: #0095f6; color: white; text-decoration: none; border-radius: 3px; font-size: 12px; }
    </style>
</head>
<body>
    <div class="navbar">
        <a href="index.jsp">🏠 Home</a>
        <a href="profile.jsp">👤 Profile</a>
        <a href="logout.jsp">🚪 Logout</a>
    </div>
    
    <div class="container">
        <%
        int uid = (Integer)session.getAttribute("user_id");
        try{
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/social_media", "root", "");
            
            PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE id=?");
            ps.setInt(1, uid);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
        %>
            <div class="profile-header">
                <h1>@<%= rs.getString("username") %></h1>
                <p><strong>Email:</strong> <%= rs.getString("email") %></p>
                <p><strong>Bio:</strong> <%= rs.getString("bio") != null ? rs.getString("bio") : "No bio yet" %></p>
                <a href="edit-profile.jsp" class="btn">Edit Profile</a>
            </div>
        <%
            }
            
            PreparedStatement ps2 = con.prepareStatement("SELECT COUNT(*) as count FROM posts WHERE user_id=?");
            ps2.setInt(1, uid);
            ResultSet rs2 = ps2.executeQuery();
            int postCount = 0;
            if(rs2.next()) postCount = rs2.getInt("count");
        %>
            <div style="padding: 20px 0;">
                <span><strong><%= postCount %></strong> posts</span>
                <a href="followers.jsp" style="margin-left:20px;"><strong>Followers</strong></a>
                <a href="following.jsp" style="margin-left:20px;"><strong>Following</strong></a>
            </div>
            
            <h3>Your Posts</h3>
            <div class="posts-grid">
        <%
            PreparedStatement ps3 = con.prepareStatement("SELECT * FROM posts WHERE user_id=? ORDER BY created_at DESC");
            ps3.setInt(1, uid);
            ResultSet rs3 = ps3.executeQuery();
            while(rs3.next()){
        %>
                <div class="post-item">
                    <img src="<%= rs3.getString("image") %>">
                    <p><%= rs3.getString("caption") %></p>
                    <a href="post-details.jsp?post_id=<%= rs3.getInt("id") %>">View</a>
                    <a href="edit-post.jsp?post_id=<%= rs3.getInt("id") %>">Edit</a>
                    <a href="delete-post.jsp?post_id=<%= rs3.getInt("id") %>">Delete</a>
                </div>
        <%
            }
        %>
            </div>
        <%
            con.close();
        }catch(Exception e){
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
        %>
    </div>
</body>
</html>
