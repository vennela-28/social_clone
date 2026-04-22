<%@page import="java.sql.*"%>
<%
if(session.getAttribute("user_id") == null) {
    response.sendRedirect("login.jsp");
    return;
}

int userId = Integer.parseInt(request.getParameter("user_id"));
int myId = (Integer)session.getAttribute("user_id");

try{
    Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost/social_media", "root", "");
    
    PreparedStatement check = con.prepareStatement("SELECT * FROM follows WHERE follower_id=? AND following_id=?");
    check.setInt(1, myId);
    check.setInt(2, userId);
    ResultSet rs = check.executeQuery();
    
    if(rs.next()){
        // Unfollow
        PreparedStatement ps = con.prepareStatement("DELETE FROM follows WHERE follower_id=? AND following_id=?");
        ps.setInt(1, myId);
        ps.setInt(2, userId);
        ps.executeUpdate();
    }else{
        // Follow
        PreparedStatement ps = con.prepareStatement("INSERT INTO follows(follower_id, following_id, created_at) VALUES (?, ?, NOW())");
        ps.setInt(1, myId);
        ps.setInt(2, userId);
        ps.executeUpdate();
    }
    con.close();
}catch(Exception e){
    out.println("Error: " + e.getMessage());
}
response.sendRedirect("user-profile.jsp?user_id=" + userId);
%>
