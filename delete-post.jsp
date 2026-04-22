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
    PreparedStatement ps = con.prepareStatement("DELETE FROM posts WHERE id=? AND user_id=?");
    ps.setInt(1, postId);
    ps.setInt(2, uid);
    ps.executeUpdate();
    con.close();
}catch(Exception e){
    out.println("Error: " + e.getMessage());
}
response.sendRedirect("profile.jsp");
%>
