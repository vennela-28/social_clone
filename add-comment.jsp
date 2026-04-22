<%@page import="java.sql.*"%>
<% if(session.getAttribute("user_id") == null) { response.sendRedirect("login.jsp"); return; } %>
<!DOCTYPE html>
<html>
<head>
    <title>Add Comment - Social Media</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #fafafa; }
        .navbar { background: white; border-bottom: 1px solid #dbdbdb; padding: 15px 20px; }
        .navbar a { margin: 0 15px; text-decoration: none; color: #262626; }
        .container { max-width: 600px; margin: 50px auto; padding: 40px; background: white; border: 1px solid #dbdbdb; border-radius: 5px; }
        h2 { margin-bottom: 20px; }
        textarea { width: 100%; padding: 12px; margin: 10px 0; border: 1px solid #dbdbdb; border-radius: 3px; font-family: inherit; height: 100px; }
        button { width: 100%; padding: 12px; background: #0095f6; color: white; border: none; border-radius: 3px; font-weight: bold; cursor: pointer; }
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
        <h2>Add Comment</h2>
        <form method="post">
            <textarea name="comment" placeholder="Write your comment..." required></textarea>
            <button type="submit">Post Comment</button>
        </form>
        <%
        int postId = Integer.parseInt(request.getParameter("post_id"));
        if(request.getMethod().equals("POST")){
            String comment = request.getParameter("comment");
            int uid = (Integer)session.getAttribute("user_id");
            try{
                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost/social_media", "root", "");
                PreparedStatement ps = con.prepareStatement("INSERT INTO comments(user_id, post_id, comment, created_at) VALUES (?, ?, ?, NOW())");
                ps.setInt(1, uid);
                ps.setInt(2, postId);
                ps.setString(3, comment);
                int i = ps.executeUpdate();
                if(i > 0){
                    out.println("<p class='success'>Comment added! Redirecting...</p>");
                    out.println("<script>setTimeout(function(){ window.location='view-comments.jsp?post_id=" + postId + "'; }, 1500);</script>");
                }
                con.close();
            }catch(Exception e){
                out.println("<p>Error: " + e.getMessage() + "</p>");
            }
        }
        %>
        <br><a href="post-details.jsp?post_id=<%= postId %>">Back to Post</a>
    </div>
</body>
</html>
