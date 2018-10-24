<!DOCTYPE html>
<html>
    <head>
        <title>Place Searches</title>
        <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
        <meta charset="utf-8">
        <style>
            /* Always set the map height explicitly to define the size of the div
             * element that contains the map. */
            #map {
                height: 100%;
            }
            /* Optional: Makes the sample page fill the window. */
            html, body {
                height: 100%;
                margin: 0;
                padding: 0;
            }
        </style>
        <script>
            // This example requires the Places library. Include the libraries=places
            // parameter when you first load the API. For example:
            // <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&libraries=places">

            var map;
            var infowindow;
            var pos = {lat: 46.0679467, lng: 11.1502771}

            function initMap() {
                infowindow = new google.maps.InfoWindow();
                if (navigator.geolocation) {
                    navigator.geolocation.getCurrentPosition(function (position) {
                        pos = {lat: position.coords.latitude, lng: position.coords.longitude};
                        console.log(pos);
                    });

                }

                map = new google.maps.Map(document.getElementById('map'), {
                    center: pos,
                    zoom: 13
                });

                infowindow.setPosition(pos);
                infowindow.setContent('Location found.');
                infowindow.open(map);
                map.setCenter(pos);


                var cityCircle = new google.maps.Circle({
                    strokeColor: '#FF0000',
                    strokeOpacity: 0.8,
                    strokeWeight: 2,
                    fillColor: '#FF0000',
                    fillOpacity: 0.35,
                    map: map,
                    center: pos,
                    radius: 5000
                });


                var service = new google.maps.places.PlacesService(map);
                service.nearbySearch({
                    location: pos,
                    radius: 10000,
                    type: ['supermarket']
                }, callback);
            }

            function callback(results, status) {
                if (status === google.maps.places.PlacesServiceStatus.OK) {
                    for (var i = 0; i < results.length; i++) {
                        createMarker(results[i]);
                    }
                }
            }

            function createMarker(place) {
                var placeLoc = place.geometry.location;
                var marker = new google.maps.Marker({
                    map: map,
                    position: place.geometry.location
                });

                google.maps.event.addListener(marker, 'click', function () {
                    infowindow.setContent(place.name);
                    infowindow.open(map, this);
                });
            }
        </script>
    </head>
    <body>
        <div id="map"></div>
        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCjXyXm-OQw78LLDEADIrQbl5OFKZGlam8&libraries=places&callback=initMap" async defer></script>
    </body>
</html>

