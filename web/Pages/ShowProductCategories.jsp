<%-- 
    Document   : ShowProductCategories
    Created on : 31.10.2018, 10:54:03
    Author     : Martin
--%>

<%@page import="database.entities.Product"%>
<%@page import="java.util.ArrayList"%>
<%@page import="database.entities.ShopList"%>
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
        <title>Categorie Prodotto</title>

        <!-- CSS personalizzati -->
        <link href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700|Varela+Round" rel="stylesheet">
        <link rel="stylesheet" href="bootstrap/css/bootstrap.css" type="text/css">
        <link rel="stylesheet" href="fonts/font-awesome.css" type="text/css">
        <link rel="stylesheet" href="css/selectize.css" type="text/css">
        <link rel="stylesheet" href="css/style.css">
        <link rel="stylesheet" href="css/user.css">
        <link rel="stylesheet" href="css/navbar.css">
        <link rel="stylesheet" href="css/notificationCss.css" type="text/css"> 
        <title>Categorie Lista</title>
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
        </style>
    </head>
    <body>
        <div class="page home-page">
            <header class="hero">
                <div class="hero-wrapper">
                    <div id="navbar">
                        <!-- Qui viene inclusa la navbar -->
                    </div>
                    <div class="page-title">
                        <div class="container">
                            <h1 class="opacity-60 center">
                                Lista con tutte le categorie per <i>prodotti</i>
                            </h1>
                        </div>                        
                    </div>
                    <div class="background"></div>

                    <div class="container text-center" id="welcomeGrid">
                        <a data-toggle="modal" data-target="#CreateCategoryModal" class="btn btn-primary text-caps btn-framed btn-block" >Crea una categoria</a>
                    </div
                </div>
            </header>
            <!-- SISTEMA PER LE NOTIFICHE -->

            <li class="dropdown" id="notificationsLI"></li>
             <div class="page sub-page">
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
                                        <a style="display: none;" id="loadProducts2" data-toggle="modal" data-target="#CreateCategoryModal" class="btn btn-primary text-caps btn-rounded" >+ Crea una categoria</a>
                                    </div>
                                    <div class="float-right d-xs-none thumbnail-toggle">
                                        <a  class="change-class" data-change-from-class="list" data-change-to-class="grid" data-parent-class="items">
                                            <i class="fa fa-th"></i>
                                        </a>
                                        <a class="change-class active" data-change-from-class="grid" data-change-to-class="list" data-parent-class="items">
                                            <i class="fa fa-th-list"></i>
                                        </a>
                                    </div>
                                </div>
                                <!--============ Items ==========================================================================-->
                                <div class="items list compact grid-xl-3-items grid-lg-2-items grid-md-2-items">

                                    <c:forEach items="${allPrcategories}" var="Pcategoria">                                       
                                        <div class="item">
                                            <div class="wrapper">
                                                <div class="image">
                                                    <h3>
                                                        <a href="/Lists/Pages/ShowProducts.jsp?cat=${Pcategoria.nome}" class="title"><c:out value="${Pcategoria.nome}"/></a><br> 
                                                        <a style="cursor: context-menu;" class="tag category"><c:out value="${Pcategoria.category}"/></a>
                                                    </h3>
                                                    <div class="text-caps">
                                                        <a href="/Lists/Pages/ShowProducts.jsp?cat=${Pcategoria.nome}">
                                                               <img src="../${Pcategoria.immagine}" alt="" class="image-wrapper background-image img-fluid"> 
                                                        </a>
                                                    </div>
                                                </div>
                                                <h4 class="description" id="descrizioneCatProd" style="cursor: context-menu; height: initial;">                                                                                                 
                                                    <c:if test="${Pcategoria.inUse != 1}">
                                                        <a style="color: black;"><c:out value="${Pcategoria.descrizione}"/><br><b><c:out value="Usata per ${Pcategoria.inUse} Prodotti amministratore e ${Pcategoria.inUsePrivate} Prodotti privati"/></b></a>
                                                    </c:if>
                                                    <c:if test="${Pcategoria.inUse == 1}">
                                                        <a style="color: black;"><c:out value="${Pcategoria.descrizione}"/><br><b><c:out value="Usata per ${Pcategoria.inUse} Prodotti amministratore e ${Pcategoria.inUsePrivate} Prodotti privati"/></b></a>
                                                    </c:if>                                                      
                                                </h4>
                                                <div class="admin-controls">
                                                    <c:if test="${Pcategoria.inUse != 0}">
                                                    <a style="cursor: not-allowed;" class="ad-remove"  data-toggle="tooltip" title="In uso, non è possibile cancellarla">
                                                        <i class="fa fa-trash"></i>Cancella
                                                    </a>
                                                    </c:if>
                                                    <c:if test="${Pcategoria.inUse == 0}">
                                                        <a href="<%=request.getContextPath()%>/restricted/DeleteProductCategory?listname=${Pcategoria.nome}" class="ad-remove" data-toggle="tooltip" title="In uso, non è possibile cancellarla">
                                                            <i class="fa fa-trash"></i>Cancella
                                                        </a>
                                                    </c:if>
                                                </div>                                            
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
            </section>
             </div>
        </div>

        <!--#####################################################################################-->
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

        <!--######################Modals#############################################-->
        <div class="modal fade" id="CreateCategoryModal" tabindex="-1" role="dialog" aria-labelledby="CreateShopListform" aria-hidden="true" enctype="multipart/form-data">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <div class="page-title">
                            <div class="container">
                                <h1 style="text-align: center;">Crea una categoria per i prodotti</h1>
                            </div>
                            <!--end container-->
                        </div>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <!-- Form per il login -->
                        <form class="form clearfix" id="CreateShopListform" action="<%=request.getContextPath()%>/restricted/CreateProductCategory"  method="post" role="form" enctype="multipart/form-data">
                            <div class="form-group">
                                <label for="Nome" class="col-form-label">Nome della categoria</label>
                                <input type="text" name="Nome" id="Nome" tabindex="1" class="form-control" placeholder="Nome" value="" required>
                            </div>
                            <!--end form-group-->
                            <div class="form-group">
                                <label for="Descrizione" class="col-form-label">Descrizione</label>
                                <input type="text" name="Descrizione" id="Descrizione" tabindex="1" class="form-control" placeholder="Descrizione" value="" required>
                            </div>
                            <div class="form-group">
                                <label for="Categoria" class="col-form-label">Categoria</label>
                                <select name="Categoria" id="Categoria" tabindex="1" required>

                                    <c:forEach items="${categorie}" var="categoria">
                                        <option value="${categoria.nome}"><c:out value="${categoria.nome}"/></option> 
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="Immagine" class="col-form-label">Immagine</label>
                                <input type="file" name="file1" required>
                            </div>
                            <div class="d-flex justify-content-between align-items-baseline">
                                <button type="submit" name="register-submit" id="register-submit" tabindex="4" class="btn btn-primary">Crea categoria</button>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                            </div>                                
                        </form>
                        <hr>
                    </div>                    
                </div>
            </div>
        </div>
        
        <!--######################Modals#############################################-->
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

