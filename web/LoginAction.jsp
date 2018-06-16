<%-- 
    Document   : LoginAction
    Created on : 15-giu-2018, 17.19.20
    Author     : Roberto97
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
    try{
        String username = request.getParameter("username");   
        String password = request.getParameter("password");
        Class.forName("com.mysql.cj.jdbc.Driver");  // MySQL database connection
        String dburl = "jdbc:mysql://sql2.freemysqlhosting.net:3306/sql2243047?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC&autoReconnect=true&useSSL=false";
        String dbusername = "sql2243047";
        String dbpassword = "mJ9*fQ4%";
        Connection conn = DriverManager.getConnection(dburl, dbusername, dbpassword);    
        PreparedStatement pst = conn.prepareStatement("Select * from USER where Email=? and Password=?"); 
        pst.setString(1, username);
        pst.setString(2, password);
        
        ResultSet rs = pst.executeQuery();
        String Nominativo = null;
        String strCheckBoxValue = request.getParameter("standard");
        String not = request.getParameter("nonstandard");
        
        //Guarda se i campoi sono corretti e se l'utente è standard
        if(rs.next() && strCheckBoxValue != null){
            if(rs.getString("Tipo").equals("standard")){
                %>
                    <%= Nominativo = rs.getString("Nominativo") %>
                <%
                    
                    Cookie cookie = new Cookie("Nominativo", Nominativo); cookie.setMaxAge(60*60*24); response.addCookie(cookie);
                    
                    response.sendRedirect("Users/standardType.jsp");
            }else out.println("Attenzione che tu sei un utente NONStandard");
        }else

        //Guarda se i campoi sono corretti e se l'utente è NON standard
           if(not != null){
            if(rs.getString("Tipo").equals("nonstandard")){
                %>
                    <%= Nominativo = rs.getString("Nominativo") %>
                <%
                    
                    Cookie cookie = new Cookie("Nominativo", Nominativo); cookie.setMaxAge(60*60*24); response.addCookie(cookie);
                    response.sendRedirect("Users/notStandardType.jsp");
            }else out.println("Attenzione che tu sei un utente Standard");
        }else
           out.println("Invalid login credentials");             
   }
   catch(Exception e){       
       out.println("Something went wrong !! Please try again");
        System.out.println("Causa Chiusura ");
                    e.printStackTrace();
   }      
%>
    </body>
</html>
