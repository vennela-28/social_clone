<%@page import="java.sql.*"%>
<% if(session.getAttribute("user_id") == null) { response.sendRedirect("login.jsp"); return; } %>
<!DOCTYPE html>
<html>
<head>
    <title>Create Post - Social Media</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #fafafa; }
        .navbar { background: white; border-bottom: 1px solid #dbdbdb; padding: 15px 20px; }
        .navbar a { margin: 0 15px; text-decoration: none; color: #262626; }
        .container { max-width: 600px; margin: 50px auto; padding: 40px; background: white; border: 1px solid #dbdbdb; border-radius: 5px; }
        h2 { text-align: center; margin-bottom: 30px; }
        input, textarea { width: 100%; padding: 12px; margin: 10px 0; border: 1px solid #dbdbdb; border-radius: 3px; font-family: inherit; }
        textarea { height: 100px; }
        button { width: 100%; padding: 12px; background: #0095f6; color: white; border: none; border-radius: 3px; font-weight: bold; cursor: pointer; }
        button:hover { background: #0076cc; }
        .success { color: #00a400; background: #e8f5e9; padding: 10px; border-radius: 3px; margin: 10px 0; text-align: center; }
        .error { color: #ed4956; background: #ffebee; padding: 10px; border-radius: 3px; margin: 10px 0; text-align: center; }
        .back-link { text-align: center; margin-top: 20px; }
    </style>
</head>
<body>
    <div class="navbar">
        <a href="index.jsp">🏠 Home</a>
        <a href="profile.jsp">👤 Profile</a>
        <a href="logout.jsp">🚪 Logout</a>
    </div>
    
    <div class="container">
        <h2>Create New Post</h2>
        <form method="post">
            <input type="text" name="image" placeholder="Image URL" required>
            <textarea name="caption" placeholder="Write a caption..."></textarea>
            <button type="submit">Post</button>
        </form>
        <div class="back-link">
            <a href="index.jsp">Back to Feed</a>
        </div>
        <%
        if(request.getMethod().equals("POST")){
            String img = request.getParameter("image");
            String caption = request.getParameter("caption");
            int uid = (Integer)session.getAttribute("user_id");
            try{
                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost/social_media", "root", "");
                PreparedStatement ps = con.prepareStatement("INSERT INTO posts(user_id, image, caption, created_at) VALUES (?, ?, ?, NOW())");
                ps.setInt(1, uid);
                ps.setString(2, img);
                ps.setString(3, caption);
                int i = ps.executeUpdate();
                if(i > 0){
                    out.println("<p class='success'>Post created successfully! Redirecting...</p>");
                    out.println("<script>setTimeout(function(){ window.location='index.jsp'; }, 2000);</script>");
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
