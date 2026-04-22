<%@page import="java.sql.*"%>
<% if(session.getAttribute("user_id") == null) { response.sendRedirect("login.jsp"); return; } %>
<!DOCTYPE html>
<html>
<head>
    <title>Home - Social Media</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #fafafa; }
        .navbar { background: white; border-bottom: 1px solid #dbdbdb; padding: 15px 20px; position: sticky; top: 0; z-index: 100; }
        .navbar a { margin: 0 15px; text-decoration: none; color: #262626; font-weight: 500; }
        .navbar a:hover { color: #0095f6; }
        .container { max-width: 600px; margin: 20px auto; padding: 0 20px; }
        .post-card { background: white; border: 1px solid #dbdbdb; border-radius: 5px; margin: 20px 0; }
        .post-header { padding: 15px; font-weight: bold; border-bottom: 1px solid #efefef; }
        .post-image { width: 100%; display: block; }
        .post-content { padding: 15px; }
        .post-actions { padding: 10px 15px; border-top: 1px solid #efefef; }
        .post-actions a { margin-right: 20px; text-decoration: none; color: #262626; }
        .post-actions a:hover { color: #0095f6; }
    </style>
</head>
<body>
    <div class="navbar">
        <a href="index.jsp">🏠 Home</a>
        <a href="explore.jsp">🔍 Explore</a>
        <a href="search.jsp">🔎 Search</a>
        <a href="create-post.jsp">➕ Create</a>
        <a href="notifications.jsp">🔔 Notifications</a>
        <a href="profile.jsp">👤 Profile</a>
        <a href="logout.jsp">🚪 Logout</a>
    </div>
    
    <div class="container">
        <h2>Your Feed</h2>
        <%
        try{
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/social_media", "root", "");
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT p.*, u.username FROM posts p JOIN users u ON p.user_id=u.id ORDER BY p.created_at DESC");
            while(rs.next()){
        %>
            <div class="post-card">
                <div class="post-header">
                    <a href="user-profile.jsp?user_id=<%= rs.getInt("user_id") %>" style="text-decoration:none; color:#262626;">
                        <strong>@<%= rs.getString("username") %></strong>
                    </a>
                </div>
                <% if(rs.getString("image") != null && !rs.getString("image").isEmpty()){ %>
                    <img src="<%= rs.getString("image") %>" class="post-image">
                <% } %>
                <div class="post-content">
                    <p><%= rs.getString("caption") %></p>
                </div>
                <div class="post-actions">
                    <a href="like-post.jsp?post_id=<%= rs.getInt("id") %>">❤️ Like</a>
                    <a href="view-comments.jsp?post_id=<%= rs.getInt("id") %>">💬 Comment</a>
                    <a href="post-details.jsp?post_id=<%= rs.getInt("id") %>">👁️ View</a>
                </div>
            </div>
        <%
            }
            con.close();
        }catch(Exception e){
            out.println("<p>Error loading feed: " + e.getMessage() + "</p>");
        }
        %>
    </div>
</body>
</html>
