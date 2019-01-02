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

<%

    DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
    if (daoFactory == null) {
        throw new ServletException("Impossible to get dao factory for user storage system");
    }
    UserDAO userdao = new JDBCUserDAO(daoFactory.getConnection());
    ListDAO listdao = new JDBCShopListDAO(daoFactory.getConnection());
    ProductDAO productdao = new JDBCProductDAO(daoFactory.getConnection());
    Category_ProductDAO category_productdao = new JDBCCategory_ProductDAO(daoFactory.getConnection());

    HttpSession s = (HttpSession) request.getSession();
    String shoplistName = "";
    if (s.getAttribute("shopListName") != null) {
        shoplistName = (String) s.getAttribute("shopListName");
    }
    User u = new User();
    boolean find = false;

    ArrayList<Product> li = productdao.getallAdminProducts();
    ArrayList<String> allCategories = productdao.getAllProductCategories();
    ArrayList<String> allListsOfUser = new ArrayList();
    ArrayList<Category_Product> cP = category_productdao.getAllCategories();
    s.setAttribute("catProd", cP);

    for(Product q : li){
        s.setAttribute(q.getNome(), null);
    }
    
    int PID = 0;
    String cat = null;
    if (request.getParameter("cat") != null) {
        cat = request.getParameter("cat");
        System.out.println("\nCAT: " + cat);
    }

    if (s.getAttribute("user") != null) {
        u = (User) s.getAttribute("user");
        allListsOfUser = listdao.getAllListsByCurentUser(u.getEmail());
        find = true;
    }
    session.setAttribute("number", 15);
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

        </style>
        <style>
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

        <%            String Nominativo = "";
            String Email = "";
            String Type = "";
            String image = "";

            //String Image = "";
            if (find) {
                Nominativo = u.getNominativo();
                Email = u.getEmail();
                Type = u.getTipo();
                image = u.getImage();
            }
        %>


        <div class="page home-page">
            <header class="hero">
                <div class="hero-wrapper">
                    <div id="navbar">
                        <!-- Qui viene inclusa la navbar -->
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
                                    <a href="/Lists/Pages/ShowProducts.jsp?cat=all" class="list-group-item">All</a>
                                    <%  String prod = "";

                                        for (String sprd : allCategories) {
                                            
                                    <a href="/Lists/Pages/ShowProducts.jsp?cat=<%=sprd%>" class="list-group-item"><%=sprd%></a>
                                    <%}%>
                                </div>
                            </div>
                            <div class="col-md-9">
                                <!--============ Section Title===================================================================-->
                                <div class="section-title clearfix">
                                    <div class="float-left float-xs-none" style="width: 89%;">
                                        <input type="text" id="myInput" onkeyup="myFunction()" placeholder="Search for names.." title="Type in a name of product">
                                        <label style="display: none;" id="loadProducts1">Nessun prodotto trovato</label><br>
                                        <c:if test="${not empty user and user.tipo=='amministratore'}">
                                            
                                                <a style="display: none;" id="loadProducts2" data-toggle="modal" data-target="#CreateProductModal" class="btn btn-primary text-caps btn-rounded" >+ Crea un prodotto</a>
                                            
                                        </c:if>
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

                                    <%  if (cat != null && !cat.equals("all")) {
                                            for (Product p : li) {
                                                PID = p.getPid();
                                                if (cat.equals(p.getCategoria_prodotto())) {
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
                                            </div>
                                            <!--end image-->

                                            <div class="price">$<%=PID%></div>

                                            <!--end admin-controls-->
                                            <div class="description">
                                                <p><%=p.getNote()%></p>
                                            </div>
                                            <!--end description-->
                                            <a class="detail text-caps underline" style="cursor: pointer;" id="addButton<%=p.getPid()%>" onclick="addProduct(<%=p.getPid()%>);">Aggiungi ad una lista</a>
                                            <!--<form class="ListModal detail text-caps underline" action="/Lists/setPID" method="post" role="form" id="ListModal" >
                                                <input type="submit" class="btn btn-primary" value="Add to your list">
                                                <input name="PID" type="hidden" value="<%=PID%>">
                                            </form>-->

                                        </div>
                                    </div>
                                    <%          }
                                        }
                                    } else if (request.getParameter("cat") == null || request.getParameter("cat").equals("all")) {
                                        int count = 5; 
                                        for (Product p : li) {
                                            if(count <= 15){ session.setAttribute(p.getNome(), p.getNome());
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
                                                <a href="single-listing-1.html" class="image-wrapper background-image" style="background-image: url('../<%=p.getImmagine()%>')">
                                                    <%System.out.println("IMAGINEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE: " + p.getImmagine());%>
                                                    <img src="../<%=p.getImmagine()%>" alt="">
                                                </a>
                                            </div>
                                            <!--end image-->

                                            <div class="price"><%=p.getPid()%></div>

                                            <!--end admin-controls-->
                                            <div class="description">
                                                <p><%=p.getNote()%></p>
                                            </div>
                                            <!--end description-->
                                            <a class="detail text-caps underline" style="cursor: pointer;" id="addButton<%=p.getPid()%>" onclick="addProduct(<%=p.getPid()%>);">Aggiungi ad una lista</a>
                                            <!--<form class="ListModal detail text-caps underline" action="/Lists/setPID" method="post" role="form" id="ListModal" >
                                                <input type="submit" class="btn btn-primary" value="Add to your list">
                                                <input name="PID" type="hidden" value="<%=PID%>">
                                            </form>-->

                                        </div>
                                    </div>
                                    <%}count++;}%>
                                    <div id="content-wrapper">
                                        
                                    </div>
                                    <button class="btn btn-primary text-center" onclick="showProduct();">Mostra più prodotti</button>
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
        
        <!--#########################################################
                                MODAL
        ##########################################################-->

        <!-- Login Modal -->
        <div class="modal fade" id="LoginModal" tabindex="-1" role="dialog" aria-labelledby="LoginModal" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">

                        <div class="page-title">
                            <div class="container">
                                <h1>Sign In</h1>
                            </div>
                            <!--end container-->
                        </div>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>            

                    </div>
                    <div class="modal-body">
                        <c:if test="${loginResult==false}">
                            <div class="alert alert-danger">
                                <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
                                <strong>Login Failed!</strong> <br> Please try again or <a data-toggle="modal" href="#RegisterModal" class="alert-link"><u>Sign up!</u></a>

                            </div>
                        </c:if>
                        <!-- Form per il login -->
                        <form class="form clearfix" id="login-form" action="/Lists/LoginAction" method="post" role="form">
                            <div class="form-group">
                                <label for="email" class="col-form-label required">Email</label>
                                <input type="text" name="email" id="emaillogin" tabindex="1" class="form-control" placeholder="Email" value="" required>
                            </div>
                            <!--end form-group-->
                            <div class="form-group">
                                <label for="password" class="col-form-label required">Password</label>
                                <input type="password" name="password" id="passwordlogin" tabindex="2" class="form-control" placeholder="Password" required>
                            </div>
                            <!--end form-group-->
                            <div class="d-flex justify-content-between align-items-baseline">
                                <div class="form-group text-center">
                                    <label>
                                        <input type="checkbox" name="remember" value="1">
                                        Remember Me
                                    </label>
                                </div>
                                <button type="submit" class="btn btn-primary">Sign In</button>
                            </div>

                        </form>
                        <hr>
                        <p>
                            Troubles with signing? <a href="#RegisterModal" data-toggle="modal" class="link">Click here.</a>
                        </p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>
        <!--######################################################-->

        <!-- Register Modal -->
        <div class="modal fade" id="RegisterModal" tabindex="-1" role="dialog" aria-labelledby="RegisterModal" aria-hidden="true" enctype="multipart/form-data">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <div class="page-title">
                            <div class="container">
                                <h1>Register</h1>
                            </div>
                            <!--end container-->
                        </div>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <!-- Form per il login -->
                        <form class="form clearfix" id="register-form" action="/Lists/RegisterAction" method="post" enctype="multipart/form-data" onsubmit="return checkCheckBoxes(this);">
                            <div class="form-group">
                                <label for="email" class="col-form-label">Email</label>
                                <input type="email" name="email" id="emailRegister" tabindex="1" class="form-control" placeholder="Email" value="" required>
                            </div>
                            <!--end form-group-->
                            <div class="form-group">
                                <label for="nominativo" class="col-form-label">Nome</label>
                                <input type="text" name="nominativo" id="nominativoRegister" tabindex="1" class="form-control" placeholder="Nome" value="" required>
                            </div>
                            <!--end form-group-->
                            <div class="form-group">
                                <label for="password" class="col-form-label">Password</label>
                                <input type="password" name="password" id="passwordRegister" tabindex="2" class="form-control" placeholder="Password" required>
                            </div>

                            <!--end form-group-->

                            <div class="form-group">
                                <label for="image" class="col-form-label required">Avatar</label>
                                <input type="file" name="file1" required>
                            </div>
                            <!--end form-group-->
                            <div class="d-flex justify-content-between align-items-baseline">
                                <div class="form-group text-center">
                                    <input type="checkbox" tabindex="3" class="" name="standard" id="standard">
                                    <label for="standard">Standard</label>
                                    <input type="checkbox" tabindex="3" class="" name="amministratore" id="amministratore">
                                    <label for="amministratore">Amministratore</label>
                                </div>
                                <button type="submit" name="register-submit" id="register-submit" tabindex="4" class="btn btn-primary">Register Now</button>
                            </div>
                        </form>
                        <hr>
                        <p>
                            By clicking "Register Now" button, you agree with our <a href="#" class="link">Terms & Conditions.</a>
                        </p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>


        <!--######################################################-->

        <div class="modal fade" id="myModal" role="dialog">
            <div class="modal-dialog">

                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">Modal Header</h4>
                    </div>
                    <div class="modal-body">
                        <input type="text" id="myInput" onkeyup="myFunction()" placeholder="Search for names.." title="Type in a name">


                        <%if (find) {
                                for (String nomeLista : allListsOfUser) {%>
                        <ul id="myUL">
                            <li><a class="btn btn-primary" href="/Lists/AddProductToList?shopListName=<%=nomeLista%>"><%=nomeLista%></a></li>
                        </ul>
                        <%}
                        } else if (s.getAttribute("guestList") != null) {
                            ShopList Glist = (ShopList) s.getAttribute("guestList");%>
                        <ul id="myUL">
                            <li><a href="/Lists/AddProductToList?shopListName=<%=Glist.getNome()%>"></a><%=Glist.getNome()%></li> 
                        </ul> 
                        <%}%>

                    </div>
                    <div style="padding: 1rem;">
                        <a data-toggle="modal" data-target="#CreateListModal" class="btn btn-primary text-caps btn-rounded" >Crea una lista</a>
                        <button style="float: right;" type="button" class="btn btn-default" data-dismiss="modal">Close</button>
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
          </c:if>
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
                        <form class="form clearfix" id="CreateShopListform" action="/Lists/CreateShopList"  method="post" role="form" enctype="multipart/form-data">
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
                            <%if (find) {%>
                            <div class="form-group">
                                <label for="Immagine" class="col-form-label required">Immagine</label>
                                <input type="file" name="file1" required>
                            </div>
                            <%}%>
                            <!--end form-group-->
                            <div class="d-flex justify-content-between align-items-baseline">

                                <button type="submit" name="register-submit" id="create-list-submit" tabindex="4" class="btn btn-primary">Crea lista</button>
                                <input type="hidden" name="showProduct" value="true">

                                <%if (find == false && session.getAttribute("guestList") != null) {%>
                                <h5>Attenzione, hai già salvato una lista. Se non sei registrato puoi salvare solo una lista alla volta. Salvando questa lista, cancellerai la lista gia salvata.</h5>
                                <%}%>
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
            
            <script>
            
            function showProduct() {
                $.ajax({
                type: "POST",
                url: "/Lists/Pages/elements.jsp",
                
                cache: false,
                success: function (response) {
                    $("#content-wrapper").html($("#content-wrapper").html() + response);
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
            
            
        });
    </script>
    </body>
</html>
