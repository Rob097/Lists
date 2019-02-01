<%-- 
    Document   : ShowProducts
    Created on : 15-giu-2018, 17.13.06
    Author     : Roberto97
--%>

<%@page import="database.jdbc.JDBCCategory_ProductDAO"%>
<%@page import="database.daos.Category_ProductDAO"%>
<%@page import="database.entities.Category_Product"%>
<%@page import="database.entities.Product"%>
<%@page import="database.jdbc.JDBCProductDAO"%>
<%@page import="database.daos.ProductDAO"%>
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
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="icon" href="img/favicon.png" sizes="16x16" type="image/png">
        <title>Products</title>

        <!-- CSS personalizzati -->
        <link href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700|Varela+Round" rel="stylesheet">
        <link rel="stylesheet" href="bootstrap/css/bootstrap.css" type="text/css">
        <link rel="stylesheet" href="fonts/font-awesome.css" type="text/css">
        <link rel="stylesheet" href="css/selectize.css" type="text/css">
        <link rel="stylesheet" href="css/style.css">
        <link rel="stylesheet" href="css/user.css">
        <link rel="stylesheet" href="css/navbar.css"> 
        <link rel="stylesheet" href="css/notificationCss.css" type="text/css"> 
        <style>

            body{
                overflow-x: unset;
            }

            .filterDiv {
                float: left;
                background-color: #2196F3;
                color: #ffffff;
                width: 100px;
                line-height: 100px;
                text-align: center;
                margin: 2px;
                display: none;
            }

            .show {
                display: block;
            }

            .container {
                margin-top: 20px;
                overflow: hidden;
            }

            /* Style the buttons */
            .btn {
                border: none;
                outline: none;
                padding: 12px 16px;
                background-color: black;
                cursor: pointer;
            }

            .btn:hover {
                background-color: #ddd;
            }

            .btn.active {
                background-color: #666;
                color: white;
            }

            .dispNone{
                display: none;
            }

            * {
                box-sizing: border-box;
            }

            #myInput {
                background-position: 10px 12px;
                background-repeat: no-repeat;
                width: 100%;
                font-size: 16px;
                padding: 12px 20px 12px 40px;
                border: 1px solid #ddd;
                margin-bottom: 12px;
            }

            #myUL {
                list-style-type: none;
                padding: 0;
                margin: 0;
            }

            #myUL li a {
                border: 1px solid #ddd;
                margin-top: -1px; /* Prevent double borders */
                background-color: #f6f6f6;
                padding: 12px;
                text-decoration: none;
                font-size: 18px;
                color: black;
                display: block
            }

            #myUL li a:hover:not(.header) {
                background-color: #eee;
            }

        </style>
        <style>
            * {
                box-sizing: border-box;
            }

            #myInput {
                background-position: 10px 12px;
                background-repeat: no-repeat;
                width: 100%;
                font-size: 16px;
                padding: 12px 20px 12px 40px;
                border: 1px solid #ddd;
                margin-bottom: 12px;
            }

            #myUL {
                list-style-type: none;
                padding: 0;
                margin: 0;
            }

            #myUL li a {
                border: 1px solid #ddd;
                margin-top: -1px; /* Prevent double borders */
                background-color: #f6f6f6;
                padding: 12px;
                text-decoration: none;
                font-size: 18px;
                color: black;
                display: block
            }

            #myUL li a:hover:not(.header) {
                background-color: #eee;
            }
        </style>

    </head>
    <body>       
        <div class="page home-page">
            <header class="hero">
                <div class="hero-wrapper">
                    <div id="navbar">
                        <c:choose>
    <c:when test="${not empty user}">
        <nav class="navbar navbar-expand-xl navbar-dark fixed-top " id="mainNav">
            <a class="navbar-brand">
                <img width= "50" src="/Lists/Pages/img/favicon.png" alt="Logo">
            </a>
            <a class="navbar-brand js-scroll-trigger" href="/Lists/homepage.jsp">LISTS</a>
            <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
                Menu
                <i class="fa fa-bars"></i>
            </button>
            <div class="collapse navbar-collapse" id="navbarResponsive">
                <ul class="navbar-nav text-uppercase ml-auto text-center">
                    <!-- La home va inclusa essendo un template, altrimenti non comparirà in nessuna pagina -->
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
                    <c:if test="${user.tipo == 'amministratore'}">
                        <li class="nav-item js-scroll-trigger dropdown">
                            <div style="cursor: pointer;" class="nav-link dropdown-toggle" id="navbarDropdown2" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="fa fa-bars"></i><b>Dashboard</b></div>
                            <div class="dropdown-menu" style="color: white;" aria-labelledby="navbarDropdown">
                                <a href="/Lists/Pages/AdminProducts.jsp" class="dropdown-item nav-link"><i class="fa fa-bars"></i><b>Lista prodotti</b></a>
                                <a href="/Lists/Pages/ShowProductCategories.jsp" class="dropdown-item nav-link"><i class="fa fa-bars"></i><b>Categorie prodotti</b></a>
                                <a href="/Lists/Pages/ShowListCategories.jsp" class="dropdown-item nav-link"><i class="fa fa-bars"></i><b>Categorie lista</b></a>                                        
                            </div>
                        </li>
                    </c:if>
                    <li class="nav-item">
                        <a class="nav-link js-scroll-trigger" href="/Lists/profile.jsp">
                            <i class="fa fa-user"></i><b>Il mio profilo</b>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link js-scroll-trigger" href="<c:url context="/Lists" value="/restricted/LogoutAction" />" data-toggle="tooltip" data-placement="bottom" title="LogOut">
                            <i class="fa fa-sign-out"></i><b><c:out value="${user.nominativo}"/> / <c:out value="${user.tipo}"/> </b>/ <img src= "/Lists/${user.image}" width="25px" height="25px" style="border-radius: 100%;">
                        </a>
                    </li>                                
                </ul>
            </div>
        </nav>
    </c:when>
    <c:otherwise>
        <nav class="navbar navbar-expand-xl navbar-dark fixed-top " id="mainNav">
            <a class="navbar-brand">
                <img width= "50" src="/Lists/Pages/img/favicon.png" alt="Logo">
            </a>
            <a class="navbar-brand js-scroll-trigger" href="/Lists/homepage.jsp">LISTS</a>
            <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation" id="navbarMenuButton">
                Menu
                <i class="fa fa-bars"></i>
            </button>
            <div class="collapse navbar-collapse" id="navbarResponsive">
                <ul class="navbar-nav text-uppercase ml-auto text-center"> 
                    <!-- La home va inclusa essendo un template, altrimenti non comparirà in nessuna pagina -->
                    <li class="nav-item">
                        <a class="nav-link js-scroll-trigger" href="/Lists/homepage.jsp"><i class="fa fa-home"></i><b>Home</b></a>
                    </li>
                    <li class="nav-item js-scroll-trigger dropdown">
                        <div style="cursor: pointer;" class="nav-link dropdown-toggle" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="fa fa-bars"></i><b>Liste</b></div>
                        <div class="dropdown-menu" style="color: white;" aria-labelledby="navbarDropdown">
                            <a class="dropdown-item nav-link" href="/Lists/userlists.jsp"><i class="fa fa-bars"></i><b>Le mie liste</b></a>
                            <a class="dropdown-item nav-link disabled" data-toggle="tooltip" title="Registrati o fai il login per usare questa funzione"><i class="fa fa-share-alt"></i><b>Liste condivise con me</b></a>                                        
                        </div>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link js-scroll-trigger" id="loginButton1" data-toggle="modal" data-target="#LoginModal" style="cursor: pointer;">
                            <i class="fa fa-sign-in"></i><b>Login</b>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link js-scroll-trigger" data-toggle="modal" data-target="#RegisterModal" style="cursor: pointer;">
                            <i class="fa fa-pencil-square-o"></i><b>Registrati</b>
                        </a>
                    </li>
                </ul>
            </div>
        </nav>
    </c:otherwise>
