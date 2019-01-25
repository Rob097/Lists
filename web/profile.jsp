<%-- 
    Document   : profile
    Created on : 15.10.2018, 16:49:13
    Author     : Martin
--%>

<%@page import="database.entities.User"%>
<%@page import="java.net.URLDecoder"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="icon" href="Pages/img/favicon.png" sizes="16x16" type="image/png">
        <title>Lists</title>

        <c:if test="${empty user}">
            <c:redirect url="/homepage.jsp"/>
        </c:if>

        <!-- CSS personalizzati -->

        <link href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700|Varela+Round" rel="stylesheet">
        <link rel="stylesheet" href="Pages/bootstrap/css/bootstrap.css" type="text/css">
        <link rel="stylesheet" href="Pages/fonts/font-awesome.css" type="text/css">
        <link rel="stylesheet" href="Pages/css/selectize.css" type="text/css">
        <link rel="stylesheet" href="Pages/css/style.css">    
        <link rel="stylesheet" href="Pages/css/navbar.css">
        <link rel="stylesheet" href="Pages/css/notificationCss.css" type="text/css"> 
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
        <c:if test="${not empty user}">
            <div class="page home-page">
                <header class="hero">
                    <div class="hero-wrapper">
                        <div id="navbar">
                            <!-- Qui viene inclusa la navbar -->
                        </div>

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
                <!-- SISTEMA PER LE NOTIFICHE -->

                <li class="dropdown" id="notificationsLI"></li>
                <!--end hero-->
                <!--*********************************************************************************************************-->
                <!--************ CONTENT ************************************************************************************-->
                <!--*********************************************************************************************************-->
                <section class="content">
                    <section class="block">
                        <div class="container">
                            <div class="row">
                                <div class="col-md-3" id="sideNavbar">
                                    <!-- Qui c'è la side navar caricata dal template con AJAX -->
                                </div>
                                <!--end col-md-3-->
                                <div class="col-md-9">
                                    <form class="form clearfix" id="update-user-form" action="/Lists/restricted/updateUser" method="post" enctype="multipart/form-data" onsubmit="return validate();">
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
                                                    <div class="form-group" style="display: flex;">
                                                        <c:if test="${user.sendEmail == true}">
                                                            <input type="checkbox" tabindex="3" class="" name="send" id="send" checked="true">
                                                        </c:if>
                                                        <c:if test="${user.sendEmail == false}">
                                                            <input type="checkbox" tabindex="3" class="" name="send" id="send">
                                                        </c:if>
                                                        <label for="standard">Inviami email per la prossimità a negozi e promemoria di acquisto</label>
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
                                                    <button type="button" class="btn btn-dark float-right" id="delete1" data-toggle="modal" data-target="#delete-modal">Cancella profilo</button>
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
                                                        <label class="mr-3 align-text-bottom">Tipo utente:</label>
                                                        <select name="type" id="type" class="small width-200px" data-placeholder="${user.tipo}">
                                                        <c:if test="${user.tipo == 'standard'}">
                                                            <option id="mioTipo" value="standard">Standard</option>
                                                            <option id="altroTipo" value="amministratore">Amministratore</option>
                                                        </c:if>
                                                        <c:if test="${user.tipo == 'amministratore'}">
                                                            <option id="mioTipo" value="amministratore">Amministratore</option>
                                                            <option id="altroTipo" value="standard">Standard</option>
                                                        </c:if>
                                                        </select>
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
                <footer class="footer"></footer>
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
                                <button type="submit" class="btn btn-dark" id="delete2">Delete</button>
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
            <!--<script src="Pages/js/userimage.js"></script>-->
            <script type="text/javascript">
            var type = document.getElementById("type");
            
            type.onchange = function(){
                if(type.value === "standard"){
                    $.ajax({
                        type: "POST",
                        url: "/Lists/changeType",
                        data: {email: '${user.email}', tipo: 'standard'},
                        cache: false,
                        success: function () {
                            document.location.href = "/Lists/homepage.jsp";
                        },
                        error: function () {
                            alert("Errore change type ajax");
                        }
                    });          
                }else            
                if(type.value === "amministratore"){
                    
                    $.ajax({
                        type: "POST",
                        url: "/Lists/changeType",
                        data: {email: '${user.email}', tipo: 'amministratore'},
                        cache: false,
                        success: function () {
                            document.location.href = "/Lists/homepage.jsp";
                        },
                        error: function () {
                            alert("Errore change type ajax");
                        }
                    });          
                }
            };
            </script>
            <script>
            $(document).ready(function () {
                $(document).on('change', '.btn-file :file', function () {
                    var input = $(this),
                            label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
                    input.trigger('fileselect', [label]);
                });

                $('.btn-file :file').on('fileselect', function (event, label) {

                    var input = $(this).parents('.input-group').find(':text'),
                            log = label;

                    if (input.length) {
                        input.val(log);
                    } else {
                        if (log)
                            alert(log);
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

                $("#imgInp").change(function () {
                    readURL(this);
                });
            });
            </script>
            <script type="text/javascript">
                function validate() {
                    var n1 = document.getElementById("password");
                    var n2 = document.getElementById("pswrt2");
                    if (n1.value != "" && n2.value != "") {
                        if ((n1.value == n2.value)) {
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

                    //Notifiche
                    $.ajax({
                        type: "GET",
                        url: "/Lists/Pages/template/notifiche.jsp",
                        cache: false,
                        success: function (response) {
                            $("#notificationsLI").html(response);
                        },
                        error: function () {
                            alert("Errore Notifiche template");
                        }
                    });
                });
            </script>
        </c:if>        
    </body>
</html>
