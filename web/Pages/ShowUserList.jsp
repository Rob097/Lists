<%--
    Document   : ShowUserList
    Created on : 15-giu-2018, 17.13.06
    Author     : Roberto97
--%>

<%@page import="Tools.ScheduledTask"%>
<%@page import="database.entities.Product"%>
<%@page import="database.jdbc.JDBCProductDAO"%>
<%@page import="database.daos.ProductDAO"%>
<%@page import="database.factories.DAOFactory"%>
<%@page import="java.net.URLDecoder"%>
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
        <link rel="stylesheet" href="css/datatables.css" type="text/css"> 
        <link rel="stylesheet" href="css/notificationCss.css" type="text/css"> 
        <script src="js/jquery-3.3.1.min.js"></script>
        <script type="text/javascript" src="js/popper.min.js"></script>
        <script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>


        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.2.0/css/all.css" integrity="sha384-hWVjflwFxL6sNzntih27bfxkr27PmbbK/iSvJ+a4+0owXq79v+lsFkW54bOGbiDQ" crossorigin="anonymous">
        <style>

            body{
                overflow-x: unset;
            }

            .icon-bar {
                width: 100%;
                background-color: #f2f2f2;
                overflow: auto;
                margin-bottom: 4%;
                overflow: hidden;
                text-align: center;

            }

            .icon-bar a {
                float: left;
                width: 25%;
                text-align: center;
                padding: 12px 0;
                transition: all 0.3s ease;
                color: black;
                font-size: 36px;
            }

            .icon-bar a:hover {
                background-color: red;
            }

            .active {
                background-color: black;
            }

            i {  vertical-align: middle; }
            .table-users tbody tr:hover {
                cursor: pointer;
                background-color: #eee;
            }
            .nav-user-photo {
                vertical-align: middle;
            }
            .user_panel {
                width: 50%;
            }
            .actualRole{
                font-weight: bold;
                font-style: italic;
            }
            #alert{
                position: fixed;
                z-index: 10000;
                max-width: -webkit-fill-available;
                width: -webkit-fill-available;
                width: -moz-available;
                max-width: -moz-available;
                bottom: 0;
            }
            .alert{
                position: relative;
                padding: 1.75rem 1.25rem;
                margin-bottom: 0;
                border: 1px solid transparent;
                border-radius: 0.25rem;
            }
            .items:not(.selectize-input).list .item.itemAcquistato{
                background-image: linear-gradient(to left, #808080d6 0%, #80808033 50%, #808080d6 100%);
                color: black;
                font-style: italic;
                font-size: -webkit-xxx-large;
                font-weight: bold; 
            }
            .items:not(.selectize-input).grid .item.itemAcquistato{
                background-image: linear-gradient(to left, #808080d6 0%, #80808033 50%, #808080d6 100%);
                color: black;
                font-style: italic;
                font-size: -webkit-xxx-large;
                font-weight: bold; 
            }
            .overlayAcquistato{
                display: -webkit-box;
                width: -webkit-fill-available;
                text-align: center;
                display: -ms-flexbox;
                display: flex;
                -webkit-box-align: center;
                -ms-flex-align: center;
                align-items: center;
                min-height: calc(100% - (0.5rem * 2));
                position: absolute;
            }
            .items:not(.selectize-input).grid .item .pAcquistato{
                margin-top: unset;
                margin-bottom: unset;
                width: -webkit-fill-available;
                opacity: 1;
                margin-left: -35px;
                height: auto !important;
            }
            .pAcquistato{
                margin-top: unset;
                margin-bottom: unset;
                width: -webkit-fill-available;
                opacity: 1;
            }
            .wrapperProva{
                z-index: -1;
            }
            .invisible{
                display: none;
            }
            /* Always set the map height explicitly to define the size of the div
             * element that contains the map. */
            #map {
                height: 30em;
                width: 100%;
            }
            .hero-wrapper{
                background-image: linear-gradient(rgba(255,255,255,.4), rgba(255,255,255,.9)),url("/Lists/${lista.immagine}");
                background-position-y: center;
                background-size: cover;
                background-repeat: no-repeat;
            }
            @-moz-document url-prefix() {
                .firefoxVisible{
                    display: unset !important;
                }
            }
            /* Optional: Makes the sample page fill the window. */
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
                    <!-- La home va inclusa essendo un template, altrimenti non comparir� in nessuna pagina -->
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
                    <!-- La home va inclusa essendo un template, altrimenti non comparir� in nessuna pagina -->
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
                            <h1 class="center">
                                <c:out value="${shopListName}"/>                                
                            </h1>                            
                            <p class="text-center" style="opacity: 1;">
                                <c:if test="${lista != null}">
                                    <c:out value="${lista.descrizione}"/>
                                </c:if>
                                <c:if test="${guestList != null}">
                                    <c:out value="${guestList.descrizione}"/>
                                </c:if>
                            </p>

                        </div>
                    </div>
                    <c:if test="${user != null}">
                        <div class="container text-center" id="welcomeGrid">
                            <a data-toggle="modal" data-target="#CreateAddProductModal" class="btn btn-primary text-caps btn-framed btn-block">Crea e aggiungi prodotto</a>
                        </div>
                    </c:if>
                    <!--============ End Page Title =====================================================================-->


                    <!--<div id="map"></div>-->
                </div>
            </header>
            <!-- SISTEMA PER LE NOTIFICHE -->

            <li class="dropdown" id="notificationsLI"></li>

            <c:if test="${role != null}">
                <div class="container pt-5" id="alert">
                    <c:if test="${role ne 'same'}">
                        <div class="alert alert-success text-center" role="alert">
                            <strong>Permessi</strong> di <c:out value="${role}"/> aggiornati correttamente.</a>.
                        </div> 
                        <c:set var="role" value="same"/>
                    </c:if> 
                </div>
            </c:if>

            <!--*********************************************************************************************************-->
            <!--************ CONTENT ************************************************************************************-->
            <!--*********************************************************************************************************-->
            <section class="content">
                <section class="block">
                    <div class="container">                        
                        <div class="icon-bar">

                            <c:choose>
                                <c:when test="${(not empty user)}">
                                    <c:set var = "ruolo" value="${user.ruolo}"/>
                                    <c:choose>
                                        <c:when test="${(ruolo eq 'creator')}">
                                            <div class="row">
                                                <div class="col-xl-4 col-lg-4 col-md-4 col-sm-6 col-6">
                                                    <a href="AddProductToListPage.jsp" style="cursor: pointer; width: 100%;"><i class="fas fa-plus"> <br>Aggiungi prodotto</i></a> 
                                                </div>
                                                <div class="col-xl-4 col-lg-4 col-md-4 col-sm-6 col-6">
                                                    <a href="ThirdChatroom.jsp" style="cursor: pointer; width: 100%;"><i class="fas fa-users"><br>Chat</i></a> 
                                                </div>
                                                <div class="col-xl-4 col-lg-4 col-md-4 col-sm-12 col-12">
                                                    <a href="singleListGeolocation.jsp" style="cursor: pointer; width: 100%;"><i class="fas fa-map-marked-alt"><br>Map</i></a> 
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xl-6 col-lg-6 col-md-6 col-sm-6 col-6">
                                                    <a style="cursor: pointer; width: 100%;" data-toggle="modal" data-target="#ShareListModal"><i class="fa fa-globe"><br>Condividi</i></a>
                                                </div>
                                                <div class="col-xl-6 col-lg-6 col-md-6 col-sm-6 col-6">
                                                    <a style="cursor: pointer; width: 100%;" data-toggle="modal" data-target="#delete-modal"><i class="fa fa-trash"><br>Elimina</i></a>
                                                </div>
                                            </div>
                                        </c:when>
                                        <c:when test="${(ruolo eq 'Write')}">
                                            <div class="row">
                                                <div class="col-xl-4 col-lg-4 col-md-4 col-sm-6 col-6">
                                                    <a href="AddProductToListPage.jsp" style="cursor: pointer; width: 100%;"><i class="fas fa-plus"> <br>Aggiungi prodotto</i></a> 
                                                </div>
                                                <div class="col-xl-4 col-lg-4 col-md-4 col-sm-6 col-6">
                                                    <a href="ThirdChatroom.jsp" style="cursor: pointer; width: 100%;"><i class="fas fa-users"><br>Chat</i></a> 
                                                </div>
                                                <div class="col-xl-4 col-lg-4 col-md-4 col-sm-12 col-12">
                                                    <a href="singleListGeolocation.jsp" style="cursor: pointer; width: 100%;"><i class="fas fa-map-marked-alt"><br>Map</i></a> 
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xl-6 col-lg-6 col-md-6 col-sm-6 col-6">
                                                    <a style="cursor: pointer; width: 100%;"data-toggle="modal" data-target="#ShareListModal"><i class="fa fa-globe"><br>Condividi</i></a>
                                                </div>
                                                <div class="col-xl-6 col-lg-6 col-md-6 col-sm-6 col-6">
                                                    <a style="cursor: pointer; width: 100%;" data-toggle="modal" data-target="#delete-modal"><i class="fa fa-trash"><br>Elimina</i></a>
                                                </div>
                                            </div>
                                        </c:when>
                                        <c:when test="${(ruolo == 'Read')}">
                                            <div class="row">
                                                <div class="col-xl-4 col-lg-4 col-md-4 col-sm-6 col-6">
                                                    <a style="cursor: pointer; width: 100%;" href="AddProductToListPage.jsp"><i class="fas fa-plus"> <br>Aggiungi prodotto</i></a> 
                                                </div>
                                                <div class="col-xl-4 col-lg-4 col-md-4 col-sm-6 col-6">
                                                    <a style="cursor: pointer; width: 100%;" href="ThirdChatroom.jsp"><i class="fas fa-users"><br>Chat</i></a>
                                                </div>
                                                <div class="col-xl-4 col-lg-4 col-md-4 col-sm-12 col-12">
                                                    <a href="singleListGeolocation.jsp" style="cursor: pointer; width: 100%;"><i class="fas fa-map-marked-alt"><br>Map</i></a> 
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-xl-6 col-lg-6 col-md-6 col-sm-6 col-6">
                                                    <a style="cursor: not-allowed; width: 100%;" data-toggle="tooltip" title="Non hai i permessi perr condividere la lista. Contatta ${lista.creator}" class="disabled"><i class="fa fa-globe"><br>Condividi</i></a>
                                                </div>
                                                <div class="col-xl-6 col-lg-6 col-md-6 col-sm-6 col-6">
                                                    <a style="cursor: not-allowed; width: 100%;" data-toggle="tooltip" title="Non hai i permessi perr cancellare la lista. Contatta ${lista.creator}" class="disabled"><i class="fa fa-trash"><br>Elimina</i></a>
                                                </div>
                                            </div>
                                        </c:when>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <div class="row">
                                        <div class="col-xl-4 col-lg-4 col-md-4 col-sm-6 col-6">
                                            <a style="cursor: pointer; width: 100%;" href="AddProductToListPage.jsp"><i class="fas fa-plus"> <br>Aggiungi prodotto</i></a> 
                                        </div>
                                        <div class="col-xl-4 col-lg-4 col-md-4 col-sm-6 col-6">
                                            <a style="cursor: not-allowed; width: 100%;" data-toggle="tooltip" title="Devi registrarti per usare questa funzione" class="disabled"><i class="fas fa-users"><br>Chat</i></a> 
                                        </div>
                                        <div class="col-xl-4 col-lg-4 col-md-4 col-sm-12 col-12">
                                            <a href="singleListGeolocation.jsp" style="width: 100%;"><i class="fas fa-map-marked-alt"><br>Map</i></a> 
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-xl-6 col-lg-6 col-md-6 col-sm-6 col-6">
                                            <a style="cursor: not-allowed; width: 100%;" data-toggle="tooltip" title="Devi registrarti per usare questa funzione" class="disabled"><i class="fa fa-globe"><br>Condividi</i></a>
                                        </div>
                                        <div class="col-xl-6 col-lg-6 col-md-6 col-sm-6 col-6">
                                            <a style="cursor: pointer; width: 100%;" data-toggle="modal" data-target="#delete-modal"><i class="fa fa-trash"><br>Elimina</i></a> 
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>                                    
                        </div>                    
                        <hr>
                        <div class="row">
                            <!--end col-md-3-->
                            <div class="col-md-9">

                                <!--============ Section Title===================================================================-->
                                <div class="section-title clearfix">
                                    <c:if test="${listProducts != null }">
                                        <form class="float-left" method="POST" action="/Lists/removeALLProducts">
                                            <input style="margin-left: 10px; margin-bottom: 10px;" type="submit" class="btn btn-primary" value="Svuota la lista">
                                        </form>
                                        <form class="float-left" method="POST" action="/Lists/statusALLProducts" id="justRestart">
                                            <input type="submit" class="btn btn-dark" style="margin-left: 10px; margin-bottom: 10px;" value="Ricomincia spesa">
                                            <input type="hidden" value="daAcquistare" name="tipo">
                                        </form>
                                        <form class="float-left" method="POST" action="/Lists/statusALLProducts" id="Finish">
                                            <input type="submit" class="btn btn-dark" style="margin-left: 10px;" value="Spesa finita">
                                            <input type="hidden" value="acquistato" name="tipo">
                                        </form>
                                    </c:if> 
                                    <div class="float-right d-xs-none thumbnail-toggle">
                                        <a href="#" class="change-class" data-change-from-class="list" data-change-to-class="grid" data-parent-class="items">
                                            <i class="fa fa-th"></i>
                                        </a>
                                        <a href="#" class="change-class active" data-change-from-class="grid" data-change-to-class="list" data-parent-class="items">
                                            <i class="fa fa-th-list"></i>
                                        </a>
                                    </div>
                                </div>
                                <c:choose>
                                    <c:when test="${(ruolo eq 'creator')}">
                                        <div class="pb-5">                                    
                                            <h4>Promemoria di default: <i class="pl-3 fa fa-info" data-toggle="tooltip" data-placement="right" title="Tutti i prodotti aggiunti a questa lista avranno un promemoria di default impostato a ${lista.promemoria} giorni. Questo valore � modificabile."></i></h4>
                                            <div style="display: flex;">
                                                <input class="form-control" style="width: 4rem; height: 2rem; padding-left: 0; padding-right: 0;" type="number" onchange="defaultChange();" value="${lista.promemoria}" id="defaultReminder">
                                                <label class="firefoxVisible" style="margin-left: 10px; display:none;">${lista.promemoria} <c:if test="${lista.promemoria == 1}"> giorno</c:if><c:if test="${lista.promemoria > 1}"> giorni</c:if> </label>
                                                <a style="display: none;" class="firefoxVisible" href="#" onclick="location.reload();"><i style="vertical-align: sub;" class="pl-3 fa fa-refresh"></i></a>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:when test="${(ruolo eq 'Write')}">
                                        <div class="pb-5">                                    
                                            <h4>Promemoria di default: <i class="pl-3 fa fa-info" data-toggle="tooltip" data-placement="right" title="Tutti i prodotti aggiunti a questa lista avranno un promemoria di default impostato a ${lista.promemoria} giorni. Questo valore � modificabile."></i></h4>
                                            <div style="display: flex;">
                                                <input class="form-control" style="width: 4rem; height: 2rem; padding-left: 0; padding-right: 0;" type="number" onchange="defaultChange();" value="${lista.promemoria}" id="defaultReminder">
                                                <label class="firefoxVisible" style="margin-left: 10px; display:none;">${lista.promemoria} <c:if test="${lista.promemoria == 1}"> giorno</c:if><c:if test="${lista.promemoria > 1}"> giorni</c:if> </label>
                                                <a style="display: none;" class="firefoxVisible" href="#" onclick="location.reload();"><i style="vertical-align: sub;" class="pl-3 fa fa-refresh"></i></a>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:when test="${(ruolo == 'Read')}">
                                        <div class="pb-5">                                    
                                            <h4>Promemoria di default: <i class="pl-3 fa fa-info" data-toggle="tooltip" data-placement="right" title="Non hai i permessi per modificare questo valore."></i></h4>
                                            <div style="display: flex;">
                                                <input class="form-control" style="width: 4rem; height: 2rem; padding-left: 0; padding-right: 0; cursor: not-allowed;" type="number" value="${lista.promemoria}" id="defaultReminder2" disabled>
                                                <label class="firefoxVisible" style="margin-left: 10px; display:none;">${lista.promemoria} <c:if test="${lista.promemoria == 1}"> giorno</c:if><c:if test="${lista.promemoria > 1}"> giorni</c:if> </label>
                                                <a style="display: none;" class="firefoxVisible" href="#" onclick="location.reload();"><i style="vertical-align: sub;" class="pl-3 fa fa-refresh"></i></a>
                                            </div>
                                        </div>
                                    </c:when>
                                </c:choose>
                                <!--============ Items ==========================================================================-->                               
                                <div class="items list compact grid-xl-3-items grid-lg-2-items grid-md-2-items">
                                    <c:if test="${listProducts != null}">
                                        <c:forEach items="${listProducts}" var="prod">
                                            <c:if test="${prod.status eq 'acquistato'}">
                                                <div class="item itemAcquistato" id="item${prod.pid}">
                                                    <div class="overlayAcquistato" id="divProva${prod.pid}">
                                                        <p class="pAcquistato" id="pProva${prod.pid}">Gi� acquistato<br><a onclick="daAcquistareItem(${prod.pid})" type="button" class="btn btn-dark" style="color: white;">Annulla</a></p>                                            
                                                    </div>
                                                    <!--end ribbon-->
                                                    <div class="wrapper wrapperProva" id="wrapperProva${prod.pid}"> 
                                                    </c:if>
                                                    <c:if test="${prod.status ne 'acquistato'}">
                                                        <div class="item" id="item${prod.pid}">
                                                            <div class="invisible" id="divProva${prod.pid}">
                                                                <p id="pProva${prod.pid}">Gi� acquistato<br><a onclick="daAcquistareItem(${prod.pid})" type="button" class="btn btn-dark" style="color: white;">Annulla</a></p>
                                                            </div>
                                                            <!--end ribbon-->
                                                            <div class="wrapper" id="wrapperProva${prod.pid}">
                                                            </c:if>
                                                            <div class="image">
                                                                <h3>
                                                                    <a href="/Lists/Pages/ShowProducts.jsp?cat=${prod.categoria_prodotto}" class="tag category"><c:out value="${prod.categoria_prodotto}"/></a>
                                                                    <a class="title"><c:out value="${prod.nome}"/></a>
                                                                </h3>
                                                                <a class="image-wrapper background-image">
                                                                    <img src="../${prod.immagine}" alt="">                                                            
                                                                </a>
                                                            </div>
                                                            <c:choose>
                                                                <c:when test="${user != null}"> 
                                                                    <h4>                                                       
                                                                        <a>
                                                                             <c:choose>
                                                                                <c:when test="${ruolo eq 'Read'}"> 
                                                                                    <i style="color: black;" class="fa fa-calendar" data-toggle="tooltip" data-placement="bottom" title="Non hai i permessi per cambiare questo valore. Contatta ${lista.creator}"></i>
                                                                                    <input style="background-color: transparent; cursor: not-allowed; width: fit-content;" type="date" ata-toggle="tooltip" data-placement="bottom" title="Non hai i permessi per cambiare questo valore. Contatta ${lista.creator}" class="border border-primary rounded disabled" value="${prod.data_scadenza}" id="Disabled-Reminder-${prod.pid}-${shopListName}">
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <i style="color: black;" class="fa fa-calendar" data-toggle="tooltip" data-placement="bottom" title="Promemoria di acquisto di ${prod.nome}"></i>
                                                                                    <input style="background-color: transparent; cursor: pointer; width: fit-content;" type="date" onchange="changeReminder(${prod.pid}, '${shopListName}');" class="border border-primary rounded" value="${prod.data_scadenza}" id="Reminder-${prod.pid}">
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </a>
                                                                    </h4>
                                                                    <input id="${prod.pid}Quantity" class="price" onchange="updateQuantity(${prod.pid});" style="width: 4rem; height: 2rem; padding-left: 0; padding-right: 0;" type="number" name="quantity" min="1" max="99" value="${prod.quantity}"></input>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <input id="${prod.pid}Quantity" class="price" onchange="updateQuantity(${prod.pid}, 'guest');" style="width: 4rem; height: 2rem; padding-left: 0; padding-right: 0;" type="number" name="quantity" min="1" max="99" value="${prod.quantity}"></input>
                                                                </c:otherwise>
                                                            </c:choose>
                                                            <div class="admin-controls">
                                                                <a style="cursor: pointer;" onclick="giaAcquistatoItem(${prod.pid})">
                                                                    <i class="fas fa-shopping-cart"></i>Acquistato
                                                                </a>
                                                                <a onclick="removeItem('${prod.pid}');" style="cursor: pointer;" class="ad-remove">
                                                                    <i class="fa fa-trash"></i>Cancella
                                                                </a>
                                                                <c:choose>
                                                                    <c:when test="${user != null}"> 
                                                                        <a class="reminderInvisible">
                                                                            <c:choose>
                                                                                <c:when test="${ruolo eq 'Read'}"> 
                                                                                    <i style="color: black;" class="fa fa-calendar" data-toggle="tooltip" data-placement="bottom" title="Non hai i permessi per cambiare questo valore. Contatta ${lista.creator}"></i>
                                                                                    <input style="background-color: transparent; cursor: not-allowed; width: fit-content;" type="date" ata-toggle="tooltip" data-placement="bottom" title="Non hai i permessi per cambiare questo valore. Contatta ${lista.creator}" class="border border-primary rounded disabled" value="${prod.data_scadenza}" id="Disabled-Reminder-${prod.pid}-${shopListName}">
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <i style="color: black;" class="fa fa-calendar" data-toggle="tooltip" data-placement="bottom" title="Promemoria di acquisto di ${prod.nome}"></i>
                                                                                    <input style="background-color: transparent; cursor: pointer; width: fit-content;" type="date" onchange="changeReminder(${prod.pid}, '${shopListName}');" class="border border-primary rounded" value="${prod.data_scadenza}" id="Reminder-${prod.pid}">
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </a>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                            <!--end admin-controls-->
                                                            <div class="description">
                                                                <p><c:out value="${prod.note}"/></p>
                                                            </div>
                                                            <!--end description-->
                                                            <!--<a href="single-listing-1.html" class="detail text-caps underline">Detail</a>-->
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </c:if> 
                                        </div>
                                        <!--end items-->
                                    </div>

                                    <c:if test="${user != null}">                            
                                        <div class = "col-md-3">
                                            <div class="panel-body">
                                                <div class="table-container" style="width: -webkit-fill-available; min-width: fit-content;">                                        
                                                    <table class="table-users table" border="0">
                                                        <thead>
                                                            <c:if test="${user.email == lista.creator}">
                                                            <button style="width: -webkit-fill-available;" type="button" class="btn btn-primary btn-block" data-toggle="modal" data-target="#ShareListModal" <c:if test="${empty Users}">disabled</c:if>>Share List</button>
                                                        </c:if> 
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach items="${sharedUsers}" var="u">
                                                                <c:set var = "shareUserRole" value="${u.ruolo}"/>
                                                                <tr>
                                                                    <td width="10" align="center">
                                                                        <i class="fa fa-2x fa-user fw"></i>
                                                                    </td>
                                                                    <td>
                                                                        <c:out value="${u.nominativo}" /><br>
                                                                    </td>
                                                                    <td>

                                                                        <c:choose>
                                                                            <c:when test="${(ruolo eq 'creator')}">
                                                                                <div class="btn-group dropleft" style="width: -webkit-fill-available;">
                                                                                    <a class="dropdown-toggle" style="background-color: red; padding: 4px; border-radius: 10%; color: white; width: -webkit-fill-available; text-align: center; min-width: max-content;" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                                                        <c:out value="${shareUserRole}"/>
                                                                                    </a>
                                                                                    <div class="dropdown-menu">
                                                                                        <c:if test = "${shareUserRole eq 'Read'}">
                                                                                            <a class="dropdown-item actualRole" href="/Lists/changeRole?user=${u.email}&role=${shareUserRole}&new=Read&list=${shopListName}">Read</a>
                                                                                            <a class="dropdown-item" href="/Lists/changeRole?user=${u.email}&role=${shareUserRole}&new=Write&list=${shopListName}">Write</a>
                                                                                        </c:if>
                                                                                        <c:if test = "${shareUserRole eq 'Write'}">
                                                                                            <a class="dropdown-item" href="/Lists/changeRole?user=${u.email}&role=${shareUserRole}&new=Read&list=${shopListName}">Read</a>
                                                                                            <a class="dropdown-item actualRole" href="/Lists/changeRole?user=${u.email}&role=${shareUserRole}&new=Write&list=${shopListName}">Write</a>
                                                                                        </c:if>
                                                                                    </div>
                                                                                </div>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <c:out value="${u.tipo}"/>
                                                                            </c:otherwise>
                                                                        </c:choose>                                                        
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>                                              
                                                        </tbody>
                                                    </table>
                                                    <c:if test="${user.email == lista.creator}">
                                                        <button style="width: -webkit-fill-available;" type="button" class="btn btn-dark btn-block" data-toggle="modal" data-target="#DeleteShareListModal" <c:if test="${empty sharedUsers}">disabled</c:if>>Delete Shared Users</button>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>                            
                                    <c:if test="${user == null}">
                                        <div class = "col-md-3">
                                            <div class="panel-body">
                                                <div class="table-container">
                                                    <button type="button" class="btn btn-primary btn-block" data-toggle="modal" data-target="#save-modal">Salva la lista</button>
                                                    <button type="button" class="btn btn-dark btn-block" data-toggle="modal" data-target="#delete-modal-DB">Elimina la lista dal database</button>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
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
                            <footer class="footer"></footer>
                            <!--end footer-->
                        </div>
                        <!--end page-->

                        <!--######################################################-->


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

                        <!--##########################--Share Modal--############################-->
                        <div class="modal fade" id="ShareListModal" tabindex="-1" role="dialog" aria-labelledby="ShareList" aria-hidden="true" enctype="multipart/form-data">
                            <div class="modal-dialog modal-dialog-centered" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <div class="page-title">
                                            <div class="container">
                                                <h1 style="text-align: center;">Share List <c:out value="${shopListName}"/></h1>
                                                <label>Selezionare gli utenti che possono lavorare con questa lista</label>
                                            </div>
                                        </div>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">
                                        <form method="POST" action="/Lists/restricted/ShareShopListServlet">
                                            <select name="sharedUsers" class="mdb-select colorful-select dropdown-primary" multiple>     
                                                <c:forEach items="${Users}" var="u">
                                                    <option value="${u.email}"><c:out value="${u.nominativo}"/></option> 
                                                </c:forEach>
                                            </select>
                                            <button type="submit" class="btn btn-primary" id="save">Save</button> 
                                            <button type="button" data-dismiss="modal" class="btn btn-primary" id=save-btn-no">Cancel</button> 
                                        </form>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <!--##########################-- End Share Modal--############################-->
                        <!--##########################--Delete Shared Users Modal--############################-->
                        <div class="modal fade" id="DeleteShareListModal" tabindex="-1" role="dialog" aria-labelledby="ShareList" aria-hidden="true" enctype="multipart/form-data">
                            <div class="modal-dialog modal-dialog-centered" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <div class="page-title">
                                            <div class="container">
                                                <h1 style="text-align: center;">Delete Shared Users</h1>

                                                <label>Choose users to remove</label>
                                            </div>
                                        </div>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">
                                        <form method="POST" action="/Lists/restricted/DeleteSharedUsers">
                                            <select name="sharedToDelete" class="mdb-select colorful-select dropdown-primary" multiple>     
                                                <c:forEach items="${sharedUsers}" var="susers">
                                                    <option value="${susers.email}"><c:out value="${susers.nominativo}"/></option> 
                                                </c:forEach>
                                            </select>
                                            <button type="submit" class="btn btn-dark" id="deleteShare">Remove</button> 
                                            <button type="button" data-dismiss="modal" class="btn btn-dark" id="deleteShare-btn-no">Cancel</button> 
                                        </form>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <!--##########################-- End Share Modal--############################-->

                        <!-- Delete Modal -->
                        <div class="modal fade" id="delete-modal" tabindex="-1" role="dialog" aria-labelledby="delete-modal" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <div class="page-title">
                                            <div class="container">
                                                <h1>Elimina ${shopListName}</h1>
                                            </div>
                                            <!--end container-->
                                        </div>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">
                                        <h3>Sei sicuro di voler eliminare questa lista?</h3>
                                        <form class="clearfix" action="/Lists/DeleteShopList" method="POST">
                                            <button type="submit" class="btn btn-dark" id="delete">Elimina</button>
                                            <button type="button" data-dismiss="modal" class="btn btn-dark" id="delete-btn-no">Annulla</button>
                                        </form>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Delete from database Modal -->
                        <div class="modal fade" id="delete-modal-DB" tabindex="-1" role="dialog" aria-labelledby="delete-modal" aria-hidden="true">
                            <div class="modal-dialog modal-dialog-centered" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <div class="page-title">
                                            <div class="container">
                                                <h1>Elimina ${shopListName}</h1>
                                            </div>
                                            <!--end container-->
                                        </div>
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                            <span aria-hidden="true">&times;</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">
                                        <h3>Sei sicuro di voler eliminare questa lista?<br> Non potrai annullare la modifica.</h3>
                                        <form class="clearfix" action="/Lists/DeleteShopList" method="POST">
                                            <c:if test="${empty user and importGL != null}">                                
                                                <input type="email" name="creator" placeholder="Email" required><br><br>
                                            </c:if>
                                            <button type="submit" class="btn btn-dark" id="delete">Elimina</button>
                                            <button type="button" data-dismiss="modal" class="btn btn-dark" id="delete-btn-no">Annulla</button>
                                        </form>

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
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Save Modal -->
                        <c:if test="${not empty guestList}">
                            <div class="modal fade" id="save-modal" tabindex="-1" role="dialog" aria-labelledby="save-modal" aria-hidden="true">
                                <div class="modal-dialog modal-dialog-centered" role="document">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <div class="page-title">
                                                <div class="container">
                                                    <h1>Salva la tua lista</h1>
                                                </div>
                                                <!--end container-->
                                            </div>
                                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                <span aria-hidden="true">&times;</span>
                                            </button>
                                        </div>
                                        <div class="modal-body">                            
                                            <form action="/Lists/SaveGuestList" method="POST">
                                                <h4>Iserisci un indirizzo email:</h4>
                                                <input type="email" name="creator" required>
                                                <h4>Iserisci una password:</h4>
                                                <input type="password" name="password" required>
                                                <input type="hidden" name="nome" value="${shoplistName}">
                                                <input type="hidden" name="categoria" value="${guestList.categoria}">
                                                <input type="hidden" name="descrizione" value="${guestList.descrizione}">
                                                <input type="hidden" name="immagine" value="${guestList.immagine}">
                                                <input type="submit" class="btn btn-primary btn-block" data-toggle="modal" data-target="#SaveListModal" value="Salva la lista">
                                                <button type="button" data-dismiss="modal" class="btn btn-dark" id="save2-btn-no">Cancel</button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>



                        <!--########################end delete modal##############################-->
                        <!--###################################################################################################################################################################################################-->

                        <!--<script type="text/javascript" src="http://maps.google.com/maps/api/js"></script>-->

                        <script src="js/selectize.min.js"></script>
                        <script src="js/masonry.pkgd.min.js"></script>
                        <script src="js/icheck.min.js"></script>
                        <script src="js/jquery.validate.min.js"></script>
                        <script src="js/custom.js"></script>
                        <script src="js/nav.js"></script>
                        <script src="js/vari.js"></script>
                        <script src="js/datepicker.js"></script>


                        <!--<script type="text/javascript" src="http://maps.google.com/maps/api/js?key=AIzaSyBEDfNcQRmKQEyulDN8nGWjLYPm8s4YB58&libraries=places"></script>-->

                        <script type="text/javascript">
                                                                                        $(document).ready(function () {
                                                                                            $("#alert").hide();

                                                                                            $("#alert").fadeTo(10000, 500).slideUp(500, function () {
                                                                                                $("#alert").slideUp(500);
                                                                                            });

                                                                                        });
                        </script>

                        <script>
                            var tipo;
                            function giaAcquistatoItem(id) {
                                tipo = "acquistato";
                                $.ajax({
                                    type: "GET",
                                    url: "/Lists/signProductAsBuyed?id=" + id + "&tipo=" + tipo,
                                    async: false,
                                    success: function () {
                                        $('#item' + id).addClass('itemAcquistato');
                                        $('#pProva' + id).addClass('pAcquistato');
                                        $('#wrapperProva' + id).addClass('wrapperProva');
                                        $('#divProva' + id).removeClass('invisible');
                                        $('#divProva' + id).addClass('overlayAcquistato');
                                    },
                                    error: function () {
                                        alert("Errore");
                                    }
                                });
                            }

                            function daAcquistareItem(id) {
                                tipo = "daAcquistare";
                                $.ajax({
                                    type: "GET",
                                    url: "/Lists/signProductAsBuyed?id=" + id + "&tipo=" + tipo,
                                    async: false,
                                    success: function () {
                                        $('#item' + id).removeClass('itemAcquistato');
                                        $('#pProva' + id).removeClass('pAcquistato');
                                        $('#wrapperProva' + id).removeClass('wrapperProva');
                                        $('#divProva' + id).addClass('invisible');
                                        $('#divProva' + id).removeClass('overlayAcquistato');
                                    },
                                    error: function () {
                                        alert("Errore");
                                    }
                                });
                            }
                        </script>

                        <script>
                            function removeItem(id) {
                                $.ajax({
                                    type: "GET",
                                    url: "/Lists/removeProduct?prodotto=" + id,
                                    async: false,
                                    success: function () {
                                        $('#item' + id).addClass('invisible');
                                    },
                                    error: function () {
                                        alert("Errore");
                                    }
                                });
                            }
                        </script>

                        <script>
                            function updateQuantity(id, type) {
                                var lista = null;
                                if (type === "guest") {
                                    lista = '${guestList}';
                                } else {
                                    lista = '${shopListName}';
                                }
                                var quantita = $('#' + id + 'Quantity').val();
                                $.ajax({
                                    type: "POST",
                                    url: "/Lists/updateQuantity",
                                    data: jQuery.param({id: id, lista: lista, quantita: quantita, tipo: type}),
                                    async: false,
                                    success: function () {

                                    },
                                    error: function () {
                                        alert("Errore");
                                    }
                                });
                            }

                            function defaultChange() {
                                var lista = '${shopListName}';
                                var valore = $('#' + 'defaultReminder').val();

                                $.ajax({
                                    type: "POST",
                                    url: "/Lists/updateDefaultReminder",
                                    data: jQuery.param({lista: lista, valore: valore}),
                                    async: false,
                                    success: function () {

                                    },
                                    error: function () {
                                        alert("Errore update default reminder");
                                    }
                                });
                            }

                            function changeReminder(id, lista) {
                                var data = $("#Reminder-" + id).val();
                                /*if(data === undefined || data === null){
                                 data = $("#Reminder-grid-"+id+"-"+lista).val();
                                 }*/
                                console.log(data);
                                $.ajax({
                                    type: "POST",
                                    url: "/Lists/updateReminder",
                                    data: jQuery.param({id: id, lista: lista, data: data}),
                                    async: false,
                                    success: function () {
                                    },
                                    error: function () {
                                        alert("Errore");
                                    }
                                });
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

                        <!--<script>
                                            // Note: This example requires that you consent to location sharing when
                                            // prompted by your browser. If you see the error "The Geolocation service
                                            // failed.", it means you probably did not give permission for the browser to
                                            // locate you.
                                            var map, infoWindow;
                                            function initMap() {
                                                map = new google.maps.Map(document.getElementById('map'), {
                                                    center: {lat: -34.397, lng: 150.644},
                                                    zoom: 6
                                                });
                                                infoWindow = new google.maps.InfoWindow;
                
                                                // Try HTML5 geolocation.
                                                if (navigator.geolocation) {
                                                    navigator.geolocation.getCurrentPosition(function (position) {
                                                        var pos = {
                                                            lat: position.coords.latitude,
                                                            lng: position.coords.longitude
                                                        };
                
                                                        infoWindow.setPosition(pos);
                                                        infoWindow.setContent('Location found.');
                                                        infoWindow.open(map);
                                                        map.setCenter(pos);
                                                    }, function () {
                                                        handleLocationError(true, infoWindow, map.getCenter());
                                                    });
                                                } else {
                                                    // Browser doesn't support Geolocation
                                                    handleLocationError(false, infoWindow, map.getCenter());
                                                }
                                            }
                
                                            function handleLocationError(browserHasGeolocation, infoWindow, pos) {
                                                infoWindow.setPosition(pos);
                                                infoWindow.setContent(browserHasGeolocation ?
                                                        'Error: The Geolocation service failed.' :
                                                        'Error: Your browser doesn\'t support geolocation.');
                                                infoWindow.open(map);
                                            }
                        </script>
                        <script async defer
                                src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCjXyXm-OQw78LLDEADIrQbl5OFKZGlam8&callback=initMap">
                        </script>-->
<script src="/Lists/Pages/js/nav.js"></script>
                        </body>
                        </html>
