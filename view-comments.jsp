<%@page import="java.sql.*"%>
<% if(session.getAttribute("user_id") == null) { response.sendRedirect("login.jsp"); return; } %>
<!DOCTYPE html>
<html>
<head>
    <title>Comments - Social Media</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #fafafa; }
        .navbar { background: white; border-bottom: 1px solid #dbdbdb; padding: 15px 20px; }
        .navbar a { margin: 0 15px; text-decoration: none; color: #262626; }
        .container { max-width: 700px; margin: 20px auto; padding: 30px; background: white; border: 1px solid #dbdbdb; border-radius: 5px; }
        .comment { padding: 15px; border-bottom: 1px solid #efefef; }
        .comment .username { font-weight: bold; margin-bottom: 5px; }
        .comment .text { color: #262626; }
        .add-comment { margin: 20px 0; }
        .btn { display: inline-block; padding: 10px 20px; background: #0095f6; color: white; text-decoration: none; border-radius: 3px; }
    </style>
</head>
<body>
    <div class="navbar">
        <a href="index.jsp">🏠 Home</a>
        <a href="profile.jsp">👤 Profile</a>
        <a href="logout.jsp">🚪 Logout</a>
    </div>
    
    <div class="container">
        <h2>Comments</h2>
        <%
        int postId = Integer.parseInt(request.getParameter("post_id"));
        try{
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/social_media", "root", "");
            PreparedStatement ps = con.prepareStatement("SELECT c.*, u.username FROM comments c JOIN users u ON c.user_id=u.id WHERE c.post_id=? ORDER BY c.created_at DESC");
            ps.setInt(1, postId);
            ResultSet rs = ps.executeQuery();
            boolean found = false;
            while(rs.next()){
                found = true;
        %>
                <div class="comment">
                    <div class="username">@<%= rs.getString("username") %></div>
                    <div class="text"><%= rs.getString("comment") %></div>
                    <small style="color:#8e8e8e;"><%= rs.getTimestamp("created_at") %></small>
                </div>
        <%
            }
            if(!found){
                out.println("<p>No comments yet. Be the first to comment!</p>");
            }
            con.close();
        }catch(Exception e){
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
        %>
        <div class="add-comment">
            <a href="add-comment.jsp?post_id=<%= postId %>" class="btn">💬 Add Comment</a>
        </div>
        <a href="post-details.jsp?post_id=<%= postId %>">Back to Post</a>
    </div>
</body>
</html>
