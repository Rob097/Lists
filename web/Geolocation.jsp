<%-- 
    Document   : userlists
    Created on : 15.10.2018, 16:08:08
    Author     : Martin
--%>

<%@page import="Notifications.Notification"%>
<%@page import="database.jdbc.JDBCShopListDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="database.entities.ShopList"%>
<%@page import="database.daos.ListDAO"%>
<%@page import="database.daos.UserDAO"%>
<%@page import="database.jdbc.JDBCUserDAO"%>
<%@page import="database.factories.DAOFactory"%>
<%@page import="database.entities.User"%>
<%@page import="java.net.URLDecoder"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    HttpSession s = (HttpSession) request.getSession(false);
    User u = null;
    ArrayList<ShopList> li = null;
    boolean find = false;
    ShopList lista = null;
    ArrayList<Notification> notifiche = null;
    
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        ListDAO listdao = new JDBCShopListDAO(daoFactory.getConnection());
        
        
    if(s.getAttribute("user") != null){
        u = (User) s.getAttribute("user");
    }
    if (u == null) {

        if (s.getAttribute("guestList") != null) {
            lista = (ShopList) s.getAttribute("guestList");
        }
    } else {
        
        li = listdao.getAllObjectListsByCurentUser(u.getEmail());
        notifiche = new ArrayList();
        if (session.getAttribute("notifiche") != null) {
            notifiche = (ArrayList<Notification>) session.getAttribute("notifiche");
        }
    }

