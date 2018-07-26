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
    String url = "/Lists/homepage.jsp";       
    boolean find = false; 
    // Get an array of Cookies associated with the this domain
    cookies = request.getCookies();
    if( cookies != null ) {
              
        for (int i = 0; i < cookies.length && find != true; i++) {                       
            cookie = cookies[i];
            if(cookies[i].getName().equals("Type")){
                if(cookies[i].getValue().equals("standard")){ url = "Pages/standard/standardType.jsp"; find = true;}
                else if(cookies[i].getValue().equals("amministratore")){ url = "Pages/amministratore/amministratore.jsp"; find = true;}
            }
        }
        
    }else {out.println("no cookies");}
    response.sendRedirect(url);
    
    %> 
