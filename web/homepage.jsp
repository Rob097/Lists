<%-- 
    Document   : homepage
    Created on : 16-giu-2018, 18.28.06
    Author     : Roberto97
--%>

<%@page import="database.jdbc.JDBCCategoryDAO"%>
<%@page import="database.daos.CategoryDAO"%>
<%@page import="database.entities.Category"%>
<%@page import="database.entities.Category_Product"%>
<%@page import="database.jdbc.JDBCCategory_ProductDAO"%>
<%@page import="database.daos.Category_ProductDAO"%>
<%@page import="database.entities.Product"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.ArrayList"%>
<%@page import="database.entities.User"%>
<%@page import="database.jdbc.JDBCUserDAO"%>
<%@page import="database.jdbc.JDBCShopListDAO"%>
<%@page import="database.jdbc.JDBCProductDAO"%>
<%@page import="database.daos.ProductDAO"%>
<%@page import="database.daos.ListDAO"%>
<%@page import="database.daos.UserDAO"%>
<%@page import="database.factories.DAOFactory"%>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!doctype html>
<html lang="en">
<head>
	<meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="author" content="ThemeStarz">

    <link href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700|Varela+Round" rel="stylesheet">
    <link rel="stylesheet" href="Pages/bootstrap/css/bootstrap.css" type="text/css">
    <link rel="stylesheet" href="Pages/fonts/font-awesome.css" type="text/css">
    <link rel="stylesheet" href="Pages/css/selectize.css" type="text/css">
    <link rel="stylesheet" href="Pages/css/style.css">
    <link rel="stylesheet" href="Pages/css/user.css">  
    <link rel="stylesheet" href="Pages/css/navbar.css">  
    <link rel="icon" href="Pages/img/favicon.png" sizes="16x16" type="image/png">
    <script src="Pages/js/jquery-3.3.1.min.js"></script>
    <script type="text/javascript" src="Pages/js/popper.min.js"></script>
    <script type="text/javascript" src="Pages/bootstrap/js/bootstrap.min.js"></script>
        
    <title>Lists</title>
    
    <!--apre subito il LoginModal se i dati inseriti non sono essistenti nel database-->
    <c:if test="${loginResult==false}">
        <script type="text/javascript">
            $(document).ready(function(){
                $("#LoginModal").modal('show');
            });
        </script>
    </c:if>
    
