<%@page import="java.sql.*"%>
<% if(session.getAttribute("user_id") == null) { response.sendRedirect("login.jsp"); return; } %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Post - Social Media</title>
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
        <h2>Edit Post</h2>
        <%
        int postId = Integer.parseInt(request.getParameter("post_id"));
        int uid = (Integer)session.getAttribute("user_id");
        
        if(request.getMethod().equals("POST")){
            String caption = request.getParameter("caption");
            try{
                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost/social_media", "root", "");
                PreparedStatement ps = con.prepareStatement("UPDATE posts SET caption=? WHERE id=? AND user_id=?");
                ps.setString(1, caption);
                ps.setInt(2, postId);
                ps.setInt(3, uid);
                int i = ps.executeUpdate();
                if(i > 0){
                    out.println("<p class='success'>Post updated successfully! Redirecting...</p>");
                    out.println("<script>setTimeout(function(){ window.location='profile.jsp'; }, 2000);</script>");
                }
                con.close();
            }catch(Exception e){
                out.println("<p>Error: " + e.getMessage() + "</p>");
            }
        }else{
            try{
                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost/social_media", "root", "");
                PreparedStatement ps = con.prepareStatement("SELECT * FROM posts WHERE id=? AND user_id=?");
                ps.setInt(1, postId);
                ps.setInt(2, uid);
                ResultSet rs = ps.executeQuery();
                if(rs.next()){
        %>
                    <form method="post">
                        <textarea name="caption" required><%= rs.getString("caption") %></textarea>
                        <button type="submit">Update Post</button>
                    </form>
        <%
                }
                con.close();
            }catch(Exception e){
                out.println("<p>Error: " + e.getMessage() + "</p>");
            }
        }
        %>
        <br><a href="profile.jsp">Cancel</a>
    </div>
</body>
</html>
