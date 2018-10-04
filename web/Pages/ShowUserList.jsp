<%-- 
    Document   : ShowUserList
    Created on : 15-giu-2018, 17.13.06
    Author     : Roberto97
--%>

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

    HttpSession s = (HttpSession) request.getSession();
    String shoplistName = (String) s.getAttribute("shopListName");
    User u = null;
    boolean find = false;

    

    if (s.getAttribute("user") != null) {
        u = (User) s.getAttribute("user");
        find = true;
    }

   
        ArrayList<Product> li = listdao.getAllProductsOfShopList(shoplistName);
        ArrayList<User> AllUsersOfCurentList = listdao.getUsersWithWhoTheListIsShared(shoplistName);

%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
        </style>

    </head>
    <body>        

        <%            String Nominativo = "";
            String Email = "";
            String Type = "";
            String image = "";

            //String Image = "";
            Nominativo = u.getNominativo();
            Email = u.getEmail();
            Type = u.getTipo();
            image = u.getImage();
        %>


        <div class="page home-page">
            <header class="hero">
                <div class="hero-wrapper">

                    <%if (find) {%> 
                    <nav class="navbar navbar-expand-xl navbar-dark fixed-top " id="mainNav">
                        <a class="navbar-brand">
                            <img width= "50" src="/Lists/Pages/img/favicon.png" alt="Logo">
                        </a>
                        <a class="navbar-brand js-scroll-trigger" href="#home">LISTS</a>
                        <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
                            Menu
                            <i class="fa fa-bars"></i>
                        </button>
                        <div class="collapse navbar-collapse" id="navbarResponsive">
                            <ul class="navbar-nav text-uppercase ml-auto text-center">
                                <li class="nav-item">
                                    <a data-toggle="modal" data-target="#CreateListModal" class="btn btn-primary text-caps btn-rounded" >+ Lista</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link js-scroll-trigger" href="/Lists/Pages/<%=Type%>/<%=Type%>.jsp"><b>Le mie liste</b></a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link js-scroll-trigger" href="#home"><i class="fa fa-home"></i><b>Home</b></a>
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
                        <a class="navbar-brand js-scroll-trigger" href="#home">LISTS</a>
                        <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
                            Menu
                            <i class="fa fa-bars"></i>
                        </button>
                        <div class="collapse navbar-collapse" id="navbarResponsive">
                            <ul class="navbar-nav text-uppercase ml-auto text-center">
                                <li class="nav-item">
                                    <a data-toggle="modal" data-target="#CreateListModal" class="btn btn-primary text-caps btn-rounded" >+ Lista</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link js-scroll-trigger" href="/Lists/Pages/guest/guest.jsp"><b>Le mie liste</b></a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link js-scroll-trigger" href="#home"><i class="fa fa-home"></i><b>Home</b></a>
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
                                <%=shoplistName%>
                            </h1>
                        </div>
                        <!--end container-->
                    </div>
                    <!--============ End Page Title =====================================================================-->
                    <!--============ Hero Form ==========================================================================-->

                    <!--============ End Hero Form ======================================================================-->


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
                        <div class="icon-bar">
                            <a href="AddProductToListPage.jsp"><i class="fas fa-plus"> <br>Add products</i></a> 
                            <a href="adaptedChatroom.jsp"><i class="fas fa-users"><br>ChatRoom</i></a> 
                            <a data-toggle="modal" data-target="#ShareListModal"><i class="fa fa-globe"><br>Share</i></a>
                            <a href="#"><i class="fa fa-trash"><br>Delete</i></a> 
                        </div>

                        <hr>

                        <div class="row">

                            <!--end col-md-3-->
                            <div class="col-md-9">
                                <!--============ Section Title===================================================================-->
                                <div class="section-title clearfix">

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

                                    <%for (Product p : li) {%>

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
                                            <h4 class="location">
                                                <a href="#"><%=p.getPid()%></a>
                                            </h4>
                                            <div class="price">$80</div>
                                            <div class="admin-controls">
                                                <a href="edit-ad.html">
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
                                                <p><%=p.getNote()%></p>
                                            </div>
                                            <!--end description-->
                                            <a href="single-listing-1.html" class="detail text-caps underline">Detail</a>
                                        </div>
                                    </div>
                                    <%}%>
                                    <!--end item-->

                                    <!--end item-->


                                    <!--end item-->

                                </div>
                                <!--end items-->
                            </div>

                            <div class = "col-md-3">
                                <div class="panel-body">
                                    <div class="table-container">
                                        <table class="table-users table" border="0">
                                            <tbody>
                                                <%for (User usersoflist : AllUsersOfCurentList) {%>
                                                <tr>
                                                    
                                                    
                                                        <td width="10" align="center">
                                                            <i class="fa fa-2x fa-user fw"></i>
                                                        </td>
                                                        <td>
                                                            <%=usersoflist.getNominativo()%><br>
                                                        </td>
                                                        <td>
                                                            <%=usersoflist.getTipo()%>
                                                        </td>
                                                </tr>
                                                <%}%>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>

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
            
            <!--end footer-->
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
                                    <option value="${u.email}"><c:out value="${u.email}"/></option> 
                                </c:forEach>
                            </select>
                            <button type="submit" class="btn btn-primary" id="delete">Save</button> 
                            <button type="button" data-dismiss="modal" class="btn btn-primary" id="delete-btn-no">Cancel</button> 
                        </form>

                    </div>
                </div>
            </div>
        </div>
        <!--##########################-- End Share Modal--############################-->
    </body>
</html>
