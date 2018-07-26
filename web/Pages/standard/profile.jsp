<%-- 
    Document   : profile
    Created on : 26-lug-2018, 12.49.19
    Author     : Roberto97
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Blob"%>
<%
    Cookie cookiecheck = null;
    Cookie[] cookiescheck = null;
    boolean find = false;
    // Get an array of Cookies associated with the this domain
    cookiescheck = request.getCookies();
    if (cookiescheck != null) {

        for (int i = 0; i < cookiescheck.length && find != true; i++) {
            cookiecheck = cookiescheck[i];
            if (cookiecheck.getName().equals("Type")) {
                if (cookiecheck.getValue().equals("standard")) {
                    find = true;
                }
            }
        }
    }

    if (find) {
%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>

        <!-- CSS personalizzati -->
        <link href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700|Varela+Round" rel="stylesheet">
        <link rel="stylesheet" href="../bootstrap/css/bootstrap.css" type="text/css">
        <link rel="stylesheet" href="../fonts/font-awesome.css" type="text/css">
        <link rel="stylesheet" href="../css/selectize.css" type="text/css">
        <link rel="stylesheet" href="../css/style.css">
        <link rel="stylesheet" href="../css/user.css">
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

            } catch (Exception e) {
                System.out.println("Causa Connessione: ");
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
            String image = "../../";

            //String Image = "";
            if (cookies != null) {
                for (int i = 0; i < cookies.length; i++) {
                    cookie = cookies[i];
                    if (cookie.getName().equals("JSESSIONID")); else {
                        if (cookie.getName().equals("Nominativo")) {
                            Nominativo += cookie.getValue();
                        }
                        if (cookie.getName().equals("Email")) {
                            Email += cookie.getValue();
                        }
                        
                        
                        if (cookie.getName().equals("Type")) {
                            Type += cookie.getValue();
                        }
                        if (cookie.getName().equals("Image")) image += cookie.getValue();

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
                                    <a class="navbar-brand" href="standardType.jsp" style="cursor: pointer;">
                                        <i class="fa fa-heart"></i>Le mie Liste
                                    </a>
                                </li>
                                <li>
                                    <a class="navbar-brand" style="cursor: pointer;" href="/Lists/LogoutAction" data-toggle="tooltip" data-placement="bottom" title="LogOut">
                                        <i class="fa fa-sign-in"></i><%= Nominativo%> / <%= Type%> / <img src="<%=image%>" width="25px" height="25px" style="border-radius: 100%;">
                                    </a>
                                </li>
                                <li>
                                    <a class="navbar-brand" style="cursor: pointer;" href="profile.jsp">
                                        <i class="fa fa-user"></i>Il mio profilo
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
                                    <img src="../img/logo.png" alt="">
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
                    <div class="page-title">
                        <div class="container">
                            <h1>Le mie liste</h1>
                        </div>
                        <!--end container-->
                    </div>
                    <div class="background">
                        <div class="background-image">
                            <img src="../img/hero-background-image-02.jpg" alt="">
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
                                    <a class="nav-link active icon" href="profile.jsp">
                                        <i class="fa fa-user"></i>My Profile
                                    </a>
                                    <a class="nav-link icon" href="standardType.jsp">
                                        <i class="fa fa-heart"></i>My Ads Listing
                                    </a>
                                    <a class="nav-link icon" href="bookmarks.html">
                                        <i class="fa fa-star"></i>Bookmarks
                                    </a>
                                    <a class="nav-link icon" href="change-password.html">
                                        <i class="fa fa-recycle"></i>Change Password
                                    </a>
                                    <a class="nav-link icon" href="sold-items.html">
                                        <i class="fa fa-check"></i>Sold Items
                                    </a>
                                </nav>
                            </div>
                            <!--end col-md-3-->
                            <div class="col-md-9">
                                <form class="form">
                                    <div class="row">
                                        <div class="col-md-8">
                                            <h2>Personal Information</h2>
                                            <section>
                                                <div class="row">
                                                    <div class="col-md-4">
                                                        <div class="form-group">
                                                            <label for="title" class="col-form-label">Title</label>
                                                            <select name="title" id="title" data-placeholder="Title">
                                                                <option value="">Title</option>
                                                                <option value="1" selected>Mrs</option>
                                                                <option value="2">Mr</option>
                                                            </select>
                                                        </div>
                                                        <!--end form-group-->
                                                    </div>
                                                    <div class="col-md-8">
                                                        <div class="form-group">
                                                            <label for="name" class="col-form-label required">Your Name</label>
                                                            <input name="name" type="text" class="form-control" id="name" placeholder="Your Name" value="Jane Doe" required>
                                                        </div>
                                                        <!--end form-group-->
                                                    </div>
                                                    <!--end col-md-8-->
                                                </div>
                                                <!--end row-->
                                                <div class="form-group">
                                                    <label for="location" class="col-form-label required">Your Location</label>
                                                    <input name="location" type="text" class="form-control" id="input-location2" placeholder="Your Location" value="Manhattan, NY" required>
                                                </div>
                                                <!--end form-group-->
                                                <div class="form-group">
                                                    <label for="about" class="col-form-label">More About You</label>
                                                    <textarea name="about" id="about" class="form-control" rows="4">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut nec tincidunt arcu, sit amet fermentum sem. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.</textarea>
                                                </div>
                                                <!--end form-group-->
                                            </section>

                                            <section>
                                                <h2>Contact</h2>
                                                <div class="form-group">
                                                    <label for="phone" class="col-form-label">Phone</label>
                                                    <input name="phone" type="text" class="form-control" id="phone" placeholder="Your Phone" value="312-238-3329">
                                                </div>
                                                <!--end form-group-->
                                                <div class="form-group">
                                                    <label for="email" class="col-form-label">Email</label>
                                                    <input name="email" type="email" class="form-control" id="email" placeholder="Your Email" value="jane.doe@example.com">
                                                </div>
                                                <!--end form-group-->
                                            </section>

                                            <section>
                                                <h2>Social</h2>
                                                <div class="form-group">
                                                    <label for="twitter" class="col-form-label">Twitter</label>
                                                    <input name="twitter" type="text" class="form-control" id="twitter" placeholder="http://" value="http://www.twitter.com/jane.doe">
                                                </div>
                                                <!--end form-group-->
                                                <div class="form-group">
                                                    <label for="facebook" class="col-form-label">Facebook</label>
                                                    <input name="facebook" type="text" class="form-control" id="facebook" placeholder="http://" value="http://www.facebook.com/jane.doe">
                                                </div>
                                                <!--end form-group-->
                                            </section>

                                            <section class="clearfix">
                                                <button type="submit" class="btn btn-primary float-right">Save Changes</button>
                                            </section>
                                        </div>
                                        <!--end col-md-8-->
                                        <div class="col-md-4">
                                            <div class="profile-image">
                                                <div class="image background-image">
                                                    <img src="<%=image%>" alt="">
                                                </div>
                                                <div class="single-file-input">
                                                    <input type="file" id="user_image" name="user_image">
                                                    <div class="btn btn-framed btn-primary small">Upload a picture</div>
                                                </div>
                                            </div>
                                        </div>
                                        <!--end col-md-3-->
                                    </div>
                                </form>
                            </div>
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
                                    <img src="../img/logo.png" alt="">
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
                            <img src="../img/footer-background-icons.jpg" alt="">
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

        <script src="../js/jquery-3.3.1.min.js"></script>
    <script type="text/javascript" src="../js/popper.min.js"></script>
    <script type="text/javascript" src="../bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="http://maps.google.com/maps/api/js?key=AIzaSyBEDfNcQRmKQEyulDN8nGWjLYPm8s4YB58&libraries=places"></script>
    <!--<script type="text/javascript" src="http://maps.google.com/maps/api/js"></script>-->
    <script src="../js/selectize.min.js"></script>
    <script src="../js/masonry.pkgd.min.js"></script>
    <script src="../js/icheck.min.js"></script>
    <script src="../js/jquery.validate.min.js"></script>
    <script src="../js/custom.js"></script>


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

<%
    } else
        response.sendRedirect("/Lists");
%>