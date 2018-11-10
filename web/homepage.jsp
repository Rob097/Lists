<%-- 
    Document   : homepage
    Created on : 16-giu-2018, 18.28.06
    Author     : Roberto97
--%>

<%@page import="Notifications.Notification"%>
<%@page import="java.util.ArrayList"%>
<%@page import="database.entities.*"%>
<%@page import="database.jdbc.*"%>
<%@page import="database.daos.*"%>
<%@page import="database.factories.DAOFactory"%>
<%@ page import="java.sql.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <link href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700|Varela+Round" rel="stylesheet">
        <link rel="stylesheet" href="Pages/bootstrap/css/bootstrap.css" type="text/css">
        <link rel="stylesheet" href="Pages/bootstrap/css/bootstrap.min.css" type="text/css">
        <link rel="stylesheet" href="Pages/fonts/font-awesome.css" type="text/css">
        <link rel="stylesheet" href="Pages/css/selectize.css" type="text/css">
        <link rel="stylesheet" href="Pages/css/style.css">
        <link rel="stylesheet" href="Pages/css/user.css">  
        <link rel="stylesheet" href="Pages/css/navbar.css"> 
        <link rel="stylesheet" href="Pages/css/datatables.css" type="text/css"> 
        <link rel="icon" href="Pages/img/favicon.png" sizes="16x16" type="image/png">
        <script src="Pages/js/jquery-3.3.1.min.js"></script>
        <script type="text/javascript" src="Pages/js/popper.min.js"></script>
        <script type="text/javascript" src="Pages/bootstrap/js/bootstrap.min.js"></script>

        <title>Lists</title>

        <!--apre subito il LoginModal se i dati inseriti non sono essistenti nel database-->
        <c:if test="${loginResult==false}">
            <script type="text/javascript">
                $(document).ready(function () {
                    $("#LoginModal").modal('show');
                });
            </script>
        </c:if>  
        <c:set var="privacy" scope="session" value="false"/>
            <style>
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
                .modal-body-pcy {
                    position: relative;
                    overflow-y: auto;
                    max-height: 450px;
                    padding: 15px;
                    overflow:scroll;
                }
            </style>
    </head>
    <body>

        <%                
            HttpSession s = (HttpSession) request.getSession(false);
            DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
            if (daoFactory == null) {
                throw new ServletException("Impossible to get dao factory for user storage system");
            }
            ListDAO listdao = new JDBCShopListDAO(daoFactory.getConnection());
            ProductDAO productdao = new JDBCProductDAO(daoFactory.getConnection());
            Category_ProductDAO category_productdao = new JDBCCategory_ProductDAO(daoFactory.getConnection());
            CategoryDAO categorydao = new JDBCCategoryDAO(daoFactory.getConnection());
            UserDAO userdao = new JDBCUserDAO(daoFactory.getConnection());            
            String Nominativo;
            String Email;
            String Type;
            String image;

            User u = new User();
            boolean find = false;
            if (s.getAttribute("user") != null) {
                u = (User) s.getAttribute("user");
                find = true;
                Nominativo = u.getNominativo();
                Email = u.getEmail();
                Type = u.getTipo();
                image = u.getImage();
            } else {
                Type = "guest";
            }

            ArrayList<Category> li = categorydao.getAllCategories();
            ArrayList<Product> prod = productdao.getAllProducts();
            ArrayList<Category_Product> cP = category_productdao.getAllCategories();
            request.getSession().setAttribute("categorie", li);
            request.getSession().setAttribute("catProd", cP);

        %>
        <!--###############################################################################################################################-->

        
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
                                <li class="nav-item js-scroll-trigger dropdown">
                                    <div style="cursor: pointer;" class="nav-link dropdown-toggle" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="fa fa-bars"></i><b>Liste</b></div>
                                    <div class="dropdown-menu" style="color: white;" aria-labelledby="navbarDropdown">
                                        <a class="dropdown-item nav-link" href="userlists.jsp"><i class="fa fa-bars"></i><b>Le mie liste</b></a>
                                        <a class="dropdown-item nav-link" href="foreignLists.jsp"><i class="fa fa-share-alt"></i><b>Liste condivise con me</b></a>                                        
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
                        <a class="navbar-brand js-scroll-trigger" href="#home">LISTS</a>
                        <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
                            Menu
                            <i class="fa fa-bars"></i>
                        </button>
                        <div class="collapse navbar-collapse" id="navbarResponsive">
                            <ul class="navbar-nav text-uppercase ml-auto text-center">                               
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
                    <!--============ End Secondary Navigation ===========================================================-->
                    <!--######################################################################################### 
                                    check dell'eventuale messaggio da visualizzare
                    ######################################################################################### -->
                    
                    <c:if test="${regResult==true}">
                        <div class="alert alert-success text-center" id="alert">
                            <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
                            <strong>Registrazione avvenuta con successo</strong> Adesso puoi fare il login al tuo account!
                        </div>
                        <%session.setAttribute("regResult", null); %>
                    </c:if>
                    <c:if test="${erroreIMG!=null}">
                        <div class="alert alert-warning text-center" id="alert">
                            <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
                            <strong>Attenzione!</strong> ${erroreIMG}
                        </div>
                        <%session.setAttribute("erroreIMG", null); %>
                    </c:if>
                    <!--#########################################################################################-->
            
                    <!--============ Page Title =========================================================================-->
                    <div class="page-title" id="home">
                        <div class="container pt-5">
                            <%if (find) {%>
                            <h1 class="opacity-60 center">
                                Bentornato <a href="/Lists/profile.jsp" data-toggle="tooltip" title="Il mio profilo"><%=u.getNominativo()%></a>
                            </h1><br>
                            <%} else {%>
                            <h1 class="opacity-60 center">
                                Benvenuto
                            </h1><br> 
                            <%}%>
                        </div>
                    </div>

                    <!--============ End Page Title =====================================================================-->
                    <div class="container text-center" id="welcomeGrid">
                        <div class="row">
                            <div class="col-md-4">
                                <a href="/Lists/userlists.jsp" class="text-caps" style="font-size: 15px; font-weight: bold; font-style: italic;">Le mie liste</a>
                            </div>
                            <div class="col-md-4">
                                <a data-toggle="modal" data-target="#CreateListModal" class="btn btn-primary text-caps btn-rounded" style="color: white;">Crea una nuova Lista</a>
                            </div>
                            <div class="col-md-4">
                                    <%if (find) {%>
                                <a href="/Lists/foreignLists.jsp" class="text-caps" style="font-size: 15px; font-weight: bold; font-style: italic;">Liste condivise</a>
                                    <%} else {%>
                                <a class="text-caps disabled" style="font-size: 15px; font-weight: bold; font-style: italic;" data-toggle="tooltip" title="Registrati o fai il login per usare questa funzione">Liste condivise</a>
                                    <%}%>
                            </div>
                           
                        </div>
                            <br>
                            
                        <div class="row">
                            <c:if test="${not empty user}">
                        <c:if test="${user.tipo == 'amministratore'}">
                            <div class="col-md-2">                                
                            </div>
                            <div class="col-md-3">
                                <a href="Pages/AdminPages/AdminProducts.jsp" class="btn btn-primary text-caps btn-rounded" style="color: white;">Lista prodotti</a>
                            </div>
                            <div class="col-md-2">
                                <a href="Pages/ShowProductCategories.jsp" class="btn btn-primary text-caps btn-rounded" style="color: white;">Categorie prodotti</a>                                
                            </div>
                            <div class="col-md-3">
                                <a href="Pages/ShowListCategories.jsp" class="btn btn-primary text-caps btn-rounded" style="color: white;">Categorie lista</a>
                            </div>  
                            <div class="col-md-2">                                
                            </div>                             
                        </c:if>
                    </c:if>
                        </div>
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
            <%if(find){
                if (session.getAttribute("notifiche") != null) {
                    ArrayList <Notification> nn = (ArrayList<Notification>) session.getAttribute("notifiche");
                    ArrayList <Notification> nNewProd = new ArrayList<>();
                    ArrayList <Notification> nRemoveProd = new ArrayList<>();
                    ArrayList <Notification> nEmptyList = new ArrayList<>();
                    ArrayList <Notification> nUser = new ArrayList<>();
                    ArrayList <Notification> nMsg = new ArrayList<>();
                    ArrayList <Notification> nRole = new ArrayList<>();
                    ArrayList <Notification> nStatusproduct = new ArrayList<>();
                    int checkNotification = 0;
            
                    for(Notification nf : nn) {
                        if(nf.getUser().equals(u.getEmail())){
                            checkNotification = 1;
                            if( nf.getType().equals("new_product")) nNewProd.add(nf);
                            
                            //Se la notifica ha come tipo 'remove_product' allora se la lista è vuota dai come notifica
                            //'lista svuotata' altrienti se non è vuota invia 'prodotto rimosso'
                            if( nf.getType().equals("remove_product")){
                                if(listdao.getbyName(nf.getListName()).getProducts() != null){
                                    if(listdao.getbyName(nf.getListName()).getProducts().isEmpty()){
                                        nEmptyList.add(nf);
                                    }else{
                                        nRemoveProd.add(nf);
                                    }
                                }else{
                                    nEmptyList.add(nf);
                                }
                            }
                            
                            if( nf.getType().equals("empty_list")) nEmptyList.add(nf);
                            
                            if( nf.getType().equals("new_user")) nUser.add(nf);
                            
                            if( nf.getType().equals("change_status_product")) nStatusproduct.add(nf);
                            
                            if( nf.getType().equals("new_message")){
                                try{
                                    nMsg.add(nf);
                                }catch(Exception e){
                                    e.printStackTrace();
                                }
                            }
                            if( nf.getType().equals("role_change")) nRole.add(nf);
                            
                        }
                    }
            
            
            %>
                    <div class="container pt-5" id="alert">
                        <%if(!nNewProd.isEmpty()){
                            if(nNewProd.size() == 1){
                        %>
                                <div class="alert alert-success text-center" role="alert">
                                    <a href="/Lists/ShowShopList?nome=<%=nNewProd.get(0).getListName()%>"><strong>Nuovo prodotto!</strong> E' stato aggiunto un nuovo prodotto alla lista <%=nNewProd.get(0).getListName()%></a>.
                                </div>
                            <%}else{%>
                                <div class="alert alert-success text-center" role="alert">
                                    <a href="/Lists/foreignLists.jsp"><strong>Nuovi Prodotti</strong> sono stati aggiunti alle liste.</a>
                                </div>
                            <%}
                        }%>
                        <%if(!nRemoveProd.isEmpty()){
                            if(nRemoveProd.size() == 1){
                        %>
                                <div class="alert alert-success text-center" role="alert">
                                    <a href="/Lists/ShowShopList?nome=<%=nRemoveProd.get(0).getListName()%>"><strong>Prodotto rimosso!</strong> E' stato rimosso un prodotto dalla lista <%=nRemoveProd.get(0).getListName()%></a>.
                                </div>
                            <%}else{%>
                                <div class="alert alert-success text-center" role="alert">
                                    <a href="/Lists/foreignLists.jsp"><strong>Prodotti rimossi!</strong> Sono stati rimossi dei prodotti dalle liste.</a>
                                </div>
                            <%}
                        }%>
                        <%if(!nEmptyList.isEmpty()){%>
                            <div class="alert alert-success text-center" role="alert">
                                <a href="/Lists/ShowShopList?nome=<%=nEmptyList.get(0).getListName()%>"><strong>Lista svuotata!</strong> E' stata svuotata la lista <%=nEmptyList.get(0).getListName()%></a>.
                            </div>
                        <%}%>
                        <%if(!nMsg.isEmpty()){
                            if(nMsg.size() == 1){
                        %>
                                <div class="alert alert-success text-center" role="alert">
                                    <a href="/Lists/ShowShopList?nome=<%=nMsg.get(0).getListName()%>"><strong>Nuovo Messaggio!</strong> Hai un nuovo messaggio nella lista <%=nMsg.get(0).getListName()%></a>.
                                </div>
                            <%}else{%>
                                <div class="alert alert-success text-center" role="alert">
                                    <a href="/Lists/foreignLists.jsp"><strong>Nuovi Messaggi</strong> nelle liste.</a>
                                </div>
                            <%}
                        }%>
                        <%if(!nRole.isEmpty()){
                            if(nRole.size() == 1){
                        %>
                                <div class="alert alert-success text-center" role="alert">
                                    <a href="/Lists/ShowShopList?nome=<%=nRole.get(0).getListName()%>"><strong>Permessi aggiornati!</strong> Sono cambiati i tuoi permessi nella lista <%=nRole.get(0).getListName()%></a>.
                                </div>
                            <%}else{%>
                                <div class="alert alert-success text-center" role="alert">
                                    <a href="/Lists/foreignLists.jsp"><strong>Permessi aggiornati!</strong> Sono stati aggiornati i tuoi permessi nelle liste.</a>
                                </div>
                            <%}
                        }%>
                        <%if(!nStatusproduct.isEmpty()){
                            if(nStatusproduct.size() == 1){
                        %>
                                <div class="alert alert-success text-center" role="alert">
                                    <a href="/Lists/ShowShopList?nome=<%=nStatusproduct.get(0).getListName()%>"><strong>Stato prodotto cambiato!</strong> E' cambiato lo stato di un prodotto nella lista <%=nStatusproduct.get(0).getListName()%></a>.
                                </div>
                            <%}else{%>
                                <div class="alert alert-success text-center" role="alert">
                                    <a href="/Lists/foreignLists.jsp"><strong>Stato prodotti cambiati!</strong> Sono cambiati gli stati di alcuni prodotti nelle liste.</a>
                                </div>
                            <%}
                        }%>
                        <%if(checkNotification == 0){%>
                            <div class="alert alert-info text-center" role="alert">
                                <strong>Non</strong> hai nuove notifiche <%=u.getNominativo()%></a>.
                            </div>
                        <%}%>
                    </div>
                <%}
            }%>
            
            
            <!--ERRORI-->
            <%if(session.getAttribute("errore") != null){%>
                <div class="container pt-5" id="alert">
                    <div class="alert alert-danger text-center" role="alert">
                        <strong><%=session.getAttribute("errore")%></strong>
                    </div>
                </div>
            <%  //session.setAttribute("errore", null);
            }%>
            
            <!--MESSAGGI-->
            <%if(session.getAttribute("messaggio") != null){%>
                <div class="container pt-5" id="alert">
                    <div class="alert alert-success text-center" role="alert">
                        <strong><%=session.getAttribute("messaggio")%></strong>
                    </div>
                </div>
            <%  //session.setAttribute("errore", null);
            }%>
            
            <!-- FINE DELLE NOTIFICHE -->

            <!--*********************************************************************************************************-->
            <!--************ CONTENT ************************************************************************************-->
            <!--*********************************************************************************************************-->
            <section class="content">    
                <!--============ products =============================================================================-->
                <section class="block">
                    <div class="container">
                        <div class="hero" style="background-color: #f2f2f2;">
                            <div class="page-title">
                                <h2>Categorie di <a href="/Lists/Pages/ShowProducts.jsp" data-toggle="tooltip" title="Tutti i prodotti">Prodotti</a></h2>
                            </div>
                        </div>

                        <ul class="categories-list clearfix">
                            <%for (Category_Product p : cP) {%>
                            <li>
                                <img src="<%= p.getImmagine()%>" alt="">
                                <h3><a href="/Lists/Pages/ShowProducts.jsp?cat=<%=p.getNome()%>"><%= p.getNome()%></a></h3>
                                <div class="sub-categories">
                                </div>
                            </li>
                            <%}%>
                            <!--end category item-->
                        </ul>
                        <!--end categories-list-->
                    </div>
                    <!--end container-->
                </section>



                <!--============ Features Steps =========================================================================-->
                <section class="block has-dark-background">
                    <div class="container">
                        <div class="block">
                            <h2>Come funziona</h2>
                            <div class="row">
                                <div class="col-md-3">
                                    <div class="feature-box">
                                        <figure>
                                            <img src="Pages/img/add-user.png" alt="">
                                            <span>1</span>
                                        </figure>
                                        <%if (!find) {%>
                                        <a style="cursor: pointer;" data-toggle="modal" data-target="#RegisterModal"><h3>Crea un Account</h3></a>
                                        <%} else {%>
                                        <h3>Crea un Account</h3>
                                        <%}%>     
                                        <p>Scegli che tipo di utente vuoi essere, o usa l'applicazione come ospite</p>
                                    </div>
                                    <!--end feature-box-->
                                </div>
                                <!--end col-->
                                <div class="col-md-3">
                                    <div class="feature-box">
                                        <figure>
                                            <img src="Pages/img/add-list.png" alt="">
                                            <span>2</span>
                                        </figure>                                        
                                        <a style="cursor: pointer;" data-toggle="modal" data-target="#CreateListModal"><h3>Crea una lista</h3></a>                                                                               
                                        <p>Crea la tua lista personalizzata</p>
                                    </div>
                                    <!--end feature-box-->
                                </div>
                                <!--end col-->
                                <div class="col-md-3">
                                    <div class="feature-box">
                                        <figure>
                                            <img src="Pages/img/add-product.png" alt="">
                                            <span>3</span>
                                        </figure>
                                        <h3>Salva i prodotti</h3>
                                        <p>Salva i prodotti che usi piu spesso</p>
                                    </div>
                                    <!--end feature-box-->
                                </div>
                                <!--end col-->
                                <div class="col-md-3">
                                    <div class="feature-box">
                                        <figure>
                                            <img src="Pages/img/collaboration.png" alt="">
                                            <span>4</span>
                                        </figure>
                                        <h3>Condividi la lista con altri utenti</h3>
                                        <p>Condividi gli impegni con gli altri</p>
                                    </div>
                                    <!--end feature-box-->
                                </div>
                                <!--end col-->
                            </div>
                            <!--end row-->
                        </div>
                        <!--end block-->
                    </div>
                    <!--end container-->
                    <div class="background" data-background-color="#2b2b2b"></div>
                    <!--end background-->
                </section>
                <!--end block-->
                <!--============ End Features Steps =====================================================================-->

                <section class="block">
                    <div class="container">
                        <div class="d-flex align-items-center justify-content-around">
                            <a href="#" style="font-weight: bold; font-style: italic; color: #f00;">
                                <h1 style="font-size: 6rem;">LISTS</h1>
                            </a>
                        </div>
                    </div>
                </section>

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
                </>
                <!--end footer-->
        </div>
        <!--end page-->



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
                                <label for="password" class="col-form-label required" style="width: 100%">Password</label>
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
                            Hai dimenticato la password? <a data-dismiss="modal" href="#" data-toggle="modal" data-target="#restorePassword" class="link">Recuperala.</a>
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
                            
                            <div class="form-group">
                                Per andare avanti accenta la nostra <a data-toggle="modal" href="#PrivacyModal" class="link">Privacy Policy</a><br>                
                                <label for="privacy">Ho letto e acceto l'informativa sulla Privacy</label>         
                                <input required type="checkbox" tabindex="3" class="" name="privacy" id="privacy">
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
        <!-- Privacy Policy Modal -->
        <div class="modal fade" tabindex="-1" aria-hidden="true" id="PrivacyModal">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="title">Informativa sulla Privacy</h1>
                    </div>
                    <div class="modal-body-pcy">                                
                                <p>Data di entrata in vigore: November 02, 2018</p>
                                <p>myLists ("noi" o "nostro") gestisce il http://localhost:8080 sito web (in appresso il "Servizio").</p>
                                <p>Questa pagina vi informa delle nostre politiche riguardanti la raccolta, l'uso e la divulgazione dei dati personali quando usate il nostro Servizio e le scelte che avete associato a quei dati. <a href="https://www.freeprivacypolicy.com/free-privacy-policy-generator.php">Informativa sulla Privacy via Free Privacy Policy</a>.</p>
                                <p>Utilizziamo i vostri dati per fornire e migliorare il Servizio. Utilizzando il Servizio, accettate la raccolta e l'utilizzo delle informazioni in conformità con questa informativa. Se non diversamente definito nella presente Informativa sulla privacy, i termini utilizzati nella presente Informativa hanno la stessa valenza dei nostri Termini e condizioni, accessibili da http://localhost:8080</p>
                                <h2>Definizioni</h2>
                                <ul>
                                    <li>
                                        <p><strong>Servizio</strong></p>
                                        <p>Il Servizio è il sito http://localhost:8080 gestito da myLists</p>
                                    </li>
                                    <li>
                                        <p><strong>Dati personali</strong></p>
                                        <p>I Dati personali sono i dati di un individuo vivente che può essere identificato da quei dati (o da quelli e altre informazioni in nostro possesso o che potrebbero venire in nostro possesso).</p>
                                    </li>
                                    <li>
                                        <p><strong>Dati di utilizzo</strong></p>
                                        <p>I dati di utilizzo sono i dati raccolti automaticamente generati dall'utilizzo del Servizio o dall'infrastruttura del Servizio stesso (ad esempio, la durata della visita di una pagina).</p>
                                    </li>
                                    <li>
                                        <p><strong>Cookies</strong></p>
                                        <p>I cookie sono piccoli file memorizzati sul vostro dispositivo (computer o dispositivo mobile).</p>
                                    </li>
                                </ul>

                                <h2>Raccolta e uso delle informazioni</h2>
                                <p>Raccogliamo diversi tipi di informazioni per vari scopi, per fornire e migliorare il nostro servizio.</p>

                                <h3>Tipologie di Dati raccolti</h3>

                                <h4>Dati personali</h4>
                                <p>Durante l'utilizzo del nostro Servizio, potremmo chiedervi di fornirci alcune informazioni di identificazione personale che possono essere utilizzate per contattarvi o identificarvi ("Dati personali"). Le informazioni di identificazione personale possono includere, ma non sono limitate a:</p>

                                <ul>
                                    <li>Indirizzo email</li>    <li>Nome e cognome</li>            <li>Cookie e dati di utilizzo</li>
                                </ul>

                                <h4>Dati di utilizzo</h4>

                                <p>Potremmo anche raccogliere informazioni su come l'utente accede e utilizza il Servizio ("Dati di utilizzo"). Questi Dati di utilizzo possono includere informazioni quali l'indirizzo del protocollo Internet del computer (ad es. Indirizzo IP), il tipo di browser, la versione del browser, le pagine del nostro servizio che si visita, l'ora e la data della visita, il tempo trascorso su tali pagine, identificatore unico del dispositivo e altri dati diagnostici.</p>

                                <h4>Tracciamento; dati dei cookie</h4>
                                <p>Utilizziamo cookie e tecnologie di tracciamento simili per tracciare l'attività sul nostro Servizio e conservare determinate informazioni.</p>
                                <p>I cookie sono file con una piccola quantità di dati che possono includere un identificatore univoco anonimo. I cookie vengono inviati al vostro browser da un sito web e memorizzati sul vostro dispositivo. Altre tecnologie di tracciamento utilizzate sono anche beacon, tag e script per raccogliere e tenere traccia delle informazioni e per migliorare e analizzare il nostro Servizio.</p>
                                <p>Potete chiedere al vostro browser di rifiutare tutti i cookie o di indicare quando viene inviato un cookie. Tuttavia, se non si accettano i cookie, potrebbe non essere possibile utilizzare alcune parti del nostro Servizio.</p>
                                <p>Esempi di cookie che utilizziamo:</p>
                                <ul>
                                    <li><strong>Cookie di sessione.</strong> Utilizziamo i cookie di sessione per gestire il nostro servizio.</li>
                                    <li><strong>Cookie di preferenza.</strong> Utilizziamo i cookie di preferenza per ricordare le vostre preferenze e varie impostazioni.</li>
                                    <li><strong>Cookie di sicurezza.</strong> Utilizziamo i cookie di sicurezza per motivi di sicurezza.</li>
                                </ul>

                                <h2>Uso dei dati</h2> 
                                <p>myLists utilizza i dati raccolti per vari scopi:</p>    
                                <ul>
                                    <li>Per fornire e mantenere il nostro Servizio</li>
                                    <li>Per comunicare agli utenti variazioni apportate al servizio che offriamo</li>
                                    <li>Per permettere agli utenti di fruire, a propria discrezione, di funzioni interattive del nostro servizio</li>
                                    <li>Per fornire un servizio ai clienti</li>
                                    <li>Per raccogliere analisi o informazioni preziose in modo da poter migliorare il nostro Servizio</li>
                                    <li>Per monitorare l'utilizzo del nostro Servizio</li>
                                    <li>Per rilevare, prevenire e affrontare problemi tecnici</li>
                                </ul>
                                <h2>Trasferimento dei dati</h2>
                                <p>Le vostre informazioni, compresi i Dati personali, possono essere trasferite a - e mantenute su - computer situati al di fuori del vostro stato, provincia, nazione o altra giurisdizione governativa dove le leggi sulla protezione dei dati possono essere diverse da quelle della vostra giurisdizione.</p>
                                <p>Se ci si trova al di fuori di Italy e si sceglie di fornire informazioni a noi, si ricorda che trasferiamo i dati, compresi i dati personali, in Italy e li elaboriamo lì.</p>
                                <p>Il vostro consenso alla presente Informativa sulla privacy seguito dall'invio di tali informazioni rappresenta il vostro consenso al trasferimento.</p>
                                <p>myLists adotterà tutte le misure ragionevolmente necessarie per garantire che i vostri dati siano trattati in modo sicuro e in conformità con la presente Informativa sulla privacy e nessun trasferimento dei vostri Dati Personali sarà effettuato a un'organizzazione o a un paese a meno che non vi siano controlli adeguati dei vostri dati e altre informazioni personali.</p>
                                <h2>Divulgazione di dati</h2>
                                <h3>Prescrizioni di legge</h3>
                                <p>myLists può divulgare i vostri Dati personali in buona fede, ritenendo che tale azione sia necessaria per:</p>
                                <ul>
                                    <li>Rispettare un obbligo legale</li>
                                    <li>Proteggere e difendere i diritti o la proprietà di myLists</li>
                                    <li>Prevenire o investigare possibili illeciti in relazione al Servizio</li>
                                    <li>Proteggere la sicurezza personale degli utenti del Servizio o del pubblico</li>
                                    <li>Proteggere contro la responsabilità legale</li>
                                </ul>
                                <h2>Sicurezza dei dati</h2>
                                <p>La sicurezza dei vostri dati è importante per noi, ma ricordate che nessun metodo di trasmissione su Internet o metodo di archiviazione elettronica è sicuro al 100%. Pertanto, anche se adotteremo ogni mezzo commercialmente accettabile per proteggere i vostri Dati personali, non possiamo garantirne la sicurezza assoluta.</p>
                                <h2>Fornitori di servizi</h2>
                                <p>Potremmo impiegare società e individui di terze parti per facilitare il nostro Servizio ("Fornitori di servizi"), per fornire il Servizio per nostro conto, per eseguire servizi relativi ai Servizi o per aiutarci ad analizzare come viene utilizzato il nostro Servizio.</p>
                                <p>Le terze parti hanno accesso ai vostri Dati personali solo per eseguire queste attività per nostro conto e sono obbligate a non rivelarle o utilizzarle per altri scopi.</p>
                                <h2>Privacy dei minori</h2>
                                <p>Il nostro servizio non si rivolge a minori di 18 anni ("Bambini").</p>
                                <p>Non raccogliamo consapevolmente informazioni personali relative a utenti di età inferiore a 18 anni. Se siete un genitore o tutore e siete consapevoli che vostro figlio ci ha fornito Dati personali, vi preghiamo di contattarci. Se veniamo a conoscenza del fatto che abbiamo raccolto Dati personali da minori senza la verifica del consenso dei genitori, adotteremo provvedimenti per rimuovere tali informazioni dai nostri server.</p>
                                <h2>Modifiche alla presente informativa sulla privacy</h2>
                                <p>Potremmo aggiornare periodicamente la nostra Informativa sulla privacy. Ti informeremo di eventuali modifiche pubblicando la nuova Informativa sulla privacy in questa pagina.</p>
                                <p>Vi informeremo via e-mail e / o un avviso di rilievo sul nostro Servizio, prima che la modifica diventi effettiva e aggiorneremo la "data di validità" nella parte superiore di questa Informativa sulla privacy.</p>
                                <p>Si consiglia di rivedere periodicamente la presente Informativa sulla privacy per eventuali modifiche. Le modifiche a tale informativa sulla privacy entrano in vigore nel momento in cui vengono pubblicate su questa pagina.</p>
                        </div>
                    <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                            </div>
                    </div>
                </div>
            </div>
        </div>


        <!--######################################################-->
        
        <!-- restore password Modal -->
        <div class="modal fade" id="restorePassword" tabindex="-1" role="dialog" aria-labelledby="restorePassword" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">

                        <div class="page-title">
                            <div class="container">
                                <h1>Recupera la password</h1>
                            </div>
                            <!--end container-->
                        </div>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>            

                    </div>
                    <div class="modal-body">
                        <!-- Form per il login -->
                        <form class="form clearfix" id="login-form" action="/Lists/restorePassword" method="post" role="form">
                            <div class="form-group">
                                <label for="email" class="col-form-label required">Email</label>
                                <input type="text" name="email" id="emaillogin" tabindex="1" class="form-control" placeholder="Email" value="" required>
                            </div>
                            <!--end form-group-->
                            <div class="d-flex justify-content-between align-items-baseline">
                                <button style="float: left;" type="submit" class="btn btn-primary">Recupera password</button>
                                <button style="float: right;" type="button" class="btn btn-secondary" data-dismiss="modal">Chiudi</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <!--######################################################-->
        
        <!-- new password Modal -->
        <div class="modal fade" id="newPassword" tabindex="-1" role="dialog" aria-labelledby="newPassword" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">

                        <div class="page-title">
                            <div class="container">
                                <h1>Nuova password</h1>
                            </div>
                            <!--end container-->
                        </div>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>            

                    </div>
                    <div class="modal-body">
                        <h5>Nuova passworrd per <%=request.getParameter("restorePasswordOf")%></h5>
                        <!-- Form per il login -->
                        <form class="form clearfix" id="login-form" action="/Lists/changePassword" method="post" role="form">
                            <div class="form-group">
                                <label for="password" class="col-form-label required">Password</label>
                                <input type="password" name="password" id="emaillogin" tabindex="1" class="form-control" placeholder="Password" value="" required>
                                <input type="hidden" name="email" value="<%=request.getParameter("restorePasswordOf")%>">
                            </div>
                            <!--end form-group-->
                            <div class="d-flex justify-content-between align-items-baseline">
                                <button style="float: left;" type="submit" class="btn btn-primary">Recupera password</button>
                                <button style="float: right;" type="button" class="btn btn-secondary" data-dismiss="modal">Chiudi</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <!--######################################################-->


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
                            <%if(find){%>
                            <div class="form-group">
                                <label for="Immagine" class="col-form-label required">Immagine</label>
                                <input type="file" name="file1" required>
                            </div>
                            <%}%>
                            <!--end form-group-->
                            <div class="d-flex justify-content-between align-items-baseline">

                                <button type="submit" name="register-submit" id="create-list-submit" tabindex="4" class="btn btn-primary">Crea lista</button>

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

            <script type="text/javascript" src="http://maps.google.com/maps/api/js?key=AIzaSyBEDfNcQRmKQEyulDN8nGWjLYPm8s4YB58&libraries=places"></script>
            <!--<script type="text/javascript" src="http://maps.google.com/maps/api/js"></script>-->
            <script src="Pages/js/selectize.min.js"></script>
            <script src="Pages/js/masonry.pkgd.min.js"></script>
            <script src="Pages/js/icheck.min.js"></script>
            <script src="Pages/js/jquery.validate.min.js"></script>
            <script src="Pages/js/custom.js"></script>
            <script src="Pages/js/vari.js"></script>
            <script src="Pages/js/nav.js"></script>

            <script type="text/javascript">
                $(document).ready (function(){
                $("#alert").hide();

                $("#alert").fadeTo(10000, 500).slideUp(500, function(){
                $("#alert").slideUp(500);
                });   

                });
            </script>
            
            <script>
                 $(document).ready (function(){
                <%if(request.getParameter("restorePasswordOf") != null){%>
                    $('#newPassword').modal('show'); 
                <%}%>
                });
            </script>
            

            <!--###############################################################################################################################
                                CHIUSURA DATABASE
            ###############################################################################################################################-->            
   
            <!--###############################################################################################################################-->

    </body>
</html>

