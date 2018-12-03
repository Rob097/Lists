<%-- 
    Document   : profile
    Created on : 15.10.2018, 16:49:13
    Author     : Martin
--%>

<%@page import="database.entities.User"%>
<%@page import="java.net.URLDecoder"%>

<%
    HttpSession s = (HttpSession) request.getSession();
    User u = null;
    boolean find = false;

    u = (User) s.getAttribute("user");
    if (u == null) {
        response.sendRedirect("/Lists/homepage.jsp");

    } else {
        find = true;      
        if (find) {
%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        <link rel="stylesheet" href="Pages/css/navbar.css">
        <style>
            .btn-file {
                position: relative;
                overflow: hidden;
               
            }
            .btn-file input[type=file] {
                position: absolute;
                top: 0;
                right: 0;
                min-width: 100%;
                min-height: 100%;
                font-size: 100px;
                text-align: right;
                filter: alpha(opacity=0);
                opacity: 0;
                outline: none;
                background: white;
                cursor: inherit;
                display: block;
            }

            #img-upload{
                width: 100%;
                border-radius: 50%;
            }
        </style>
        
        
    </head>
    <body>        
        <div class="page home-page">
            <header class="hero">
                <div class="hero-wrapper">
                    <div id="navbar">
                        <!-- Qui viene inclusa la navbar -->
                    </div>
                                    
                    <c:if test="${updateResult==true}">
                        <div class="alert alert-success" id="alert">
                            <a href="#" class="close" data-dismiss="alert" aria-label="close">&times;</a>
                            <strong>Successful Modification!</strong> Your account is actualized.
                        </div>
                        <% request.getSession().setAttribute("updateResult", false); %>               
                    </c:if> 
                                    
                    <!--============ Page Title =========================================================================-->
                    <div class="page-title">
                        <div class="container" >
                            <h1>Il mio profilo</h1>
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
                                    <a class="nav-link icon" href="userlists.jsp">
                                        <i class="fa fa-bars"></i>Le mie liste
                                    </a>
                                    <a class="nav-link icon" href="foreignLists.jsp">
                                        <i class="fa fa-share-alt"></i>Liste condivise
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
                                <form class="form clearfix" id="login-form" action="/Lists/restricted/updateUser" method="post" enctype="multipart/form-data" onsubmit="return validate();">
                                    <div class="row">
                                        <div class="col-md-8">
                                            <h2>Informazioni personali</h2>
                                            <section>
                                                <div class="form-group">
                                                    <label for="email" class="col-form-label">Email(non modificabile)</label>
                                                    <input type="email" name="email" id="email" tabindex="1" class="form-control" placeholder="Email" value="${user.email}"  disabled>
                                                </div>                                                
                                                <div class="form-group">
                                                    <label for="nominativo" class="col-form-label">Nome</label>
                                                    <input type="text" name="nominativo" id="nominativo" tabindex="1" class="form-control" placeholder="Nome" value="${user.nominativo}" >                                                    
                                                </div>
                                                <div class="form-group">
                                                    <label for="password" class="col-form-label">Password</label>
                                                    <input type="password" name="password" id="password" tabindex="2" class="form-control" placeholder="Password"  value="${user.password}">
                                                    <label for="pswrt2" class="col-form-label">Conferma Password</label>
                                                    <input type="password" name="pswrt2" id="pswrt2" tabindex="2" class="form-control" placeholder="Password"  value="${user.password}">
                                                </div>
                                                <div class="form-group">
                                                    <div class="input-group">
                                                        <div class="row">
                                                            <div>
                                                                <span class="input-group-btn">                                                                    
                                                                    <input type="text" class="form-control" readonly>
                                                                    <span class="btn btn-block btn-file btn-framed btn-primary">
                                                                        scegli immagine...<input type="file" id="imgInp" name="file1">                                                                        
                                                                    </span>
                                                                </span>                                                                
                                                            </div>
                                                            <div class="col-md-7">
                                                                 <img id='img-upload'/>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>                                                 
                                                <!--end form-group-->

                                            </section>
                                            <section class="clearfix">
                                                <button type="submit" name="register-submit" id="register-submit" tabindex="4" class="btn btn-primary float-right">Salva cambiamenti</button>
                                            </section>
                                            <section class="clearfix">
                                                <button type="button" class="btn btn-dark float-right" id="delete" data-toggle="modal" data-target="#delete-modal">Cancella profilo</button>
                                            </section>
                                        </div>
                                        <!--end col-md-8--> 
                                        <div class="col-md-4">
                                            <div class="profile-image">
                                                <div class="image background-image">
                                                    <img src="${user.image}" alt="">
                                                </div> 
                                                <br>
                                                <div class="text-center">
                                                    <c:out value="${user.nominativo}"/>
                                                </div>
                                                <div class="text-center">
                                                    Tipo utente: <c:out value="${user.tipo}"/>
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



        <!--#########################################################
                                MODAL
        ##########################################################-->

        <!-- Delete Modal -->
        <div class="modal fade" id="delete-modal" tabindex="-1" role="dialog" aria-labelledby="delete-modal" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <div class="page-title">
                            <div class="container">
                                <h1>Delete user</h1>
                            </div>
                            <!--end container-->
                        </div>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <h3>Sei sicuro di voler eliminare questo utente?<br> Non potrai annullare la modifica.</h3>
                        <form class="clearfix" action="/Lists/restricted/deleteUser" method="POST">
                            <button type="submit" class="btn btn-dark" id="delete">Delete</button>
                            <button type="button" data-dismiss="modal" class="btn btn-dark" id="delete-btn-no">Cancel</button>
                        </form>

                    </div>
                </div>
            </div>
        </div>
        

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
        <script src="Pages/js/nav.js"></script>
        <script src="Pages/js/userimage.js"></script>
        <script>
            $(document).ready( function() {
    	$(document).on('change', '.btn-file :file', function() {
		var input = $(this),
			label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
		input.trigger('fileselect', [label]);
		});

		$('.btn-file :file').on('fileselect', function(event, label) {
		    
		    var input = $(this).parents('.input-group').find(':text'),
		        log = label;
		    
		    if( input.length ) {
		        input.val(log);
		    } else {
		        if( log ) alert(log);
		    }
	    
		});
		function readURL(input) {
		    if (input.files && input.files[0]) {
		        var reader = new FileReader();
		        
		        reader.onload = function (e) {
		            $('#img-upload').attr('src', e.target.result);
		        }
		        
		        reader.readAsDataURL(input.files[0]);
		    }
		}

		$("#imgInp").change(function(){
		    readURL(this);
		}); 	
	});
        </script>
        <script type="text/javascript">
            function validate(){
                var n1 = document.getElementById("password");
                var n2 = document.getElementById("pswrt2");
                if(n1.value != "" && n2.value != ""){
                    if((n1.value == n2.value)){
                        return true;                       
                    }
                }
                alert("password can't be empty and has to be equal to Conferma Password");
                return false;
            }
        </script>
        
        
        <script type="text/javascript">
            $(document).ready(function () {
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

<%
    } else
        response.sendRedirect("/Lists");
}
%>