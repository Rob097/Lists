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
            find = true;
    }

    if (find) {
        ArrayList<ShopList> li = listdao.getAllSharedList(u.getEmail());
        ArrayList <Notification> notifiche = new ArrayList();
            if(session.getAttribute("notifiche") != null){
                notifiche = (ArrayList<Notification>) session.getAttribute("notifiche");
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
                        <a class="navbar-brand js-scroll-trigger">LISTS</a>
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
                                        <a class="dropdown-item nav-link" href="#"><i class="fa fa-share-alt"></i><b>Liste condivise con me</b></a>                                        
                                    </div>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link js-scroll-trigger" href="profile.jsp">
                                        <i class="fa fa-user"></i><b>Il mio profilo</b>
                                    </a>
                                </li>                                
                                <li class="nav-item">
                                    <a class="nav-link js-scroll-trigger" href="<c:url context="/Lists" value="/restricted/LogoutAction" />" data-toggle="tooltip" data-placement="bottom" title="LogOut">
                                        <i class="fa fa-sign-in"></i><b><c:out value="${user.nominativo}"/> / <c:out value="${user.tipo}"/> </b>/ <img src= "${user.image}" width="25px" height="25px" style="border-radius: 100%;">
                                    </a>
                                </li>                                
                            </ul>
                        </div>
                    </nav>


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
                                    <a class="nav-link active icon" href="userlists.jsp">
                                        <i class="fa fa-bars"></i>Le mie liste
                                    </a>
                                    <a class="nav-link icon" href="/Lists/Pages/ShowProducts.jsp">
                                        <i class="fa fa-recycle"></i>Tutti i Prodotti
                                    </a>
                                    <c:if test="${user.tipo=='amministratore'}">
                                        <a class="nav-link icon" href="Pages/ShowProductCategories.jsp">
                                            <i class="fa fa-bookmark"></i>Tutte le categorie per prodotti
                                        </a>
                                        <a class="nav-link icon" href="Pages/ShowListCategories.jsp">
                                            <i class="fa fa-bookmark"></i>Tutte le categorie per liste
                                        </a> 
                                    </c:if>                                                                      
                                </nav>
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

                                    <% 
                                        for (ShopList l : li) {
                                            ArrayList<Notification> n = new ArrayList();
                                            for(Notification nn : notifiche) {
                                                if(nn.getListName().equals(l.getNome())){
                                                    n.add(nn);
                                                }
                                            }
                                    %>                                                                  
                                    <div class="item">
                                        <%if(!n.isEmpty()){%>
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
                                            <div class="price">$80</div>
                                            <div class="admin-controls">
                                                <a href="/Lists/ShowShopList?nome=<%=l.getNome()%>">
                                                    <i class="fa fa-pencil"></i>Edit
                                                </a>
                                                <a href="#" class="ad-hide">
                                                    <i class="fa fa-eye-slash"></i>Hide
                                                </a>
                                                <a href="#" class="ad-remove">
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

            <script src="Pages/js/nav.js"></script>
    </body>
</html>

<%    } else
        response.sendRedirect("/Lists");
%>
