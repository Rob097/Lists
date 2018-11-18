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
    System.out.println("ShowUserList\n\n");
    DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
    if (daoFactory == null) {
        throw new ServletException("Impossible to get dao factory for user storage system");
    }

    UserDAO userdao = new JDBCUserDAO(daoFactory.getConnection());
    ListDAO listdao = new JDBCShopListDAO(daoFactory.getConnection());
    HttpSession s = (HttpSession) request.getSession();
    String shoplistName = null; //Nome della lista
    ShopList guestList = null; //Lista dell'utente non registrato
    ShopList lista = null;
    String role = ""; String shareUserRole = "";
    ArrayList<Product> li = null; //ArrayList dei prodotti della lista
    ArrayList<User> AllUsersOfCurentList = null; //ArrayList degli utenti con cui la lista è condivisa
    User u = null; //Eventuale utent
    boolean find = false;

    //Se rileva che c'è un utente loggato imposta find = true
    if (s.getAttribute("user") != null) {
        u = (User) s.getAttribute("user");
        find = true;
    }

    if (find) {//Se c'è un utente loggato
        if (s.getAttribute("shopListName") != null) {//Se l'attributo di session col nome della lista non è null
            shoplistName = (String) s.getAttribute("shopListName");
            li = listdao.getAllProductsOfShopList(shoplistName); //prendi tutti i prodotti della lista e mettili in li
            AllUsersOfCurentList = listdao.getUsersWithWhoTheListIsShared(shoplistName); //Prendi tutti gli utenti con cui la lista è condivisa
            lista = listdao.getbyName(shoplistName);
            role  = listdao.checkRole(u.getEmail(), shoplistName); System.out.println("\nRUOLO: " + role + "\n");
        }
    } else if (s.getAttribute("guestList") != null) { //Se non è loggato nessun utente, se l'attributo di sessione contenente la lista dell'utente Guest non è nullo
        guestList = (ShopList) s.getAttribute("guestList");
        if (s.getAttribute("prodottiGuest") != null) {
            li = (ArrayList<Product>) s.getAttribute("prodottiGuest"); //Prendi l'attributo di sessione contenente i prodotti se non è nullo
        }
        shoplistName = (String) guestList.getNome();
    }