</head>
<body>
    <!--###############################################################################################################################
                            CONNESSIONE DATABASE
        ###############################################################################################################################-->    
        <%
            Connection conn = null;
            Statement stmt = null;
            try {
                Class.forName("com.mysql.jdbc.Driver");
                String url = "jdbc:mysql://ourlists.ddns.net:3306/ourlists?zeroDateTimeBehavior=convertToNull";
                String username = "user";
                String password = "the_password";
                conn = DriverManager.getConnection(url, username, password);
                stmt = conn.createStatement();
                
            }catch (Exception e) {
                System.out.println("Causa Connessione: ");
                e.printStackTrace();
            }            
        %>
        
        <%
            DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
            if (daoFactory == null) {
                throw new ServletException("Impossible to get dao factory for user storage system");
            }
            ListDAO listdao = new JDBCShopListDAO(daoFactory.getConnection());
            ProductDAO productdao = new JDBCProductDAO(daoFactory.getConnection());
            Category_ProductDAO category_productdao = new JDBCCategory_ProductDAO(daoFactory.getConnection());
            CategoryDAO categorydao = new JDBCCategoryDAO(daoFactory.getConnection());
            
            HttpSession s = (HttpSession) request.getSession();
            
           ArrayList<Category> li = categorydao.getAllCategories();
           ArrayList<Product> prod = productdao.getAllProducts();
           
        %>
        <!--###############################################################################################################################-->
       
        
    <div class="page home-page">
        <header class="hero">
            <div class="hero-wrapper">
                
                <!--============ Secondary Navigation ===============================================================-->
                <!-- Barra di navigazione fissata in alto tema scuro -->
                <nav class="navbar navbar-expand-xl navbar-dark fixed-top " id="mainNav">
                    <a class="navbar-brand">
                        <img width= "50" src="Pages/img/favicon.png" alt="Logo">
                    </a>
                    <a class="navbar-brand js-scroll-trigger" href="#home">LISTS</a>
                    <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
                        Menu
                        <i class="fa fa-bars"></i>
                    </button>
                    <div class="collapse navbar-collapse" id="navbarResponsive">
                        <ul class="navbar-nav text-uppercase ml-auto text-center">
                            <li class="nav-item">
                                <a href="submit.html" class="btn btn-primary text-caps btn-rounded" >+ Lista</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link js-scroll-trigger" href="#lists"><b>Le mie liste</b></a>
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
                
                <!--============ End Secondary Navigation ===========================================================-->
                <!--============ Main Navigation ====================================================================-->
                <c:if test="${regResult==true}">
                <div class="alert alert-success">
                        <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
                        <strong>Successful Registration!</strong> You can now log in in your account.
                </div>
                </c:if> 
                
                <!--<div class="main-navigation">
                    <div class="container">
                        <nav class="navbar navbar-expand-lg navbar-light justify-content-between">
                            <a class="navbar-brand" href="index.html">
                                <img src="Pages/img/logo.png" alt="">
                            </a>
                            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar" aria-controls="navbar" aria-expanded="false" aria-label="Toggle navigation">
                                <span class="navbar-toggler-icon"></span>
                            </button>
                            <div class="collapse navbar-collapse" id="navbar">
                                <!--Main navigation list
                                <ul class="navbar-nav">
                                    <li class="nav-item">
                                        <a class="nav-link" href="homepage.jsp">home</a>
                                    </li>
                                    <li class="nav-item has-child">
                                        <a class="nav-link" href="#">Listing</a>
                                        <!-- 1st level 
                                        
                                    </li>
                                    <li class="nav-item has-child">
                                        <a class="nav-link" href="#">Pages</a>
                                        <!-- 2nd level 
                                        
                                    </li>
                                    <li class="nav-item has-child">
                                        <a class="nav-link" href="#">Extras</a>
                                        <!--1st level 
                                        
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" href="contact.html">Contact</a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="submit.html" class="btn btn-primary text-caps btn-rounded">Submit Ad</a>
                                    </li>
                                </ul>
                                <!--Main navigation list
                            </div>
                            <!--end navbar-collapse
                        </nav>
                        <!--end navbar
                    </div>
                    <!--end container
                </div>-->
                <!--============ End Main Navigation ================================================================-->
                <!--============ Page Title =========================================================================-->
                <div class="page-title">
                    <div class="container">
                        <h1 class="opacity-60 center">
                            Your own<a href="#"> Lists</a>
                        </h1><br>
                        <div class="row">
                            <%
                                ResultSet users = null;
                                try {
                                    String query = "select * from User";
                                    users = stmt.executeQuery(query);
                                    while (users.next()) {
                            %>
                            <div class="col-xl col-lg col-md col-sm col"

                                 <br><h5 style="color: red"><%=users.getRow()%>° Record:</h5> 
                                

                                
                                <img src="<%=users.getString("immagine")%>" width= "70px" height="70px" style="border-radius: 100%;">
                                <h6>Email: <%=users.getString("email")%><br>
                                    Password: <%=users.getString("password")%><br>
                                    Nominativo: <%=users.getString("nominativo")%><br>
                                    Tipo: <%=users.getString("tipo")%><br></h6>
                            </div>
                 
                            

                            
                <%
                        }//while
                    } catch (Exception e) {
                        System.out.println("Causa Dati0 ");
                        e.printStackTrace();
                    }   %>
                        </p>
                    </div>
                    <!--end container-->
                </div>

                <!--============ End Page Title =====================================================================-->
                <!--============ Hero Form ==========================================================================-->
                <form class="hero-form form">
                    <div class="container">
                        <!--Main Form-->
                        <div class="main-search-form">
                            <div class="form-row">
                                <div class="col-md-9 col-sm-9">
                                    <div class="form-group">
                                        <label for="what" class="col-form-label">What Are You Looking For?</label>
                                        <input name="keyword" type="text" class="form-control" id="what" placeholder="Enter Anything">
                                    </div>
                                    <!--end form-group-->
                                </div>
                                <!--end col-md-3-->
                                <div class="col-md-3 col-sm-3">
                                    <button type="submit" class="btn btn-primary width-100">Search</button>
                                </div>
                                <!--end col-md-3-->
                            </div>
                            <!--end form-row-->
                        </div>
                        <!--end main-search-form-->
                        <!--Alternative Form-->
                        <div class="alternative-search-form">
                            <a href="#collapseAlternativeSearchForm" class="icon" data-toggle="collapse"  aria-expanded="false" aria-controls="collapseAlternativeSearchForm"><i class="fa fa-plus"></i>More Options</a>
                            <div class="collapse" id="collapseAlternativeSearchForm">
                                <div class="wrapper">
                                    <div class="form-row">
                                        <div class="col-xl-6 col-lg-12 col-md-12 col-sm-12 d-xs-grid d-flex align-items-center justify-content-between">
                                            <label>
                                                <input type="checkbox" name="new">
                                                New
                                            </label>
                                            <label>
                                                <input type="checkbox" name="used">
                                                Used
                                            </label>
                                            <label>
                                                <input type="checkbox" name="with_photo">
                                                With Photo
                                            </label>
                                            <label>
                                                <input type="checkbox" name="featured">
                                                Featured
                                            </label>
                                        </div>
                                        <!--end col-xl-6-->
                                        <div class="col-xl-6 col-lg-12 col-md-12 col-sm-12">
                                            <div class="form-row">
                                                <div class="col-md-4 col-sm-4">
                                                    <div class="form-group">
                                                        <input name="min_price" type="text" class="form-control small" id="min-price" placeholder="Minimal Price">
                                                        <span class="input-group-addon small">$</span>
                                                    </div>
                                                    <!--end form-group-->
                                                </div>
                                                <!--end col-md-4-->
                                                <div class="col-md-4 col-sm-4">
                                                    <div class="form-group">
                                                        <input name="max_price" type="text" class="form-control small" id="max-price" placeholder="Maximal Price">
                                                        <span class="input-group-addon small">$</span>
                                                    </div>
                                                    <!--end form-group-->
                                                </div>
                                                <!--end col-md-4-->
                                                <div class="col-md-4 col-sm-4">
                                                    <div class="form-group">
                                                        <select name="distance" id="distance" class="small" data-placeholder="Distance" >
                                                            <option value="">Distance</option>
                                                            <option value="1">1km</option>
                                                            <option value="2">5km</option>
                                                            <option value="3">10km</option>
                                                            <option value="4">50km</option>
                                                            <option value="5">100km</option>
                                                        </select>
                                                    </div>
                                                    <!--end form-group-->
                                                </div>
                                                <!--end col-md-3-->
                                            </div>
                                            <!--end form-row-->
                                        </div>
                                        <!--end col-xl-6-->
                                    </div>
                                    <!--end row-->
                                </div>
                                <!--end wrapper-->
                            </div>
                            <!--end collapse-->
                        </div>
                        <!--end alternative-search-form-->
                    </div>
                    <!--end container-->
                </form>
                <!--============ End Hero Form ======================================================================-->
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
            <!--============ Categories =============================================================================-->
            <section class="block">
                <div class="container">
                    <h2>Categorie</h2>
                    
                    <ul class="categories-list clearfix">
                        <%for(Category p: li){%>
                        <li>
                            <img src="<%= p.getImmagine() %>" alt="">
                            <h3><a href="#"><%= p.getNome()%></a></h3>
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
            <!--end block-->
            <!--============ End Categories =========================================================================-->
            <!--============ Featured Ads ===========================================================================-->
            <section class="block">
                <div class="container">
                    <h2>I più visti</h2>
                    <div class="items grid grid-xl-3-items grid-lg-3-items grid-md-2-items">
                    <%
                    for(Product p: prod){
                        if(p.getPid() == 1 || p.getPid() == 2|| p.getPid() == 3){
                    %>    
                        
                        <div class="item">
                            <div class="wrapper">
                                <div class="image">
                                    <h3>
                                        <a href="#" class="tag category"><%= p.getCategoria_prodotto() %></a>
                                        <a href="single-listing-1.html" class="title"><%= p.getNome() %> </a>
                                    </h3>
                                    <a href="single-listing-1.html" class="image-wrapper background-image">
                                        <img src="<%= p.getImmagine() %>" alt="">
                                    </a>
                                </div>
                                <!--end image-->
                                <div class="price">$80</div>
                                <div class="meta">
                                    <figure>
                                        <i class="fa fa-calendar-o"></i>02.05.2017
                                    </figure>
                                    <figure>
                                        <a href="#">
                                            <i class="fa fa-user"></i>Jane Doe
                                        </a>
                                    </figure>
                                </div>
                                <!--end meta-->
                                <div class="description">
                                    <p><%= p.getNote() %></p>
                                </div>
                                <!--end description-->
                                <a href="single-listing-1.html" class="detail text-caps underline">Detail</a>
                            </div>
                        </div>
                        <!--end item-->
                        <%
                            }
                        }
                        %>

                    </div>
                </div>
                <div class="background" data-background-color="#fff"></div>
                <!--end background-->
            </section>
            <!--============ End Featured Ads =======================================================================-->
            <!--============ Features Steps =========================================================================-->
            <section class="block has-dark-background">
                <div class="container">
                    <div class="block">
                        <h2>Crea le tue liste della spesa</h2>
                        <div class="row">
                            <div class="col-md-3">
                                <div class="feature-box">
                                    <figure>
                                        <img src="Pages/icons/feature-user.png" alt="">
                                        <span>1</span>
                                    </figure>
                                    <h3>Crea un Account</h3>
                                    <p>Scegli che tipo di utente vuoi essere</p>
                                </div>
                                <!--end feature-box-->
                            </div>
                            <!--end col-->
                            <div class="col-md-3">
                                <div class="feature-box">
                                    <figure>
                                        <img src="Pages/icons/feature-upload.png" alt="">
                                        <span>2</span>
                                    </figure>
                                    <h3>Crea una lista</h3>
                                    <p>Crea la tua lista personalizzata</p>
                                </div>
                                <!--end feature-box-->
                            </div>
                            <!--end col-->
                            <div class="col-md-3">
                                <div class="feature-box">
                                    <figure>
                                        <img src="Pages/icons/feature-like.png" alt="">
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
                                        <img src="Pages/icons/feature-wallet.png" alt="">
                                        <span>4</span>
                                    </figure>
                                    <h3>Vai ad acquistare quello che ti serve</h3>
                                    <p>Ricevi delle notifiche quando sei nei pressi di un negozio!</p>
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
            <!--============ Recent Ads =============================================================================-->
            <section class="block">
                <div class="container">
                    <h2>Recent Ads</h2>
                    <div class="items grid grid-xl-4-items grid-lg-3-items grid-md-2-items">
                        <div class="item">
                            <div class="wrapper">
                                <div class="image">
                                    <h3>
                                        <a href="#" class="tag category">Real Estate</a>
                                        <a href="single-listing-1.html" class="title">Luxury Apartment</a>
                                        <span class="tag">Offer</span>
                                    </h3>
                                    <a href="single-listing-1.html" class="image-wrapper background-image">
                                        <img src="Pages/img/image-04.jpg" alt="">
                                    </a>
                                </div>
                                <!--end image-->
                                <h4 class="location">
                                    <a href="#">Greeley, CO</a>
                                </h4>
                                <div class="price">$75,000</div>
                                <div class="meta">
                                    <figure>
                                        <i class="fa fa-calendar-o"></i>13.03.2017
                                    </figure>
                                    <figure>
                                        <a href="#">
                                            <i class="fa fa-user"></i>Hills Estate
                                        </a>
                                    </figure>
                                </div>
                                <!--end meta-->
                                <div class="description">
                                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam venenatis lobortis</p>
                                </div>
                                <!--end description-->
                                <div class="additional-info">
                                    <ul>
                                        <li>
                                            <figure>Area</figure>
                                            <aside>368m<sup>2</sup></aside>
                                        </li>
                                        <li>
                                            <figure>Bathrooms</figure>
                                            <aside>2</aside>
                                        </li>
                                        <li>
                                            <figure>Bedrooms</figure>
                                            <aside>3</aside>
                                        </li>
                                        <li>
                                            <figure>Garage</figure>
                                            <aside>1</aside>
                                        </li>
                                    </ul>
                                </div>
                                <!--end addition-info-->
                                <a href="single-listing-1.html" class="detail text-caps underline">Detail</a>
                            </div>
                        </div>
                        <!--end item-->

                        <div class="item">
                            <div class="wrapper">
                                <div class="image">
                                    <h3>
                                        <a href="#" class="tag category">Architecture</a>
                                        <a href="single-listing-1.html" class="title">We'll Redesign Your Apartment</a>
                                        <span class="tag">Offer</span>
                                    </h3>
                                    <a href="single-listing-1.html" class="image-wrapper background-image">
                                        <img src="Pages/img/image-05.jpg" alt="">
                                    </a>
                                </div>
                                <!--end image-->
                                <h4 class="location">
                                    <a href="#">Greeley, CO</a>
                                </h4>
                                <div class="price">
                                    <span class="appendix">From</span>
                                    $200
                                </div>
                                <div class="meta">
                                    <figure>
                                        <i class="fa fa-calendar-o"></i>13.03.2017
                                    </figure>
                                    <figure>
                                        <a href="#">
                                            <i class="fa fa-user"></i>XL Designers
                                        </a>
                                    </figure>
                                </div>
                                <!--end meta-->
                                <div class="description">
                                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam venenatis lobortis</p>
                                </div>
                                <!--end description-->
                                <div class="additional-info">
                                    <ul>
                                        <li>
                                            <figure>Area</figure>
                                            <aside>368m<sup>2</sup></aside>
                                        </li>
                                        <li>
                                            <figure>Bathrooms</figure>
                                            <aside>2</aside>
                                        </li>
                                        <li>
                                            <figure>Bedrooms</figure>
                                            <aside>3</aside>
                                        </li>
                                    </ul>
                                </div>
                                <!--end addition-info-->
                                <a href="single-listing-1.html" class="detail text-caps underline">Detail</a>
                            </div>
                        </div>
                        <!--end item-->

                        <div class="item">
                            <div class="ribbon-featured">Featured</div>
                            <!--end ribbon-->
                            <div class="wrapper">
                                <div class="image">
                                    <h3>
                                        <a href="#" class="tag category">Jobs</a>
                                        <a href="single-listing-1.html" class="title">Seeking for a Job</a>
                                        <span class="tag">Demand</span>
                                    </h3>
                                    <a href="single-listing-1.html" class="image-wrapper background-image">
                                        <img src="Pages/img/image-06.jpg" alt="">
                                    </a>
                                </div>
                                <!--end image-->
                                <h4 class="location">
                                    <a href="#">Delavan, IL</a>
                                </h4>
                                <div class="price">$1,200</div>
                                <div class="meta">
                                    <figure>
                                        <i class="fa fa-calendar-o"></i>10.03.2017
                                    </figure>
                                    <figure>
                                        <a href="#">
                                            <i class="fa fa-user"></i>Aurelio Thomas
                                        </a>
                                    </figure>
                                </div>
                                <!--end meta-->
                                <div class="description">
                                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam venenatis lobortis</p>
                                </div>
                                <!--end description-->
                                <div class="additional-info">
                                    <ul>
                                        <li>
                                            <figure>Degree</figure>
                                            <aside>Bachelor’s</aside>
                                        </li>
                                        <li>
                                            <figure>Category</figure>
                                            <aside>Art & Design</aside>
                                        </li>
                                        <li>
                                            <figure>Experience</figure>
                                            <aside>5 years</aside>
                                        </li>
                                        <li>
                                            <figure>Language</figure>
                                            <aside>English, German</aside>
                                        </li>
                                    </ul>
                                </div>
                                <!--end addition-info-->
                                <a href="single-listing-1.html" class="detail text-caps underline">Detail</a>
                            </div>
                        </div>
                        <!--end item-->

                        <div class="item">
                            <div class="wrapper">
                                <div class="image">
                                    <h3>
                                        <a href="#" class="tag category">Pets & Animals</a>
                                        <a href="single-listing-1.html" class="title">Baby Cats</a>
                                        <span class="tag">Offer</span>
                                    </h3>
                                    <a href="single-listing-1.html" class="image-wrapper background-image">
                                        <img src="Pages/img/image-07.jpg" alt="">
                                    </a>
                                </div>
                                <!--end image-->
                                <h4 class="location">
                                    <a href="#">Detroit, MI</a>
                                </h4>
                                <div class="price">
                                    <span class="appendix">From</span>
                                    $80
                                </div>
                                <div class="meta">
                                    <figure>
                                        <i class="fa fa-calendar-o"></i>23.02.2017
                                    </figure>
                                    <figure>
                                        <a href="#">
                                            <i class="fa fa-user"></i>Detroit Pet Center
                                        </a>
                                    </figure>
                                </div>
                                <!--end meta-->
                                <div class="description">
                                    <p>Pellentesque ullamcorper justo quis bibendum
                                        consequat. Integer id euismod lacus, facilisis faucibus urna.
                                    </p>
                                </div>
                                <!--end description-->
                                <div class="additional-info">
                                    <ul>
                                        <li>
                                            <figure>Age</figure>
                                            <aside>2 weeks</aside>
                                        </li>
                                    </ul>
                                </div>
                                <!--end addition-info-->
                                <a href="single-listing-1.html" class="detail text-caps underline">Detail</a>
                            </div>
                        </div>
                        <!--end item-->

                        <div class="item">
                            <div class="wrapper">
                                <div class="image">
                                    <h3>
                                        <a href="#" class="tag category">Mobiles</a>
                                        <a href="single-listing-1.html" class="title">Used Smartphone</a>
                                        <span class="tag">Offer</span>
                                    </h3>
                                    <a href="single-listing-1.html" class="image-wrapper background-image">
                                        <img src="Pages/img/image-08.jpg" alt="">
                                    </a>
                                </div>
                                <!--end image-->
                                <h4 class="location">
                                    <a href="#">West Roxbury, MA</a>
                                </h4>
                                <div class="price">$300</div>
                                <div class="meta">
                                    <figure>
                                        <i class="fa fa-calendar-o"></i>28.02.2017
                                    </figure>
                                    <figure>
                                        <a href="#">
                                            <i class="fa fa-user"></i>Gloria A. Crawford
                                        </a>
                                    </figure>
                                </div>
                                <!--end meta-->
                                <div class="description">
                                    <p>Vestibulum congue at justo semper dignissim. Pellentesque ullamcorper justo quis bibendum
                                        consequat. Integer id euismod lacus, facilisis faucibus urna.
                                    </p>
                                </div>
                                <!--end description-->
                                <div class="additional-info">
                                    <ul>
                                        <li>
                                            <figure>Status</figure>
                                            <aside>Used</aside>
                                        </li>
                                        <li>
                                            <figure>Brand</figure>
                                            <aside>Samsung</aside>
                                        </li>
                                    </ul>
                                </div>
                                <!--end addition-info-->
                                <a href="single-listing-1.html" class="detail text-caps underline">Detail</a>
                            </div>
                        </div>
                        <!--end item-->

                        <div class="item">
                            <div class="wrapper">
                                <div class="image">
                                    <h3>
                                        <a href="#" class="tag category">Cars</a>
                                        <a href="single-listing-1.html" class="title">Offroad Car</a>
                                        <span class="tag">Offer</span>
                                    </h3>
                                    <a href="single-listing-1.html" class="image-wrapper background-image">
                                        <img src="Pages/img/image-09.jpg" alt="">
                                    </a>
                                </div>
                                <!--end image-->
                                <h4 class="location">
                                    <a href="#">Nehalem, OR</a>
                                </h4>
                                <div class="price">$30,000</div>
                                <div class="meta">
                                    <figure>
                                        <i class="fa fa-calendar-o"></i>14.01.2017
                                    </figure>
                                    <figure>
                                        <a href="#">
                                            <i class="fa fa-user"></i>Leonardo
                                        </a>
                                    </figure>
                                </div>
                                <!--end meta-->
                                <div class="description">
                                    <p>Nam eget imperdiet massa. Cras dolor nulla, tristique eu nisl ut, venenatis volutpat massa.
                                        Integer imperdiet finibus ipsum vitae scelerisque.
                                    </p>
                                </div>
                                <!--end description-->
                                <div class="additional-info">
                                    <ul>
                                        <li>
                                            <figure>Brand</figure>
                                            <aside>Jeep</aside>
                                        </li>
                                        <li>
                                            <figure>Engine</figure>
                                            <aside>Diesel</aside>
                                        </li>
                                        <li>
                                            <figure>Mileage</figure>
                                            <aside>28,630</aside>
                                        </li>
                                    </ul>
                                </div>
                                <!--end addition-info-->
                                <a href="single-listing-1.html" class="detail text-caps underline">Detail</a>
                            </div>
                        </div>
                        <!--end item-->

                        <div class="item">
                            <div class="wrapper">
                                <div class="image">
                                    <h3>
                                        <a href="#" class="tag category">Clothing</a>
                                        <a href="single-listing-1.html" class="title">High Boots</a>
                                        <span class="tag">Offer</span>
                                    </h3>
                                    <a href="single-listing-1.html" class="image-wrapper background-image">
                                        <img src="Pages/img/image-10.jpg" alt="">
                                    </a>
                                </div>
                                <!--end image-->
                                <h4 class="location">
                                    <a href="#">Raleigh, NC</a>
                                </h4>
                                <div class="price">$67</div>
                                <div class="meta">
                                    <figure>
                                        <i class="fa fa-calendar-o"></i>05.01.2017
                                    </figure>
                                    <figure>
                                        <a href="#">
                                            <i class="fa fa-user"></i>Bobby
                                        </a>
                                    </figure>
                                </div>
                                <!--end meta-->
                                <div class="description">
                                    <p>Nam pulvinar mollis tortor, eu lobortis mauris luctus non. Integer lobortis sapien enim,
                                        ut imperdiet leo faucibus id. Fusce tincidunt nunc elit, at varius erat rutrum vitae.
                                    </p>
                                </div>
                                <!--end description-->
                                <div class="additional-info">
                                    <ul>
                                        <li>
                                            <figure>Status</figure>
                                            <aside>Used</aside>
                                        </li>
                                        <li>
                                            <figure>Material</figure>
                                            <aside>Genuine Leather</aside>
                                        </li>
                                        <li>
                                            <figure>Size</figure>
                                            <aside>10</aside>
                                        </li>
                                    </ul>
                                </div>
                                <!--end addition-info-->
                                <a href="single-listing-1.html" class="detail text-caps underline">Detail</a>
                            </div>
                        </div>
                        <!--end item-->

                        <div class="item">
                            <div class="wrapper">
                                <div class="image">
                                    <h3>
                                        <a href="#" class="tag category">Books & Magazines</a>
                                        <a href="single-listing-1.html" class="title">Will Buy "Behind the Sea" Book</a>
                                        <span class="tag">Demand</span>
                                    </h3>
                                    <a href="single-listing-1.html" class="image-wrapper background-image">
                                        <img src="Pages/img/image-11.jpg" alt="">
                                    </a>
                                </div>
                                <!--end image-->
                                <h4 class="location">
                                    <a href="#">Long Beach, CA</a>
                                </h4>
                                <div class="price">$30</div>
                                <div class="meta">
                                    <figure>
                                        <i class="fa fa-calendar-o"></i>02.01.2017
                                    </figure>
                                    <figure>
                                        <a href="#">
                                            <i class="fa fa-user"></i>Patty McAlexander
                                        </a>
                                    </figure>
                                </div>
                                <!--end meta-->
                                <div class="description">
                                    <p>Mauris nisi ligula, pulvinar eu commodo eu, semper id quam. In vitae purus bibendum,
                                        mattis ex nec, eleifend diam. Cras at vehicula metus. Sed elementum lectus ut aliquet vehicula.
                                    </p>
                                </div>
                                <!--end description-->
                                <a href="single-listing-1.html" class="detail text-caps underline">Detail</a>
                            </div>
                        </div>
                        <!--end item-->
                    </div>
                </div>
                <!--end container-->
            </section>
            <!--end block-->
            <!--============ End Recent Ads =========================================================================-->
            <!--============ Newsletter =============================================================================-->
            <section class="block">
                <div class="container">
                    <div class="box has-dark-background">
                        <div class="row align-items-center justify-content-center d-flex">
                            <div class="col-md-10 py-5">
                                <h2>Get the Latest Ads in Your Inbox</h2>
                                <form class="form email">
                                    <div class="form-row">
                                        <div class="col-md-4 col-sm-4">
                                            <div class="form-group">
                                                <label for="newsletter-category" class="col-form-label">Category?</label>
                                                <select name="newsletter-category" id="newsletter-category" data-placeholder="Select Category" >
                                                    <% Category c;
                                                    for(int i = 3; i < 4; i++){
                                                            c = li.get(i); %>
                                                            <option value=""><%= c.getNome() %></option>
                                                    <%}%>
                                                </select>
                                            </div>
                                            <!--end form-group-->
                                        </div>
                                        <!--end col-md-4-->
                                        <div class="col-md-7 col-sm-7">
                                            <div class="form-group">
                                                <label for="newsletter-email" class="col-form-label">Your Email</label>
                                                <input name="newsletter-email" type="email" class="form-control" id="newsletter-email" placeholder="Your Email">
                                            </div>
                                            <!--end form-group-->
                                        </div>
                                        <!--end col-md-9-->
                                        <div class="col-md-1 col-sm-1">
                                            <div class="form-group">
                                                <label class="invisible">.</label>
                                                <button type="submit" class="btn btn-primary width-100"><i class="fa fa-chevron-right"></i></button>
                                            </div>
                                            <!--end form-group-->
                                        </div>
                                        <!--end col-md-9-->
                                    </div>
                                </form>
                                <!--end form-->
                            </div>
                        </div>
                        <div class="background">
                            <div class="background-image">
                                <img src="Pages/img/hero-background-image-01.jpg" alt="">
                            </div>
                            <!--end background-image-->
                        </div>
                        <!--end background-->
                    </div>
                    <!--end box-->
                </div>
                <!--end container-->
            </section>
            <!--end block-->

            <section class="block">
                <div class="container">
                    <div class="d-flex align-items-center justify-content-around">
                        <a href="#">
                            <img src="Pages/img/partner-1.png" alt="">
                        </a>
                        <a href="#">
                            <img src="Pages/img/partner-2.png" alt="">
                        </a>
                        <a href="#">
                            <img src="Pages/img/partner-3.png" alt="">
                        </a>
                        <a href="#">
                            <img src="Pages/img/partner-4.png" alt="">
                        </a>
                        <a href="#">
                            <img src="Pages/img/partner-5.png" alt="">
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
                        <input type="text" name="email" id="email" tabindex="1" class="form-control" placeholder="Email" value="" required>
                    </div>
                    <!--end form-group-->
                    <div class="form-group">
                        <label for="password" class="col-form-label required">Password</label>
                        <input type="password" name="password" id="password" tabindex="2" class="form-control" placeholder="Password" required>
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
                    <form class="form clearfix" id="login-form" action="/Lists/RegisterAction" method="post" enctype="multipart/form-data" onsubmit="return checkCheckBoxes(this);">
                        <div class="form-group">
                            <label for="email" class="col-form-label">Email</label>
                            <input type="email" name="email" id="email" tabindex="1" class="form-control" placeholder="Email" value="" required>
                        </div>
                        <!--end form-group-->
                        <div class="form-group">
                            <label for="nominativo" class="col-form-label">Nome</label>
                            <input type="text" name="nominativo" id="nominativo" tabindex="1" class="form-control" placeholder="Nome" value="" required>
                        </div>
                        <!--end form-group-->
                        <div class="form-group">
                            <label for="password" class="col-form-label">Password</label>
                            <input type="password" name="password" id="password" tabindex="2" class="form-control" placeholder="Password" required>
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

	
        <script type="text/javascript" src="http://maps.google.com/maps/api/js?key=AIzaSyBEDfNcQRmKQEyulDN8nGWjLYPm8s4YB58&libraries=places"></script>
    <!--<script type="text/javascript" src="http://maps.google.com/maps/api/js"></script>-->
	<script src="Pages/js/selectize.min.js"></script>
	<script src="Pages/js/masonry.pkgd.min.js"></script>
	<script src="Pages/js/icheck.min.js"></script>
	<script src="Pages/js/jquery.validate.min.js"></script>
	<script src="Pages/js/custom.js"></script>
        <script src="Pages/js/vari.js"></script>
        <script src="Pages/js/nav.js"></script>
        
        
        
        <!--###############################################################################################################################
                            CHIUSURA DATABASE
        ###############################################################################################################################-->            
            <%
                try {
                    stmt.close();
                    conn.close();
                } catch (Exception e) {
                    System.out.println("Causa Chiusura ");
                    e.printStackTrace();
                }
            %>    
        <!--###############################################################################################################################-->

</body>
</html>

