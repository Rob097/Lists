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
    String shoplistName = (String) s.getAttribute("shopListName");
    User u = new User();
    boolean find = false;
    if (s.getAttribute("user") != null) {
        u = (User) s.getAttribute("user");
    }

    if (u.getTipo() != null) {
        if (u.getTipo().equals("standard")) {
            find = true;
        }
    }

    ArrayList<Product> li = productdao.getAllProducts();
    ArrayList<String> allCategories = productdao.getAllProductCategories();
    //ArrayList<String> allListsOfUser = listdao.getAllListsByCurentUser(u.getEmail());
    ArrayList<User> allUsers = userdao.getAllUsers();

%>


<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="author" content="ThemeStarz">

        
        
        <link href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700|Varela+Round" rel="stylesheet">
          
        <link rel="stylesheet" href="../css/navbar.css"> 
        <link rel="stylesheet" href="../css/datatables.css" type="text/css"> 
        <link rel="icon" href="../img/favicon.png" sizes="16x16" type="image/png">
        <script src="../js/jquery-3.3.1.min.js"></script>
        <script type="text/javascript" src="../js/popper.min.js"></script>
        <script type="text/javascript" src="../bootstrap/js/bootstrap.min.js"></script>
        
        
        <link rel="stylesheet" href="../bootstrap/css/bootstrap.css" type="text/css">
        <link rel="stylesheet" href="../fonts/font-awesome.css" type="text/css">
        <link rel="stylesheet" href="../css/selectize.css" type="text/css">
        <link rel="stylesheet" href="../css/style.css">
        <link rel="stylesheet" href="../css/user.css">

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
                    <nav class="navbar navbar-expand-xl navbar-dark fixed-top " id="mainNav">
                        <a class="navbar-brand">
                            <img width= "50" src="../img/favicon.png" alt="Logo">
                        </a>
                        <a class="navbar-brand js-scroll-trigger" href="#home">LISTS</a>
                        <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
                            Menu
                            <i class="fa fa-bars"></i>
                        </button>
                        <div class="collapse navbar-collapse" id="navbarResponsive">
                            <ul class="navbar-nav text-uppercase ml-auto text-center">
                                <li class="nav-item">
                                    <a data-toggle="modal" data-target="#AddProductModal" class="btn btn-primary text-caps btn-rounded" >+ Product</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link js-scroll-trigger"  href="../../homepage.jsp"><i class="fa fa-home"></i><b>Home</b></a>
                                </li> 
                                <li class="nav-item js-scroll-trigger dropdown">
                                    <div style="cursor: pointer;" class="nav-link dropdown-toggle" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="fa fa-bars"></i><b>Liste</b></div>
                                    <div class="dropdown-menu" style="color: white;" aria-labelledby="navbarDropdown">
                                        <a class="dropdown-item nav-link" href="../../userlists.jsp"><i class="fa fa-bars"></i><b>Le mie liste</b></a>
                                        <a class="dropdown-item nav-link" href="../../foreignLists.jsp"><i class="fa fa-share-alt"></i><b>Liste condivise con me</b></a>                                        
                                    </div>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link js-scroll-trigger" href="../../profile.jsp">
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
                    <!--============ Secondary Navigation ===============================================================-->
   
                    <div class="page-title">
                        <div class="container">
                            <h1>All Products</h1>
                        </div>
                        <!--end container-->
                    </div>
                    <!--============ End Page Title =====================================================================-->
                    <div class="background"></div>

                    <div class="container text-center" id="welcomeGrid">
                        <a data-toggle="modal" data-target="#AddProductModal" class="btn btn-primary text-caps btn-rounded" style="color: white;">Add new product</a>

                    </div

                    <!--end background-->
                </div>

                >

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

                            <!--end col-md-3-->
                            <div class="col-md-12">
                                <!--============ Section Title===================================================================-->
                                  <div class="section-title clearfix">                                    
                                        <div class="float-left float-xs-none" style="width: 89%;">
                                            <input type="text" id="myInput" onkeyup="myFunction()" placeholder="Search for names.." title="Type in a name of product">
                                            <label style="display: none;" id="loadProducts">Carico i prodotti...</label>
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

                                    <%for (Product elem : li) {%>

                                    <div class="item">
                                        <div class="wrapper">
                                            <div class="image">
                                                <h3>
                                                    <a href="#" class="tag category"><%=elem.getCategoria_prodotto()%></a>
                                                    <a href="single-listing-1.html" class="title"><%=elem.getNome()%></a>                           
                                                </h3>
                                                <a href="single-listing-1.html" >
                                                    <img src="../../<%=elem.getImmagine()%>" alt="" class="avatar">
                                                </a>
                                            </div>
                                            <h4 class="location">
                                                <a href="#"><%=elem.getNote()%></a>
                                            </h4>

                                            <div class="admin-controls">
                                                <a href="edit-ad.html">
                                                    <i class="fa fa-pencil"></i>Edit
                                                </a>
                                                <a href="#" class="ad-hide">
                                                    <i class="fa fa-eye-slash"></i>Hide
                                                </a>
                                                <a href="/Lists/DeleteProduct?PID=<%=elem.getPid()%>" class="ad-remove">
                                                    <i class="fa fa-trash"></i>Remove
                                                </a>
                                            </div>

                                        </div>
                                    </div>
                                    <%}%>

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

            <!--*********************************************************************************************************-->
            <!--************ FOOTER *************************************************************************************-->
            <!--*********************************************************************************************************-->

        </div>
        <!--end page-->

        <div class="modal fade" id="AddProductModal" tabindex="-1" role="dialog" aria-labelledby="AddProductModal" aria-hidden="true" enctype="multipart/form-data">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <div class="page-title">
                            <div class="container">
                                <h1>Aggiungi prodotto</h1>
                            </div>
                            <!--end container-->
                        </div>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <!-- Form per il login -->
                        <form class="form clearfix" id="register-form" action="/Lists/AddNewProductToDataBase" method="post" enctype="multipart/form-data">
                            <div class="form-group">
                                <label for="NomeProdotto" class="col-form-label">Nome Prodotto</label>
                                <input type="text" name="NomeProdotto" id="NomeProdotto" tabindex="1" class="form-control" placeholder="Email" value="" required>
                            </div>
                            <!--end form-group-->
                            <div class="form-group">
                                <label for="NoteProdotto" class="col-form-label">Note Prodotto</label>
                                <input type="text" name="NoteProdotto" id="NoteProdotto" tabindex="1" class="form-control" placeholder="Nome" value="" required>
                            </div>
                            <!--end form-group-->
                            
                            
                            <div class="form-group">
                                <label for="CategoriaProdotto" class="col-form-label">Categoria</label>
                                <select name="CategoriaProdotto" id="Categoria" tabindex="1" size="5" >

                                    <c:forEach items="${categorie}" var="categoria">
                                        <option value="${categoria.nome}"><c:out value="${categoria.nome}"/></option> 
                                    </c:forEach>
                                </select><!--<input type="text" name="Categoria" id="Categoria" tabindex="1" class="form-control" placeholder="Categoria" value="" required>-->

                            </div>

                            <!--end form-group-->

                            <div class="form-group">
                                <label for="image" class="col-form-label required">Immagine Prodotto</label>
                                <input type="file" name="ImmagineProdotto" required>
                            </div>
                            
                            <button type="submit" name="register-submit" id="create-list-submit" tabindex="4" class="btn btn-primary">Aggiungi</button>
                            <!--end form-group-->

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


        <script src="../js/jquery-3.3.1.min.js"></script>
        <script type="text/javascript" src="assets/js/popper.min.js"></script>
        <script type="text/javascript" src="assets/bootstrap/js/bootstrap.min.js"></script>
        <script type="text/javascript" src="http://maps.google.com/maps/api/js?key=AIzaSyBEDfNcQRmKQEyulDN8nGWjLYPm8s4YB58&libraries=places"></script>
        <script src="../js/selectize.min.js"></script>
        <script src="../js/masonry.pkgd.min.js"></script>
        <script src="../js/icheck.min.js"></script>
        <script src="../js/jquery.validate.min.js"></script>
        <script src="../js/custom.js"></script>
            <!--<script type="text/javascript" src="http://maps.google.com/maps/api/js"></script>-->
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
            
            <script src="../js/vari.js"></script>
            <script src="../js/nav.js"></script>


    </body>
</html>