%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="icon" href="Pages/img/favicon.png" sizes="16x16" type="image/png">
        <title>Lists</title>

        <!-- CSS personalizzati -->
        <link href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700|Varela+Round" rel="stylesheet">
        <link rel="stylesheet" href="Pages/bootstrap/css/bootstrap.css" type="text/css">
        <link rel="stylesheet" href="Pages/fonts/font-awesome.css" type="text/css">
        <link rel="stylesheet" href="Pages/css/selectize.css" type="text/css">
        <link rel="stylesheet" href="Pages/css/style.css">
        <link rel="stylesheet" href="Pages/css/user.css">
        <link rel="stylesheet" href="Pages/css/navbar.css">
        <link rel="stylesheet" href="Pages/css/datatables.css" type="text/css"> 
        
        <link rel="stylesheet" type="text/css" href="https://js.api.here.com/v3/3.0/mapsjs-ui.css?dp-version=1542186754" />
        <script type="text/javascript" src="https://js.api.here.com/v3/3.0/mapsjs-core.js"></script>
        <script type="text/javascript" src="https://js.api.here.com/v3/3.0/mapsjs-service.js"></script>
        <script type="text/javascript" src="https://js.api.here.com/v3/3.0/mapsjs-ui.js"></script>
        <script type="text/javascript" src="https://js.api.here.com/v3/3.0/mapsjs-mapevents.js"></script>
        <script type="text/javascript" src="https://js.api.here.com/v3/3.0/mapsjs-places.js"></script>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        

        <title>Lists</title>

        <!-- Style for serch modal table-->
        <style>
            .modal-dialog{
                position: relative;
                display: table; /* This is important */ 
                overflow-y: auto;    
                overflow-x: auto;
                width: auto;
                min-width: 500px;
                max-height: 530px;
            }
            .modal-body {
                position: relative;
                overflow-y: auto;
                max-height: 530px;
                padding: 15px;
            }
        </style>
        
    </head>
    <body>
        <div class="page home-page">
            <header class="hero">
                <div class="hero-wrapper">
                    <nav class="navbar navbar-expand-xl navbar-dark fixed-top " id="mainNav">
                        <a class="navbar-brand">
                            <img width= "50" src="Pages/img/favicon.png" alt="Logo">
                        </a>
                        <a class="navbar-brand js-scroll-trigger" href="#home">LISTS</a>
                        <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
                            Menu
                            <i class="fa fa-bars"></i>
                        </button>
                        <div class="collapse navbar-collapse" id="navbarResponsive">
                            <ul class="navbar-nav text-uppercase ml-auto text-center">
                                <li class="nav-item">
                                    <a data-toggle="modal" data-target="#CreateListModal" class="btn btn-primary text-caps btn-rounded" >Crea una lista</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link js-scroll-trigger"  href="/Lists/homepage.jsp"><i class="fa fa-home"></i><b>Home</b></a>
                                </li>                                
                                <c:if test="${empty user}">
                                    <li class="nav-item js-scroll-trigger dropdown">
                                        <div style="cursor: pointer;" class="nav-link dropdown-toggle" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="fa fa-bars"></i><b>Liste</b></div>
                                        <div class="dropdown-menu" style="color: white;" aria-labelledby="navbarDropdown">
                                            <a class="dropdown-item nav-link" href="#"><i class="fa fa-bars"></i><b>Le mie liste</b></a>
                                            <a class="dropdown-item nav-link disabled" data-toggle="tooltip" title="Registrati o fai il login per usare questa funzione"><i class="fa fa-share-alt"></i><b>Liste condivise con me</b></a>                                        
                                        </div>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link js-scroll-trigger" style="cursor: pointer;" data-toggle="modal" data-target="#LoginModal"><i class="fa fa-home"></i><b>Login</b></a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link js-scroll-trigger" style="cursor: pointer;" data-toggle="modal" data-target="#RegisterModal"><i class="fa fa-home"></i><b>Registrati</b></a>
                                    </li>
                                </c:if>
                                <c:if test="${not empty user}">
                                    <li class="nav-item js-scroll-trigger dropdown">
                                        <div style="cursor: pointer;" class="nav-link dropdown-toggle" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="fa fa-bars"></i><b>Liste</b></div>
                                        <div class="dropdown-menu" style="color: white;" aria-labelledby="navbarDropdown">
                                            <a class="dropdown-item nav-link" href="#"><i class="fa fa-bars"></i><b>Le mie liste</b></a>
                                            <a class="dropdown-item nav-link" href="/Lists/foreignLists.jsp"><i class="fa fa-share-alt"></i><b>Liste condivise con me</b></a>                                        
                                        </div>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link js-scroll-trigger" href="profile.jsp">
                                            <i class="fa fa-user"></i><b>Il mio profilo</b>
                                        </a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link js-scroll-trigger" href="<c:url context="/Lists" value="/restricted/LogoutAction" />" data-toggle="tooltip" data-placement="bottom" title="LogOut">
                                            <i class="fa fa-sign-in"></i><b><c:out value="${user.nominativo}"/> / <c:out value="${user.tipo}"/> </b>/ <img src= "/Lists/${user.image}" width="25px" height="25px" style="border-radius: 100%;">
                                        </a>
                                    </li>
                                </c:if>                              
                            </ul>
                        </div>
                    </nav>
                    <!--============ End Page Title =====================================================================-->  
                    <div class="page-title">
                        <div class="container">
                            <h1>Le mie liste</h1>    
                        </div>
                        <!--end container-->
                    </div>
                    <div class="background">
                        <div class="background-image">
                            <img src="Pages/img/hero-background-image-02.jpg" alt="">
                        </div>
                        <!--end background-image-->
                    </div>
                    <!--end background-->
                </div>
                <!--end hero-wrapper-->
            </header>
            <!--end hero-->
            <!--*********************************************************************************************************-->
            <!--************ CONTENT ************************************************************************************-->
            <!--*********************************************************************************************************-->
            <section class="content">
                <section class="block">
                    <div class="container">
                        <div class="row">
                            
                            <!--end col-md-3-->
                            <div class="col-md-12">
                                <div id="map" style="width: 100%; height: 400px; background: grey"></div>
                                <div class="container">
                                    
                                    <div id = "contenitore"></div>
                                    
                                    
                                       
                                    
                                    
                                    <table class="table">
                                      <thead class="thead-dark">
                                        <tr>
                                          <th>Nome</th>
                                          <th>Categoria</th>
                                          <th>Distanza</th>
                                          <th>orari</th>
                                          <th>Indirizzo</th>
                                          <th>nome lista</th>
                                        </tr>
                                      </thead>
                                      <tbody id="tabella">
                                        
                                      </tbody>
                                    </table>
                                                  
                                  </div>
                                <!--============ Section Title===================================================================-->
                                
                                <!--============ Items ==========================================================================-->
                                <div class="items list compact grid-xl-3-items grid-lg-2-items grid-md-2-items">
                                    <c:choose>         
                                        <c:when test = "${ not empty user}">  

                                            <%  
                                                for (ShopList l : li) {      
                                            %>                                                                  
                                            <div class="item">
                                               
                                                <div class="wrapper">
                                                    <div class="image">
                                                        <h3>
                                                            <a href="#" class="tag category"><%=l.getCategoria()%></a>
                                                            <a href="/Lists/ShowShopList?nome=<%=l.getNome()%>" class="title"><%=l.getNome()%></a>
                                                        </h3>
                                                        <a href="single-listing-1.html" class="image-wrapper background-image">
                                                            <img src="/Lists/<%=l.getImmagine()%>" alt="">
                                                        </a>

                                                    </div>

                                                    <!--end image-->
                                                    <div class="price"><%=listdao.getAllProductsOfShopList(l.getNome()).size()%></div>
                                                    <div class="admin-controls">
                                                        <a href="/Lists/ShowShopList?nome=<%=l.getNome()%>">
                                                            <i class="fa fa-pencil"></i>Edit
                                                        </a>
                                                        <a href="#" class="ad-hide">
                                                            <i class="fa fa-eye-slash"></i>Hide
                                                        </a>
                                                        <a href="/Lists/DeleteShopList?shopListName=<%=l.getNome()%>" class="ad-remove">
                                                            <i class="fa fa-trash"></i>Remove
                                                        </a>
                                                    </div>
                                                    <!--end admin-controls-->
                                                    <div class="description">
                                                        <p><%=l.getDescrizione()%></p>
                                                    </div>
                                                    <!--end description-->
                                                    <a href="/Lists/ShowShopList?nome=<%=l.getNome()%>" class="detail text-caps underline">Detail</a>
                                                </div>
                                            </div>                                        
                                            <!--end item-->
                                            <%}%>                                   

                                        </c:when>

                                        <c:otherwise>        
                                            <%if (lista != null && lista.getNome() != null) {%>                                                                 
                                            <div class="item">
                                                <!--end ribbon-->
                                                <div class="wrapper">
                                                    <div class="image">
                                                        <h3>
                                                            <a href="#" class="tag category"><%=lista.getCategoria()%></a>
                                                            <a href="/Lists/ShowShopList?nome=<%=lista.getNome()%>" class="title"><%=lista.getNome()%></a>
                                                        </h3>
                                                        <a href="single-listing-1.html" class="image-wrapper background-image">
                                                            <img src="/Lists/<%=lista.getImmagine()%>" alt="">
                                                        </a>
                                                    </div>
                                                    <!--end image-->
                                                    <%if(lista.getProducts() != null){%>
                                                    <div class="price"><%=lista.getProducts().size()%></div>
                                                    <%}else{%>
                                                    <div class="price">0</div>
                                                    <%}%>
                                                    <div class="admin-controls">
                                                        <a href="/Lists/restricted/ShowShopList?nome=<%=lista.getNome()%>">
                                                            <i class="fa fa-pencil"></i>Edit
                                                        </a>
                                                        <a href="#" class="ad-hide">
                                                            <i class="fa fa-eye-slash"></i>Hide
                                                        </a>
                                                        <a href="/Lists/DeleteShopList?shopListName=<%=s.getAttribute("guestList")%>" class="ad-remove">
                                                            <i class="fa fa-trash"></i>Remove
                                                        </a>
                                                    </div>
                                                    <!--end admin-controls-->
                                                    <div class="description">
                                                        <p><%=lista.getDescrizione()%></p>
                                                    </div>
                                                    <!--end description-->
                                                    <a href="/Lists/restricted/ShowShopList?nome=<%=lista.getNome()%>" class="detail text-caps underline">Detail</a>
                                                </div>
                                            </div>
                                            <!--end item-->
                                            <%} else {%>
                                            <h1>Non hai ancora creato nessuna lista</h1>
                                            <button data-toggle="modal" data-target="#import-list" class="btn btn-primary text-caps btn-rounded" >Ho una lista salvata</button>
                                            <%}%>                                        
                                        </c:otherwise>
                                    </c:choose>
                                </div>                                
                                <!--end items-->
                            </div>
                            <!--end col-md-9-->
                        </div>
                        <!--end row-->
                    </div>
                    <!--end container-->
                </section>
                <!--end block-->
            </section>
            <!--end content-->
        </div>
        <!--end page-->

        <!--######################################################-->
        <script src="Pages/js/jquery-3.3.1.min.js"></script>

        <script type="text/javascript" src="Pages/js/popper.min.js"></script>
        <script type="text/javascript" src="Pages/bootstrap/js/bootstrap.min.js"></script>
        <script type="text/javascript" src="http://maps.google.com/maps/api/js?key=AIzaSyBEDfNcQRmKQEyulDN8nGWjLYPm8s4YB58&libraries=places"></script>
        <!--<script type="text/javascript" src="http://maps.google.com/maps/api/js"></script>-->
        <script src="Pages/js/selectize.min.js"></script>
        <script src="Pages/js/masonry.pkgd.min.js"></script>
        <script src="Pages/js/icheck.min.js"></script>
        <script src="Pages/js/jquery.validate.min.js"></script>
        <script src="Pages/js/custom.js"></script>        
        <script type="text/javascript" src="Pages/js/datatables.js" ></script>
        <c:if test="${not empty user}">             
            <script>
                function myFunction() {
                    var input, filter, ul, li, a, i;
                    input = document.getElementById("myInput");
                    filter = input.value.toUpperCase();
                    ul = document.getElementById("myUL");
                    li = ul.getElementsByTagName("li");
                    for (i = 0; i < li.length; i++) {
                        a = li[i].getElementsByTagName("a")[0];
                        if (a.innerHTML.toUpperCase().indexOf(filter) > -1) {
                            li[i].style.display = "";
                        } else {
                            li[i].style.display = "none";
                        }
                    }
                }
            </script>
            <script>
                function myFunction() {
                    var input, filter, items, li, a, i;
                    input = document.getElementById("myInput");
                    filter = input.value.toUpperCase();
                    items = document.getElementsByClassName("item");
                    console.log(items);
                    
                    var title = "";
                    var i;
                    $.ajax({
                                type: "POST",
                                url: "/Lists/Pages/nameContain.jsp?s="+filter,
                                
                                cache: false,
                                success: function (response) {
                                    $("#content-wrapper").html($("#content-wrapper").html() + response);
                                },
                                error: function () {
                                   alert("Errore");
                               }
                            });
                    for (i = 0; i<items.length;i++) {
                        console.log(items[i]);
                        console.log("inside cicle ");
                        title = items[i].getElementsByClassName("title");
                        if(title[0].innerHTML.toUpperCase().indexOf(filter)>-1){
                            
                            items = document.getElementsByClassName("item");
                            title = items[i].getElementsByClassName("title");
                            items[i].style.display = "";
                            document.getElementById("loadProducts").style.display = "none";
                            
                        }else{
                            items[i].style.display = "none";
                            document.getElementById("loadProducts").style.display = "";
                        }
                    }
                }
            </script>
        </c:if>           
            
        <!-- Login Modal -->
        <div class="modal fade" id="LoginModal" tabindex="-1" role="dialog" aria-labelledby="LoginModal" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">

                        <div class="page-title">
                            <div class="container">
                                <h1>Sign In</h1>
                            </div>
                            <!--end container-->
                        </div>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>            

                    </div>
                    <div class="modal-body">
                        <c:if test="${loginResult==false}">
                            <div class="alert alert-danger">
                                <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
                                <strong>Login Failed!</strong> <br> Please try again or <a data-toggle="modal" href="#RegisterModal" class="alert-link"><u>Sign up!</u></a>

                            </div>
                        </c:if>
                        <!-- Form per il login -->
                        <form class="form clearfix" id="login-form" action="/Lists/LoginAction" method="post" role="form">
                            <div class="form-group">
                                <label for="email" class="col-form-label required">Email</label>
                                <input type="text" name="email" id="emaillogin" tabindex="1" class="form-control" placeholder="Email" value="" required>
                            </div>
                            <!--end form-group-->
                            <div class="form-group">
                                <label for="password" class="col-form-label required">Password</label>
                                <input type="password" name="password" id="passwordlogin" tabindex="2" class="form-control" placeholder="Password" required>
                            </div>
                            <!--end form-group-->
                            <div class="d-flex justify-content-between align-items-baseline">
                                <div class="form-group text-center">
                                    <label>
                                        <input type="checkbox" name="remember" value="1">
                                        Remember Me
                                    </label>
                                </div>
                                <button type="submit" class="btn btn-primary">Sign In</button>
                            </div>

                        </form>
                        <hr>
                        <p>
                            Troubles with signing? <a href="#RegisterModal" data-toggle="modal" class="link">Click here.</a>
                        </p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
        <!--######################################################-->

        <!-- Register Modal -->
        <div class="modal fade" id="RegisterModal" tabindex="-1" role="dialog" aria-labelledby="RegisterModal" aria-hidden="true" enctype="multipart/form-data">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <div class="page-title">
                            <div class="container">
                                <h1>Register</h1>
                            </div>
                            <!--end container-->
                        </div>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <!-- Form per il login -->
                        <form class="form clearfix" id="register-form" action="/Lists/RegisterAction" method="post" enctype="multipart/form-data" onsubmit="return checkCheckBoxes(this);">
                            <div class="form-group">
                                <label for="email" class="col-form-label">Email</label>
                                <input type="email" name="email" id="emailRegister" tabindex="1" class="form-control" placeholder="Email" value="" required>
                            </div>
                            <!--end form-group-->
                            <div class="form-group">
                                <label for="nominativo" class="col-form-label">Nome</label>
                                <input type="text" name="nominativo" id="nominativoRegister" tabindex="1" class="form-control" placeholder="Nome" value="" required>
                            </div>
                            <!--end form-group-->
                            <div class="form-group">
                                <label for="password" class="col-form-label">Password</label>
                                <input type="password" name="password" id="passwordRegister" tabindex="2" class="form-control" placeholder="Password" required>
                            </div>

                            <!--end form-group-->

                            <div class="form-group">
                                <label for="image" class="col-form-label required">Avatar</label>
                                <input type="file" name="file1" required>
                            </div>
                            <!--end form-group-->
                            <div class="d-flex justify-content-between align-items-baseline">
                                <div class="form-group text-center">
                                    <input type="checkbox" tabindex="3" class="" name="standard" id="standard">
                                    <label for="standard">Standard</label>
                                    <input type="checkbox" tabindex="3" class="" name="amministratore" id="amministratore">
                                    <label for="amministratore">Amministratore</label>
                                </div>
                                <button type="submit" name="register-submit" id="register-submit2" tabindex="4" class="btn btn-primary">Register Now</button>
                            </div>
                        </form>
                        <hr>
                        <p>
                            By clicking "Register Now" button, you agree with our <a href="#" class="link">Terms & Conditions.</a>
                        </p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>


        <!--######################################################-->
            
            
        <!--########################## create list modal ############################-->

        <div class="modal fade" id="CreateListModal" tabindex="-1" role="dialog" aria-labelledby="CreateShopListform" aria-hidden="true" enctype="multipart/form-data">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <div class="page-title">
                            <div class="container">
                                <h1 style="text-align: center;">Create list</h1>
                            </div>
                            <!--end container-->
                        </div>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <!-- Form per il login -->
                        <form class="form clearfix" id="CreateShopListform" action="/Lists/CreateShopList"  method="post" role="form" enctype="multipart/form-data">
                            <div class="form-group">
                                <label for="Nome" class="col-form-label">Nome della lista</label>
                                <input type="text" name="Nome" id="Nome" tabindex="1" class="form-control" placeholder="Nome" value="" required>
                            </div>
                            <!--end form-group-->
                            <div class="form-group">
                                <label for="Descrizione" class="col-form-label">Descrizione</label>
                                <input type="text" name="Descrizione" id="Descrizione" tabindex="1" class="form-control" placeholder="Descrizione" value="" required>
                            </div>
                            <!--end form-group-->
                            <div class="form-group">
                                <label for="Categoria" class="col-form-label">Categoria</label>
                                <select name="Categoria" id="Categoria" tabindex="1" size="5" >
                                    <c:forEach items="${categorie}" var="categoria">
                                        <option value="${categoria.nome}"><c:out value="${categoria.nome}"/></option> 
                                    </c:forEach>
                                </select>

                            </div>
                            <c:choose>
                                <c:when test="${not empty user}">
                                    <div class="form-group">
                                        <label for="Immagine" class="col-form-label required">Immagine</label>
                                        <input type="file" name="file1" required>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-baseline">
                                        <button type="submit" name="register-submit" id="register-submit1" tabindex="4" class="btn btn-primary">Crea lista</button>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                    </div>
                                </c:when>

                                <c:otherwise>
                                    <div class="d-flex justify-content-between align-items-baseline">
                                        <button type="submit" name="register-submit" id="create-list-submit" tabindex="4" class="btn btn-primary">Crea lista</button>
                                        <%if (session.getAttribute("guestList") != null) {%>
                                        <h5>Attenzione, hai giÃ  salvato una lista. Se non sei registrato puoi salvare solo una lista alla volta. Salvando questa lista, cancellerai la lista gia salvata.</h5>
                                        <%}%>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </form>
                        <hr>
                    </div>                    
                </div>
            </div>
        </div>
        <!--##############################-->
        <div class="modal fade" id="import-list" tabindex="-1" role="dialog" aria-labelledby="import-list" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <div class="page-title">
                            <div class="container">
                                <h1 style="text-align: center;">Importa la tua lista</h1>
                            </div>
                            <!--end container-->
                        </div>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <!-- Form per il login -->
                        <form class="form clearfix" id="ImportShopListform" action="/Lists/importGuestList"  method="get" role="form">
                            <div class="form-group">
                                <label for="Nome" class="col-form-label">Email</label>
                                <input type="email" name="creator" id="creator" tabindex="1" class="form-control" placeholder="Email" required>
                            </div>
                            <div class="form-group">
                                <label for="password" class="col-form-label">Password</label>
                                <input type="password" name="password" id="passwordGuest" tabindex="1" class="form-control" placeholder="Password" required>
                            </div>
                            <!--end form-group-->
                            <button type="submit" name="import-submit" id="import-list-submit" tabindex="4" class="btn btn-primary">Importa lista</button>
                        </form>
                        <hr>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="Pages/js/nav.js"></script>
        

        <!--MAPPA=====================================================================================================-->
                
        <script  type="text/javascript" charset="UTF-8" >

            var keyWord = "farmacia";
            //----------------------------------------------------------------------


            //---------------------------------INIT MAP---------------------------------------

            //Step 1: initialize communication with the platform
            var platform = new H.service.Platform({
                app_id: 'devportal-demo-20180625',
                app_code: '9v2BkviRwi9Ot26kp2IysQ',
                useHTTPS: true
            });
            var pixelRatio = window.devicePixelRatio || 1;
            var defaultLayers = platform.createDefaultLayers({
                tileSize: pixelRatio === 1 ? 256 : 512,
                ppi: pixelRatio === 1 ? undefined : 320
            });

            //Step 2: initialize a map  - not specificing a location will give a whole world view.
            var map = new H.Map(document.getElementById('map'), defaultLayers.normal.map, {pixelRatio: pixelRatio});

            //Step 3: make the map interactive
            // MapEvents enables the event system
            // Behavior implements default interactions for pan/zoom (also on mobile touch environments)
            var behavior = new H.mapevents.Behavior(new H.mapevents.MapEvents(map));

            // Create the default UI components
            var ui = H.ui.UI.createDefault(map, defaultLayers);

            //---------------------------------END OF INIT MAP------------------------------------

            var yourLat = 0;
            var yourLong = 0;

            /**
             * prende la posizione, la ricava dal browser
             * @returns {undefined}
             */
            function getLocation() {
                if (navigator.geolocation) {
                    navigator.geolocation.getCurrentPosition(showPosition);
                } else {
                    x.innerHTML = "Geolocation is not supported by this browser.";
                }
            }


            function showPosition(position) {
                yourLat = position.coords.latitude;
                yourLong = position.coords.longitude;
                console.log("latitude: " + yourLat);
                console.log("longitude: " + yourLong);
                var nomeLista, nomeCategoria;
                map.setCenter({lat: yourLat, lng: yourLong});
                map.setZoom(12);
                addCircleToMap(yourLat, yourLong);
                var parisMarker = new H.map.Marker({lat: yourLat, lng: yourLong});
                map.addObject(parisMarker);

                var params = {
                    'q': keyWord,
                    'at': yourLat+','+yourLong
                };
                var search = new H.places.Search(platform.getPlacesService()), searchResult, error;
                
                
                var z = 0;
                function onResult(data) {
                    z++; console.log("sto guardanado z: " + z);
                    console.log("guardo il nome della lista: " + nomeLista);
                    
                    searchResult = data;
                    console.log(searchResult);
                    console.log(searchResult.results.items[0].position);
                    
                    
                    var distanzaMassima = 1000;
                    for (var i = 0, max = 5; i < max; i++) {
                        var l = searchResult.results.items[i].position[0];
                        var la = searchResult.results.items[i].position[1];
                        var icon = new H.map.Icon(searchResult.results.items[i].icon);

                        // Create a marker using the previously instantiated icon:
                        var marker = new H.map.Marker({lat: l, lng: la}, {icon: icon});
                        var category = searchResult.results.items[i].category.title;
                        var distance = searchResult.results.items[i].distance;
                        var openingHours = searchResult.results.items[i].openingHours;
                        var vicinity = searchResult.results.items[i].vicinity;

                        var orari = "";
                        if (openingHours) {
                            orari = openingHours.text;
                            console.log(openingHours.text);
                        } else {
                            orari = "non ci sono gli orari";
                            console.log("non ci sono gli orari");
                        }
                        console.log(openingHours);
                        if(distance<=distanzaMassima){
                            document.getElementById("tabella").innerHTML += "<tr><td>" + searchResult.results.items[i].title + "</td>" + "<td>" + category + "</td>" + "<td>" + distance + "</td>" + "<td>" + orari + "</td>" + "<td>" + vicinity + "</td>"+"</tr>";
                        
                            console.log(searchResult.results.items[i].title);

                            console.log("???????????????????????????????????????????? " + nomeLista);

                            // Add the marker to the map:
                            map.addObject(marker);
                        }
                    }
                }

                //Define a callback function to handle errors:
                function onError(data) {
                    error = data;
                    console.log(error);
                }

                // Run a search request with parameters, headers (empty), and
                // callback functions:
                <%  for (ShopList l : li) {%>
                        var lsn;
                        nomeLista = '<%=l.getNome()%>';
                        lsn = '<%=l.getNome()%>';
                        nomeCategoria = '<%=l.getCategoria()%>';
                        console.log("Sto cercando per cetegoria ["+nomeCategoria+"] nella lista ["+nomeLista+"]");
                        giveAllPlaces(nomeCategoria, nomeLista);
                        
                <%}%>
                    
                    function buildDOMwithPlaces(nomeLista, nomeLocale, category, distance, orari, vicinity){
                        var msg = "Hei sei nelle vicinanze di una farmacia, dai un occhiata alla lista {NOME LISTA} e completa la spesa";
                        
                        var cardHeader = "<div id=\"accordion\">"+
                                        "<div class=\"card\">"+
                                          "<div class=\"card-header\" id=\"headingOne\">"+
                                            "<h5 class=\"mb-0\">"+
                                              "<button class=\"btn collapsed\" data-toggle=\"collapse\" data-target=\"#collapseTwo\" aria-expanded=\"false\" aria-controls=\"collapseTwo\">"+
                                                "Collapsible Group Item #1"+
                                              "</button>"+
                                            "</h5>"+
                                          "</div>"+
                                          "<div id=\"collapseTwo\" class=\"collapse\" aria-labelledby=\"headingTwo\" data-parent=\"#accordion\">"+
                                           " <div class=\"card-body\">";
                                   
                        var table = "<tr>"+
                                        "<td>" + searchResult.results.items[i].title + "</td>" + 
                                        "<td>" + category + "</td>" + 
                                        "<td>" + distance + "</td>" + 
                                        "<td>" + orari + "</td>" + 
                                        "<td>" + vicinity + "</td>"+ 
                                        "<td>" + nomeLista + "</td>"+
                                    "</tr>";
                        
                        var closeCard = "</table>"+
                                        "</div>"+
                                        "</div>"+
                                        "</div>"+
                                        "</div>";
                                
                                
                        var tableHeader = " <table class=\"table\">"+
                                      "<thead class=\"thead-dark\">"+
                                        "<tr>"+
                                          "<th>Nome</th>"+
                                          "<th>Categoria</th>"+
                                          "<th>Distanza</th>"+
                                          "<th>orari</th>"+
                                          "<th>Indirizzo</th>"+
                                          "<th>nome lista</th>"+
                                        "</tr>"+
                                      "</thead>"+
                                      "<tbody id=\"tabella\">";
                                        
                        var tableClose = "</tbody>"+
                                         "</table>";
                        
                        document.getElementById("contenitore").innerHTML+="";
                    }
                    
                    function giveAllPlaces(nomeCategoria, nomeLista){
                        $.ajax({
                        url: 'https://places.demo.api.here.com/places/v1/discover/search',
                        type: 'GET',
                        data: {
                          at: yourLat+','+yourLong,
                          q: nomeCategoria,
                          app_id: 'devportal-demo-20180625',
                          app_code: '9v2BkviRwi9Ot26kp2IysQ'
                        },
                        beforeSend: function(xhr){
                          xhr.setRequestHeader('Accept', 'application/json');
                        },
                        success: function (data) {
                          //alert(JSON.stringify(data));
                          console.log(data);
                          //alert(nomeLista);
                          
                          searchResult = data;
                    console.log(searchResult);
                    console.log(searchResult.results.items[0].position);
                    
                    var cardHeader = "<div id=\"accordion\">"+
                                        "<div class=\"card\">"+
                                          "<div class=\"card-header\" id=\"heading"+nomeLista+"\">"+
                                            "<h5 class=\"mb-0\">"+
                                              "<button class=\"btn collapsed\" data-toggle=\"collapse\" data-target=\"#collapse"+nomeLista+"\" aria-expanded=\"false\" aria-controls=\"collapse"+nomeLista+"\">"+
                                                "Collapsible Group Item #1"+
                                              "</button>"+
                                            "</h5>"+
                                          "</div>"+
                                          "<div id=\"collapse"+nomeLista+"\" class=\"collapse\" aria-labelledby=\"heading"+nomeLista+"\" data-parent=\"#accordion\">"+
                                           " <div class=\"card-body\">";
                    
                    var tableHeader = " <table class=\"table\">"+
                                      "<thead class=\"thead-dark\">"+
                                        "<tr>"+
                                          "<th>Nome</th>"+
                                          "<th>Categoria</th>"+
                                          "<th>Distanza</th>"+
                                          "<th>orari</th>"+
                                          "<th>Indirizzo</th>"+
                                          "<th>nome lista</th>"+
                                        "</tr>"+
                                      "</thead>"+
                                      "<tbody id=\""+nomeLista+"\">";
                              
                    var tableClose = "</tbody>"+
                                     "</table>";
                             
                    var closeCard = "</table>"+
                                        "</div>"+
                                        "</div>"+
                                        "</div>"+
                                        "</div>";
                                
                   var msg = "<div class=\"shadow-lg p-3 mb-5 bg-white rounded\">Hei sei nelle vicinanze di una "+nomeCategoria+", dai un occhiata alla lista "+nomeLista+" e completa la spesa</div>";
                   document.getElementById("contenitore").innerHTML += msg;
                   document.getElementById("contenitore").innerHTML += tableHeader;
                   
                    var distanzaMassima = 1000;
                    for (var i = 0, max = 5; i < max; i++) {
                        var l = searchResult.results.items[i].position[0];
                        var la = searchResult.results.items[i].position[1];
                        var icon = new H.map.Icon(searchResult.results.items[i].icon);

                        // Create a marker using the previously instantiated icon:
                        var marker = new H.map.Marker({lat: l, lng: la}, {icon: icon});
                        var category = searchResult.results.items[i].category.title;
                        var distance = searchResult.results.items[i].distance;
                        var openingHours = searchResult.results.items[i].openingHours;
                        var vicinity = searchResult.results.items[i].vicinity;

                        var orari = "";
                        if (openingHours) {
                            orari = openingHours.text;
                            console.log(openingHours.text);
                        } else {
                            orari = "non ci sono gli orari";
                            console.log("non ci sono gli orari");
                        }
                        if(distance <= distanzaMassima){
                            console.log(openingHours);

                                document.getElementById(nomeLista).innerHTML += "<tr><td>" + searchResult.results.items[i].title + "</td>" + "<td>" + category + "</td>" + "<td>" + distance + "</td>" + "<td>" + orari + "</td>" + "<td>" + vicinity + "</td>"+ "<td>" + nomeLista + "</td>"+"</tr>";

                            console.log(searchResult.results.items[i].title);

                            console.log("???????????????????????????????????????????? " + nomeLista);

                            // Add the marker to the map:
                            map.addObject(marker);
                            sendProximityEmail(${user.email}, ${user.nome}, nomeLista);
                        }
                    }
                    document.getElementById("contenitore").innerHTML +=tableClose;
                   

                        }
                    });
                    }
                    
                    
            }
            
            

            getLocation();

            function addCircleToMap(lat, lng) {
                map.addObject(new H.map.Circle(
                        // The central point of the circle
                                {lat: lat, lng: lng},
                                // The radius of the circle in meters
                                4000,
                                {
                                    style: {
                                        strokeColor: 'rgba(55, 85, 170, 0.6)', // Color of the perimeter
                                        lineWidth: 2,
                                        fillColor: 'rgba(0, 128, 0, 0.7)'  // Color of the circle
                                    }
                                }
                        ));
            }

            function addDomMarker(map, lon, lat, text) {
                var outerElement = document.createElement('div'),
                innerElement = document.createElement('div');

                outerElement.style.userSelect = 'none';
                outerElement.style.webkitUserSelect = 'none';
                outerElement.style.msUserSelect = 'none';
                outerElement.style.mozUserSelect = 'none';
                outerElement.style.cursor = 'default';

                innerElement.style.color = 'red';
                innerElement.style.backgroundColor = 'white';
                innerElement.style.border = '2px solid black';
                innerElement.style.font = 'normal 12px arial';
                innerElement.style.lineHeight = '12px';

                innerElement.style.paddingTop = '2px';
                innerElement.style.paddingLeft = '4px';
                innerElement.style.width = '20px';
                innerElement.style.height = '20px';

                // add negative margin to inner element
                // to move the anchor to center of the div
                innerElement.style.marginTop = '-10px';
                innerElement.style.marginLeft = '-10px';

                outerElement.appendChild(innerElement);

                // Add text to the DOM element
                innerElement.innerHTML = text;

                function changeOpacity(evt) {
                    evt.target.style.opacity = 0.6;
                }
                ;

                function changeOpacityToOne(evt) {
                    evt.target.style.opacity = 1;
                }
                ;

                //create dom icon and add/remove opacity listeners
                var domIcon = new H.map.DomIcon(outerElement, {
                    // the function is called every time marker enters the viewport
                    onAttach: function (clonedElement, domIcon, domMarker) {
                        clonedElement.addEventListener('mouseover', changeOpacity);
                        clonedElement.addEventListener('mouseout', changeOpacityToOne);
                    },
                    // the function is called every time marker leaves the viewport
                    onDetach: function (clonedElement, domIcon, domMarker) {
                        clonedElement.removeEventListener('mouseover', changeOpacity);
                        clonedElement.removeEventListener('mouseout', changeOpacityToOne);
                    }
                });

                // Marker for Chicago Bears home
                var bearsMarker = new H.map.DomMarker({lat: lat, lng: lon}, {
                    icon: domIcon
                });
                map.addObject(bearsMarker);
            }
            
            
            function sendProximityEmail(email, nome, lista) {
                //send email
                $.ajax({
                    type: "POST",
                    url: "/Lists/sendProximityEmail",
                    data: {email: email, nome: nome, lista: lista},
                    cache: false,
                    success: function () {
                        console.log("email sent");
                    },
                    error: function () {
                        alert("Errore sending email proximity");
                    }
                });
            };
        </script>

    </body>
</html>
