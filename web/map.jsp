<%-- 
    Document   : map
    Created on : 23-gen-2019, 11.19.07
    Author     : Roberto97
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!doctype html>
<html lang="en">
    <head>
        <link rel="stylesheet" type="text/css" href="https://js.api.here.com/v3/3.0/mapsjs-ui.css?dp-version=1542186754" />
        <script type="text/javascript" src="https://js.api.here.com/v3/3.0/mapsjs-core.js"></script>
        <script type="text/javascript" src="https://js.api.here.com/v3/3.0/mapsjs-service.js"></script>
        <script type="text/javascript" src="https://js.api.here.com/v3/3.0/mapsjs-ui.js"></script>
        <script type="text/javascript" src="https://js.api.here.com/v3/3.0/mapsjs-mapevents.js"></script>
        <script type="text/javascript" src="https://js.api.here.com/v3/3.0/mapsjs-places.js"></script>
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    </head>
    <body>
        <script type="text/javascript" src="http://maps.google.com/maps/api/js?key=AIzaSyBEDfNcQRmKQEyulDN8nGWjLYPm8s4YB58&libraries=places"></script>
        <script>
            <%System.out.println("NOME: " + request.getParameter("listaNome"));%>
            <%System.out.println("CATEGORIA: " + request.getParameter("listaCategoria"));%>
            <%System.out.println("UTENTE: " + request.getParameter("utenteNome"));%>
            <%System.out.println("EMAIL: " + request.getParameter("utenteEmail"));%>
            var keyWord = "<%=request.getParameter("listaNome")%>";
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
//var map = new H.Map(document.getElementById('map'), defaultLayers.normal.map, {pixelRatio: pixelRatio});

//Step 3: make the map interactive
// MapEvents enables the event system
// Behavior implements default interactions for pan/zoom (also on mobile touch environments)
//var behavior = new H.mapevents.Behavior(new H.mapevents.MapEvents(map));

// Create the default UI components
//var ui = H.ui.UI.createDefault(map, defaultLayers);

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
                    console.log("Geolocation is not supported by this browser.");
                }
            }


            function showPosition(position) {
                yourLat = position.coords.latitude;
                yourLong = position.coords.longitude;
                console.log("latitude: " + yourLat);
                console.log("longitude: " + yourLong);
                var nomeLista, nomeCategoria;
                //map.setCenter({lat: yourLat, lng: yourLong});
                //map.setZoom(12);
                //addCircleToMap(yourLat, yourLong);
                //var parisMarker = new H.map.Marker({lat: yourLat, lng: yourLong});
                //map.addObject(parisMarker);

                /*var params = {
                 'q': keyWord,
                 'at': yourLat + ',' + yourLong
                 };*/
                var search = new H.places.Search(platform.getPlacesService()), searchResult, error;


                var z = 0;
                /*function onResult(data) {
                 z++;
                 console.log("sto guardanado z: " + z);
                 console.log("guardo il nome della lista: " + nomeLista);
                 
                 searchResult = data;
                 console.log(searchResult);
                 console.log(searchResult.results.items[0].position);
                 
                 
                 var distanzaMassima = 1000;
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
                 document.getElementById("tabella").innerHTML += "<tr><td>" + searchResult.results.items[i].title + "</td>" + "<td>" + category + "</td>" + "<td>" + distance + "</td>" + "<td>" + orari + "</td>" + "<td>" + vicinity + "</td>" + "</tr>";
                 }
                 console.log(searchResult.results.items[i].title);
                 
                 console.log("???????????????????????????????????????????? " + nomeLista);
                 
                 // Add the marker to the map:
                 map.addObject(marker);
                 }
                 }*/

                //Define a callback function to handle errors:
                /*function onError(data) {
                 error = data;
                 console.log(error);
                 }*/

                // Run a search request with parameters, headers (empty), and
                // callback functions:


                nomeLista = "<%=request.getParameter("listaNome")%>";
                nomeCategoria = "<%=request.getParameter("listaCategoria")%>";
                
                console.log("Sto cercando per cetegoria [" + nomeCategoria + "] nella lista [" + nomeLista + "]");
                giveAllPlaces(nomeCategoria, nomeLista);

                /*function buildDOMwithPlaces(nomeLista, nomeLocale, category, distance, orari, vicinity) {
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
                 }*/

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

                            /*var cardHeader = "<div id=\"accordion\">" +
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
                             
                             var msg = "<div class=\"shadow-lg p-3 mb-5 bg-white rounded\">Hei sei nelle vicinanze di una " + nomeCategoria + ", dai un occhiata alla lista " + nomeLista + " e completa la spesa</div>";
                             document.getElementById("contenitore").innerHTML += msg;
                             document.getElementById("contenitore").innerHTML += tableHeader;*/

                            var distanzaMassima = 1000;
                            for (var i = 0, max = 5; i < max; i++) {
                                var l = searchResult.results.items[i].position[0];
                                var la = searchResult.results.items[i].position[1];
                                //var icon = new H.map.Icon(searchResult.results.items[i].icon);

                                // Create a marker using the previously instantiated icon:
                                //var marker = new H.map.Marker({lat: l, lng: la}, {icon: icon});
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
                                if (distance <= distanzaMassima) {
                                    console.log(openingHours);

                                    //document.getElementById(nomeLista).innerHTML += "<tr><td>" + searchResult.results.items[i].title + "</td>" + "<td>" + category + "</td>" + "<td>" + distance + "</td>" + "<td>" + orari + "</td>" + "<td>" + vicinity + "</td>" + "<td>" + nomeLista + "</td>" + "</tr>";

                                    console.log(searchResult.results.items[i].title);

                                    console.log("???????????????????????????????????????????? " + nomeLista);
                                    $.ajax({
                                        type: "POST",
                                        url: "/Lists/sendProximityEmail",
                                        data: {email: '<%=request.getParameter("utenteEmail")%>', nome: '<%=request.getParameter("utenteNome")%>', lista: '<%=request.getParameter("listaNome")%>'},
                                        cache: false,
                                        success: function () {
                                            console.log("email sent");
                                        },
                                        error: function () {
                                            alert("Errore sending email proximity");
                                        }
                                    });

                                    // Add the marker to the map:
                                    //map.addObject(marker);
                                }
                            }
                            //document.getElementById("contenitore").innerHTML += tableClose;


                        }
                    });
                }


            }



            getLocation();

            /*function addCircleToMap(lat, lng) {
             map.addObject(new H.map.Circle(
             // The central point of the circle
             {lat: lat, lng: lng},
             // The radius of the circle in meters
             4000,
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
             }*/
        </script>
    </body>
</html>