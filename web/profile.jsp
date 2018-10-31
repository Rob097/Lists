<%-- 
    Document   : profile
    Created on : 15.10.2018, 16:49:13
    Author     : Martin
--%>

<%@page import="database.entities.User"%>
<%@page import="java.net.URLDecoder"%>

<%
    HttpSession s = (HttpSession) request.getSession();
    User u = null;
    boolean find = false;

    u = (User) s.getAttribute("user");
    if (u == null) {
        response.sendRedirect("/Lists/homepage.jsp");

    } else {
        find = true;      
        if (find) {
%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    </head>
    <body>
        <%
            String Nominativo = "";
            String Email = "";
            String Type = "";
            String image = "../../";

            //String Image = "";
            Nominativo = u.getNominativo();
            Email = u.getEmail();
            Type = u.getTipo();
            image = u.getImage();
        %>
        
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
                                    <a class="nav-link js-scroll-trigger" href="/Lists/homepage.jsp"><i class="fa fa-home"></i><b>Home</b></a>
                                </li>
                                <li class="nav-item js-scroll-trigger dropdown">
                                    <div style="cursor: pointer;" class="nav-link dropdown-toggle" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="fa fa-bars"></i><b>Liste</b></div>
                                    <div class="dropdown-menu" style="color: white;" aria-labelledby="navbarDropdown">
                                        <a class="dropdown-item nav-link" href="/Lists/userlists.jsp"><i class="fa fa-bars"></i><b>Le mie liste</b></a>
                                        <a class="dropdown-item nav-link" href="/Lists/foreignLists.jsp"><i class="fa fa-share-alt"></i><b>Liste condivise con me</b></a>                                        
                                    </div>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link js-scroll-trigger" href="<c:url context="/Lists" value="/restricted/LogoutAction" />" data-toggle="tooltip" data-placement="bottom" title="LogOut">
                                        <i class="fa fa-sign-in"></i><b><c:out value="${user.nominativo}"/> / <c:out value="${user.tipo}"/> </b>/ <img src= "${user.image}" width="25px" height="25px" style="border-radius: 100%;">
                                    </a>
                                </li>                                
                            </ul>
                        </div>
                    </nav>
                                    
                    <c:if test="${updateResult==true}">
                        <div class="alert alert-success" id="alert">
                            <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
                            <strong>Successful Modification!</strong> Your account is actualized.
                        </div>
                        <% request.getSession().setAttribute("updateResult", false); %>               
                    </c:if> 
                                    
                    <!--============ Page Title =========================================================================-->
                    <div class="page-title">
                        <div class="container" >
                            <h1>Il mio profilo</h1>
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
                            <div class="col-md-3">
                                <nav class="nav flex-column side-nav">                                   
                                    <a class="nav-link icon" href="userlists.jsp">
                                        <i class="fa fa-bars"></i>Le mie liste
                                    </a>
                                    <a class="nav-link icon" href="foreignLists.jsp">
                                        <i class="fa fa-share-alt"></i>Liste condivise
                                    </a>
                                    <c:if test="${user.tipo=='amministratore'}">
                                        <a class="nav-link icon" href="Pages/ShowProductCategories.jsp">
                                            <i class="fa fa-bookmark"></i>Tutte le categorie per prodotti
                                        </a>
                                        <a class="nav-link icon" href="Pages/ShowListCategories.jsp">
                                            <i class="fa fa-bookmark"></i>Tutte le categorie per liste
                                        </a> 
                                        <a class="nav-link icon" href="/Lists/Pages/AdminPages/adminPage.jsp">
                                            <i class="fa fa-users"></i>Lista Utenti
                                        </a>
                                    </c:if>
                                                                        
                                </nav>
                            </div>
                            <!--end col-md-3-->
                            <div class="col-md-9">
                                <form class="form clearfix" id="login-form" action="/Lists/restricted/updateUser" method="post" enctype="multipart/form-data" onsubmit="return checkCheckBoxes(this);">
                                    <div class="row">
                                        <div class="col-md-8">
                                            <h2>Personal Information</h2>
                                            <section>
                                                <div class="form-group">
                                                    <label for="email" class="col-form-label">Email</label>
                                                    <input type="email" name="email" id="email" tabindex="1" class="form-control" placeholder="Email" value="${user.email}" >
                                                </div>
                                                <div class="form-group">
                                                    <label for="password" class="col-form-label">Password</label>
                                                    <input type="password" name="password" id="password" tabindex="2" class="form-control" placeholder="Password"  value="${user.password}">
                                                </div>
                                                <div class="form-group">
                                                    <label for="nominativo" class="col-form-label">Nome</label>
                                                    <input type="text" name="nominativo" id="nominativo" tabindex="1" class="form-control" placeholder="Nome" value="${user.nominativo}" >
                                                </div>

                                                <!--end form-group-->

                                            </section>
                                            <section class="clearfix">
                                                <button type="submit" name="register-submit" id="register-submit" tabindex="4" class="btn btn-primary float-right">Save Changes</button>
                                            </section>
                                            <section class="clearfix">
                                                <button type="button" class="btn btn-dark float-right" id="delete" data-toggle="modal" data-target="#delete-modal">Delete profile</button>
                                            </section>
                                        </div>
                                        <!--end col-md-8--> 
                                        <div class="col-md-4">
                                            <div class="profile-image">
                                                <div class="image background-image">
                                                    <img src="/Lists/${user.image}" alt="">
                                                </div>
                                                <div class="single-file-input">
                                                    <input type="file" name="file1" >
                                                    <div class="btn btn-framed btn-primary small">Upload a picture</div>
                                                </div>
                                            </div>
                                        </div>
                                        <!--end col-md-3-->
                                    </div>
                                </form>

                            </div>
                        </div>
                        <!--end row-->
                    </div>
                    <!--end container-->
                </section>
                <!--end block-->
            </section>
            <!--end content-->

            <!--*********************************************************************************************************-->
            <!--************ FOOTER *************************************************************************************-->
            <!--*********************************************************************************************************-->
            <footer class="footer">
                <div class="wrapper">
                    <div class="container">
                        <div class="row">
                            <div class="col-md-5">
                                <a href="#" class="brand">
                                    <img src="Pages/img/logo.png" alt="">
                                </a>
                                <p>
                                    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut nec tincidunt arcu, sit amet
                                    fermentum sem. Class aptent taciti sociosqu ad litora torquent per conubia nostra.
                                </p>
                            </div>
                            <!--end col-md-5-->
                            <div class="col-md-3">
                                <h2>Navigation</h2>
                                <div class="row">
                                    <div class="col-md-6 col-sm-6">
                                        <nav>
                                            <ul class="list-unstyled">
                                                <li>
                                                    <a href="#">Home</a>
                                                </li>
                                                <li>
                                                    <a href="#">Listing</a>
                                                </li>
                                                <li>
                                                    <a href="#">Pages</a>
                                                </li>
                                                <li>
                                                    <a href="#">Extras</a>
                                                </li>
                                                <li>
                                                    <a href="#">Contact</a>
                                                </li>
                                                <li>
                                                    <a href="#">Submit Ad</a>
                                                </li>
                                            </ul>
                                        </nav>
                                    </div>
                                    <div class="col-md-6 col-sm-6">
                                        <nav>
                                            <ul class="list-unstyled">
                                                <li>
                                                    <a href="#">My Ads</a>
                                                </li>
                                                <li>
                                                    <a href="#">Sign In</a>
                                                </li>
                                                <li>
                                                    <a href="#">Register</a>
                                                </li>
                                            </ul>
                                        </nav>
                                    </div>
                                </div>
                            </div>
                            <!--end col-md-3-->
                            <div class="col-md-4">
                                <h2>Contact</h2>
                                <address>
                                    <figure>
                                        124 Abia Martin Drive<br>
                                        New York, NY 10011
                                    </figure>
                                    <br>
                                    <strong>Email:</strong> <a href="#">hello@example.com</a>
                                    <br>
                                    <strong>Skype: </strong> Craigs
                                    <br>
                                    <br>
                                    <a href="contact.html" class="btn btn-primary text-caps btn-framed">Contact Us</a>
                                </address>
                            </div>
                            <!--end col-md-4-->
                        </div>
                        <!--end row-->
                    </div>
                    <div class="background">
                        <div class="background-image original-size">
                            <img src="Pages/img/footer-background-icons.jpg" alt="">
                        </div>
                        <!--end background-image-->
                    </div>
                    <!--end background-->
                </div>
            </footer>
            <!--end footer-->
        </div>
        <!--end page-->



        <!--#########################################################
                                MODAL
        ##########################################################-->

        <!-- Delete Modal -->
        <div class="modal fade" id="delete-modal" tabindex="-1" role="dialog" aria-labelledby="delete-modal" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <div class="page-title">
                            <div class="container">
                                <h1>Delete user</h1>
                            </div>
                            <!--end container-->
                        </div>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <h3>Sei sicuro di voler eliminare questo utente?<br> Non potrai annullare la modifica.</h3>
                        <form class="clearfix" action="/Lists/restricted/deleteUser" method="POST">
                            <button type="submit" class="btn btn-dark" id="delete">Delete</button>
                            <button type="button" data-dismiss="modal" class="btn btn-dark" id="delete-btn-no">Cancel</button>
                        </form>

                    </div>
                </div>
            </div>
        </div>
        
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
                                </select><!--<input type="text" name="Categoria" id="Categoria" tabindex="1" class="form-control" placeholder="Categoria" value="" required>-->

                            </div>
                            <!--end form-group-->
                            <%if(find){%>
                            <div class="form-group">
                                <label for="Immagine" class="col-form-label required">Immagine</label>
                                <input type="file" name="file1" required>
                            </div>
                            <%}%>
                            <!--end form-group-->
                            <div class="d-flex justify-content-between align-items-baseline">

                                <button type="submit" name="register-submit" id="create-list-submit" tabindex="4" class="btn btn-primary">Crea lista</button>

                                <%if (find == false && session.getAttribute("guestList") != null) {%>
                                <h5>Attenzione, hai già salvato una lista. Se non sei registrato puoi salvare solo una lista alla volta. Salvando questa lista, cancellerai la lista gia salvata.</h5>
                                <%}%>
                            </div>
                        </form>
                        <hr>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
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
        <script src="Pages/js/nav.js"></script>

    </body>
</html>

<%
    } else
        response.sendRedirect("/Lists");
}
%>