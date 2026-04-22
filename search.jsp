<%@page import="java.sql.*"%>
<% if(session.getAttribute("user_id") == null) { response.sendRedirect("login.jsp"); return; } %>
<!DOCTYPE html>
<html>
<head>
    <title>Search - Social Media</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #fafafa; }
        .navbar { background: white; border-bottom: 1px solid #dbdbdb; padding: 15px 20px; }
        .navbar a { margin: 0 15px; text-decoration: none; color: #262626; }
        .container { max-width: 700px; margin: 20px auto; padding: 20px; }
        .search-box { background: white; padding: 20px; border: 1px solid #dbdbdb; border-radius: 5px; margin-bottom: 20px; }
        .search-box input { width: 70%; padding: 10px; border: 1px solid #dbdbdb; border-radius: 3px; }
        .search-box button { padding: 10px 20px; background: #0095f6; color: white; border: none; border-radius: 3px; cursor: pointer; margin-left: 10px; }
        .result { background: white; padding: 15px; border: 1px solid #dbdbdb; border-radius: 3px; margin: 10px 0; }
        .result a { text-decoration: none; color: #262626; font-weight: bold; }
        .result a:hover { color: #0095f6; }
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
        <div class="search-box">
            <h2>Search Users</h2>
            <form method="get">
                <input type="text" name="query" placeholder="Search for users..." value="<%= request.getParameter("query") != null ? request.getParameter("query") : "" %>">
                <button type="submit">Search</button>
            </form>
        </div>
        
        <%
        String query = request.getParameter("query");
        if(query != null && !query.isEmpty()){
            try{
                Class.forName("com.mysql.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost/social_media", "root", "");
                PreparedStatement ps = con.prepareStatement("SELECT id, username, email FROM users WHERE username LIKE ? OR email LIKE ?");
                ps.setString(1, "%" + query + "%");
                ps.setString(2, "%" + query + "%");
                ResultSet rs = ps.executeQuery();
                out.println("<h3>Search Results:</h3>");
                boolean found = false;
                while(rs.next()){
                    found = true;
        %>
                    <div class="result">
                        <a href="user-profile.jsp?user_id=<%= rs.getInt("id") %>">@<%= rs.getString("username") %></a>
                        <p><%= rs.getString("email") %></p>
                    </div>
        <%
                }
                if(!found){
                    out.println("<p>No users found.</p>");
                }
                con.close();
            }catch(Exception e){
                out.println("<p>Error: " + e.getMessage() + "</p>");
            }
        }
        %>
    </div>
</body>
</html>
