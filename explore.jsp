<%@page import="java.sql.*"%>
<% if(session.getAttribute("user_id") == null) { response.sendRedirect("login.jsp"); return; } %>
<!DOCTYPE html>
<html>
<head>
    <title>Explore - Social Media</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #fafafa; }
        .navbar { background: white; border-bottom: 1px solid #dbdbdb; padding: 15px 20px; }
        .navbar a { margin: 0 15px; text-decoration: none; color: #262626; font-weight: 500; }
        .navbar a:hover { color: #0095f6; }
        .container { max-width: 1000px; margin: 20px auto; padding: 0 20px; }
        .posts-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-top: 20px; }
        .post-item { position: relative; border: 1px solid #dbdbdb; border-radius: 3px; overflow: hidden; }
        .post-item img { width: 100%; height: 300px; object-fit: cover; }
        .post-overlay { position: absolute; bottom: 0; background: rgba(0,0,0,0.6); color: white; width: 100%; padding: 10px; }
    </style>
</head>
<body>
    <div class="navbar">
        <a href="index.jsp">🏠 Home</a>
        <a href="explore.jsp">🔍 Explore</a>
        <a href="search.jsp">🔎 Search</a>
        <a href="profile.jsp">👤 Profile</a>
        <a href="logout.jsp">🚪 Logout</a>
    </div>
    
    <div class="container">
        <h2>Explore</h2>
        <div class="posts-grid">
        <%
        try{
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost/social_media", "root", "");
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT p.*, u.username FROM posts p JOIN users u ON p.user_id=u.id ORDER BY RAND() LIMIT 30");
            while(rs.next()){
        %>
                <div class="post-item">
                    <a href="post-details.jsp?post_id=<%= rs.getInt("id") %>" style="text-decoration:none;">
                        <img src="<%= rs.getString("image") %>">
                        <div class="post-overlay">@<%= rs.getString("username") %></div>
                    </a>
                </div>
        <%
            }
            con.close();
        }catch(Exception e){
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
        %>
        </div>
    </div>
</body>
</html>
