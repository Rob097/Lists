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

<%

    DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
    if (daoFactory == null) {
        throw new ServletException("Impossible to get dao factory for user storage system");
    }
    UserDAO userdao = new JDBCUserDAO(daoFactory.getConnection());
    ListDAO listdao = new JDBCShopListDAO(daoFactory.getConnection());
    ProductDAO productdao = new JDBCProductDAO(daoFactory.getConnection());

    HttpSession s = (HttpSession) request.getSession();
    String shoplistName = "";
    if (s.getAttribute("shopListName") != null) {
        shoplistName = (String) s.getAttribute("shopListName");
    }
    if (request.getParameter("shopListName") != null) {
        shoplistName = (String) request.getParameter("shopListName");
        s.setAttribute("shopListName", shoplistName);

    }
    User u = new User();
    boolean find = false;
    if (s.getAttribute("user") != null) {
        u = (User) s.getAttribute("user");
    }

    if (u.getTipo() != null) {
        if (u.getTipo().equals("standard") || u.getTipo().equals("amministratore")) {
            find = true;
        }
    }
    ArrayList<Product> li = productdao.getAllProducts();
    ArrayList<String> allCategories = productdao.getAllProductCategories();
    ArrayList<String> allListsOfUser = null;
    if (find) {
        allListsOfUser = listdao.getAllListsByCurentUser(u.getEmail());
    }


