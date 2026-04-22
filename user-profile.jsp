<%@page import="java.sql.*"%>
<% if(session.getAttribute("user_id") == null) { response.sendRedirect("login.jsp"); return; } %>
<!DOCTYPE html>
<html>
<head>
    <title>User Profile - Social Media</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #fafafa; }
        .navbar { background: white; border-bottom: 1px solid #dbdbdb; padding: 15px 20px; }
        .navbar a { margin: 0 15px; text-decoration: none; color: #262626; }
        .container { max-width: 800px; margin: 20px auto; padding: 30px; background: white; border: 1px solid #dbdbdb; border-radius: 5px; }
        .profile-header { padding: 20px 0; border-bottom: 1px solid #efefef; }
        .btn { display: inline-block; padding: 10px 20px; background: #0095f6; color: white; text-decoration: none; border-radius: 3px; margin: 10px 5px; }
        .posts-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-top: 30px; }
        .post-item { border: 1px solid #dbdbdb; border-radius: 3px; overflow: hidden; }
        .post-item img { width: 100%; height: 200px; object-fit: cover; }
        .post-item p { padding: 10px; }
    </style>
</head>
<body>
    <div class="navbar">
        <a href="index.jsp">🏠 Home</a>
        <a href="search.jsp">🔎 Search</a>
        <a href="profile.jsp">👤 Profile</a>
        <a href="logout.jsp">🚪 Logout</a>
    </div>
    
    <div class="container">
        <%
        int userId = Integer.parseInt(request.getParameter("user_id"));
        int myId = (Integer)session.getAttribute("user_id");
        
        try{
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/social_media", "root", "");
            
            PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE id=?");
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
        %>
                <div class="profile-header">
                    <h1>@<%= rs.getString("username") %></h1>
                    <p><strong>Email:</strong> <%= rs.getString("email") %></p>
                    <p><strong>Bio:</strong> <%= rs.getString("bio") != null ? rs.getString("bio") : "No bio" %></p>
                    <% if(userId != myId) { %>
                        <a href="follow-user.jsp?user_id=<%= userId %>" class="btn">Follow/Unfollow</a>
                    <% } %>
                </div>
        <%
            }
            
            out.println("<h3>Posts</h3>");
            out.println("<div class='posts-grid'>");
            PreparedStatement ps2 = con.prepareStatement("SELECT * FROM posts WHERE user_id=? ORDER BY created_at DESC");
            ps2.setInt(1, userId);
            ResultSet rs2 = ps2.executeQuery();
            while(rs2.next()){
        %>
                <div class="post-item">
                    <a href="post-details.jsp?post_id=<%= rs2.getInt("id") %>" style="text-decoration:none; color:#262626;">
                        <img src="<%= rs2.getString("image") %>">
                        <p><%= rs2.getString("caption") %></p>
                    </a>
                </div>
        <%
            }
            out.println("</div>");
            con.close();
        }catch(Exception e){
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
        %>
        <br><a href="index.jsp">Back to Feed</a>
    </div>
</body>
</html>
