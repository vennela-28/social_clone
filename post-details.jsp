<%@page import="java.sql.*"%>
<% if(session.getAttribute("user_id") == null) { response.sendRedirect("login.jsp"); return; } %>
<!DOCTYPE html>
<html>
<head>
    <title>Post Details - Social Media</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #fafafa; }
        .navbar { background: white; border-bottom: 1px solid #dbdbdb; padding: 15px 20px; }
        .navbar a { margin: 0 15px; text-decoration: none; color: #262626; }
        .container { max-width: 800px; margin: 20px auto; padding: 30px; background: white; border: 1px solid #dbdbdb; border-radius: 5px; }
        .post-image { width: 100%; max-height: 600px; object-fit: cover; }
        .post-header { font-weight: bold; margin: 20px 0; }
        .post-caption { margin: 10px 0; }
        .actions { margin: 20px 0; }
        .actions a { margin-right: 20px; text-decoration: none; color: #0095f6; padding: 10px 20px; background: #e8f5ff; border-radius: 3px; }
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
        int postId = Integer.parseInt(request.getParameter("post_id"));
        try{
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/social_media", "root", "");
            PreparedStatement ps = con.prepareStatement("SELECT p.*, u.username FROM posts p JOIN users u ON p.user_id=u.id WHERE p.id=?");
            ps.setInt(1, postId);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
        %>
                <div class="post-header">Posted by: <a href="user-profile.jsp?user_id=<%= rs.getInt("user_id") %>">@<%= rs.getString("username") %></a></div>
                <img src="<%= rs.getString("image") %>" class="post-image">
                <div class="post-caption"><strong>Caption:</strong> <%= rs.getString("caption") %></div>
                <div class="actions">
                    <a href="like-post.jsp?post_id=<%= postId %>">❤️ Like</a>
                    <a href="add-comment.jsp?post_id=<%= postId %>">💬 Comment</a>
                    <a href="view-comments.jsp?post_id=<%= postId %>">View Comments</a>
                </div>
        <%
            }
            con.close();
        }catch(Exception e){
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
        %>
        <a href="index.jsp">Back to Feed</a>
    </div>
</body>
</html>
