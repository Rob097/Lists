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

<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="author" content="ThemeStarz">
        <link href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700|Varela+Round" rel="stylesheet">
        <link rel="stylesheet" href="css/navbar.css"> 
        <link rel="stylesheet" href="css/datatables.css" type="text/css"> 
        <link rel="icon" href="img/favicon.png" sizes="16x16" type="image/png">
        <script src="js/jquery-3.3.1.min.js"></script>
        <script type="text/javascript" src="js/popper.min.js"></script>
        <script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>        
        <link rel="stylesheet" href="bootstrap/css/bootstrap.css" type="text/css">
        <link rel="stylesheet" href="fonts/font-awesome.css" type="text/css">
        <link rel="stylesheet" href="css/selectize.css" type="text/css">
        <link rel="stylesheet" href="css/style.css">
        <link rel="stylesheet" href="css/user.css">
        <link rel="stylesheet" href="css/notificationCss.css" type="text/css"> 

        <title>Adminpage Products</title>

        <style>
            body{
                overflow-x: unset;
            }

            .items:not(.selectize-input).list .item .wrapper {
                min-height: 14rem;
                padding-bottom: 0;
            }

            .items:not(.selectize-input).list.compact .item .image .background-image {
                border-radius: 100%;
            }

            .items:not(.selectize-input).list.compact .item .image .background-image {
                width: 10rem;
                border-radius: 100%;
            }
            .items:not(.selectize-input).list.compact .item {
                min-height: 0rem;
            }
        </style>
        <style>
            .avatar {
                vertical-align: middle;
                width: 140px;
                height: 140px;
                border-radius: 4%;
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
                    <!--============ Secondary Navigation ===============================================================-->
   
                    <div class="page-title">
                        <div class="container text-center">
                            <h1>Tutti i prodotti</h1>
                        </div>
                        <!--end container-->
                    </div>
                    <!--============ End Page Title =====================================================================-->
                    <div class="background"></div>

                    <div class="container text-center" id="welcomeGrid">
                        <a data-toggle="modal" data-target="#CreateProductModal" class="btn btn-primary text-caps btn-framed btn-block" >Aggiungi un nuovo prodotto</a>

                    </div

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
                                            <label style="display: none;" id="loadProducts1">Nessuna categoria corrispondente</label></br>
                                        <a style="display: none;" id="loadProducts2" data-toggle="modal" data-target="#CreateProductModal" class="btn btn-primary text-caps btn-rounded" >+ Crea un prodotto</a>
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

                                    <c:forEach items="${products}" var="product">
                                    <div class="item">
                                        <div class="wrapper">
                                            <div class="image">
                                                <h3>
                                                    <a class="tag category">${product.categoria_prodotto}</a>
                                                    <a class="title">${product.nome}</a>                           
                                                </h3>
                                                <a >
                                                    <img src="../${product.immagine}" alt="" class="avatar">
                                                </a>
                                            </div>
                                            <h4 class="description">
                                                <a >${product.note}</a>
                                            </h4>

                                            <div class="admin-controls">                                               
                                                <a href="<%=request.getContextPath()%>/DeleteProduct?PID=<c:out value="${product.pid}"/>" class="ad-remove">
                                                    <i class="fa fa-trash"></i>Cancella
                                                </a>
                                            </div>

                                        </div>
                                    </div>
                                    </c:forEach>

                                </div>
                            </div>
                            <!--end item-->

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


        <script src="js/jquery-3.3.1.min.js"></script>
        <script type="text/javascript" src="assets/js/popper.min.js"></script>
        <script type="text/javascript" src="assets/bootstrap/js/bootstrap.min.js"></script>
        <script type="text/javascript" src="http://maps.google.com/maps/api/js?key=AIzaSyBEDfNcQRmKQEyulDN8nGWjLYPm8s4YB58&libraries=places"></script>
        <script src="js/selectize.min.js"></script>
        <script src="js/masonry.pkgd.min.js"></script>
        <script src="js/icheck.min.js"></script>
        <script src="js/jquery.validate.min.js"></script>
        <script src="js/custom.js"></script>
            <!--<script type="text/javascript" src="http://maps.google.com/maps/api/js"></script>-->
            <script>
                function myFunction() {
                    var input, filter, ul, li, a, i;zz
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
                    var input, filter, items, li, a, i, check = true;
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
                            document.getElementById("loadProducts1").style.display = "none";
                            document.getElementById("loadProducts2").style.display = "none";
                            
                        }else{
                            items[i].style.display = "none";
                            
                        }
                        if(items[i].style.display === "") check = false;
                    }
                    if(check === true){
                        document.getElementById("loadProducts1").style.display = "";
                        document.getElementById("loadProducts2").style.display = "";
                    }
                }
            </script>
            
            <script src="../js/vari.js"></script>
            <script src="../js/nav.js"></script>
            
            <script>
                $(document).ready(function () {
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


    </body>
</html>
