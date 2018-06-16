<%-- 
    Document   : standardType
    Created on : 15-giu-2018, 17.13.06
    Author     : Roberto97
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script src="https://code.jquery.com/jquery-3.3.1.js" integrity="sha256-2Kok7MbOyxpgUVvAk/HJ2jigOSYS2auK4Pfzbm7uH60=" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js" integrity="sha384-cs/chFZiN24E4KMATLdqdvsezGxaGsi4hLGOzlXwp5UZB1LY//20VyM2taTB4QvJ" crossorigin="anonymous"></script>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4" crossorigin="anonymous">
        
        <!-- CSS personalizzati -->
        <link rel="stylesheet" type="text/css" href="css/standardUser.css">
    </head>
    <body>
        <%
            Cookie cookie = null;
            Cookie[] cookies = null;
            
            
            // Get an array of Cookies associated with the this domain
            cookies = request.getCookies();           
            String Nominativo = "";
             if( cookies != null ) {
                for (int i = 0; i < cookies.length; i++) {                       
                        cookie = cookies[i];
                        if(cookie.getName().equals("JSESSIONID"));
                        else Nominativo += cookie.getValue();
                }
            } else {
                out.println("<h2>No cookies founds</h2>");
            }
        %>
        <h1>Utente standard</h1><br>
        <p>HI <%= Nominativo %></p>
        
    </body>
</html>
