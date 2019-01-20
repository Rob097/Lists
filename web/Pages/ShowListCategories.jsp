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
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
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
           }
            .modal-body {
                position: relative;
                overflow-y: auto;
                padding: 15px;
            }
            .container .img-responsive {
                display: block;
                height: auto;
                max-width: 100%;
            }  
            /*To */

            .container  .img-responsive {
                display: block;
                width: auto;
                max-height: 100%;
            }
            .thumbnail img {
                height:150px;
                width:100%;
                border: 5px lightgray solid; 
                margin-bottom: 10px;
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
                    <div class="page-title">
                        <div class="container">
                            <h1 class="opacity-60 center">
                                Categorie di Liste della spesa
                            </h1>
                        </div>                        
                    </div>
                    <div class="background"></div>

                    <div class="container text-center" id="welcomeGrid">
                        <a data-toggle="modal" data-target="#CreateCategoryModal" class="btn btn-primary text-caps btn-framed btn-block" >Crea una categoria</a>
                    </div>
                </div>
            </header>
             <div class="page sub-page">
            <section class="content">
                <section class="block">
                    <div class="container">
                        <div class="row">
                            <div class="col-md-3" id="sideNavbar">
                                <!-- Qui c'è la side navar caricata dal template con AJAX -->
                            </div>
                            <!--end col-md-3-->
                            <div class="col-md-9">
                                <!--============ Section Title===================================================================-->
                                <div class="section-title clearfix">
                                    <div class="float-left float-xs-none" style="width: 89%;">
                                        <input type="text" id="myInput" onkeyup="myFunction()" placeholder="Search for names.." title="Type in a name of product">
                                        <label style="display: none;" id="loadProducts1">Nessuna categoria corrispondente</label></br>
                                        <a style="display: none;" id="loadProducts2" data-toggle="modal" data-target="#CreateCategoryModal" class="btn btn-primary text-caps btn-rounded" >+ Crea una categoria</a>
                                    </div>
                                    <div class="float-right d-xs-none thumbnail-toggle">
                                        <a class="change-class" data-change-from-class="list" data-change-to-class="grid" data-parent-class="items">
                                            <i class="fa fa-th"></i>
                                        </a>
                                        <a class="change-class active" data-change-from-class="grid" data-change-to-class="list" data-parent-class="items">
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
                                                                <a onclick="setImage('${categoria.nome}', 'show')" class="ad-remove">
                                                                  <img src="../${categoria.immagine}" style="cursor: pointer;" alt="immagine categoria" class="img-fluid background-image">
                                                                </a>
                                                            </div>
                                                              <c:forEach items="${categoria.immagini}" var="immagine">
                                                                    <div class="carousel-item">
                                                                        <a onclick="setImage('${categoria.nome}', 'show')" style="cursor: pointer;" class="ad-remove">
                                                                            <img src="../${immagine}" alt="immagine categoria" class=" background-image">
                                                                        </a>
                                                                    </div>
                                                              </c:forEach>                                                            
                                                        </div>
                                                      </div>                                                   
                                                </div>
                                                <h4 class="description">
                                                    <c:if test="${categoria.inUse != 1}">
                                                        <a><c:out value="${categoria.descrizione}"/><br><b><c:out value="Usata in ${categoria.inUse} Liste"/></b></a>
                                                    </c:if>
                                                    <c:if test="${categoria.inUse == 1}">
                                                        <a><c:out value="${categoria.descrizione}"/><br><b><c:out value="Usata in ${categoria.inUse} Lista"/></b></a>
                                                    </c:if>                                                    
                                                </h4>
                                                <div class="admin-controls">
                                                    <a onclick="setImage('${categoria.nome}', 'add')" class="ad-remove">
                                                        <i class="fa fa-picture-o"></i>+ immagine
                                                    </a>                                                  
                                                    <a onclick="setImage('${categoria.nome}', 'delete')" class="ad-remove">
                                                        <i class="fa fa-remove"></i>- immagine
                                                    </a>
                                                    <a href="<%=request.getContextPath()%>/restricted/DeleteListCategory?listname=${categoria.nome}" class="ad-remove <c:if test="${categoria.inUse != 0}">disabled</c:if>" data-toggle="tooltip" <c:if test="${categoria.inUse != 0}">title="In uso, non è possibile cancellarla"</c:if> >
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
                                <h1 class="text-center">Aggiungi un'immagine</h1>
                            </div>                             
                        </div>
                    </div> 
                    <div class="modal-body">
                        <form class="form clearfix" action="<%=request.getContextPath()%>/restricted/AddCategoryImage"  method="post" role="form" enctype="multipart/form-data">
                            <div class="form-group">
                                <div class="input-group">
                                    <div>
                                        <span class="input-group-btn">
                                            <div class="form-group">
                                                <label for="image" class="col-form-label required">Scegli un'immagine</label>
                                                <input type="file" name="file1" required>
                                            </div>
                                        </span>                                                                
                                    </div>
                                    <div>
                                        <img id='img-upload'/>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <div class="row">
                                    <div class="col-4">
                                         <button type="submit" name="register-submit" id="create-list-submit" tabindex="4" class="btn btn-primary">Submit</button>
                                    </div>
                                    <div class="col-6">
                                        <a data-dismiss="modal" class="btn btn-dark pull-right" style="color: white;">Close</a>
                                    </div>  
                                    <div class="col-3">
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>                
                </div>
            </div>
        </div>
        <!--deleteimageModal-->
        <div class="modal fade" id="deleteImageModal" tabindex="-1" role="dialog" aria-labelledby="deleteImageModal" aria-hidden="true" style="width: auto;">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <div class="page-title">
                            <div class="container">
                                <h1 class="text-center">Attenzione</h1>
                            </div>                             
                        </div>
                    </div> 
                    <div class="modal-body">                        
                        <h3>Nessuna categoria selezionata, o errore interno</h3><p>Ricaricare la pagina e riprovare</p>                       
                        <a data-dismiss="modal" class="btn btn-dark">Close</a>                         
                    </div>
                </div>                
            </div>
        </div>
                            
                            
        <!--image popup modal-->
        <div class="modal fade" id="imageModal" tabindex="-1" role="dialog" aria-labelledby="imageModal" aria-hidden="true">
        <!--<div id="imageModal" class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true" >-->
            <div class="modal-dialog" >
                <div class="modal-content">
                    <div class="container">
                        
                        Attendere il caricamento...
                        
                    </div>
                </div>
            </div>
        </div>
        <!--######################Modals#############################################-->
                                    
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
        <script>
            //Funzione ajax che carica il modal per eliminare un'immagine da una categoria di liste
                function deleteImage(listname) {
                    $.ajax({
                        type: "GET",
                        url: "/Lists/Pages/template/deleteImage.jsp?listname=" + listname,
                        async: true,
                        success: function (response) {
                            $("#deleteImageModal").html(response);
                        },
                        error: function () {
                            alert("Errore");
                        }
                    });
                }
        </script>
        <script>
            //funzione ajax che carica il modal con il carousel delle immagini per una particolare categoria di liste
                function showImage(listname) {
                    $.ajax({
                        type: "GET",
                        url: "/Lists/Pages/template/showImage.jsp?listname=" + listname,
                        async: true,
                        success: function (response) {
                            $("#imageModal").html(response);
                        },
                        error: function () {
                            alert("Errore");
                        }
                    });
                }
        </script>
        <script>
            //Funzione ajax che setta in sessione il nome della categoria di liste e esegue diverse funzioni a seconda del valore della variabibile link
                function setImage(listname, link) {
                    $.ajax({
                        type: "GET",
                        url: "/Lists/setImage?listname=" + listname + "&link=" + link,
                        async: true,
                        success: function () {
                            if(link === "add"){
                                $('#AddImageModal').modal('show');
                            }else if(link === "delete"){
                                deleteImage();
                                $("#deleteImageModal").modal('show');
                            }else if(link === "show"){
                                showImage();
                                $("#imageModal").modal('show');
                            }
                        },
                        error: function () {
                            alert("Errore");
                        }
                    });
                }
        </script>
        
        <script>
            $(document).ready(function () {
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
                //Side-Navbar
                $.ajax({
                    type: "GET",
                    url: "/Lists/Pages/template/sideNavbar.jsp",
                    cache: false,
                    success: function (response) {
                        $("#sideNavbar").html(response);
                    },
                    error: function () {
                        alert("Errore sideNavbar Template");
                    }
                });

            });
        </script>
</body>
</html>