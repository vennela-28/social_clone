<%@page import="java.sql.*"%>
<%
if(session.getAttribute("user_id") == null) {
    response.sendRedirect("login.jsp");
    return;
}

int postId = Integer.parseInt(request.getParameter("post_id"));
int uid = (Integer)session.getAttribute("user_id");

try{
    Class.forName("com.mysql.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost/social_media", "root", "");
    
    PreparedStatement check = con.prepareStatement("SELECT * FROM likes WHERE user_id=? AND post_id=?");
    check.setInt(1, uid);
    check.setInt(2, postId);
    ResultSet rs = check.executeQuery();
    
    if(rs.next()){
        // Unlike
        PreparedStatement ps = con.prepareStatement("DELETE FROM likes WHERE user_id=? AND post_id=?");
        ps.setInt(1, uid);
        ps.setInt(2, postId);
        ps.executeUpdate();
    }else{
        // Like
        PreparedStatement ps = con.prepareStatement("INSERT INTO likes(user_id, post_id, created_at) VALUES (?, ?, NOW())");
        ps.setInt(1, uid);
        ps.setInt(2, postId);
        ps.executeUpdate();
    }
    con.close();
}catch(Exception e){
    out.println("Error: " + e.getMessage());
}
response.sendRedirect("post-details.jsp?post_id=" + postId);
%>
