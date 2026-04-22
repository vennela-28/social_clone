<%@page import="java.sql.*"%>
<% if(session.getAttribute("user_id") == null) { response.sendRedirect("login.jsp"); return; } %>
<!DOCTYPE html>
<html>
<head>
    <title>Followers - Social Media</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #fafafa; }
        .navbar { background: white; border-bottom: 1px solid #dbdbdb; padding: 15px 20px; }
        .navbar a { margin: 0 15px; text-decoration: none; color: #262626; }
        .container { max-width: 600px; margin: 20px auto; padding: 30px; background: white; border: 1px solid #dbdbdb; border-radius: 5px; }
        .follower { padding: 15px; border-bottom: 1px solid #efefef; }
        .follower a { text-decoration: none; color: #262626; font-weight: bold; }
        .follower a:hover { color: #0095f6; }
    </style>
</head>
<body>
    <div class="navbar">
        <a href="index.jsp">🏠 Home</a>
        <a href="profile.jsp">👤 Profile</a>
        <a href="logout.jsp">🚪 Logout</a>
    </div>
    
    <div class="container">
        <h2>Your Followers</h2>
        <%
        int uid = (Integer)session.getAttribute("user_id");
        try{
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/social_media", "root", "");
            PreparedStatement ps = con.prepareStatement("SELECT u.id, u.username FROM follows f JOIN users u ON f.follower_id=u.id WHERE f.following_id=?");
            ps.setInt(1, uid);
            ResultSet rs = ps.executeQuery();
            boolean found = false;
            while(rs.next()){
                found = true;
        %>
                <div class="follower">
                    <a href="user-profile.jsp?user_id=<%= rs.getInt("id") %>">@<%= rs.getString("username") %></a>
                </div>
        <%
            }
            if(!found){
                out.println("<p>No followers yet.</p>");
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
