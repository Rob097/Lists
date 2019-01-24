<%-- 
    Document   : AddProductToListPage
    Created on : 15-giu-2018, 17.13.06
    Author     : Roberto97
--%>

<%@page import="database.jdbc.JDBCProductDAO"%>
<%@page import="database.daos.ProductDAO"%>
<%@page import="database.entities.Product"%>
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
        <title><c:out value="${shopListName}"/></title>

        <!-- CSS personalizzati -->
        <link href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700|Varela+Round" rel="stylesheet">
        <link rel="stylesheet" href="bootstrap/css/bootstrap.css" type="text/css">
        <link rel="stylesheet" href="fonts/font-awesome.css" type="text/css">
        <link rel="stylesheet" href="css/selectize.css" type="text/css">
        <link rel="stylesheet" href="css/style.css">
        <link rel="stylesheet" href="css/user.css">
        <link rel="stylesheet" href="css/navbar.css">
        <link rel="stylesheet" href="css/datepicker.css">
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
                background-image: url('/css/searchicon.png');
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
            .botButton {

                position: fixed;
                bottom: 1rem;
                right: 1rem;
                z-index: 1000;
            }
        </style>

    </head>
    <body>        
        <div class="page home-page">
            <header class="hero">
                <div class="hero-wrapper">
                    <div id="navbar">
                        <!-- Qui viene inclusa la navbar -->
                    </div>
                    <!--============ Page Title =========================================================================-->
                    <div class="page-title">
                        <div class="container center">
                            <div class="row center">
                                <div class="col-4">
                                    <c:if test="${not empty user}">                                
                                        <button class="btn btn-primary" data-toggle="modal" data-target="#perPro">Prodotti permanenti <i class="fa fa-line-chart"></i></button> 
                                        </c:if>                                   
                                </div>
                                <div class="col-4">
                                    <h1 class="opacity-60">
                                        Tutti i Prodotti
                                    </h1>
                                </div>
                                <div class="col-4">                                    
                                    <c:if test="${not empty user}">
                                        <button class="btn btn-dark" data-toggle="modal" data-target="#delPerPro">Cancella Prodotti permanenti <i class="fa fa-line-chart"></i></button>
                                        </c:if>                                                                      
                                </div>
                            </div>                           

                        </div>
                        <!--end container-->
                    </div>
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
                            <a href="/Lists/Pages/ShowUserList.jsp" id="backToList" class="btn btn-primary botButton social">Torna alla lista</a>
                            <!--end col-md-3-->
                            <div class="col-md-3">
                                <div class="list-group">
                                    <a href="/Lists/Pages/AddProductToListPage.jsp?cat=all" class="list-group-item">All</a>
                                    <c:forEach items="${prodCategories}" var="prodcat" >                                    
                                        <a href="/Lists/Pages/AddProductToListPage.jsp?cat=${prodcat}" class="list-group-item"><c:out value="${prodcat}"/></a>
                                    </c:forEach>
                                </div>
                            </div>
                            <div class="col-md-9">    
                                <!--============ Section Title===================================================================-->
                                <div class="section-title clearfix">
                                    <div class="float-left float-xs-none" style="width: 89%;">
                                        <input type="text" id="myInput" onkeyup="myFunction()" placeholder="Search for names.." title="Type in a name of product">
                                        <label style="display: none;" id="loadProducts1">Nessun prodotto trovato</label><br>
                                        <c:if test="${not empty user and user.tipo=='amministratore'}">

                                            <a style="display: none;" id="loadProducts2" data-toggle="modal" data-target="#CreateProductModal" class="btn btn-primary text-caps btn-rounded" >Crea un nuovo prodotto</a>

                                        </c:if>
                                        <c:if test="${not empty user and user.tipo=='standard'}">
                                            <a style="display: none;" id="loadProducts2" data-toggle="modal" data-target="#CreateAddProductModal" class="btn btn-primary text-caps btn-rounded" >Crea e aggiungi prodotto</a>
                                        </c:if>
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
                                <div class="items list compact grid-xl-3-items grid-lg-2-items grid-md-2-items">
                                    <c:choose>
                                        <c:when test="${not empty param.cat and param.cat ne 'all'}">
                                            <c:forEach items="${products}" var="product">
                                                <c:if test="${param.cat eq product.categoria_prodotto}">

                                                    <div class="item">
                                                        <!--end ribbon-->
                                                        <div class="wrapper">
                                                            <div class="image">
                                                                <h3>
                                                                    <a class="tag category"><c:out value="${product.categoria_prodotto}"/></a>
                                                                    <a class="title"><c:out value="${product.nome}"/></a>
                                                                    <span class="tag">Offer</span>
                                                                </h3>
                                                                <a class="image-wrapper background-image">
                                                                    <img src="../${product.immagine}" alt="">
                                                                </a>
                                                            </div>
                                                            <!--end image-->
                                                            <!--end admin-controls-->
                                                            <div class="description">
                                                                <p><c:out value="${product.note}"/></p>                                                                
                                                            </div>
                                                            <!--end description-->
                                                            <c:choose>
                                                                <c:when test="${not empty user}">
                                                                    <c:if test="${product.inList == false}">
                                                                        <a class="detail text-caps underline" style="cursor: pointer;" id="addButton${product.pid}" onclick="addProduct(${product.pid});">Add to your list</a>
                                                                    </c:if>
                                                                    <c:if test="${product.inList != false}">                                                       
                                                                        <a class="detail"><img src="img/correct.png" id="addIco"></a>                                                            
                                                                        </c:if>
                                                                    </c:when>
                                                                    <c:when test="${prodottiGuest != null && not empty prodottiGuest}">
                                                                        <c:set var="check" scope="page" value="false"/>
                                                                        <c:forEach items="${prodottiGuest}" var="gprod">
                                                                            <c:if test="${gprod.pid == product.pid}">
                                                                                <c:set var="check" scope="page" value="true"/>
                                                                            </c:if>
                                                                        </c:forEach>           
                                                                        <c:if test="${check == true}">
                                                                        <a class="detail"><img src="img/correct.png" id="addIco"></a>
                                                                        </c:if>
                                                                        <c:if test="${check != true}">                                                            
                                                                        <a class="detail text-caps underline" style="cursor: pointer;" id="addButton${product.pid}" onclick="addProduct(${product.pid});">Add to your list</a>
                                                                    </c:if>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <a class="detail text-caps underline" style="cursor: pointer;" id="addButton${product.pid}" onclick="addProduct(${product.pid});">Add to your list</a>
                                                                </c:otherwise> 
                                                            </c:choose>                                                        
                                                            <a class="detail"><img src="img/correct.png" id="addIco${product.pid}" class="dispNone"></a>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </c:forEach>
                                        </c:when>
                                        <c:when test="${param.cat == null or param.cat eq 'all'}">
                                            <c:set var="count" value="5" scope="page"/>
                                            <c:forEach items="${products}" var="product">
                                                <div class="item">
                                                    <!--end ribbon-->
                                                    <div class="wrapper">
                                                        <div class="image">
                                                            <h3>
                                                                <a class="tag category"><c:out value="${product.categoria_prodotto}"/></a>
                                                                <a class="title"><c:out value="${product.nome}"/></a>
                                                                <span class="tag">Offer</span>
                                                            </h3>
                                                            <a class="image-wrapper background-image" style="background-image: url('../${product.immagine}')">
                                                                <img src="../${product.immagine}" alt="">
                                                            </a>
                                                        </div>
                                                        <!--end image-->
                                                        <!--end admin-controls-->
                                                        <div class="description">
                                                            <p><c:out value="${product.note}"/></p>
                                                        </div>
                                                        <!--end description-->
                                                        <c:choose>
                                                            <c:when test="${not empty user}">
                                                                <c:if test="${product.inList == false}">
                                                                    <a class="detail text-caps underline" style="cursor: pointer;" id="addButton${product.pid}" onclick="addProduct(${product.pid});">Add to your list</a>
                                                                </c:if>
                                                                <c:if test="${product.inList != false}">
                                                                    <a class="detail"><img src="img/correct.png" id="addIco"></a> 
                                                                    </c:if>
                                                                </c:when>
                                                                <c:when test="${prodottiGuest != null && not empty prodottiGuest}">
                                                                    <c:set var="check" scope="page" value="false"/>
                                                                    <c:forEach items="${prodottiGuest}" var="gprod">
                                                                        <c:if test="${gprod.pid == product.pid}">
                                                                            <c:set var="check" scope="page" value="true"/>
                                                                        </c:if>
                                                                    </c:forEach> 
                                                                    <c:if test="${check == true}">
                                                                    <a class="detail"><img src="img/correct.png" id="addIco"></a>
                                                                    </c:if>
                                                                    <c:if test="${check != true}">                                                            
                                                                    <a class="detail text-caps underline" style="cursor: pointer;" id="addButton${product.pid}" onclick="addProduct(${product.pid});">Add to your list</a>
                                                                </c:if>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <a class="detail text-caps underline" style="cursor: pointer;" id="addButton${product.pid}" onclick="addProduct(${product.pid});">Add to your list</a>
                                                            </c:otherwise> 
                                                        </c:choose>
                                                        <a class="detail"><img src="img/correct.png" id="addIco${product.pid}" class="dispNone"></a>
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
        <script src="js/nav.js"></script>
        <script src="js/datepicker.js"></script>

        <div class="modal fade" id="myModal" role="dialog">
            <div class="modal-dialog">

                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">Modal Header</h4>
                    </div>
                    <div class="modal-body">

                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    </div>
                </div>

            </div>
        </div>

        <!--createAndAddProductModal-->
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
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <c:if test="${not empty user}">
            <!--modal per prodotti permanenti-->
            <div class="modal fade" id="perPro" tabindex="-1" role="dialog" aria-labelledby="CreateAddProductModal" aria-hidden="true" enctype="multipart/form-data">
                <div class="modal-dialog modal-dialog-centered" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <div class="page-title">
                                <div class="container">
                                    <h1 style="text-align: center;">Crea prodotti permanenti</h1>
                                </div>
                                <!--end container-->
                            </div>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <!-- Form per il login -->
                            <form class="form clearfix" id="perPro" action="/Lists/restricted/AddPeriodicProducts"  method="post" >
                                <div class="form-group">
                                    <label for="Nome" class="col-form-label">Prodotti scelti</label>
                                    <select name="choosenProducts" class="mdb-select colorful-select dropdown-primary" multiple required>     
                                        <c:forEach items="${products}" var="p">
                                            <option value="${p.pid}"><c:out value="${p.nome}"/></option> 
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-group row">
                                    <label for="example-number-input" class="col-2 col-form-label">Periodo</label>  
                                    <div class="col-12">
                                        <div class="input-group-append">
                                            <span class="input-group-text"><strong>da comprare ogni</strong></span>
                                            <input class="form-control" name="period" type="number" value="${lista.promemoria}" min="1" max="60" id="example-number-input">                                
                                            <span class="input-group-text"><strong>giorni</strong></span>
                                        </div> 
                                    </div>
                                </div>  
                                <div class="form-group">                                    
                                    <label for="Date" class="col-form-label required">Data partenza</label>
                                    <input type="date" class="" name="initday" >                            
                                </div>
                                <!--end form-group-->
                                <div class="d-flex justify-content-between align-items-baseline">
                                    <button type="submit" name="register-submit" id="create-list-submit" tabindex="4" class="btn btn-primary">Conferma prodotti periodici</button>                                
                                </div>
                            </form>
                            <hr>
                            <i>Salva prodotti che si insericono automaticamente nella lista ogni ${lista.promemoria} giorni</i>
                        </div> 
                    </div>
                </div>
            </div>
            <!--cancella prodotti permanenti-->
            <div class="modal fade" id="delPerPro" tabindex="-1" role="dialog" aria-labelledby="CreateAddProductModal" aria-hidden="true" enctype="multipart/form-data">
                <div class="modal-dialog modal-dialog-centered" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <div class="page-title">
                                <div class="container">
                                    <h1 style="text-align: center;">Cancella prodotti permanenti</h1>
                                </div>
                                <!--end container-->
                            </div>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <!-- Form per il login -->
                            <form class="form clearfix" id="perPro" action="/Lists/restricted/DeletePeriodicProducts"  method="post" >
                                <div class="form-group">
                                    <label for="Nome" class="col-form-label">Prodotti da cancellare</label>
                                    <select name="choosenProducts" class="mdb-select colorful-select dropdown-primary" multiple required>     
                                        <c:forEach items="${periodicProducts}" var="p">
                                            <option value="${p.pid}"><c:out value="${p.nome}"/></option> 
                                        </c:forEach>
                                    </select>
                                </div>                              

                                <div class="d-flex justify-content-between align-items-baseline">
                                    <button type="submit" name="register-submit" id="create-list-submit" tabindex="4" class="btn btn-dark">Cancella prodotti periodici</button>                                
                                </div>
                            </form>
                            <hr>
                            <i>Cancella prodotti che si insericono automaticamente nella lista ogni ${lista.promemoria} giorni</i>
                        </div> 
                    </div>
                </div>
            </div>
        </c:if>
        <!--Create Product Modal-->
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
                        <form class="form clearfix" id="CreateShopListform" action="/Lists/AddNewProductToDataBase"  method="post" role="form" enctype="multipart/form-data">
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
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
        <script>
        function addProduct(id) {
            //var d1 = new Date(prompt('Comprare entro: (yyyy-mm-dd)'));
            $.ajax({
                type: "GET",
                url: "/Lists/AddProductToList?prodotto=" + id,
                async: false,
                success: function () {
                    $('#addButton' + id).addClass('dispNone');
                    $('#addIco' + id).removeClass('dispNone');
                    //$('#backToList').removeClass('dispNone');
                },
                error: function () {
                    alert("Errore");
                }
            });
        }
        </script>
        <script>
            $(document).ready(function () {
                items = document.getElementsByClassName("item");
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
                items = document.getElementsByClassName("item");
                console.log(items);

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
                    console.log(items[i]);
                    console.log("inside cicle ");
                    title = items[i].getElementsByClassName("title");
                    if (title[0].innerHTML.toUpperCase().indexOf(filter) > -1) {

                        items = document.getElementsByClassName("item");
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
                if (check === true) {
                    document.getElementById("loadProducts1").style.display = "";
                    document.getElementById("loadProducts2").style.display = "";
                }
            }
        </script>
        <script type="text/javascript">
            $(document).ready(function () {
                //Navbar
                $.ajax({
                    type: "GET",
                    url: "/Lists/Pages/template/navbarTemplate.jsp",
                    cache: false,
                    success: function (response) {
                        $("#navbar").html(response);
                    },
                    error: function () {
                        alert("Errore navbarTemplate");
                    }
                });

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

    </body>
</html>