%>

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

        <%            String Nominativo = "";
            String Email = "";
            String Type = "";
            String image = "";

            if (find) {
                //String Image = "";
                Nominativo = u.getNominativo();
                Email = u.getEmail();
                Type = u.getTipo();
                image = u.getImage();
            }
        %>


        <div class="page home-page">
            <header class="hero">
                <div class="hero-wrapper">

                    <%if (find) {%> 
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
                                        <i class="fa fa-sign-in"></i><b><c:out value="${user.nominativo}"/> / <c:out value="${user.tipo}"/> </b>/ <img src= "/Lists/${user.image}" width="25px" height="25px" style="border-radius: 100%;">
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link js-scroll-trigger" href="/Lists/Pages/<%=Type%>/profile.jsp">
                                        <i class="fa fa-user"></i><b>Il mio profilo</b>
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </nav>
                    <%} else {%>
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
                                    <a class="nav-link js-scroll-trigger" data-toggle="modal" data-target="#LoginModal" style="cursor: pointer;">
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

                    <%}%>
                    <!--============ Page Title =========================================================================-->
                    <div class="page-title">
                        <div class="container">
                            <h1 class="opacity-60 center">
                                Tutti i Prodotti
                            </h1>
                        </div>
                        <!--end container-->
                    </div>



                    <!--end background-->
                </div>
                <!--end hero-wrapper-->
            </header>
            <!--end hero-->

            <!--*********************************************************************************************************-->
            <!--************ CONTENT ************************************************************************************-->
            <!--*********************************************************************************************************-->
            <section class="content" id="prodottiBox">
                <section class="block">
                    <div class="container">
                        <div class="row">
                            <a href="/Lists/Pages/ShowUserList.jsp" id="backToList" class="btn btn-primary botButton social dispNone">Torna alla lista</a>
                            <!--end col-md-3-->
                                <div class="col-md-3">
                                    <div class="list-group">
                                        <a href="/Lists/Pages/ShowProducts.jsp?cat=all" class="list-group-item">All</a>
                                         <%  String prod = "";

                                            for (String sprd : allCategories) {
                                                System.out.println("sprd: " + sprd);%>
                                        <a href="/Lists/Pages/AddProductToListPage.jsp?cat=<%=sprd%>" class="list-group-item"><%=sprd%></a>
                                        <%}%>
                                    </div>
                                </div>
                                <div class="col-md-9">    
                                <!--============ Section Title===================================================================-->
                                <div class="section-title clearfix">
                                    <div class="float-left float-xs-none">
                                        <label class="mr-3 align-text-bottom">Ordina: </label>
                                        <select name="sorting" id="sorting" class="small width-200px" data-placeholder="Default Sorting" >
                                            <option value="">Ultime aggiunte</option>
                                            <option value="1">Prime aggiunte</option>
                                            <option value="2">Costo piu basso</option>
                                            <option value="3">Costo più alto</option>
                                        </select>

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

                                    <%
                                        if (request.getParameter("cat") != null && !request.getParameter("cat").equals("all")) {
                                            for (Product p : li) {
                                                if (request.getParameter("cat").equals(p.getCategoria_prodotto())) {
                                    %>

                                    <div class="item">
                                        <!--end ribbon-->
                                        <div class="wrapper">
                                            <div class="image">
                                                <h3>
                                                    <a href="#" class="tag category"><%=p.getCategoria_prodotto()%></a>
                                                    <a href="single-listing-1.html" class="title"><%=p.getNome()%></a>
                                                    <span class="tag">Offer</span>
                                                </h3>
                                                <a href="single-listing-1.html" class="image-wrapper background-image">
                                                    <img src="../<%=p.getImmagine()%>" alt="">
                                                </a>
                                            </div>\
                                            <!--end image-->

                                            <div class="price">$80</div>

                                            <!--end admin-controls-->
                                            <div class="description">
                                                <p><%=p.getNote()%></p>
                                            </div>
                                            <!--end description-->
                                            <%if(listdao.chckIfProductIsInTheList(p.getPid(), shoplistName)){%>
                                                <a class="detail text-caps underline" style="cursor: pointer;" id="addButton<%=p.getPid()%>" onclick="addProduct(<%=p.getPid()%>);">Add to your list</a>
                                            <%}else{%> 
                                                <a class="detail"><img src="img/correct.png" id="addIco"></a>
                                            <%}%>
                                            <a class="detail"><img src="img/correct.png" id="addIco<%=p.getPid()%>" class="dispNone"></a>
                                        </div>
                                    </div>
                                    <%}
                                        }
                                    } else if (request.getParameter("cat") == null || request.getParameter("cat").equals("all")) {
                                        for (Product p : li) {%>



                                    <div class="item">
                                        <!--end ribbon-->
                                        <div class="wrapper">
                                            <div class="image">
                                                <h3>
                                                    <a href="#" class="tag category"><%=p.getCategoria_prodotto()%></a>
                                                    <a href="single-listing-1.html" class="title"><%=p.getNome()%></a>

                                                </h3>
                                                <a href="single-listing-1.html" class="image-wrapper background-image">
                                                    <img src="../<%=p.getImmagine()%>" alt="">
                                                </a>
                                            </div>
                                            <!--end image-->

                                            <div class="price">$80</div>

                                            <!--end admin-controls-->
                                            <div class="description">
                                                <p><%=p.getNote()%></p>
                                            </div>
                                            <!--end description-->
                                            <%if(listdao.chckIfProductIsInTheList(p.getPid(), shoplistName) == false){%>
                                                <a class="detail text-caps underline" style="cursor: pointer;" id="addButton<%=p.getPid()%>" onclick="addProduct(<%=p.getPid()%>);">Add to your list</a>
                                            <%}else{%> 
                                                <a class="detail"><img src="img/correct.png" id="addIco"></a>
                                            <%}%>
                                            <a class="detail"><img src="img/correct.png" id="addIco<%=p.getPid()%>" class="dispNone"></a>
                                        </div>
                                    </div>
                                    <%}
                                        }%>

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

        <script>
        function addProduct(id) {
            $.ajax({
                type: "GET",
                url: "/Lists/AddProductToList?prodotto=" + id,
                async: false,
                success: function () {
                    $('#addButton' + id).addClass('dispNone');
                    $('#addIco' + id).removeClass('dispNone');
                    $('#backToList').removeClass('dispNone');
                },
                error: function () {
                   alert("Errore");
               }
            });
        }
        </script>

    </body>
</html>