%>

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
        <link rel="stylesheet" href="css/datatables.css" type="text/css"> 
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
        </style>
        <style>
            /* Always set the map height explicitly to define the size of the div
             * element that contains the map. */
            #map {
                height: 30em;
                width: 100%;
            }
            /* Optional: Makes the sample page fill the window. */
        </style>


    </head>
    <body>        

        <%            
            String Nominativo = "";
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
                                    <a data-toggle="modal" data-target="#CreateAddProductModal" class="btn btn-primary text-caps btn-rounded" >Crea e aggiungi prodotto</a>
                                </li>
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
                                <%=shoplistName%>
                                <%System.out.println("NOME:    ====   " + shoplistName); %>
                            </h1>
                            
                            <p class="text-center">
                                <%if(lista != null){%>
                                    <%=lista.getDescrizione()%>
                                <%}else if(guestList != null){%>
                                    <%=guestList.getDescrizione()%>
                                <%}%>
                            </p>
                        </div>
                    </div>
                    <!--============ End Page Title =====================================================================-->


                    <!--<div id="map"></div>-->
                </div>
            </header>
            
                                <%if(session.getAttribute("role") != null){%>
                                <div class="container pt-5" id="alert">
                                    <%if (!session.getAttribute("role").equals("same")) {%>
                                    <div class="alert alert-success text-center" role="alert">
                                        <strong>Permessi</strong> di <%=session.getAttribute("role")%> aggiornati correttamente.</a>.
                                    </div>
                                    <%session.setAttribute("role", "same");}%>
                                </div>
                                <%}%>

            <!--*********************************************************************************************************-->
            <!--************ CONTENT ************************************************************************************-->
            <!--*********************************************************************************************************-->
            <section class="content">
                

                <section class="block">
                    <div class="container">
                        
                        <div class="icon-bar">
                            
                            <c:choose>
                                <c:when test="${(not empty user)}">
                                    <c:set var = "ruolo" value="<%=role%>"/>
                                    <c:choose>
                                        <c:when test="${(ruolo eq 'creator')}">
                                            <div class="row">
                                                <div class="col-xl-3 col-lg-3 col-md-3 col-sm-6 col-6">
                                                    <a href="AddProductToListPage.jsp" style="font-size: 2.5rem; width: -webkit-fill-available;"><i class="fas fa-plus"> <br>Add products</i></a> 
                                                </div>
                                                <div class="col-xl-3 col-lg-3 col-md-3 col-sm-6 col-6">
                                                    <a href="ThirdChatroom.jsp" style="font-size: 2.5rem; width: -webkit-fill-available;"><i class="fas fa-users"><br>ChatRoom</i></a> 
                                                </div>
                                                <div class="col-xl-3 col-lg-3 col-md-3 col-sm-6 col-6">
                                                    <a style="cursor: pointer; font-size: 2.5rem; width: -webkit-fill-available;" data-toggle="modal" data-target="#ShareListModal"><i class="fa fa-globe"><br>Share</i></a>
                                                </div>
                                                <div class="col-xl-3 col-lg-3 col-md-3 col-sm-6 col-6">
                                                    <a style="cursor: pointer; font-size: 2.5rem; width: -webkit-fill-available;" data-toggle="modal" data-target="#delete-modal"><i class="fa fa-trash"><br>Delete</i></a>
                                                </div>
                                            </div>
                                        </c:when>
                                        <c:when test="${(ruolo eq 'Write')}">
                                            <a href="AddProductToListPage.jsp"><i class="fas fa-plus"> <br>Add products</i></a> 
                                            <a href="ThirdChatroom.jsp"><i class="fas fa-users"><br>ChatRoom</i></a> 
                                            <a style="cursor: pointer;" data-toggle="modal" data-target="#ShareListModal"><i class="fa fa-globe"><br>Share</i></a>
                                            <a style="cursor: pointer;" data-toggle="modal" data-target="#delete-modal"><i class="fa fa-trash"><br>Delete</i></a>
                                        </c:when>
                                        <c:when test="${(ruolo == 'Read')}">
                                        <a href="AddProductToListPage.jsp"><i class="fas fa-plus"> <br>Add products</i></a> 
                                        <a href="ThirdChatroom.jsp"><i class="fas fa-users"><br>ChatRoom</i></a>
                                        <a data-toggle="tooltip" title="Non hai i permessi perr condividere la lista. Contatta <%=u.getNominativo()%>" class="disabled"><i class="fa fa-globe"><br>Share</i></a>
                                        <a data-toggle="tooltip" title="Non hai i permessi perr cancellare la lista. Contatta <%=u.getNominativo()%>" class="disabled"><i class="fa fa-trash"><br>Delete</i></a> 
                                        </c:when>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    <a href="AddProductToListPage.jsp"><i class="fas fa-plus"> <br>Add products</i></a> 
                                    <a data-toggle="tooltip" title="Devi registrarti per usare questa funzione" class="disabled"><i class="fas fa-users"><br>ChatRoom</i></a> 
                                    <a data-toggle="tooltip" title="Devi registrarti per usare questa funzione" class="disabled"><i class="fa fa-globe"><br>Share</i></a>
                                    <a style="cursor: pointer;" data-toggle="modal" data-target="#delete-modal"><i class="fa fa-trash"><br>Delete</i></a> 
                                </c:otherwise>
                            </c:choose>                                    
                        </div>
                    
                        <hr>

                        <div class="row">

                            <!--end col-md-3-->
                            <div class="col-md-9">

                                
                                <!--============ Section Title===================================================================-->
                                <div class="section-title clearfix">
                                    <%if (li != null && !li.isEmpty()) {%>
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
                                    <%}%>
                                    <div class="float-right d-xs-none thumbnail-toggle">
                                        <a href="#" class="change-class" data-change-from-class="list" data-change-to-class="grid" data-parent-class="items">
                                            <i class="fa fa-th"></i>
                                        </a>
                                        <a href="#" class="change-class active" data-change-from-class="grid" data-change-to-class="list" data-parent-class="items">
                                            <i class="fa fa-th-list"></i>
                                        </a>
                                    </div></div>
                                <!--============ Items ==========================================================================-->
                                <div class="items list compact grid-xl-3-items grid-lg-2-items grid-md-2-items">
                                <%for (Product p : li) {%>
                                    <%if(listdao.checkBuyed(p.getPid(), shoplistName) == true){%>
                                    <div class="item itemAcquistato" id="item<%=p.getPid()%>">
                                        <div class="overlayAcquistato" id="divProva<%=p.getPid()%>">
                                            <p class="pAcquistato" id="pProva<%=p.getPid()%>">Già acquistato<br><a onclick="daAcquistareItem(<%=p.getPid()%>)" type="button" class="btn btn-dark" style="color: white;">Annulla</a></p>                                            
                                        </div>
                                        <!--end ribbon-->
                                        <div class="wrapper wrapperProva" id="wrapperProva<%=p.getPid()%>">
                                    <%}else{%>
                                    <div class="item" id="item<%=p.getPid()%>">
                                        <div class="invisible" id="divProva<%=p.getPid()%>">
                                            <p id="pProva<%=p.getPid()%>">Già acquistato<br><a onclick="daAcquistareItem(<%=p.getPid()%>)" type="button" class="btn btn-dark" style="color: white;">Annulla</a></p>
                                        </div>
                                        <!--end ribbon-->
                                        <div class="wrapper" id="wrapperProva<%=p.getPid()%>">
                                    <%}%>
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
                                                <a style="cursor: pointer;" onclick="giaAcquistatoItem(<%=p.getPid()%>)">
                                                    <i class="fas fa-shopping-cart"></i>Acquistato
                                                </a>
                                                <a href="#" class="ad-hide">
                                                    <i class="fa fa-eye-slash"></i>Hide
                                                </a>
                                                <a onclick="removeItem('<%=p.getPid()%>');" style="cursor: pointer;" class="ad-remove">
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

                            <%if (find) {%>
                            <div class = "col-md-3">
                                <div class="panel-body">
                                    <div class="table-container" style="width: -webkit-fill-available; min-width: fit-content;">                                        
                                        <table class="table-users table" border="0">
                                            <thead>
                                                <c:if test="${user.email == shoplist.creator}">
                                                    <button style="width: -webkit-fill-available;" type="button" class="btn btn-primary btn-block" data-toggle="modal" data-target="#ShareListModal" <c:if test="${empty Users}">disabled</c:if>>Share List</button>
                                                </c:if> 
                                            </thead>
                                            <tbody>
                                                <%for (User usersoflist : AllUsersOfCurentList) {
                                                    shareUserRole = listdao.checkRole(usersoflist.getEmail(), shoplistName);
                                                    System.out.println("\nNOME: " + usersoflist.getNominativo() + "\nTIPO: " + usersoflist.getTipo());
                                                %>
                                                <c:set var = "shareUserRole" value="<%=listdao.checkRole(usersoflist.getEmail(), shoplistName)%>"/>
                                                <tr>


                                                    <td width="10" align="center">
                                                        <i class="fa fa-2x fa-user fw"></i>
                                                    </td>
                                                    <td>
                                                        <%=usersoflist.getNominativo()%><br>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${(ruolo eq 'creator')}">
                                                                <div class="btn-group dropleft" style="width: -webkit-fill-available;">
                                                                    <a class="dropdown-toggle" style="background-color: red; padding: 4px; border-radius: 10%; color: white; width: -webkit-fill-available; text-align: center; min-width: max-content;" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                                                        <%=shareUserRole%>
                                                                    </a>
                                                                    <div class="dropdown-menu">
                                                                        <c:if test = "${shareUserRole eq 'Read'}">
                                                                            <a class="dropdown-item actualRole" href="/Lists/changeRole?user=<%=usersoflist.getEmail()%>&role=<%=shareUserRole%>&new=Read&list=<%=shoplistName%>">Read</a>
                                                                            <a class="dropdown-item" href="/Lists/changeRole?user=<%=usersoflist.getEmail()%>&role=<%=shareUserRole%>&new=Write&list=<%=shoplistName%>">Write</a>
                                                                        </c:if>
                                                                        <c:if test = "${shareUserRole eq 'Write'}">
                                                                            <a class="dropdown-item" href="/Lists/changeRole?user=<%=usersoflist.getEmail()%>&role=<%=shareUserRole%>&new=Read&list=<%=shoplistName%>">Read</a>
                                                                            <a class="dropdown-item actualRole" href="/Lists/changeRole?user=<%=usersoflist.getEmail()%>&role=<%=shareUserRole%>&new=Write&list=<%=shoplistName%>">Write</a>
                                                                        </c:if>
                                                                    </div>
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <%=usersoflist.getTipo()%>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        
                                                    </td>
                                                </tr>
                                                <%}%>
                                            </tbody>
                                        </table>
                                            <c:if test="${user.email == shoplist.creator}">
                                                <button style="width: -webkit-fill-available;" type="button" class="btn btn-dark btn-block" data-toggle="modal" data-target="#DeleteShareListModal" <c:if test="${empty shoplist.sharedUsers}">disabled</c:if>>Delete Shared Users</button>
                                            </c:if>
                                    </div>
                                </div>
                            </div>
                            <%} else {%>
                            <div class = "col-md-3">
                                <div class="panel-body">
                                    <div class="table-container">
                                        <button type="button" class="btn btn-primary btn-block" data-toggle="modal" data-target="#save-modal">Salva la lista</button>
                                        <button type="button" class="btn btn-dark btn-block" data-toggle="modal" data-target="#DeleteListModal">Elimina la lista</button>
                                    </div>
                                </div>
                            </div>
                            <%}%>
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
                                <c:forEach items="${shoplist.sharedUsers}" var="susers">
                                    <option value="${susers.email}"><c:out value="${susers.email}"/></option> 
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
                                <h1>Delete List</h1>
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
                            <%if (!find && s.getAttribute("import") != null) {%>
                            <input type="email" name="creator" placeholder="Email" required><br><br>
                            <%}%>
                            <button type="submit" class="btn btn-dark" id="delete">Delete</button>
                            <button type="button" data-dismiss="modal" class="btn btn-dark" id="delete-btn-no">Cancel</button>
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
                            <h3>Sei sicuro di voler salvare questa lista?</h3>
                            <h4>Iserisci un indirizzo email:</h4>
                            <form action="/Lists/SaveGuestList" method="POST">
                                <input type="email" name="creator" required>
                                <input type="hidden" name="nome" value="<%=shoplistName%>">
                                <input type="hidden" name="categoria" value="<%=guestList.getCategoria()%>">
                                <input type="hidden" name="descrizione" value="<%=guestList.getDescrizione()%>">
                                <input type="hidden" name="immagine" value="<%=guestList.getImmagine()%>">
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
        
        <script type="text/javascript" src="http://maps.google.com/maps/api/js?key=AIzaSyBEDfNcQRmKQEyulDN8nGWjLYPm8s4YB58&libraries=places"></script>
        
        <script type="text/javascript">
                $(document).ready (function(){
                $("#alert").hide();

                $("#alert").fadeTo(10000, 500).slideUp(500, function(){
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
                url: "/Lists/signProductAsBuyed?id="+id+"&tipo="+tipo,
                async: false,
                success: function () {
                    $('#item'+id).addClass('itemAcquistato');
                    $('#pProva'+id).addClass('pAcquistato');
                    $('#wrapperProva'+id).addClass('wrapperProva');
                    $('#divProva'+id).removeClass('invisible');
                    $('#divProva'+id).addClass('overlayAcquistato');
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
                url: "/Lists/signProductAsBuyed?id="+id+"&tipo="+tipo,
                async: false,
                success: function () {
                    $('#item'+id).removeClass('itemAcquistato');
                    $('#pProva'+id).removeClass('pAcquistato');
                    $('#wrapperProva'+id).removeClass('wrapperProva');
                    $('#divProva'+id).addClass('invisible');
                    $('#divProva'+id).removeClass('overlayAcquistato');
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
                url: "/Lists/removeProduct?prodotto="+id,
                async: false,
                success: function () {
                    $('#item'+id).addClass('invisible');
                },
                error: function () {
                   alert("Errore");
               }
            });
        }
        </script>
        
        
        <script>
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
        </script>
        
    </body>
</html>
