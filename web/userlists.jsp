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
        
        li = listdao.getByEmail(u.getEmail());
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
                    <div id="navbar">
                        <!-- Qui viene inclusa la navbar -->
                    </div>
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
                            <div class="col-md-3" id="sideNavbar">
                                <!-- Qui c'è la side navar caricata dal template con AJAX -->
                            </div>
                            <!--end col-md-3-->
                            <div class="col-md-9">
                                <!--============ Section Title===================================================================-->
                                <div class="section-title clearfix">
                                    <c:if test="${not empty user}">
                                        <div class="float-left float-xs-none" style="width: 89%;">
                                            <input type="text" id="myInput" onkeyup="myFunction()" placeholder="Search for names.." title="Type in a name of product">
                                            <label style="display: none;" id="loadProducts">Carico le categorie...</label>
                                        </div>
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
                                
                                <!--============ Items ==========================================================================-->
                                <div class="items list compact grid-xl-3-items grid-lg-2-items grid-md-2-items">
                                    <c:choose>         
                                        <c:when test = "${ not empty user}">  

                                            <%  
                                                if(li != null && !li.isEmpty()){
                                                for (ShopList l : li) {
                                                    ArrayList<Notification> n = new ArrayList();
                                                    for (Notification nn : notifiche) {
                                                        if (nn.getListName().equals(l.getNome())) {
                                                            n.add(nn);
                                                        }
                                                    }
                                            %>             
                                            <a href="#" data-toggle="modal" data-target="#CreateListModal" class="nav-link icon"><i class="fa fa-plus"></i>Crea una nuova lista</a><br>
                                            <div class="item">
                                                <%if (!n.isEmpty()) {%>
                                                    <div class="ribbon-featured">Featured</div>
                                                <%}%>
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
                                            <%}}else{%>
                                            <h1>Non hai ancora creato nessuna lista</h1>
                                            <button data-toggle="modal" data-target="#CreateListModal" class="btn btn-primary text-caps btn-rounded" >Crea una lista</button>
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
                                            <button data-toggle="modal" data-target="#CreateListModal" class="btn btn-primary text-caps btn-rounded" >Crea una lista</button>
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


        <div class="modal fade" id="CreateListModal" tabindex="-1" role="dialog" aria-labelledby="CreateShopListform" aria-hidden="true" enctype="multipart/form-data"></div>
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

                //Footer
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
                });
            
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
            });
        </script>
    </body>
</html>

