<%@page import="database.entities.User"%>
<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<% 
    
    HttpSession sessione = (HttpSession) request.getSession();
    String url = "";
    String logged = (String) sessione.getAttribute("Logged");
    if(logged != null){
        if(logged.equals("on")){
            User user = (User) sessione.getAttribute("user");
            if(user.getTipo().equals("standard"))
                url = "Pages/standard/standard.jsp";
            else if(user.getTipo().equals("amministratore"))
                url = "Pages/amministratore/amministratore.jsp";
            else{
                url = "homepage.jsp";
                out.println("Errore di tipo utente");
            }
        } else{
            url = "homepage.jsp";
        }
    } else{
            url = "homepage.jsp";
        }
    if (url != "") {
        response.sendRedirect(url);
    } else {
        out.print("Errore Imprevisto");
    }
    
    %> 
