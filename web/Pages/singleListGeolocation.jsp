<%-- 
    Document   : userlists
    Created on : 15.10.2018, 16:08:08
    Author     : Martin
--%>

<%@page import="Notifications.Notification"%>
<%@page import="database.jdbc.JDBCShopListDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="database.entities.ShopList"%>
<%@page import="database.daos.ListDAO"%>
<%@page import="database.daos.UserDAO"%>
<%@page import="database.jdbc.JDBCUserDAO"%>
<%@page import="database.factories.DAOFactory"%>
<%@page import="database.entities.User"%>
<%@page import="java.net.URLDecoder"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <link rel="icon" href="img/favicon.png" sizes="16x16" type="image/png">
        <title>${shopListName} Map</title>

        <!-- CSS personalizzati -->
        <link href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700|Varela+Round" rel="stylesheet">
        <link rel="stylesheet" href="bootstrap/css/bootstrap.css" type="text/css">
        <link rel="stylesheet" href="fonts/font-awesome.css" type="text/css">
        <link rel="stylesheet" href="css/selectize.css" type="text/css">
        <link rel="stylesheet" href="css/style.css">
        <link rel="stylesheet" href="css/user.css">
        <link rel="stylesheet" href="css/navbar.css">
        <link rel="stylesheet" href="css/datatables.css" type="text/css"> 
        <link rel="stylesheet" href="css/notificationCss.css" type="text/css"> 

        <link rel="stylesheet" type="text/css" href="https://js.api.here.com/v3/3.0/mapsjs-ui.css?dp-version=1542186754" />
        <script type="text/javascript" src="https://js.api.here.com/v3/3.0/mapsjs-core.js"></script>
        <script type="text/javascript" src="https://js.api.here.com/v3/3.0/mapsjs-service.js"></script>
        <script type="text/javascript" src="https://js.api.here.com/v3/3.0/mapsjs-ui.js"></script>
        <script type="text/javascript" src="https://js.api.here.com/v3/3.0/mapsjs-mapevents.js"></script>
        <script type="text/javascript" src="https://js.api.here.com/v3/3.0/mapsjs-places.js"></script>
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>


        <title>Lists</title>

        <!-- Style for serch modal table-->
        <style>
            .modal-dialog{
                position: relative;
                display: table; /* This is important */ 
                overflow-y: auto;    
                overflow-x: auto;
                width: auto;
                min-width: 500px;
                max-height: 530px;
            }
            .modal-body {
                position: relative;
                overflow-y: auto;
                max-height: 530px;
                padding: 15px;
            }
            .hero-wrapper{
                background-image: linear-gradient(rgba(255,255,255,.4), rgba(255,255,255,.9)),url("/Lists/${lista.immagine}");
                background-position-y: center;
                background-size: cover;
                background-repeat: no-repeat;
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
                    <!--============ End Page Title =====================================================================-->  
                    <div class="page-title">
                        <div class="container">
                            <h1>Mappa per ${shopListName}</h1>
                        </div>
                        <!--end container-->
                    </div>
                    <!--end background-->
                </div>
                <!--end hero-wrapper-->
            </header>
            <!--end hero-->
            <!-- SISTEMA PER LE NOTIFICHE -->

            <li class="dropdown" id="notificationsLI"></li>
            <!--*********************************************************************************************************-->
            <!--************ CONTENT ************************************************************************************-->
            <!--*********************************************************************************************************-->
            <section class="content">
                <section class="block">
                    <div class="container">
                        <div class="row">

                            <!--end col-md-3-->
                            <div class="col-md-12">
                                <div id="map" style="width: 100%; height: 400px; background: grey"></div>
                                <br>
                                <!--<input type="range" name="points" min="0" max="5000" id="raggio" style="align-content: center;">-->


                                <div class="container">

                                    <div class="items list compact grid-xl-3-items grid-lg-3-items grid-md-2-items" id="TuttiInegozzi">

                                        <!--end item-->

                                    </div>

                                    <div id = "contenitore"></div>



                                </div>
                                <!--============ Section Title===================================================================-->

                                <!--============ Items ==========================================================================-->

                                <!--end items-->
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
            <footer class="footer">
                <div class="wrapper">                   
                    <div class="background">
                        <div class="background-image original-size">
                            <img src="img/footer-background-icons.jpg" alt="">
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
        <script type="text/javascript" src="js/datatables.js" ></script>
        <c:if test="${not empty user}">             
            <script>
                function myFunction() {
                    var input, filter, ul, li, a, i;
                    input = document.getElementById("myInput");
                    filter = input.value.toUpperCase();
                    ul = document.getElementById("myUL");
                    li = ul.getElementsByTagName("li");
                    for (i = 0; i < li.length; i++) {
                        a = li[i].getElementsByTagName("a")[0];
                        if (a.innerHTML.toUpperCase().indexOf(filter) > -1) {
                            li[i].style.display = "";
                        } else {
                            li[i].style.display = "none";
                        }
                    }
                }
            </script>
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
                        url: "/Lists/Pages/nameContain.jsp?s=" + filter,

                        cache: false,
                        success: function (response) {
                            $("#content-wrapper").html($("#content-wrapper").html() + response);
                        },
                        error: function () {
                            alert("Errore");
                        }
                    });
                    for (i = 0; i < items.length; i++) {
                        console.log(items[i]);
                        console.log("inside cicle ");
                        title = items[i].getElementsByClassName("title");
                        if (title[0].innerHTML.toUpperCase().indexOf(filter) > -1) {

                            items = document.getElementsByClassName("item");
                            title = items[i].getElementsByClassName("title");
                            items[i].style.display = "";
                            document.getElementById("loadProducts").style.display = "none";

                        } else {
                            items[i].style.display = "none";
                            document.getElementById("loadProducts").style.display = "";
                        }
                    }
                }
            </script>
        </c:if>           

        <!-- Login Modal -->
        <div class="modal fade" id="LoginModal" tabindex="-1" role="dialog" aria-labelledby="LoginModal" aria-hidden="true"></div>
        <!--######################################################-->

        <!-- Register Modal -->
        <div class="modal fade" id="RegisterModal" tabindex="-1" role="dialog" aria-labelledby="RegisterModal" aria-hidden="true" enctype="multipart/form-data"></div>

        <!-- restore password Modal -->
        <div class="modal fade" id="restorePassword" tabindex="-1" role="dialog" aria-labelledby="restorePassword" aria-hidden="true"></div>
        <!--######################################################-->

        <!-- new password Modal -->
        <div class="modal fade" id="newPassword" tabindex="-1" role="dialog" aria-labelledby="newPassword" aria-hidden="true"></div>

        <div class="modal fade" id="CreateListModal" tabindex="-1" role="dialog" aria-labelledby="CreateShopListform" aria-hidden="true" enctype="multipart/form-data"></div>
        <!--##############################-->
        <div class="modal fade" id="import-list" tabindex="-1" role="dialog" aria-labelledby="import-list" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <div class="page-title">
                            <div class="container">
                                <h1 style="text-align: center;">Importa la tua lista</h1>
                            </div>
                            <!--end container-->
                        </div>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <!-- Form per il login -->
                        <form class="form clearfix" id="ImportShopListform" action="/Lists/importGuestList"  method="get" role="form">
                            <div class="form-group">
                                <label for="Nome" class="col-form-label">Email</label>
                                <input type="email" name="creator" id="creator" tabindex="1" class="form-control" placeholder="Email" required>
                            </div>
                            <div class="form-group">
                                <label for="password" class="col-form-label">Password</label>
                                <input type="password" name="password" id="passwordGuest" tabindex="1" class="form-control" placeholder="Password" required>
                            </div>
                            <!--end form-group-->
                            <button type="submit" name="import-submit" id="import-list-submit" tabindex="4" class="btn btn-primary">Importa lista</button>
                        </form>
                        <hr>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="js/nav.js"></script>


        <!--MAPPA=====================================================================================================-->

        <script  type="text/javascript" charset="UTF-8" >
                var raggio = 5000;
                var keyWord = "${lista.categoria}";
                //----------------------------------------------------------------------


                //---------------------------------INIT MAP---------------------------------------

                //Step 1: initialize communication with the platform
                var platform = new H.service.Platform({
                    app_id: 'devportal-demo-20180625',
                    app_code: '9v2BkviRwi9Ot26kp2IysQ',
                    useHTTPS: true
                });
                var pixelRatio = window.devicePixelRatio || 1;
                var defaultLayers = platform.createDefaultLayers({
                    tileSize: pixelRatio === 1 ? 256 : 512,
                    ppi: pixelRatio === 1 ? undefined : 320
                });

                //Step 2: initialize a map  - not specificing a location will give a whole world view.
                var map = new H.Map(document.getElementById('map'), defaultLayers.normal.map, {pixelRatio: pixelRatio});

                //Step 3: make the map interactive
                // MapEvents enables the event system
                // Behavior implements default interactions for pan/zoom (also on mobile touch environments)
                var behavior = new H.mapevents.Behavior(new H.mapevents.MapEvents(map));

                // Create the default UI components
                var ui = H.ui.UI.createDefault(map, defaultLayers);

                //---------------------------------END OF INIT MAP------------------------------------

                var yourLat = 0;
                var yourLong = 0;

                /**
                 * prende la posizione, la ricava dal browser
                 * @returns {undefined}
                 */
                function getLocation() {
                    if (navigator.geolocation) {
                        navigator.geolocation.getCurrentPosition(showPosition);
                    } else {
                        x.innerHTML = "Geolocation is not supported by this browser.";
                    }
                }


                function showPosition(position) {
                    yourLat = position.coords.latitude;
                    yourLong = position.coords.longitude;
                    console.log("latitude: " + yourLat);
                    console.log("longitude: " + yourLong);
                    var nomeLista, nomeCategoria;
                    map.setCenter({lat: yourLat, lng: yourLong});
                    map.setZoom(12);
                    addCircleToMap(yourLat, yourLong);
                    var parisMarker = new H.map.Marker({lat: yourLat, lng: yourLong});
                    map.addObject(parisMarker);

                    var params = {
                        'q': keyWord,
                        'at': yourLat + ',' + yourLong
                    };
                    var search = new H.places.Search(platform.getPlacesService()), searchResult, error;




                    //Define a callback function to handle errors:
                    function onError(data) {
                        error = data;
                        console.log(error);
                    }

                    // Run a search request with parameters, headers (empty), and
                    // callback functions:

                    var usi = '${user}';
                    nomeLista = "${shopListName}";
                    nomeCategoria = "${lista.categoria}";
                    if (usi === "")
                        nomeCategoria = "${guestList.categoria}";
                    console.log("Sto cercando per cetegoria [" + nomeCategoria + "] nella lista [" + nomeLista + "]");
                    giveAllPlaces(nomeCategoria, nomeLista);



                    function buildDOMwithPlaces(nomeLista, nomeLocale, category, distance, orari, vicinity) {
                        var msg = "Hei sei nelle vicinanze di una farmacia, dai un occhiata alla lista {NOME LISTA} e completa la spesa";

                        var cardHeader = "<div id=\"accordion\">" +
                                "<div class=\"card\">" +
                                "<div class=\"card-header\" id=\"headingOne\">" +
                                "<h5 class=\"mb-0\">" +
                                "<button class=\"btn collapsed\" data-toggle=\"collapse\" data-target=\"#collapseTwo\" aria-expanded=\"false\" aria-controls=\"collapseTwo\">" +
                                "Collapsible Group Item #1" +
                                "</button>" +
                                "</h5>" +
                                "</div>" +
                                "<div id=\"collapseTwo\" class=\"collapse\" aria-labelledby=\"headingTwo\" data-parent=\"#accordion\">" +
                                " <div class=\"card-body\">";

                        var table = "<tr>" +
                                "<td>" + searchResult.results.items[i].title + "</td>" +
                                "<td>" + category + "</td>" +
                                "<td>" + distance + "</td>" +
                                "<td>" + orari + "</td>" +
                                "<td>" + vicinity + "</td>" +
                                "<td>" + nomeLista + "</td>" +
                                "</tr>";

                        var closeCard = "</table>" +
                                "</div>" +
                                "</div>" +
                                "</div>" +
                                "</div>";


                        var tableHeader = " <table class=\"table\">" +
                                "<thead class=\"thead-dark\">" +
                                "<tr>" +
                                "<th>Nome</th>" +
                                "<th>Categoria</th>" +
                                "<th>Distanza</th>" +
                                "<th>orari</th>" +
                                "<th>Indirizzo</th>" +
                                "<th>nome lista</th>" +
                                "</tr>" +
                                "</thead>" +
                                "<tbody id=\"tabella\">";

                        var tableClose = "</tbody>" +
                                "</table>";

                        document.getElementById("contenitore").innerHTML += "";
                    }

                    function giveAllPlaces(nomeCategoria, nomeLista) {
                        $.ajax({
                            url: 'https://places.demo.api.here.com/places/v1/discover/search',
                            type: 'GET',
                            data: {
                                at: yourLat + ',' + yourLong,
                                q: nomeCategoria,
                                app_id: 'devportal-demo-20180625',
                                app_code: '9v2BkviRwi9Ot26kp2IysQ'
                            },
                            beforeSend: function (xhr) {
                                xhr.setRequestHeader('Accept', 'application/json');
                            },
                            success: function (data) {
                                //alert(JSON.stringify(data));
                                console.log(data);
                                //alert(nomeLista);

                                searchResult = data;
                                console.log(searchResult);
                                console.log(searchResult.results.items[0].position);

                                var cardHeader = "<div id=\"accordion\">" +
                                        "<div class=\"card\">" +
                                        "<div class=\"card-header\" id=\"heading" + nomeLista + "\">" +
                                        "<h5 class=\"mb-0\">" +
                                        "<button class=\"btn collapsed\" data-toggle=\"collapse\" data-target=\"#collapse" + nomeLista + "\" aria-expanded=\"false\" aria-controls=\"collapse" + nomeLista + "\">" +
                                        "Collapsible Group Item #1" +
                                        "</button>" +
                                        "</h5>" +
                                        "</div>" +
                                        "<div id=\"collapse" + nomeLista + "\" class=\"collapse\" aria-labelledby=\"heading" + nomeLista + "\" data-parent=\"#accordion\">" +
                                        " <div class=\"card-body\">";

                                var tableHeader = " <table class=\"table\">" +
                                        "<thead class=\"thead-dark\">" +
                                        "<tr>" +
                                        "<th>Nome</th>" +
                                        "<th>Categoria</th>" +
                                        "<th>Distanza</th>" +
                                        "<th>orari</th>" +
                                        "<th>Indirizzo</th>" +
                                        "<th>nome lista</th>" +
                                        "</tr>" +
                                        "</thead>" +
                                        "<tbody id=\"" + nomeLista + "\">";

                                var tableClose = "</tbody>" +
                                        "</table>";

                                var closeCard = "</table>" +
                                        "</div>" +
                                        "</div>" +
                                        "</div>" +
                                        "</div>";

                                var msg = "<br><div><h1 class=\"center\">Hei sei nelle vicinanze di un negozio simile a <span style = \"color:red;\">" + nomeCategoria + "</span>, dai un occhiata alla lista <span><a style = \"color:red;\" href='/Lists/ShowShopList?nome=" + nomeLista + "'>" + nomeLista + "</a></span> e completa la spesa</h1></div><br>";
                                document.getElementById("TuttiInegozzi").innerHTML += msg;
                                //document.getElementById("contenitore").innerHTML += tableHeader;

                                var distanzaMassima = raggio;
                                for (var i = 0, max = 5; i < max; i++) {
                                    var l = searchResult.results.items[i].position[0];
                                    var la = searchResult.results.items[i].position[1];
                                    var icon = new H.map.Icon(searchResult.results.items[i].icon);

                                    // Create a marker using the previously instantiated icon:
                                    var marker = new H.map.Marker({lat: l, lng: la}, {icon: icon});
                                    var category = searchResult.results.items[i].category.title;
                                    var distance = searchResult.results.items[i].distance;
                                    var openingHours = searchResult.results.items[i].openingHours;
                                    var vicinity = searchResult.results.items[i].vicinity;

                                    var orari = "";
                                    if (openingHours) {
                                        orari = openingHours.text;
                                        console.log(openingHours.text);
                                    } else {
                                        orari = "non ci sono gli orari";
                                        console.log("non ci sono gli orari");
                                    }
                                    console.log(openingHours);

                                    if (distance < distanzaMassima) {
                                        //document.getElementById(nomeLista).innerHTML += "<tr><td>" + searchResult.results.items[i].title + "</td>" + "<td>" + category + "</td>" + "<td>" + distance + "</td>" + "<td>" + orari + "</td>" + "<td>" + vicinity + "</td>"+ "<td>" + nomeLista + "</td>"+"</tr>";
                                        var im = '${lista.immagine}';
                                        if (im === "")
                                            im = '${guestList.immagine}';
                                        document.getElementById("TuttiInegozzi").innerHTML += "<div class=\"item\">" +
                                                "<div class=\"wrapper\">" +
                                                "<div class=\"image\">" +
                                                "<h3>" +
                                                "<a href=\"#\" class=\"tag category\">" + category + "</a>" +
                                                "<a href=\"#\" class=\"title\">" + searchResult.results.items[i].title + "</a>" +
                                                "</h3>" +
                                                "<a href=\"#\" class=\"image-wrapper background-image\">" +
                                                '<img style="width: inherit; display:unset;" src=/Lists/' + im + '>' +
                                                "</a>" +
                                                "</div>" +
                                                "<h4 class=\"location\">" +
                                                "<a href=\"#\">" + vicinity + "</a>" +
                                                "</h4>" +
                                                "<div class=\"meta\">" +
                                                "<figure>" +
                                                "<i class=\"fa fa-calendar-o\"></i> orario: " + orari +
                                                "</figure>" +
                                                "</div>" +
                                                "</div>" +
                                                "</div>";

                                        console.log(searchResult.results.items[i].title);

                                        console.log("???????????????????????????????????????????? " + nomeLista);

                                        // Add the marker to the map:
                                        map.addObject(marker);
                                    }

                                }
                                document.getElementById("contenitore").innerHTML += tableClose;


                            }
                        });
                    }


                }



                getLocation();

                function addCircleToMap(lat, lng) {
                    map.addObject(new H.map.Circle(
                            // The central point of the circle
                                    {lat: lat, lng: lng},
                                    // The radius of the circle in meters
                                    raggio,
                                    {
                                        style: {
                                            strokeColor: 'rgba(55, 85, 170, 0.6)', // Color of the perimeter
                                            lineWidth: 2,
                                            fillColor: 'rgba(0, 128, 0, 0.7)'  // Color of the circle
                                        }
                                    }
                            ));
                        }

                function addDomMarker(map, lon, lat, text) {
                    var outerElement = document.createElement('div'),
                            innerElement = document.createElement('div');

                    outerElement.style.userSelect = 'none';
                    outerElement.style.webkitUserSelect = 'none';
                    outerElement.style.msUserSelect = 'none';
                    outerElement.style.mozUserSelect = 'none';
                    outerElement.style.cursor = 'default';

                    innerElement.style.color = 'red';
                    innerElement.style.backgroundColor = 'white';
                    innerElement.style.border = '2px solid black';
                    innerElement.style.font = 'normal 12px arial';
                    innerElement.style.lineHeight = '12px';

                    innerElement.style.paddingTop = '2px';
                    innerElement.style.paddingLeft = '4px';
                    innerElement.style.width = '20px';
                    innerElement.style.height = '20px';

                    // add negative margin to inner element
                    // to move the anchor to center of the div
                    innerElement.style.marginTop = '-10px';
                    innerElement.style.marginLeft = '-10px';

                    outerElement.appendChild(innerElement);

                    // Add text to the DOM element
                    innerElement.innerHTML = text;

                    function changeOpacity(evt) {
                        evt.target.style.opacity = 0.6;
                    }
                    ;

                    function changeOpacityToOne(evt) {
                        evt.target.style.opacity = 1;
                    }
                    ;

                    //create dom icon and add/remove opacity listeners
                    var domIcon = new H.map.DomIcon(outerElement, {
                        // the function is called every time marker enters the viewport
                        onAttach: function (clonedElement, domIcon, domMarker) {
                            clonedElement.addEventListener('mouseover', changeOpacity);
                            clonedElement.addEventListener('mouseout', changeOpacityToOne);
                        },
                        // the function is called every time marker leaves the viewport
                        onDetach: function (clonedElement, domIcon, domMarker) {
                            clonedElement.removeEventListener('mouseover', changeOpacity);
                            clonedElement.removeEventListener('mouseout', changeOpacityToOne);
                        }
                    });

                    // Marker for Chicago Bears home
                    var bearsMarker = new H.map.DomMarker({lat: lat, lng: lon}, {
                        icon: domIcon
                    });
                    map.addObject(bearsMarker);
                }
        </script>

        <script type="text/javascript">
            $(document).ready(function () {
                //LoginModal
                $.ajax({
                    type: "GET",
                    url: "/Lists/Pages/template/loginTemplate.jsp",
                    cache: false,
                    success: function (response) {
                        $("#LoginModal").html(response);
                    },
                    error: function () {
                        alert("Errore LoginModalImport");
                    }
                });

                //RegisterModal
                $.ajax({
                    type: "GET",
                    url: "/Lists/Pages/template/registerTemplate.jsp",
                    cache: false,
                    success: function (response) {
                        $("#RegisterModal").html(response);
                    },
                    error: function () {
                        alert("Errore RegisterModalImport");
                    }
                });

                //Restore password
                $.ajax({
                    type: "GET",
                    url: "/Lists/Pages/template/restorePasswordTemplate.jsp",
                    cache: false,
                    success: function (response) {
                        $("#restorePassword").html(response);
                    },
                    error: function () {
                        alert("Errore restorePasswordTemplate");
                    }
                });

                //New password
                $.ajax({
                    type: "GET",
                    url: "/Lists/Pages/template/newPasswordTemplate.jsp",
                    cache: false,
                    success: function (response) {
                        $("#newPassword").html(response);
                    },
                    error: function () {
                        alert("Errore newPasswordTemplate");
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

    </body>
</html>
