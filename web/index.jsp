<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<% 
    Cookie cookie = null;
    Cookie cookieOn = null;
    Cookie[] cookies = null;
            
            
    // Get an array of Cookies associated with the this domain
    cookies = request.getCookies();
    if( cookies != null ) {
        for (int i = 0; i < cookies.length; i++) {                       
            cookie = cookies[i];
            if(cookie.getName().equals("Logged") && cookie.getValue().equals("on")){
                for (int j = 0; j < cookies.length; j++) {
                    cookieOn = cookies[j];
                    if(cookieOn.getName().equals("Type") && cookieOn.getValue().equals("standard")){ response.sendRedirect("Pages/standardType.jsp"); break;}
                    else if(cookieOn.getName().equals("Type") && cookieOn.getValue().equals("nonStandard")){ response.sendRedirect("Pages/notStandardType.jsp"); break;}
                    else if(j == cookies.length - 1 && ((cookieOn.getName().equals("Type") && (!cookieOn.getValue().equals("standard") && !cookieOn.getValue().equals("nonStandard"))) || !cookieOn.getName().equals("Type"))) { response.sendRedirect("/Lists/homepage.jsp"); }
                } 
            }else if ( i == (cookies.length - 1 ) && ((cookie.getName().equals("Logged") && !cookie.getValue().equals("on")) || !cookie.getName().equals("Logged"))){ response.sendRedirect("/Lists/homepage.jsp"); }
        }
    }else { response.sendRedirect("/Lists/homepage.jsp");}
    
    %> 
