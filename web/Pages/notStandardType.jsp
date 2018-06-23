<%-- 
    Document   : standardType
    Created on : 15-giu-2018, 17.13.06
    Author     : Roberto97
--%>

<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        
        <!-- CSS personalizzati -->
        <link href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700|Varela+Round" rel="stylesheet">
        <link rel="stylesheet" href="bootstrap/css/bootstrap.css" type="text/css">
        <link rel="stylesheet" href="fonts/font-awesome.css" type="text/css">
        <link rel="stylesheet" href="css/selectize.css" type="text/css">
        <link rel="stylesheet" href="css/style.css">
        <link rel="stylesheet" href="css/user.css">
    </head>
    <body>
        <!--###############################################################################################################################
                            CONNESSIONE DATABASE
        ###############################################################################################################################-->    
        <%
            Connection conn = null;
            Statement stmt = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                String url = "jdbc:mysql://sql2.freemysqlhosting.net:3306/sql2243047?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC&autoReconnect=true&useSSL=false";
                String username = "sql2243047";
                String password = "mJ9*fQ4%";
                conn = DriverManager.getConnection(url, username, password);
                stmt = conn.createStatement();
                
            }catch (Exception e) {
                out.println("Causa Connessione: ");
                e.printStackTrace();
            }            
        %>
        <!--###############################################################################################################################-->
        
        
        
        
        <%
            Cookie cookie = null;
            Cookie[] cookies = null;
            
            
            // Get an array of Cookies associated with the this domain
            cookies = request.getCookies();           
            String Nominativo = "";
            String Email = "";
            String Type = "";
            String Image = "";
            if( cookies != null ) {
                for (int i = 0; i < cookies.length; i++) {                       
                        cookie = cookies[i];
                        if(cookie.getName().equals("JSESSIONID"));
                        else{   if (cookie.getName().equals("Nominativo")) Nominativo += cookie.getValue();
                                if (cookie.getName().equals("Email")) Email += cookie.getValue();
                                if (cookie.getName().equals("Type")) Type += cookie.getValue();
                                if (cookie.getName().equals("Image")) Image += cookie.getValue();
                        }
                }
            } else {
                System.out.println("<h2>No cookies founds</h2>");
            }
        %>

        <div class="page home-page">
        <header class="hero">
            <div class="hero-wrapper">
                
                <!--============ Secondary Navigation ===============================================================-->
                <div class="secondary-navigation sticky-top">
                    <div class="container">
                        <ul class="left">
                            <li>
                            <span>
                                <i class="fa fa-phone"></i> +1 123 456 789
                            </span>
                            </li>
                        </ul>
                        <!--end left-->
                        <ul class="right">
                            <li>
                                <a class="navbar-brand" href="my-ads.html" style="cursor: pointer;">
                                    <i class="fa fa-heart"></i>My Ads
                                </a>
                            </li>
                            <li>
                                <a class="navbar-brand" style="cursor: pointer;" href="/Lists/LogoutAction" data-toggle="tooltip" data-placement="bottom" title="LogOut">
                                    <i class="fa fa-sign-in"></i><%= Nominativo%> / <%= Type %> / <img src="<%= Image %>" width="25px">
                                </a>
                            </li>
                            <li>
                                <a class="navbar-brand" data-toggle="modal" data-target="#RegisterModal" style="cursor: pointer;">
                                    <i class="fa fa-pencil-square-o"></i>Register
                                </a>
                            </li>
                        </ul>
                        <!--end right-->
                    </div>
                    <!--end container-->
                </div>
                
                <!--============ End Secondary Navigation ===========================================================-->
                <!--============ Main Navigation ====================================================================-->
                <div class="main-navigation">
                    <div class="container">
                        <nav class="navbar navbar-expand-lg navbar-light justify-content-between">
                            <a class="navbar-brand" href="index.html">
                                <img src="img/logo.png" alt="">
                            </a>
                            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar" aria-controls="navbar" aria-expanded="false" aria-label="Toggle navigation">
                                <span class="navbar-toggler-icon"></span>
                            </button>
                            <div class="collapse navbar-collapse" id="navbar">
                                <!--Main navigation list-->
                                <ul class="navbar-nav">
                                    <li class="nav-item">
                                        <a class="nav-link" href="homepage.jsp">home</a>
                                    </li>
                                    <li class="nav-item has-child">
                                        <a class="nav-link" href="#">Listing</a>
                                        <!-- 1st level -->
                                        <ul class="child">
                                            <li class="nav-item has-child">
                                                <a href="#" class="nav-link">Grid</a>
                                                <!-- 2nd level -->
                                                <ul class="child">
                                                    <li class="nav-item">
                                                        <a href="listing-grid-full-width.html" class="nav-link">Full Width</a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="listing-grid-sidebar.html" class="nav-link">With Sidebar</a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="listing-grid-compact-sidebar.html" class="nav-link">Compact With Sidebar</a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="listing-grid-compact-full-width.html" class="nav-link">Compact Full Width</a>
                                                    </li>
                                                </ul>
                                                <!-- end 2nd level -->
                                            </li>
                                            <li class="nav-item has-child">
                                                <a href="#" class="nav-link">List</a>
                                                <!-- 2nd level -->
                                                <ul class="child">
                                                    <li class="nav-item">
                                                        <a href="listing-list-full-width.html" class="nav-link">Full Width</a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="listing-list-sidebar.html" class="nav-link">With Sidebar</a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="listing-list-compact-sidebar.html" class="nav-link">Compact With Sidebar</a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="listing-list-compact-full-width.html" class="nav-link">Compact Full Width</a>
                                                    </li>
                                                </ul>
                                                <!-- end 2nd level -->
                                            </li>
                                            <li class="nav-item has-child">
                                                <a href="#" class="nav-link">Masonry</a>
                                                <!-- 2nd level -->
                                                <ul class="child">
                                                    <li class="nav-item">
                                                        <a href="listing-masonry-full-width.html" class="nav-link">Full Width</a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="listing-masonry-sidebar.html" class="nav-link">With Sidebar</a>
                                                    </li>
                                                </ul>
                                                <!-- end 2nd level -->
                                            </li>
                                            <li class="nav-item has-child">
                                                <a href="#" class="nav-link">Single</a>
                                                <!-- 2nd level -->
                                                <ul class="child">
                                                    <li class="nav-item">
                                                        <a href="single-listing-1.html" class="nav-link">Single 1</a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="single-listing-2.html" class="nav-link">Single 2</a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="single-listing-3.html" class="nav-link">Single 3</a>
                                                    </li>
                                                </ul>
                                                <!-- end 2nd level -->
                                            </li>
                                        </ul>
                                        <!-- end 1st level -->
                                    </li>
                                    <li class="nav-item has-child">
                                        <a class="nav-link" href="#">Pages</a>
                                        <!-- 2nd level -->
                                        <ul class="child">
                                            <li class="nav-item">
                                                <a href="sellers.html" class="nav-link">Sellers</a>
                                            </li>
                                            <li class="nav-item has-child">
                                                <a href="#" class="nav-link">Seller Detail</a>
                                                <!-- 3rd level -->
                                                <ul class="child">
                                                    <li class="nav-item">
                                                        <a href="seller-detail-1.html" class="nav-link">Seller Detail
                                                            1</a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="seller-detail-2.html" class="nav-link">Seller Detail
                                                            2</a>
                                                    </li>
                                                </ul>
                                                <!-- end 3rd level -->
                                            </li>
                                            <li class="nav-item">
                                                <a href="blog.html" class="nav-link">Blog</a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="blog-post.html" class="nav-link">Blog Post</a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="submit.html" class="nav-link">Submit Ad</a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="pricing.html" class="nav-link">Pricing</a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="faq.html" class="nav-link">FAQ</a>
                                            </li>
                                        </ul>
                                        <!-- end 2nd level -->
                                    </li>
                                    <li class="nav-item has-child">
                                        <a class="nav-link" href="#">Extras</a>
                                        <!--1st level -->
                                        <ul class="child">
                                            <li class="nav-item has-child">
                                                <a href="#" class="nav-link">Grid Variants</a>
                                                <ul class="child">
                                                    <li class="nav-item">
                                                        <a href="listing-grid-4-items.html" class="nav-link">4 Items</a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="listing-grid-3-items.html" class="nav-link">3 Items</a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="listing-grid-2-items.html" class="nav-link">2 Items</a>
                                                    </li>
                                                </ul>
                                            </li>
                                            <li class="nav-item has-child">
                                                <a href="#" class="nav-link">User Panel</a>
                                                <ul class="child">
                                                    <li class="nav-item">
                                                        <a href="my-profile.html" class="nav-link">My Profile</a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="my-ads.html" class="nav-link">My Ads</a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="change-password.html" class="nav-link">Change
                                                            Password</a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="sign-in.html" class="nav-link">Sign In</a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="register.html" class="nav-link">Register</a>
                                                    </li>
                                                </ul>
                                            </li>
                                            <li class="nav-item">
                                                <a href="elements.html" class="nav-link">Elements</a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="typography.html" class="nav-link">Typography</a>
                                            </li>
                                            <li class="nav-item has-child">
                                                <a href="#" class="nav-link">Nested Navigation</a>
                                                <!--2nd level -->
                                                <ul class="child">
                                                    <li class="nav-item">
                                                        <a href="#" class="nav-link">Level 2</a>
                                                    </li>
                                                    <li class="nav-item">
                                                        <a href="#" class="nav-link">Level 2</a>
                                                    </li>
                                                    <li class="nav-item has-child">
                                                        <a href="#" class="nav-link">Level 2</a>
                                                        <!--3rd level -->
                                                        <ul class="child">
                                                            <li class="nav-item has-child">
                                                                <a href="#" class="nav-link">Level 3</a>
                                                                <!--4th level -->
                                                                <ul class="child">
                                                                    <li class="nav-item">
                                                                        <a href="#" class="nav-link">Level 4</a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a href="#" class="nav-link">Level 4</a>
                                                                    </li>
                                                                    <li class="nav-item">
                                                                        <a href="#" class="nav-link">Level 4</a>
                                                                    </li>
                                                                </ul>
                                                                <!-- end 4th level-->
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="#" class="nav-link">Level 3</a>
                                                            </li>
                                                            <li class="nav-item">
                                                                <a href="#" class="nav-link">Level 3</a>
                                                            </li>
                                                        </ul>
                                                        <!--end 3rd level-->
                                                    </li>
                                                </ul>
                                                <!-- end 2nd level -->
                                            </li>
                                            <li class="nav-item">
                                                <a href="image-header.html" class="nav-link">Image Header</a>
                                            </li>
                                            <li class="nav-item">
                                                <a href="messaging.html" class="nav-link">Messages</a>
                                            </li>
                                        </ul>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" href="contact.html">Contact</a>
                                    </li>
                                    <li class="nav-item">
                                        <a href="submit.html" class="btn btn-primary text-caps btn-rounded">Submit Ad</a>
                                    </li>
                                </ul>
                                <!--Main navigation list-->
                            </div>
                            <!--end navbar-collapse-->
                        </nav>
                        <!--end navbar-->
                    </div>
                    <!--end container-->
                </div>
                <!--============ End Main Navigation ================================================================-->
                <!--============ Page Title =========================================================================-->
                <div class="page-title">
                    <div class="container">
                        <h1 class="opacity-60 center">
                            Your own<a href="#"> Lists</a>
                        </h1>
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
                        <img src="img/hero-background-image-02.jpg" alt="">
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
                    <h2>Categories</h2>
                    <ul class="categories-list clearfix">
                        <li>
                            <i class="category-icon">
                                <img src="icons/category-furniture-b.png" alt="">
                            </i>
                            <h3><a href="#">Furniture</a></h3>
                            <div class="sub-categories">
                                <a href="#">Beds</a>
                                <a href="#">Sofas</a>
                                <a href="#">Garden</a>
                            </div>
                        </li>
                        <!--end category item-->
                        <li>
                            <i class="category-icon">
                                <img src="icons/category-pets-b.png" alt="">
                            </i>
                            <h3><a href="#">Pets</a></h3>
                            <div class="sub-categories">
                                <a href="#">Dogs</a>
                                <a href="#">Cats</a>
                                <a href="#">Exotic</a>
                            </div>
                        </li>
                        <!--end category item-->
                        <li>
                            <i class="category-icon">
                                <img src="icons/category-real-estate-b.png" alt="">
                            </i>
                            <h3><a href="#">Real Estate</a></h3>
                            <div class="sub-categories">
                                <a href="#">Houses</a>
                                <a href="#">Apartments</a>
                            </div>
                        </li>
                        <!--end category item-->
                        <li>
                            <i class="category-icon">
                                <img src="icons/category-jobs-b.png" alt="">
                            </i>
                            <h3><a href="#">Jobs</a></h3>
                            <div class="sub-categories">
                                <a href="#">Find Job</a>
                                <a href="#">Offer Job</a>
                            </div>
                        </li>
                        <!--end category item-->

                        <li>
                            <i class="category-icon">
                                <img src="icons/category-cars-b.png" alt="">
                            </i>
                            <h3><a href="#">Car</a></h3>
                            <div class="sub-categories">
                                <a href="#">New</a>
                                <a href="#">Used</a>
                                <a href="#">Rent</a>
                            </div>
                        </li>
                        <!--end category item-->
                        <li>
                            <i class="category-icon">
                                <img src="icons/category-mobile-b.png" alt="">
                            </i>
                            <h3><a href="#">Mobile</a></h3>
                            <div class="sub-categories">
                                <a href="#">Apple</a>
                                <a href="#">Samsung</a>
                            </div>
                        </li>
                        <!--end category item-->
                        <li>
                            <i class="category-icon">
                                <img src="icons/category-cameras-b.png" alt="">
                            </i>
                            <h3><a href="#">Cameras</a></h3>
                            <div class="sub-categories">
                                <a href="#">Photo</a>
                                <a href="#">Video</a>
                                <a href="#">Lenses</a>
                            </div>
                        </li>
                        <!--end category item-->
                        <li>
                            <i class="category-icon">
                                <img src="icons/category-sport-b.png" alt="">
                            </i>
                            <h3><a href="#">Sport</a></h3>
                            <div class="sub-categories">
                                <a href="#">Ski</a>
                                <a href="#">Bike</a>
                                <a href="#">Hockey</a>
                            </div>
                        </li>
                        <!--end category item-->

                        <li>
                            <i class="category-icon">
                                <img src="icons/category-electro-b.png" alt="">
                            </i>
                            <h3><a href="#">Electro</a></h3>
                            <div class="sub-categories">
                                <a href="#">TV</a>
                                <a href="#">Radio</a>
                                <a href="#">PC</a>
                            </div>
                        </li>
                        <!--end category item-->
                        <li>
                            <i class="category-icon">
                                <img src="icons/category-clothing-b.png" alt="">
                            </i>
                            <h3><a href="#">Clothing</a></h3>
                            <div class="sub-categories">
                                <a href="#">Shirts</a>
                                <a href="#">Trousers</a>
                            </div>
                        </li>
                        <!--end category item-->
                        <li>
                            <i class="category-icon">
                                <img src="icons/category-books-b.png" alt="">
                            </i>
                            <h3><a href="#">Books</a></h3>
                            <div class="sub-categories">
                                <a href="#">Fantasy</a>
                                <a href="#">History</a>
                                <a href="#">Sci-Fi</a>
                            </div>
                        </li>
                        <!--end category item-->
                        <li>
                            <i class="category-icon">
                                <img src="icons/category-music-b.png" alt="">
                            </i>
                            <h3><a href="#">Music</a></h3>
                            <div class="sub-categories">
                                <a href="#">Rock</a>
                                <a href="#">Techno</a>
                                <a href="#">Folk</a>
                            </div>
                        </li>
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
                    <h2>Featured Ads</h2>
                    <div class="items grid grid-xl-3-items grid-lg-3-items grid-md-2-items">
                        <div class="item">
                            <div class="wrapper">
                                <div class="image">
                                    <h3>
                                        <a href="#" class="tag category">Home & Decor</a>
                                        <a href="single-listing-1.html" class="title">Furniture for sale</a>
                                        <span class="tag">Offer</span>
                                    </h3>
                                    <a href="single-listing-1.html" class="image-wrapper background-image">
                                        <img src="img/image-01.jpg" alt="">
                                    </a>
                                </div>
                                <!--end image-->
                                <h4 class="location">
                                    <a href="#">Manhattan, NY</a>
                                </h4>
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
                                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam venenatis lobortis</p>
                                </div>
                                <!--end description-->
                                <a href="single-listing-1.html" class="detail text-caps underline">Detail</a>
                            </div>
                        </div>
                        <!--end item-->

                        <div class="item">
                            <div class="wrapper">
                                <div class="image">
                                    <h3>
                                        <a href="#" class="tag category">Education</a>
                                        <a href="single-listing-1.html" class="title">Creative Course</a>
                                        <span class="tag">Offer</span>
                                    </h3>
                                    <a href="single-listing-1.html" class="image-wrapper background-image">
                                        <img src="img/image-02.jpg" alt="">
                                    </a>
                                </div>
                                <!--end image-->
                                <h4 class="location">
                                    <a href="#">Nashville, TN</a>
                                </h4>
                                <div class="price">$125</div>
                                <div class="meta">
                                    <figure>
                                        <i class="fa fa-calendar-o"></i>28.04.2017
                                    </figure>
                                    <figure>
                                        <a href="#">
                                            <i class="fa fa-user"></i>Peter Browner
                                        </a>
                                    </figure>
                                </div>
                                <!--end meta-->
                                <div class="description">
                                    <p>Proin at tortor eros. Phasellus porta nec elit non lacinia. Nam bibendum erat at leo faucibus vehicula. Ut laoreet porttitor risus, eget suscipit tellus tincidunt sit amet. </p>
                                </div>
                                <!--end description-->
                                <div class="additional-info">
                                    <ul>
                                        <li>
                                            <figure>Start Date</figure>
                                            <aside>25.06.2017 09:00</aside>
                                        </li>
                                        <li>
                                            <figure>Length</figure>
                                            <aside>2 months</aside>
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
                            <div class="wrapper">
                                <div class="image">
                                    <h3>
                                        <a href="#" class="tag category">Adventure</a>
                                        <a href="single-listing-1.html" class="title">Into The Wild</a>
                                        <span class="tag">Ad</span>
                                    </h3>
                                    <a href="single-listing-1.html" class="image-wrapper background-image">
                                        <img src="img/image-03.jpg" alt="">
                                    </a>
                                </div>
                                <!--end image-->
                                <h4 class="location">
                                    <a href="#">Seattle, WA</a>
                                </h4>
                                <div class="price">$1,560</div>
                                <div class="meta">
                                    <figure>
                                        <i class="fa fa-calendar-o"></i>21.04.2017
                                    </figure>
                                    <figure>
                                        <a href="#">
                                            <i class="fa fa-user"></i>Peak Agency
                                        </a>
                                    </figure>
                                </div>
                                <!--end meta-->
                                <div class="description">
                                    <p>Nam eget ullamcorper massa. Morbi fringilla lectus nec lorem tristique gravida</p>
                                </div>
                                <!--end description-->
                                <a href="single-listing-1.html" class="detail text-caps underline">Detail</a>
                            </div>
                        </div>
                        <!--end item-->

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
                        <h2>Selling With Us Is Easy</h2>
                        <div class="row">
                            <div class="col-md-3">
                                <div class="feature-box">
                                    <figure>
                                        <img src="icons/feature-user.png" alt="">
                                        <span>1</span>
                                    </figure>
                                    <h3>Create an Account</h3>
                                    <p>Etiam molestie viverra dui vitae mattis. Ut velit est</p>
                                </div>
                                <!--end feature-box-->
                            </div>
                            <!--end col-->
                            <div class="col-md-3">
                                <div class="feature-box">
                                    <figure>
                                        <img src="icons/feature-upload.png" alt="">
                                        <span>2</span>
                                    </figure>
                                    <h3>Submit Your Ad</h3>
                                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
                                </div>
                                <!--end feature-box-->
                            </div>
                            <!--end col-->
                            <div class="col-md-3">
                                <div class="feature-box">
                                    <figure>
                                        <img src="icons/feature-like.png" alt="">
                                        <span>3</span>
                                    </figure>
                                    <h3>Make a Deal</h3>
                                    <p>Nunc ultrices eu urna quis cursus. Sed viverra ullamcorper</p>
                                </div>
                                <!--end feature-box-->
                            </div>
                            <!--end col-->
                            <div class="col-md-3">
                                <div class="feature-box">
                                    <figure>
                                        <img src="icons/feature-wallet.png" alt="">
                                        <span>4</span>
                                    </figure>
                                    <h3>Enjoy the Money!</h3>
                                    <p>Integer nisl ipsum, sodales sed scelerisque nec, aliquet sit</p>
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
                                        <img src="img/image-04.jpg" alt="">
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
                                        <img src="img/image-05.jpg" alt="">
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
                                        <img src="img/image-06.jpg" alt="">
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
                                        <img src="img/image-07.jpg" alt="">
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
                                        <img src="img/image-08.jpg" alt="">
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
                                        <img src="img/image-09.jpg" alt="">
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
                                        <img src="img/image-10.jpg" alt="">
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
                                        <img src="img/image-11.jpg" alt="">
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
                                                    <option value="">Select Category</option>
                                                    <option value="1">Computers</option>
                                                    <option value="2">Real Estate</option>
                                                    <option value="3">Cars & Motorcycles</option>
                                                    <option value="4">Furniture</option>
                                                    <option value="5">Pets & Animals</option>
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
                                <img src="img/hero-background-image-01.jpg" alt="">
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
                            <img src="img/partner-1.png" alt="">
                        </a>
                        <a href="#">
                            <img src="img/partner-2.png" alt="">
                        </a>
                        <a href="#">
                            <img src="img/partner-3.png" alt="">
                        </a>
                        <a href="#">
                            <img src="img/partner-4.png" alt="">
                        </a>
                        <a href="#">
                            <img src="img/partner-5.png" alt="">
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
                                <img src="img/logo.png" alt="">
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
                        <img src="img/footer-background-icons.jpg" alt="">
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
                    <!-- Form per il login -->
                <form class="form clearfix" id="login-form" action="/Lists/LoginAction" method="post" role="form">
                    <div class="form-group">
                        <label for="email" class="col-form-label required">Email</label>
                        <input type="text" name="username" id="username" tabindex="1" class="form-control" placeholder="Email" value="" required>
                    </div>
                    <!--end form-group-->
                    <div class="form-group">
                        <label for="password" class="col-form-label required">Password</label>
                        <input type="password" name="password" id="password" tabindex="2" class="form-control" placeholder="Password" required>
                    </div>
                    <!--end form-group-->
                    <div class="d-flex justify-content-between align-items-baseline">
                        <div class="form-group text-center">
                            <input type="checkbox" tabindex="3" class="" name="standard" id="standard">
                            <label for="standard">Standard</label>
                            <input type="checkbox" tabindex="3" class="" name="nonstandard" id="nonstandard">
                            <label for="non-standard">non Standard</label>
                        </div>
                        <button type="submit" class="btn btn-primary">Sign In</button>
                    </div>
                    <label>
                        <input type="checkbox" name="remember" value="1">
                        Remember Me
                    </label>
                </form>
                <hr>
                <p>
                    Troubles with signing? <a href="#" class="link">Click here.</a>
                </p>
            </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            <button type="button" class="btn btn-primary">Save changes</button>
          </div>
        </div>
      </div>
    </div>
    <!--######################################################-->
    
    <!-- Register Modal -->
    <div class="modal fade" id="RegisterModal" tabindex="-1" role="dialog" aria-labelledby="RegisterModal" aria-hidden="true">
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
                <form class="form clearfix" id="login-form" action="/Lists/RegisterAction" method="post" role="form">
                    <div class="form-group">
                        <label for="email" class="col-form-label required">Email</label>
                        <input type="email" name="username" id="username" tabindex="1" class="form-control" placeholder="Email" value="">
                    </div>
                    <!--end form-group-->
                    <div class="form-group">
                        <label for="nominativo" class="col-form-label required">Nome</label>
                        <input type="text" name="nominativo" id="nominativo" tabindex="1" class="form-control" placeholder="Nome" value="">
                    </div>
                    <!--end form-group-->
                    <div class="form-group">
                        <label for="password" class="col-form-label required">Password</label>
                        <input type="password" name="password" id="password" tabindex="2" class="form-control" placeholder="Password">
                    </div>
                    <!--end form-group-->
                    <div class="d-flex justify-content-between align-items-baseline">
                        <div class="form-group text-center">
                            <input type="checkbox" tabindex="3" class="" name="standard" id="standard">
                            <label for="standard">Standard</label>
                            <input type="checkbox" tabindex="3" class="" name="nonstandard" id="nonstandard">
                            <label for="non-standard">non Standard</label>
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
            <button type="button" class="btn btn-primary">Save changes</button>
          </div>
        </div>
      </div>
    </div>
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