</c:choose>
                    </div>
                    <!--============ Page Title =========================================================================-->
                    <div class="page-title">
                        <div class="container">
                            <c:choose>
                                <c:when test="${param.cat != null and param.cat != '' and param.cat ne 'all'}">
                                    <h1 class="opacity-60 center">
                                        <c:out value="${param.cat}"/>                                    
                                    </h1>
                                </c:when>
                                <c:otherwise>
                                    <h1 class="opacity-60 center">
                                        Tutti i prodotti
                                    </h1>
                                </c:otherwise>
                            </c:choose>                            
                        </div>
                        <!--end container-->
                    </div>
                    <c:choose>
                        <c:when test="${not empty user}">
                            <c:if test="${user.tipo == 'amministratore'}">
                                <div class="container text-center" id="welcomeGrid">
                                    <a data-toggle="modal" data-target="#CreateProductModal" class="btn btn-primary text-caps btn-framed btn-block" >Aggiungi un nuovo prodotto</a>
                                </div>
                            </c:if>
                        </c:when>
                    </c:choose>
                    <!--end background-->
                </div>
                <!--end hero-wrapper-->
            </header>
            <!--end hero-->
            <!-- SISTEMA PER LE NOTIFICHE -->

            <li class="dropdown" id="notificationsLI"></li>
            <!--*********************************************************************************************************-->
            <!--************ CONTENT ************************************************************************************-->
            <!--*********************************************************************************************************-->
            <section class="content" id="prodottiBox">
                <section class="block">
                    <div class="container">
                        <div class="row">

                            <!--end col-md-3-->

                            <div class="col-md-3">
                                <div class="list-group">
                                    <a href="ShowProducts.jsp?cat=all" class="list-group-item">All</a>
                                    <c:forEach items="${prodCategories}" var="cat">
                                        <a href="ShowProducts.jsp?cat=${cat}" class="list-group-item"><c:out value="${cat}"/></a>
                                    </c:forEach>                                    
                                </div>
                            </div>
                            <div class="col-md-9">
                                <!--============ Section Title===================================================================-->
                                <div class="section-title clearfix">
                                    <div class="float-left float-xs-none" style="width: 100%;">
                                        <input type="text" id="myInput" onkeyup="myFunction()" placeholder="Search for names.." title="Type in a name of product">
                                        <label style="display: none;" id="loadProducts1">Nessun prodotto trovato</label><br>
                                        <c:if test="${not empty user and user.tipo=='amministratore'}">                                            
                                            <a style="display: none;" id="loadProducts2" data-toggle="modal" data-target="#CreateProductModal" class="btn btn-primary text-caps btn-rounded" >Crea un nuovo prodotto</a>                                            
                                        </c:if>
                                        <c:if test="${not empty user and user.tipo=='standard'}">                                            
                                            <a style="display: none;" id="loadProducts2" data-toggle="modal" data-target="#CreateAddProductModal" class="btn btn-primary text-caps btn-rounded" >Crea e aggiungi un nuovo prodotto</a>                                            
                                        </c:if>
                                    </div>
                                </div>
                                <div class="section-title clearfix">
                                    <div class="float-left float-xs-none">
                                        <label class="mr-3 align-text-bottom">Ordina per: </label>
                                        <select name="sorting" id="sorting" class="small width-200px" data-placeholder="Default">
                                            <option id="idBnt" value="0">Default</option>
                                            <option id="alphBnt" value="1">Nome</option>
                                            <option id="catBnt" value="2">Categoria</option>
                                        </select>
                                    </div>
                                    <div class="float-right d-xs-none thumbnail-toggle">
                                        <a class="change-class" data-change-from-class="list" data-change-to-class="grid" data-parent-class="items">
                                            <i class="fa fa-th"></i>
                                        </a>
                                        <a class="change-class active" data-change-from-class="grid" data-change-to-class="list" data-parent-class="items">
                                            <i class="fa fa-th-list"></i>
                                        </a>
                                    </div>
                                </div>
                                <!--============ Items ==========================================================================-->
                                <div class="items list compact grid-xl-3-items grid-lg-2-items grid-md-2-items" id="prodottiCont">
                                    <c:choose>
                                        <c:when test="${param.cat != null && param.cat ne 'all'}">
                                            <c:forEach items="${products}" var="p">
                                                <c:if test="${param.cat eq p.categoria_prodotto}">
                                                    <div class="item itemGiusto">
                                                        <!--end ribbon-->
                                                        <div class="wrapper">
                                                            <div class="image">
                                                                <h3>
                                                                    <a class="tag category"><c:out value="${p.categoria_prodotto}"/></a>
                                                                    <a class="title"><c:out value="${p.nome}"/></a>
                                                                    <input type="hidden" class="idProdotto" value="${p.pid}">
                                                                </h3>
                                                                <a class="image-wrapper background-image">
                                                                    <img src="../${p.immagine}" alt="">
                                                                </a>
                                                            </div>
                                                            <!--end image-->
                                                            <div class="price"><c:out value="ID: ${p.pid}"/></div>
                                                            <!--end admin-controls-->
                                                            <div class="description">
                                                                <p><c:out value="${p.note}"/></p>
                                                            </div>
                                                            <!--end description-->
                                                            <a class="detail text-caps underline" style="cursor: pointer;" id="addButton${p.pid}" onclick="addProduct(${p.pid});">Aggiungi ad una lista</a>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </c:forEach>
                                        </c:when>
                                        <c:when test="${param.cat == null or param.cat eq 'all'}">
                                            <c:set scope="page" var="count" value="5"/>
                                            <c:forEach  items="${products}" var="p">
                                                <div class="item itemGiusto">
                                                    <!--end ribbon-->
                                                    <div class="wrapper">
                                                        <div class="image">
                                                            <h3>
                                                                <a class="tag category"><c:out value="${p.categoria_prodotto}"/></a>
                                                                <a class="title"><c:out value="${p.nome}"/></a>
                                                                <input type="hidden" class="idProdotto" value="${p.pid}">
                                                            </h3>
                                                            <a class="image-wrapper background-image" style="background-image: url('../${p.immagine}')">                                                                
                                                                <img src="../${p.immagine}" alt="">
                                                            </a>
                                                        </div>
                                                        <!--end image-->

                                                        <div class="price"><c:out value="ID: ${p.pid}"/></div>

                                                        <!--end admin-controls-->
                                                        <div class="description">
                                                            <p><c:out value="${p.note}"/></p>
                                                        </div>
                                                        <!--end description-->
                                                        <a class="detail text-caps underline" style="cursor: pointer;" id="addButton${p.pid}" onclick="addProduct(${p.pid});">Aggiungi ad una lista</a>
                                                    </div>
                                                </div>
                                                <c:set var="count" value="${count + 1}" scope="page"/>
                                            </c:forEach>
                                        </c:when>
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

        <script src="js/jquery-3.3.1.min.js"></script>
        <script type="text/javascript" src="js/popper.min.js"></script>
        <script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>
        <script type="text/javascript" src="http://maps.google.com/maps/api/js?key=AIzaSyBEDfNcQRmKQEyulDN8nGWjLYPm8s4YB58&libraries=places"></script>
        <!--<script type="text/javascript" src="http://maps.google.com/maps/api/js"></script>-->
        <script src="js/selectize.min.js"></script>
        <script src="js/masonry.pkgd.min.js"></script>
        <script src="js/icheck.min.js"></script>
        <script src="js/jquery.validate.min.js"></script>
        <script src="js/custom.js"></script>

        <!--#########################################################
                                MODAL
        ##########################################################-->

        <!-- Login Modal -->
        <div class="modal fade" id="LoginModal" tabindex="-1" role="dialog" aria-labelledby="LoginModal" aria-hidden="true"></div>
        <!--######################################################-->

        <!-- Register Modal -->
        <div class="modal fade" id="RegisterModal" tabindex="-1" role="dialog" aria-labelledby="RegisterModal" aria-hidden="true" enctype="multipart/form-data"></div>

        <!-- restore password Modal -->
        <div class="modal fade" id="restorePassword" tabindex="-1" role="dialog" aria-labelledby="restorePassword" aria-hidden="true"></div>
        <!--######################################################-->

        <!-- new password Modal -->
        <div class="modal fade" id="newPassword" tabindex="-1" role="dialog" aria-labelledby="newPassword" aria-hidden="true"></div>
        <!--######################################################-->

        <div class="modal fade" id="CreateAddProductModal" tabindex="-1" role="dialog" aria-labelledby="CreateAddProductModal" aria-hidden="true" enctype="multipart/form-data">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <div class="page-title">
                            <div class="container">
                                <h1 style="text-align: center;">Crea un nuovo prodotto</h1>
                            </div>
                            <!--end container-->
                        </div>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <!-- Form per il login -->
                        <form class="form clearfix" id="CreateShopListform" action="<%=request.getContextPath()%>/restricted/CreateAndAddProduct"  method="post" role="form" enctype="multipart/form-data">
                            <div class="form-group">
                                <label for="Nome" class="col-form-label">Nome del prodotto</label>
                                <input type="text" name="NomeProdotto" id="Nome" tabindex="1" class="form-control" placeholder="Nome" value="" required>
                            </div>
                            <!--end form-group-->
                            <div class="form-group">
                                <label for="Descrizione" class="col-form-label">Note prodotto</label>
                                <input type="text" name="NoteProdotto" id="Descrizione" tabindex="1" class="form-control" placeholder="Descrizione" value="" required>
                            </div>
                            <!--end form-group-->
                            <div class="form-group">
                                <label for="Categoria" class="col-form-label">Categoria</label>
                                <select name="CategoriaProdotto" id="Categoria" tabindex="1" size="5" >
                                    <c:forEach items="${catProd}" var="prodcat">
                                        <option value="${prodcat.nome}"><c:out value="${prodcat.nome}"/></option> 
                                    </c:forEach>
                                </select>

                            </div>
                            <div class="form-group">
                                <label for="Date" class="col-form-label required">Data di scadenza</label>
                                <input type="date" class="" name="expiration" >
                            </div>
                            <div class="form-group">
                                <label for="Immagine" class="col-form-label required">Immagine</label>
                                <input type="file" name="ImmagineProdotto" required>
                            </div>

                            <!--end form-group-->
                            <div class="d-flex justify-content-between align-items-baseline">
                                <button type="submit" name="register-submit" id="create-list-submit" tabindex="4" class="btn btn-primary">Crea Prodotto</button>
                                <input type="hidden" name="showProduct" value="true">
                            </div>
                        </form>
                        <hr>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Chiudi</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="myModal" role="dialog">
            <div class="modal-dialog">

                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">Scegli la lista</h4>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>                        
                    </div>
                    <div class="modal-body">
                        <input type="text" id="myInput" onkeyup="myFunction()" placeholder="Search for names.." title="Type in a name">
                        <c:if test="${not empty user}">
                            <c:forEach items="${allListsOfUser}" var="listname">
                                <ul id="myUL">
                                    <li><a class="btn btn-primary" href="/Lists/AddProductToList?shopListName=${listname}"><c:out value="${listname}"/></a></li>
                                </ul>
                            </c:forEach>
                        </c:if>
                        <c:if test="${not empty guestList}">
                            <ul id="myUL">
                                <li><a href="/Lists/AddProductToList?shopListName=${guestList.nome}"><c:out value="${guestList.nome}"/></a></li> 
                            </ul> 
                        </c:if>
                    </div>
                    <div style="padding: 1rem;">
                        <a data-toggle="modal" data-target="#CreateListModal" class="btn btn-primary text-caps btn-rounded" >Crea una lista</a>
                        <button style="float: right;" type="button" class="btn btn-default" data-dismiss="modal">Chiudi</button>
                    </div>
                </div>

            </div>
        </div>
        <!--########################## moooddaaalllll ############################-->
        <c:if test="${not empty user and user.tipo=='amministratore'}">
            <div class="modal fade" id="CreateProductModal" tabindex="-1" role="dialog" aria-labelledby="CreateShopListform" aria-hidden="true" enctype="multipart/form-data">
                <div class="modal-dialog modal-dialog-centered" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <div class="page-title">
                                <div class="container">
                                    <h1 style="text-align: center;">Crea un nuovo prodotto</h1>
                                </div>
                                <!--end container-->
                            </div>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <!-- Form per il login -->
                            <form class="form clearfix" id="CreateShopListform1" action="/Lists/AddNewProductToDataBase"  method="post" role="form" enctype="multipart/form-data">
                                <div class="form-group">
                                    <label for="Nome" class="col-form-label">Nome del prodotto</label>
                                    <input type="text" name="NomeProdotto" id="NomeProduct" tabindex="1" class="form-control" placeholder="Nome" value="" required>
                                </div>
                                <!--end form-group-->
                                <div class="form-group">
                                    <label for="Descrizione" class="col-form-label">Note prodotto</label>
                                    <input type="text" name="NoteProdotto" id="DescrizioneProduct" tabindex="1" class="form-control" placeholder="Descrizione" value="" required>
                                </div>
                                <!--end form-group-->
                                <div class="form-group">
                                    <label for="Categoria" class="col-form-label">Categoria</label>
                                    <select name="CategoriaProdotto" id="CategoriaProduct" tabindex="1" size="5" >
                                        <c:forEach items="${catProd}" var="prodcat">
                                            <option value="${prodcat.nome}"><c:out value="${prodcat.nome}"/></option> 
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="Immagine" class="col-form-label required">Immagine</label>
                                    <input type="file" name="ImmagineProdotto" required>
                                </div>

                                <!--end form-group-->
                                <div class="d-flex justify-content-between align-items-baseline">
                                    <button type="submit" name="register-submit" id="create-Product-submit" tabindex="4" class="btn btn-primary">Crea Prodotto</button>
                                    <input type="hidden" name="showProduct" value="true">
                                </div>
                            </form>
                            <hr>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Chiudi</button>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>

        <!--########################## moooddaaalllll ############################-->

        <div class="modal fade" id="CreateListModal" tabindex="-1" role="dialog" aria-labelledby="CreateShopListform" aria-hidden="true" enctype="multipart/form-data"></div>
        <script type="text/javascript">
            var sort = document.getElementById("sorting");

            sort.onchange = function () {
                var divs = $(".itemGiusto");

                if (sort.value === "1") {
                    var alphabeticallyOrderedDivs = divs.sort(function (a, b) {
                        return $(a).find($(".title")).text() === $(b).find($(".title")).text() ? 0 : $(a).find($(".title")).text() < $(b).find($(".title")).text() ? -1 : 1;

                    });
                    $("#prodottiCont").html(alphabeticallyOrderedDivs);
                } else

                if (sort.value === "2") {
                    var alphabeticallyOrderedDivs = divs.sort(function (a, b) {
                        return $(a).find($(".category")).text() === $(b).find($(".category")).text() ? 0 : $(a).find($(".category")).text() < $(b).find($(".category")).text() ? -1 : 1;

                    });
                    $("#prodottiCont").html(alphabeticallyOrderedDivs);
                } else if (sort.value === "0") {
                    var alphabeticallyOrderedDivs = divs.sort((a, b) => $(a).find($(".idProdotto")).val() - $(b).find($(".idProdotto")).val());
                    $("#prodottiCont").html(alphabeticallyOrderedDivs);
                }
                ;
            };
        </script>
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
            function addProduct(id) {
                $.ajax({
                    type: "GET",
                    url: "/Lists/setPID?PID=" + id,
                    async: true,
                    success: function () {
                        $('\\#myModal').modal('show');
                    },
                    error: function () {
                        alert("Errore");
                    }
                });
            }
        </script>

        <script>
            $(document).ready(function () {
                var items = document.getElementsByClassName("itemGiusto");
                var check1 = true;
                for (i = 0; i < items.length; i++) {
                    if (items[i].style.display !== "none") {
                        check1 = false;
                    }
                }
                if (check1 === true) {
                    document.getElementById("loadProducts1").style.display = "";
                    document.getElementById("loadProducts2").style.display = "";
                }
            });
        </script>

        <script>
            function myFunction() {
                var input, filter, items, li, a, i, check = true;
                input = document.getElementById("myInput");
                filter = input.value.toUpperCase();
                items = document.getElementsByClassName("itemGiusto");

                var title = "";
                var i;
                $.ajax({
                    type: "POST",
                    url: "/Lists/Pages/nameContain.jsp?s=" + filter,

                    cache: false,
                    success: function (response) {
                        $("#content-wrapper").html($("#content-wrapper").html() + response);
                    },
                    error: function () {
                        alert("Errore");
                    }
                });
                for (i = 0; i < items.length; i++) {
                    title = items[i].getElementsByClassName("title");
                    if (title[0].innerHTML.toUpperCase().indexOf(filter) > -1) {

                        items = document.getElementsByClassName("itemGiusto");
                        title = items[i].getElementsByClassName("title");
                        items[i].style.display = "";
                        document.getElementById("loadProducts1").style.display = "none";
                        document.getElementById("loadProducts2").style.display = "none";

                    } else {
                        items[i].style.display = "none";

                    }
                    if (items[i].style.display === "")
                        check = false;
                }
                if (filter === null || filter === "") {
                    for (i = 0; i < items.length; i++) {
                        items[i].style.display = "";
                    }
                }
                if (check === true) {
                    document.getElementById("loadProducts1").style.display = "";
                    document.getElementById("loadProducts2").style.display = "";
                }
            }
        </script>

        <script>
            $(document).ready(function () {

                //LoginModal
                $.ajax({
                    type: "GET",
                    url: "/Lists/Pages/template/loginTemplate.jsp",
                    cache: false,
                    success: function (response) {
                        $("#LoginModal").html(response);
                    },
                    error: function () {
                        alert("Errore LoginModalImport");
                    }
                });

                //RegisterModal
                $.ajax({
                    type: "GET",
                    url: "/Lists/Pages/template/registerTemplate.jsp",
                    cache: false,
                    success: function (response) {
                        $("#RegisterModal").html(response);
                    },
                    error: function () {
                        alert("Errore RegisterModalImport");
                    }
                });

                //Restore password
                $.ajax({
                    type: "GET",
                    url: "/Lists/Pages/template/restorePasswordTemplate.jsp",
                    cache: false,
                    success: function (response) {
                        $("#restorePassword").html(response);
                    },
                    error: function () {
                        alert("Errore restorePasswordTemplate");
                    }
                });

                //New password
                $.ajax({
                    type: "GET",
                    url: "/Lists/Pages/template/newPasswordTemplate.jsp",
                    cache: false,
                    success: function (response) {
                        $("#newPassword").html(response);
                    },
                    error: function () {
                        alert("Errore newPasswordTemplate");
                    }
                });

                //Create List
                $.ajax({
                    type: "GET",
                    url: "/Lists/Pages/template/createListTemplate.jsp",
                    cache: false,
                    success: function (response) {
                        $("#CreateListModal").html(response);
                    },
                    error: function () {
                        alert("Errore createListTemplate");
                    }
                });

                /*Footer
                 $.ajax({
                 type: "GET",
                 url: "/Lists/Pages/template/footerTemplate.jsp",
                 cache: false,
                 success: function (response) {
                 $("footer").html(response);
                 },
                 error: function () {
                 alert("Errore footerTemplate");
                 }
                 });*/

                //Navbar
                /*$.ajax({
                    type: "GET",
                    url: "/Lists/Pages/template/navbarTemplate.jsp",
                    cache: false,
                    success: function (response) {
                        $("#navbar").html(response);
                    },
                    error: function () {
                        alert("Errore navbarTemplate");
                    }
                });*/

                //Notifiche
                $.ajax({
                    type: "GET",
                    url: "/Lists/Pages/template/notifiche.jsp",
                    cache: false,
                    success: function (response) {
                        $("#notificationsLI").html(response);
                    },
                    error: function () {
                        alert("Errore Notifiche template");
                    }
                });

            });
        </script>
        <script src="/Lists/Pages/js/nav.js"></script>
    </body>
</html>
