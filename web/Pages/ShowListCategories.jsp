<%-- 
    Document   : ShowListCategories
    Created on : 27.10.2018, 17:32:59
    Author     : Martin
--%>

<%@page import="database.entities.Product"%>
<%@page import="java.util.ArrayList"%>
<%@page import="database.entities.ShopList"%>
<%@page import="database.entities.User"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Blob"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="icon" href="img/favicon.png" sizes="16x16" type="image/png">
        <title>Categorie Lista</title>

        <!-- CSS personalizzati -->
        <link href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700|Varela+Round" rel="stylesheet">
        <link rel="stylesheet" href="bootstrap/css/bootstrap.css" type="text/css">
        <link rel="stylesheet" href="bootstrap/css/bootstrap.min.css" type="text/css">
        <link rel="stylesheet" href="fonts/font-awesome.css" type="text/css">
        <link rel="stylesheet" href="css/selectize.css" type="text/css">
        <link rel="stylesheet" href="css/style.css">
        <link rel="stylesheet" href="css/user.css">  
        <link rel="stylesheet" href="css/navbar.css"> 
        <link rel="stylesheet" href="css/datatables.css" type="text/css"> 
        <link rel="icon" href="img/favicon.png" sizes="16x16" type="image/png">
        <script src="js/jquery-3.3.1.min.js"></script>
        <script type="text/javascript" src="js/popper.min.js"></script>
        <script type="text/javascript" src="bootstrap/js/bootstrap.min.js"></script>
        <title>Categorie Lista</title>
        
        
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
            .modal-dialog{
                position: relative;
                display: table; /* This is important */ 
                overflow-y: auto;    
                overflow-x: auto;
                width: auto;
                min-width: 800px;
                max-height: 530px;
            }
            .modal-body {
                position: relative;
                overflow-y: auto;
                max-height: 530px;
                padding: 15px;
            }
            
        </style>
            
    </head>
    <body>
        <div class="page home-page">
            <header class="hero">
                <div class="hero-wrapper">
                    <nav class="navbar navbar-expand-xl navbar-dark fixed-top " id="mainNav">
                        <a class="navbar-brand">
                            <img width= "50" src="img/favicon.png" alt="Logo">
                        </a>
                        <a class="navbar-brand js-scroll-trigger" href="../homepage.jsp">LISTS</a>
                        <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
                            Menu
                            <i class="fa fa-bars"></i>
                        </button>
                        <div class="collapse navbar-collapse" id="navbarResponsive">
                            <ul class="navbar-nav text-uppercase ml-auto text-center">
                                <li class="nav-item">
                                    <a data-toggle="modal" data-target="#CreateCategoryModal" class="btn btn-primary text-caps btn-rounded" >+ Crea una categoria</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link js-scroll-trigger" href="../homepage.jsp"><i class="fa fa-home"></i><b>Home</b></a>
                                </li>
                                <li class="nav-item js-scroll-trigger dropdown">
                                    <div style="cursor: pointer;" class="nav-link dropdown-toggle" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="fa fa-bars"></i><b>Liste</b></div>
                                    <div class="dropdown-menu" style="color: white;" aria-labelledby="navbarDropdown">
                                        <a class="dropdown-item nav-link" href="../userlists.jsp"><i class="fa fa-bars"></i><b>Le mie liste</b></a>
                                        <a class="dropdown-item nav-link" href="../foreignLists.jsp"><i class="fa fa-share-alt"></i><b>Liste condivise con me</b></a>                                        
                                    </div>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link js-scroll-trigger" href="ShowProductCategories.jsp">
                                        <i class="fa fa-bookmark"></i><b>Categorie Prodotti</b>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link js-scroll-trigger" href="../profile.jsp">
                                        <i class="fa fa-user"></i><b>Il mio profilo</b>
                                    </a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link js-scroll-trigger" href="<c:url context="/Lists" value="/restricted/LogoutAction" />" data-toggle="tooltip" data-placement="bottom" title="LogOut">
                                        <i class="fa fa-sign-in"></i><b><c:out value="${user.nominativo}"/> / <c:out value="${user.tipo}"/> </b>/ <img src= "/Lists/${user.image}" width="25px" height="25px" style="border-radius: 100%;">
                                    </a>
                                </li>                                
                            </ul>
                        </div>
                    </nav>
                    <div class="page-title">
                        <div class="container">
                            <h1 class="opacity-60 center">
                                Lista con tutte le categorie per <i>liste</i>
                            </h1>
                        </div>                        
                    </div>
                </div>
            </header>
             <div class="page sub-page">
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
                                        <label style="display: none;" id="loadProducts">Carico le categorie...</label>
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

                                    <c:forEach items="${allCategories}" var="categoria">                                       
                                        <div class="item">
                                            <div class="wrapper">
                                                <div class="image">
                                                    <h3>                                                        
                                                        <a class="title"><div><c:out value="${categoria.nome}"/></div></a> 
                                                        <!--<a class="tag category"><c:out value="${categoria.admin}"/></a>-->                                                      
                                                    </h3>
                                                    <div id="carouselExampleSlidesOnly" class="carousel slide" data-ride="carousel">
                                                        <div class="carousel-inner">
                                                            <div class="carousel-item active">
                                                                <a href="<%=request.getContextPath()%>/restricted/NewCategoryNameAttribute?listname=${categoria.nome}&link=show" class="ad-remove">
                                                                  <img src="../${categoria.immagine}" alt="immagine categoria" class="img-fluid background-image">
                                                                </a>
                                                            </div>
                                                              <c:forEach items="${categoria.immagini}" var="immagine">
                                                                    <div class="carousel-item">
                                                                        <a href="<%=request.getContextPath()%>/restricted/NewCategoryNameAttribute?listname=${categoria.nome}&link=show" class="ad-remove">
                                                                            <img src="../${immagine}" alt="immagine categoria" class=" background-image">
                                                                        </a>
                                                                    </div>
                                                              </c:forEach>
                                                        </div>
                                                      </div>                                                   
                                                </div>
                                                <h4 class="description">
                                                    <a><c:out value="${categoria.descrizione}"/></a>                                                    
                                                </h4>
                                                <div class="admin-controls">
                                                    <a href="<%=request.getContextPath()%>/restricted/NewCategoryNameAttribute?listname=${categoria.nome}&link=add" class="ad-remove">
                                                        <i class="fa fa-picture-o"></i>+ immagine
                                                    </a>                                                  
                                                    <a href="<%=request.getContextPath()%>/restricted/NewCategoryNameAttribute?listname=${categoria.nome}&link=delete" class="ad-remove">
                                                        <i class="fa fa-remove"></i>- immagine
                                                    </a>
                                                    <a href="<%=request.getContextPath()%>/restricted/DeleteListCategory?listname=${categoria.nome}" class="ad-remove">
                                                        <i class="fa fa-trash"></i>Cancella
                                                    </a>
                                                </div>                                            
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
            </section>
             </div>
        </div>

        <!--#####################################################################################-->
        <script type="text/javascript" src="http://maps.google.com/maps/api/js?key=AIzaSyBEDfNcQRmKQEyulDN8nGWjLYPm8s4YB58&libraries=places"></script>
        <!--<script type="text/javascript" src="http://maps.google.com/maps/api/js"></script>-->
        <script src="js/selectize.min.js"></script>
        <script src="js/masonry.pkgd.min.js"></script>
        <script src="js/icheck.min.js"></script>
        <script src="js/jquery.validate.min.js"></script>
        <script src="js/custom.js"></script>
        <script src="js/vari.js"></script>
        <script src="js/nav.js"></script>
                    
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
            

        <!--######################Modals#############################################-->
        <!--create category modal-->
        <div class="modal fade" id="CreateCategoryModal" tabindex="-1" role="dialog" aria-labelledby="CreateShopListform" aria-hidden="true" enctype="multipart/form-data">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <div class="page-title">
                            <div class="container">
                                <h1 style="text-align: center;">Crea una categoria</h1>
                            </div>
                        </div>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <!-- Form per il login -->
                        <form class="form clearfix" id="CreateShopListform" action="<%=request.getContextPath()%>/restricted/CreateListCategory"  method="post" role="form">
                            <div class="form-group">
                                <label for="Nome" class="col-form-label">Nome della categoria</label>
                                <input type="text" name="Nome" id="Nome" tabindex="1" class="form-control" placeholder="Nome" value="" required>
                            </div>
                            <!--end form-group-->
                            <div class="form-group">
                                <label for="Descrizione" class="col-form-label">Descrizione</label>
                                <input type="text" name="Descrizione" id="Descrizione" tabindex="1" class="form-control" placeholder="Descrizione" value="" required>
                            </div>
                            <div class="d-flex justify-content-between align-items-baseline">
                                <button type="submit" name="register-submit" id="register-submit" tabindex="4" class="btn btn-primary">Crea categoria</button>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                            </div>                                
                        </form>
                        <hr>
                    </div>                    
                </div>
            </div>
        </div>
        <!--adimageModal-->
        <div class="modal fade" id="AddImageModal" tabindex="-1" role="dialog" aria-labelledby="AddImageModal" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <div class="page-title">
                            <div class="container">
                                <h1 class="text-center">Aggiungi un immagine</h1> <h3>per la categoria <c:out value="${listname}"/></h3>
                            </div>                             
                        </div>
                    </div> 
                    <div class="modal-body">
                        <form class="form clearfix" action="<%=request.getContextPath()%>/restricted/AddCategoryImage"  method="post" role="form" enctype="multipart/form-data">
                            <div class="form-group">
                                <div class="input-group">
                                    <input type="hidden" name="category" id="hiddenfield" value="<c:out value="${listname}"/>" >
                                    <div class="row">
                                        <div class="col-6">
                                            <span class="input-group-btn">
                                                <div class="row">
                                                    <div class="col-6">
                                                        <input type="text" class="form-control" readonly>
                                                    </div>
                                                    <div class="col-6">
                                                        <span class="btn btn-file btn-primary">
                                                            scegli immagine...<input type="file" id="imgInp" name="file1">                                                                        
                                                        </span>
                                                    </div>
                                                </div>
                                            </span>                                                                
                                        </div>
                                        <div class="col-6">
                                             <img id='img-upload'/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <div class="row">
                                <div class="col-4">
                                     <button type="submit" name="register-submit" id="create-list-submit" tabindex="4" class="btn btn-primary">Submit</button>
                                </div>
                                <div class="col-6">
                                   <a href="<%=request.getContextPath()%>/restricted/NewCategoryNameAttribute?listname=NO" class="btn btn-dark">Close</a>
                                </div>  
                                <div class="col-3">
                                </div>
                            </div>
                        </div>
                    </form>
                </div>                
            </div>
        </div>
        <!--deleteimageModal-->
        <div class="modal fade" id="deleteImageModal" tabindex="-1" role="dialog" aria-labelledby="deleteImageModal" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <div class="page-title">
                            <div class="container">
                                <h1 class="text-center">Quale immagine vuoi cancellare</h1><h2>Categoria: <c:out value="${listname}"/></h2>
                            </div>                             
                        </div>
                    </div> 
                    <div class="modal-body">                        
                            <div class="row">  
                                <c:forEach items="${Immagini}" var="immagine">
                                    <div class="col-md-4">
                                        <div class="thumbnail">
                                          <a href="<%=request.getContextPath()%>/restricted/DeleteCategoryImage?image=${immagine}">
                                            <img src="../${immagine}" alt="immagini categoria ${listname}">
                                          </a>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div> 
                            <a href="<%=request.getContextPath()%>/restricted/NewCategoryNameAttribute?listname=NO" class="btn btn-dark">Close</a> 
                        </form>
                    </div>
                </div>                
            </div>
        </div>
                            
                            
        <!--image popup modal-->
        <div id="imageModal" class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
            <div class="modal-dialog" style="min-width: 100px;">
              <div class="modal-content">
                <div id="carousel-example-generic" class="carousel slide" data-ride="carousel">
            <!-- Wrapper for slides -->
            <div class="carousel-inner">
                <div class="carousel-item active">
                    <a href="<%=request.getContextPath()%>/restricted/NewCategoryNameAttribute?listname=NO" class="btn btn-framed btn-block">
                    <img class="img-responsive" src="../${firstImg}" alt="img">
                     <div class="carousel-caption">
                         Close 
                     </div>
                    </a>
                   </div>
                <c:forEach items="${Immagini}" var="immagine">
                    <div class="carousel-item">
                    <a href="<%=request.getContextPath()%>/restricted/NewCategoryNameAttribute?listname=NO" class="btn btn-framed btn-block">
                    <img class="img-responsive text-center" src="../${immagine}" alt="...">
                     <div class="carousel-caption">
                         Close
                     </div>
                      </a>
                   </div>
                </c:forEach>
            </div>

            <!-- Controls -->
            <a class="left carousel-control" href="#carousel-example-generic" role="button" data-slide="prev">
              <span class="glyphicon glyphicon-chevron-left"></span>
            </a>
            <a class="right carousel-control" href="#carousel-example-generic" role="button" data-slide="next">
              <span class="glyphicon glyphicon-chevron-right"></span>
            </a>
          </div>
              </div>
            </div>
          </div>
        <!--######################Modals#############################################-->
        <c:if test="${modalImage==true}">
            <script type="text/javascript">
                $(document).ready(function () {
                    $("#AddImageModal").modal('show');
                });
            </script>
        </c:if>
        <c:if test="${deleteImage==true}">
            <script type="text/javascript">
                $(document).ready(function () {
                    $("#deleteImageModal").modal('show');
                });
            </script>
        </c:if>
        <c:if test="${showImage==true}">
            <script type="text/javascript">
                $(document).ready(function () {
                    $("#imageModal").modal('show');
                });
            </script>
        </c:if>
        
</body>
</html>