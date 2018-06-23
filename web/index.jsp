<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<% 
    Cookie cookie = null;
    Cookie[] cookies = null;
            
            
    // Get an array of Cookies associated with the this domain
    cookies = request.getCookies();
    if( cookies != null ) {
        for (int i = 0; i < cookies.length; i++) {                       
            cookie = cookies[i];
            if(cookie.getName().equals("Type") && cookie.getValue().equals("standard")){ response.sendRedirect("Pages/standardType.jsp"); System.out.println("type standard\n");}
            if(cookie.getName().equals("Type") && cookie.getValue().equals("nonStandard")){ response.sendRedirect("Pages/notStandardType.jsp"); System.out.println("type non standard \n");}
        }
    }else { response.sendRedirect("/Lists/homepage.jsp"); System.out.println("no cookies");}
    
    %> 
