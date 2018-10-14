<%-- 
    Document   : standard
    Created on : 15-giu-2018, 17.13.06
    Author     : Roberto97
--%>

<%@page import="database.jdbc.JDBCShopListDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="database.entities.ShopList"%>
<%@page import="database.daos.ListDAO"%>
<%@page import="database.daos.UserDAO"%>
<%@page import="database.jdbc.JDBCUserDAO"%>
<%@page import="database.factories.DAOFactory"%>
<%@page import="database.entities.User"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Blob"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%

    DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
    if (daoFactory == null) {
        throw new ServletException("Impossible to get dao factory for user storage system");
    }
    UserDAO userdao = new JDBCUserDAO(daoFactory.getConnection());
    ListDAO listdao = new JDBCShopListDAO(daoFactory.getConnection());
    
    HttpSession s = (HttpSession) request.getSession();
    User u = null;
    boolean find = false;

    u = (User) s.getAttribute("user");
    if (u == null) {
        response.setHeader("Refresh", "0; URL=/Lists/homepage.jsp");

    } else {
        if (u.getTipo().equals("standard")) {
            find = true;
        }
    }

    if (find) {
        ArrayList<ShopList> li = listdao.getByEmail(u.getEmail());
        

%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="icon" href="../img/favicon.png" sizes="16x16" type="image/png">
        <title>Lists</title>

        <!-- CSS personalizzati -->
        <link href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700|Varela+Round" rel="stylesheet">
        <link rel="stylesheet" href="../bootstrap/css/bootstrap.css" type="text/css">
        <link rel="stylesheet" href="../fonts/font-awesome.css" type="text/css">
        <link rel="stylesheet" href="../css/selectize.css" type="text/css">
        <link rel="stylesheet" href="../css/style.css">
        <link rel="stylesheet" href="../css/user.css">
        <link rel="stylesheet" href="../css/navbar.css">
        <link rel="stylesheet" href="../css/datatables.css" type="text/css"> 

        <!-- Style for serch modal table-->
        <style>
            .modal-dialog{
                position: relative;
                display: table; /* This is important */ 
                overflow-y: auto;    
                overflow-x: auto;
                width: auto;
                min-width: 300px;
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

        <%            String Nominativo = "";
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
                            <img width= "50" src="../img/favicon.png" alt="Logo">
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
                                    <a class="nav-link js-scroll-trigger" href="/Lists/homepage.jsp"><i class="fa fa-home"></i><b>Home</b></a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link js-scroll-trigger" href="foreignLists.jsp"><i class="fa fa-share-alt"></i><b>Liste condivise con me</b></a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link js-scroll-trigger" href="profile.jsp">
                                        <i class="fa fa-user"></i><b>Il mio profilo</b>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link js-scroll-trigger" href="<c:url context="/Lists" value="/restricted/LogoutAction" />" data-toggle="tooltip" data-placement="bottom" title="LogOut">
                                        <i class="fa fa-sign-in"></i><b><c:out value="${user.nominativo}"/> / <c:out value="${user.tipo}"/> </b>/ <img src= "../../${user.image}" width="25px" height="25px" style="border-radius: 100%;">
                                    </a>
                                </li>                                
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
                            <img src="../img/hero-background-image-02.jpg" alt="">
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
                                    <a class="nav-link icon" href="profile.jsp">
                                        <i class="fa fa-user"></i>Il mio profilo
                                    </a>
                                    <a class="nav-link active icon" href="foreignLists.jsp">
                                        <i class="fa fa-share-alt"></i>Liste condivise
                                    </a>
                                    <a class="nav-link icon" href="/Lists/Pages/ShowProducts.jsp">
                                        <i class="fa fa-recycle"></i>Tutti i Prodotti
                                    </a>
                                    <!--<a class="nav-link icon" href="sold-items.html">
                                        <i class="fa fa-check"></i>Articoli in offerta
                                    </a>-->
                                </nav>
                            </div>
                            <!--end col-md-3-->
                            <div class="col-md-9">
                                <!--============ Section Title===================================================================-->
                                <div class="section-title clearfix">
                                    <div class="float-left float-xs-none">
                                        <a data-toggle="modal" data-target="#SearchListModal" class="btn btn-primary text-caps btn-rounded" >Search List</a>
                                    </div>
                                    <div class="float-right d-xs-none thumbnail-toggle">
                                        <a href="#" class="change-class" data-change-from-class="list" data-change-to-class="grid" data-parent-class="items">
                                            <i class="fa fa-th"></i>
                                        </a>
                                        <a href="#" class="change-class active" data-change-from-class="grid" data-change-to-class="list" data-parent-class="items">
                                            <i class="fa fa-th-list"></i>
                                        </a>
                                    </div>
                                </div>
                                <!--============ Items ==========================================================================-->
                                <div class="items list compact grid-xl-3-items grid-lg-2-items grid-md-2-items">
                                    <!--##############-->

                                    <% 
                                        for (ShopList l : li) {
                                    %>                                                                  
                                    <div class="item">
                                        <!--end ribbon-->
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
                                            <div class="price">$80</div>
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

            <!--*********************************************************************************************************-->
            <!--************ FOOTER *************************************************************************************-->
            <!--*********************************************************************************************************-->
            <footer class="footer">
                <div class="wrapper">
                    <div class="container">
                        <div class="row">
                            <div class="col-md-5">
                                <a href="#" class="brand">
                                    <img src="../img/logo.png" alt="">
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
                            <img src="../img/footer-background-icons.jpg" alt="">
                        </div>
                        <!--end background-image-->
                    </div>
                    <!--end background-->
                </div>
            </footer>
            <!--end footer-->
        </div>
        <!--end page-->

        <!--######################################################-->
        <script src="../js/jquery-3.3.1.min.js"></script>

        <script type="text/javascript" src="../js/popper.min.js"></script>
        <script type="text/javascript" src="../bootstrap/js/bootstrap.min.js"></script>
        <script type="text/javascript" src="http://maps.google.com/maps/api/js?key=AIzaSyBEDfNcQRmKQEyulDN8nGWjLYPm8s4YB58&libraries=places"></script>
        <!--<script type="text/javascript" src="http://maps.google.com/maps/api/js"></script>-->
        <script src="../js/selectize.min.js"></script>
        <script src="../js/masonry.pkgd.min.js"></script>
        <script src="../js/icheck.min.js"></script>
        <script src="../js/jquery.validate.min.js"></script>
        <script src="../js/custom.js"></script>        
        <script type="text/javascript" src="../js/datatables.js" ></script>
        <script>
            var data = [
            <c:forEach varStatus="status" items="${userLists}" var="list"  >
            [
                    "<a href=\"/Lists/restricted/ShowShopList?nome=${list.nome}\">♣</a>",
                    "<a href=\"/Lists/restricted/ShowShopList?nome=${list.nome}\">${list.nome}</a>",
                    "<a href=\"/Lists/restricted/ShowShopList?nome=${list.nome}\">${list.descrizione}</a>",
                    "<a href=\"/Lists/restricted/ShowShopList?nome=${list.nome}\">${list.creator}</a>",
                    "<a href=\"/Lists/restricted/ShowShopList?nome=${list.nome}\">${list.categoria}</a>",
            [
                <c:forEach items="${list.sharedUsers}" var="user" varStatus="userStatus">
            ' ${user.email}'
                    <c:if test="${!userStatus.last}">
            ,
                    </c:if>
                </c:forEach>
            ]

            ]<c:if test="${!status.last}">
            ,
                </c:if>
            </c:forEach>

            ];

            $(document).ready(function () {
                $('#listTable').DataTable({
                    data: data

                });
            });
        </script> 

        <!--########################## moooddaaalllll ############################-->

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
                        <form class="form clearfix" id="CreateShopListform" action="/Lists/restricted/CreateShopList"  method="post" role="form" enctype="multipart/form-data">
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

                            <div class="form-group">
                                <label for="Immagine" class="col-form-label required">Immagine</label>
                                <input type="file" name="file1" required>
                            </div>
                            <!--end form-group-->
                            <div class="d-flex justify-content-between align-items-baseline">

                                <button type="submit" name="register-submit" id="register-submit" tabindex="4" class="btn btn-primary">Crea lista</button>
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
        <!--########################## modal search ############################-->
        <div class="modal fade" id="SearchListModal" tabindex="-1" role="dialog" aria-labelledby="SearchList" aria-hidden="true" enctype="multipart/form-data">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <div class="page-title">
                            <div class="container">
                                <h1 style="text-align: center;">Search List</h1>
                            </div>
                            <!--end container-->
                        </div>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="table-responsive">
                            <table id="listTable" class="dataTable cell-border compact display order-column" width="100%">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th scope="col">Nome</th>
                                        <th scope="col">Descrizione</th>
                                        <th scope="col">Creator</th>
                                        <th scope="col">Categoria</th>
                                        <th scope="col">Shared With</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>CARICA I DATI DELLA TABELLA</td>                                          
                                    </tr>

                                </tbody>
                            </table> 
                        </div>

                    </div>
                </div>
            </div>
        </div>

        <!--########################## end modal search ############################-->
        
        <script src="../js/nav.js"></script>

    </body>
</html>

<%    } else
        response.sendRedirect("/Lists");
%>