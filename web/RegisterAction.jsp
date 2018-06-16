<%-- 
    Document   : RegisterAction
    Created on : 16-giu-2018, 13.01.16
    Author     : Roberto97
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        
        
        <%
            Connection conn = null;
            try{
                Class.forName("com.mysql.cj.jdbc.Driver");  // MySQL database connection
                String dburl = "jdbc:mysql://sql2.freemysqlhosting.net:3306/sql2243047?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC&autoReconnect=true&useSSL=false";
                String dbusername = "sql2243047";
                String dbpassword = "mJ9*fQ4%";
                conn = DriverManager.getConnection(dburl, dbusername, dbpassword);
            
            }catch(Exception e){
                System.out.println("Errore di connessione RegisterAction");
            }
            String username=null, nome=null, password=null, Tipostandard=null, TipononStandard=null, photo=null, standard="standard", nonStandard="nonStandard";    
                username=request.getParameter("username"); //txt_username
                nome=request.getParameter("nominativo"); //txt_name
                password=request.getParameter("password"); //txt_password
                Tipostandard=request.getParameter("standard"); //txt_standard
                TipononStandard=request.getParameter("nonstandard"); //txt_nonSstandard
                photo="ciao";
            try{
                PreparedStatement pstmt=null; //create statement
            
           
                pstmt=conn.prepareStatement("insert into USER(Email,Password,Nominativo,Tipo,Image) values(?,?,?,?,?)"); //sql insert query
                pstmt.setString(1,username);
                pstmt.setString(2,password);
                pstmt.setString(3,nome);
                if(Tipostandard != null) pstmt.setString(4,standard);
                else if(TipononStandard != null) pstmt.setString(4,nonStandard);
                pstmt.setString(5,photo);
                

                pstmt.executeUpdate();
                Cookie cookie = new Cookie("Nominativo", nome); cookie.setMaxAge(60*60*24); response.addCookie(cookie);
                session.setAttribute("Nominativo", nome); session.setAttribute("login", username);
                
                //request.setAttribute("successMsg","Register Successfully...! Please login"); //register success messeage
                if(Tipostandard != null) response.sendRedirect("Users/standardType.jsp");
                else if(TipononStandard != null) response.sendRedirect("Users/notStandardType.jsp");
                conn.close(); //close connection
            }catch(Exception e){
                System.out.println("Errore database RegisterAction");
                out.println(e);
            }
        %>
    </body>
</html>
