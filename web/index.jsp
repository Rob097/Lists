<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<html>
    <head>
        <title>WORKING with our list</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <!-- Link bootstrap -->

        <script src="https://code.jquery.com/jquery-3.3.1.js" integrity="sha256-2Kok7MbOyxpgUVvAk/HJ2jigOSYS2auK4Pfzbm7uH60=" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js" integrity="sha384-cs/chFZiN24E4KMATLdqdvsezGxaGsi4hLGOzlXwp5UZB1LY//20VyM2taTB4QvJ" crossorigin="anonymous"></script>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css" integrity="sha384-9gVQ4dYFwwWSjIDZnLEWnxCjeSWFphJiwGPXr1jddIhOegiu1FwO5qRGvFXOdJZ4" crossorigin="anonymous">
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js" integrity="sha384-uefMccjFJAIv6A+rW+L4AHf99KvxDjWSu1z9VI8SKNVmz4sk7buKt/6v9KI65qnm" crossorigin="anonymous"></script>

        <!-- CSS personalizzati -->
        <link rel="stylesheet" type="text/css" href="Users/css/Login.css">               
    </head>
    <body>
        
        <!--###############################################################################################################################
                            CONNESSIONE DATABASE
        ###############################################################################################################################-->    
        <%
            Connection conn = null;
            Statement stmt = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                String url = "jdbc:mysql://sql2.freemysqlhosting.net:3306/sql2243047?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC&autoReconnect=true&useSSL=false";
                String username = "sql2243047";
                String password = "mJ9*fQ4%";
                conn = DriverManager.getConnection(url, username, password);
                stmt = conn.createStatement();
                
            }catch (Exception e) {
                System.out.println("Causa Connessione: ");
                e.printStackTrace();
            }            
        %>
        <!--###############################################################################################################################-->
        
        
        
        
        
        
        
        
        
        <div class="container">
            <img style="top: 0%; text-align: center;" width="30%" src="Users/img/welcome.gif"><br>
            <div class="row">
                <div class="col-md-12">
                    <div class="panel panel-login">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-6 col-sm-6 col-md-6 col-lg-6 col-xl-6">
                                    <a href="#" class="active" id="login-form-link">Entra</a>
                                </div>
                                <div class="col-6 col-sm-6 col-md-6 col-lg-6 col-xl-6">
                                    <a href="#" id="register-form-link">Registrati</a>
                                </div>
                            </div>
                            <hr>
                        </div>
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-lg-12">
                                    <form id="login-form" action="LoginAction.jsp" method="post" role="form" style="display: block;">
                                        
                                        <div class="form-group">
                                            <input type="text" name="username" id="username" tabindex="1" class="form-control" placeholder="Email" value="" required>
                                        </div>
                                        <div class="form-group">
                                            <input type="password" name="password" id="password" tabindex="2" class="form-control" placeholder="Password" required>
                                        </div>
                                        
                                        <div class="form-group text-center">
                                            <input type="checkbox" tabindex="3" class="" name="standard" id="standard">
                                            <label for="standard">Standard</label>
                                            <input type="checkbox" tabindex="3" class="" name="nonstandard" id="nonstandard">
                                            <label for="non-standard">non Standard</label>
                                        </div>
                                        <div class="form-group text-center">
                                            <input type="checkbox" tabindex="3" class="" name="remember" id="remember">
                                            <label for="remember"> Remember Me</label>
                                        </div>                                        
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-sm-12">
                                                    <input type="submit" name="login-submit" id="login-submit" tabindex="4" class="form-control btn btn-login" value="Log In">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-lg-12">
                                                    <div class="text-center">
                                                        <a href="#" tabindex="5" class="forgot-password">Forgot Password?</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </form>
                                    
                                    
                                    <!-- Registration Form -->
                                    <form id="register-form" action="RegisterAction.jsp" method="post" role="form" style="display: none;">
                                        
                                        <div class="form-group">
                                            <input type="email" name="username" id="username" tabindex="1" class="form-control" placeholder="Email" value="">
                                        </div>
                                        <div class="form-group">
                                            <input type="text" name="nominativo" id="nominativo" tabindex="1" class="form-control" placeholder="Nome" value="">
                                        </div>
                                        <div class="form-group">
                                            <input type="password" name="password" id="password" tabindex="2" class="form-control" placeholder="Password">
                                        </div>
                                        <div class="form-group text-center">
                                            <input type="checkbox" tabindex="3" class="" name="standard" id="standard">
                                            <label for="standard">Standard</label>
                                            <input type="checkbox" tabindex="3" class="" name="nonstandard" id="nonstandard">
                                            <label for="non-standard">non Standard</label>
                                        </div>
                                        <div class="form-group">
                                            <div class="row">
                                                <div class="col-sm-12">
                                                    <input type="submit" name="register-submit" id="register-submit" tabindex="4" class="form-control btn btn-register" value="Register Now">
                                                </div>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <h1 style="text-align: right; bottom: 0%;">Primo Progetto</h1>
        </div>
        
        <%
                    ResultSet rs = null;
                    try {
                        String query = "select * from USER";
                        rs = stmt.executeQuery(query);
                        while (rs.next()) {
                %>
                <br><h5 style="color: red"><%=rs.getRow()%>° Record:</h5> 
                <h6>Email: <%=rs.getString("Email")%><br>
                Password: <%=rs.getString("Password")%><br>
                Nominativo: <%=rs.getString("Nominativo")%><br>
                Tipo: <%=rs.getString("Tipo")%><br></h6>
                
                 

                <%
                    }//while
                    }catch (Exception e) {
                        System.out.println("Causa Dati0 ");
                        e.printStackTrace();
                    }        
                %>
        
        
        <!--###############################################################################################################################
                            CHIUSURA DATABASE
        ###############################################################################################################################-->            
            <%
                try {
                    stmt.close();
                    conn.close();
                } catch (Exception e) {
                    System.out.println("Causa Chiusura ");
                    e.printStackTrace();
                }
            %>    
        <!--###############################################################################################################################-->
        
        <script type ="text/javascript" src ="Users/js/loginJS.js"></script>
    </body>        
</html>
