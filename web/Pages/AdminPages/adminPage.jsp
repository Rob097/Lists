<%-- 
    Document   : adminPage
    Created on : 21-set-2018, 15.31.34
    Author     : Dmytr
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="database.entities.User"%>
<%@page import="database.jdbc.JDBCShopListDAO"%>
<%@page import="database.jdbc.JDBCUserDAO"%>
<%@page import="database.daos.ListDAO"%>
<%@page import="database.daos.UserDAO"%>
<%@page import="database.factories.DAOFactory"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <title>Admin</title>
        
        <style>
            
            
            .avatar {
    vertical-align: middle;
    width: 50px;
    height: 50px;
    border-radius: 50%;
}
            </style>
        
    </head>
    <body>

        <%

            DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
            if (daoFactory == null) {
                throw new ServletException("Impossible to get dao factory for user storage system");
            }
            UserDAO userdao = new JDBCUserDAO(daoFactory.getConnection());

            ArrayList<User> allUsers = userdao.getAllUsers();
        %>

        <h1 style="text-align: center;">You are in Admin page</h1>
        <br>
        <div class="container">
            <%@include file="navbar.jsp"%>




            <input class="form-control" id="myInput" type="text" placeholder="Search..">
            <br>

            <table class="table table-bordered table-striped">
                <thead>
                    <tr>
                        <th>Imagine</th>
                        <th>Email</th>
                        <th>Nominativo</th>
                        <th>Tipo</th>
                        <th>Password</th>
                        <th>Options</th>
                    </tr>
                </thead>
                <tbody id="myTable">

                    <%for (User elem : allUsers) {%>

                    <tr>
                        <td><img src="../../<%=elem.getImage()%>" class="avatar"/></td>
                        <td><%=elem.getEmail()%></td>
                        <td><%=elem.getNominativo()%></td>
                        <td><%=elem.getTipo()%></td>
                        <td><%=elem.getPassword()%></td>
                        <td>
                            <button type="button" class="btn btn-default btn-sm">
                                <span class="glyphicon glyphicon-trash"></span>
                            </button>
                            
                            <button type="button" class="btn btn-default btn-sm">
                    <span class="glyphicon glyphicon-pencil"></span>
                </button>
                        </td>
                        
                      
                <%}%>

                </tbody>
            </table>

            <script>
                $(document).ready(function () {
                    $("#myInput").on("keyup", function () {
                        var value = $(this).val().toLowerCase();
                        $("#myTable tr").filter(function () {
                            $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
                        });
                    });
                });
            </script>
    </body>
</html>
