<%-- 
    Document   : foreignLists
    Created on : 16.10.2018, 18:08:40
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

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="icon" href="Pages/img/favicon.png" sizes="16x16" type="image/png">
        <title>Lists</title>
        <c:if test="${empty user}">
            <c:redirect url="/homepage.jsp"/>
        </c:if>

        <!-- CSS personalizzati -->
        <link href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700|Varela+Round" rel="stylesheet">
        <link rel="stylesheet" href="Pages/bootstrap/css/bootstrap.css" type="text/css">
        <link rel="stylesheet" href="Pages/fonts/font-awesome.css" type="text/css">
        <link rel="stylesheet" href="Pages/css/selectize.css" type="text/css">
        <link rel="stylesheet" href="Pages/css/style.css">
        <link rel="stylesheet" href="Pages/css/user.css">
        <link rel="stylesheet" href="Pages/css/navbar.css">
        <link rel="stylesheet" href="Pages/css/datatables.css" type="text/css">
        <link rel="stylesheet" href="Pages/css/notificationCss.css" type="text/css"> 
        
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
        <c:if test="${not empty user}">
        <div class="page home-page">
            <header class="hero">
                <div class="hero-wrapper">
                    <div id="navbar">
                        <!-- Qui viene inclusa la navbar -->
                    </div>
                    <div class="page-title">
                        <div class="container">
                            <h1>Liste condivise</h1>
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
            <!-- SISTEMA PER LE NOTIFICHE -->

            <li class="dropdown" id="notificationsLI"></li>
            <!--*********************************************************************************************************-->
            <!--************ CONTENT ************************************************************************************-->
            <!--*********************************************************************************************************-->
            <section class="content">
                <section class="block">
                    <div class="container">
                        <div class="row">
                            <div class="col-md-3" id="sideNavbar">
                                <!-- Qui c'è la side navar caricata dal template con AJAX -->
                            </div>
                            <!--end col-md-3-->
                            <div class="col-md-9">
                                <!--============ Section Title===================================================================-->
                                <div class="section-title clearfix">
                                    <div class="float-left float-xs-none" style="width: 89%;">
                                        <input type="text" id="myInput" onkeyup="myFunction()" placeholder="Search for names.." title="Type in a name of product">
                                        <label style="display: none;" id="loadProducts">Carico le categorie...</label>
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
                                    <c:forEach items="${sharedLists}" var="list">
                                        <c:set scope="page" var="featured" value="false"/> 
                                        <c:forEach items="${allNotifiche}" var="nn">
                                            <c:if test="${nn.listName eq list.nome}">
                                                <c:set scope="page" var="featured" value="true"/>
                                            </c:if>
                                        </c:forEach>                                                                
                                        <div class="item">
                                            <c:if test="${featured == true}">
                                                <div class="ribbon-featured">Featured</div> 
                                            </c:if>
                                            <!--end ribbon-->
                                            <div class="wrapper">
                                                <div class="image">
                                                    <h3>
                                                        <a href="#" class="tag category"><c:out value="${list.categoria}"/></a>
                                                        <a href="/Lists/ShowShopList?nome=${list.nome}" class="title"><c:out value="${list.nome}"/></a>
                                                    </h3>
                                                    <a href="/Lists/ShowShopList?nome=${list.nome}" class="image-wrapper background-image">
                                                        <img src="${list.immagine}" alt="">
                                                    </a>
                                                </div>
                                                <!--end image--> 
                                                <!--end admin-controls-->
                                                <div class="description">
                                                    <p><c:out value="${list.descrizione}"/></p>
                                                </div>
                                                <!--end description-->
                                            </div>
                                        </div>
                                    <!--end item-->
                                    </c:forEach>                                  
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
            <footer class="footer"></footer>
            <!--end footer-->
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
            
            <script>
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
                
                //Side-Navbar
                $.ajax({
                    type: "GET",
                    url: "/Lists/Pages/template/sideNavbar.jsp",
                    cache: false,
                    success: function (response) {
                        $("#sideNavbar").html(response);
                    },
                    error: function () {
                        alert("Errore sideNavbar Template");
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
        

            <script src="Pages/js/nav.js"></script>
            </c:if>
    </body>
</html>


