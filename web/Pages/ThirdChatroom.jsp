<%@page import="database.jdbc.JDBCProductDAO"%>
<%@page import="database.daos.ProductDAO"%>
<%@page import="database.entities.Product"%>
<%@page import="database.jdbc.JDBCShopListDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="database.entities.ShopList"%>
<%@page import="database.daos.ListDAO"%>
<%@page import="database.daos.UserDAO"%>
<%@page import="database.jdbc.JDBCUserDAO"%>
<%@page import="database.factories.DAOFactory"%>
<%@page import="database.entities.User"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Blob"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!doctype html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <meta name="author" content="ThemeStarz">

        <link rel="icon" href="img/favicon.png" sizes="16x16" type="image/png">
        <title>Products</title>

        <!-- CSS personalizzati -->
        <link href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700|Varela+Round" rel="stylesheet">
        <link rel="stylesheet" href="bootstrap/css/bootstrap.css" type="text/css">
        <link rel="stylesheet" href="fonts/font-awesome.css" type="text/css">
        <link rel="stylesheet" href="css/selectize.css" type="text/css">
        <link rel="stylesheet" href="css/style.css">
        <link rel="stylesheet" href="css/user.css">
        <link rel="stylesheet" href="css/navbar.css">

        <title>Craigs - Easy Buy & Sell Listing HTML Template</title>

        <style>
            .username{
                display: block;
                text-align: left;
                margin-bottom: 0em;
                font-style: oblique;
                font-weight: bold;
            }
        </style>

    </head>
    <body onload="loadChatFile()">
        <div class="page sub-page">
            <!--*********************************************************************************************************-->
            <!--************ HERO ***************************************************************************************-->
            <!--*********************************************************************************************************-->
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
                                    <a class="nav-link js-scroll-trigger"  href="../homepage.jsp"><i class="fa fa-home"></i><b>Home</b></a>
                                </li>
                                <li class="nav-item js-scroll-trigger dropdown">
                                    <div style="cursor: pointer;" class="nav-link dropdown-toggle" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="fa fa-bars"></i><b>Liste</b></div>
                                    <div class="dropdown-menu" style="color: white;" aria-labelledby="navbarDropdown">
                                        <a class="dropdown-item nav-link" href="../userlists.jsp"><i class="fa fa-bars"></i><b>Le mie liste</b></a>
                                        <a class="dropdown-item nav-link" href="../foreignLists.jsp"><i class="fa fa-share-alt"></i><b>Liste condivise con me</b></a>                                        
                                    </div>
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
                </div>
                <!--end collapse-->
                <!--============ End Hero Form ======================================================================-->
                <!--============ Page Title =========================================================================-->
                <div class="page-title">
                    <div class="container">
                        <h1>Messages</h1>
                        <br>
                    </div>
                    <!--end container-->
                </div>
                <!--============ End Page Title =====================================================================-->
                <div class="background"></div>
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
                    <div class="col-md-5 col-lg-5 col-xl-4">
                        <!--============ Section Title===========================================================-->
                        <div class="section-title clearfix">
                            <h3>People</h3>
                        </div>
                        <div id="messaging__chat-list" class="messaging__box">
                            <div class="messaging__header">
                                <h1>Users</h1>
                            </div>
                            <div class="messaging__content">
                                <ul class="messaging__persons-list">
                                    <c:forEach items="${userList}" var="u">
                                        <li>
                                            <a class="messaging__person">
                                                <figure class="messaging__image-item" data-background-image="../${u.image}"></figure>
                                                <figure class="content">
                                                    <h5><c:out value="${u.nominativo}"/></h5>
                                                </figure>
                                                <figure class="messaging__image-person" ></figure>
                                            </a>
                                            <!--messaging__person-->
                                        </li>
                                    </c:forEach>
                                </ul>
                                <!--end messaging__persons-list-->
                            </div>
                            <!--messaging__content-->
                        </div>
                        <!--end section-title-->
                    </div>
                    <!--end col-md-3-->
                    <div class="col-md-7 col-lg-7 col-xl-8">
                        <!--============ Section Title===========================================================-->
                        <div class="section-title clearfix">
                            <h3>Message Window</h3>
                        </div>
                        <!--end section-title-->
                        <div id="messaging__chat-window" class="messaging__box">
                            <div class="messaging__header">
                                <div class="float-left flex-row-reverse messaging__person">
                                    <h5 class="font-weight-bold" id="Sender"><c:out value="${user.nominativo}"/></h5>
                                    <input type = "hidden" name = "senderEmail" id = "senderEmail" value = "<c:out value="${user.email}"/>">
                                    <figure class="mr-4 messaging__image-person" data-background-image="assets/img/author-02.jpg"></figure>
                                </div>
                                <div class="float-right messaging__person">
                                    <h5 class="mr-4" id="shoplistName"><c:out value="${shopListName}"/></h5>
                                    <figure id="messaging__user" class="messaging__image-person" data-background-image="assets/img/author-06.jpg"></figure>
                                </div>
                            </div>
                            <div class="messaging__content" data-background-color="rgba(0,0,0,.05)" id="panellodeimessaggi">
                                <div class="messaging__main-chat" id="TuttiImessaggi">
                                    <div class="messaging__main-chat__bubble">
                                        <p>
                                            Curabitur vel venenatis sem. Fusce suscipit pharetra nisl, sit amet blandit sem sollicitudin ac.
                                            <small>24 hour ago</small>
                                        </p>
                                    </div>
                                    <div class="messaging__main-chat__bubble">
                                        <p>
                                            Vivamus laoreet nisl a odio commodo varius. Donec arcu mauris, molestie a euismod at,
                                            mattis eu arcu. Cras volutpat, velit sit amet cursus molestie, ex ipsum sagittis urna,
                                            vitae auctor augue erat eget justo. Sed dignissim lacus risus, ut blandit nunc volutpat
                                            quis. Fusce porta semper nisi, quis lobortis nulla ultricies ac.
                                            <small>24 hour ago</small>
                                        </p>
                                    </div>
                                    <div class="messaging__main-chat__bubble user">
                                        <p>
                                            Cras volutpat, velit sit amet cursus molestie, ex ipsum sagittis urna,
                                            vitae auctor augue erat eget justo. Sed dignissim lacus risus, ut blandit nunc
                                            <small>24 hour ago</small>
                                        </p>
                                    </div>
                                    <div class="messaging__main-chat__bubble user">
                                        <p>
                                            Sed dignissim lacus risus, ut blandit nunc
                                            <small>24 hour ago</small>
                                        </p>
                                    </div>
                                    <div class="messaging__main-chat__bubble">
                                        <p>
                                            Donec consequat lobortis erat non tempus. Quisque id accumsan velit. Nullam mollis bibendum ex.
                                            Integer egestas nisi nulla, ut tempus mi euismod in
                                            <small>24 hour ago</small>
                                        </p>
                                    </div>
                                    <div class="messaging__main-chat__bubble user">
                                        <p>
                                            <span style="float: right;">Nome utente</span>
                                            Quisque id accumsan velit. Nullam mollis bibendum ex.
                                            Integer egestas nisi nulla, ut tempus mi euismod in
                                            <small>24 hour ago</small>
                                        </p>
                                    </div>
                                </div>
                            </div>
                            <div class="messaging__footer">

                                <div class="input-group">
                                    <input id="messaggioDaInviare" type="text" class="form-control mr-4" placeholder="Your Message">
                                    <div class="input-group-append">
                                        <button class="btn btn-primary" type="submit" onclick="sendMessage()">Send <i class="fa fa-send ml-3"></i></button>
                                    </div>

                                    </form>
                                </div>
                            </div>
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

    <!--end footer-->
</div>
<!--end page-->

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
<script src="js/nav.js"></script>

<script>
                                            $("#messaging__chat-window .messaging__content").scrollTop($(".messaging__content")[0].scrollHeight);
</script>

<script>

    function newMessage() {

        replierMessage('sono stupido', 'dima');
        scrollDown();

    }

    function scrollDown() {
        var elmnt = document.getElementById("panellodeimessaggi");
        elmnt.scrollTop += 500;
    }

    function myMessage(textOfMessage) {
        var allMessages = document.getElementById("TuttiImessaggi");

        var actualMessage = '<div class="messaging__main-chat__bubble user">';
        actualMessage += '<p>';
        actualMessage += textOfMessage;
        actualMessage += '<small>24 hour ago</small>';
        actualMessage += '</p>';
        actualMessage += '</div>';

        allMessages.innerHTML = allMessages.innerHTML + actualMessage;
    }

    function replierMessage(textOfMessage, name) {
        var allMessages = document.getElementById("TuttiImessaggi");

        var actualMessage = '<div class="messaging__main-chat__bubble">';
        actualMessage += '<p>';
        actualMessage += '<span class="username">' + name;
        actualMessage += '</span>';
        actualMessage += textOfMessage;
        actualMessage += '<small>24 hour ago</small>';
        actualMessage += '</p>';
        actualMessage += '</div>';

        allMessages.innerHTML = allMessages.innerHTML + actualMessage;
    }


</script>

<script type="text/javascript">
    var webSocket = new WebSocket("ws://localhost:8080/Lists/wsServer");
    var slname = document.getElementById("shoplistName");
    var messaggioDaInviare = document.getElementById("messaggioDaInviare");
    var user = document.getElementById("Sender");
    var email = document.getElementById("senderEmail");
    //var messages = document.getElementById('messages');

    webSocket.onopen = function (message) {
        processOpen(message);
    };
    webSocket.onmessage = function (message) {
        processMessage(message);
        $.ajax({
                type: "GET",
                url: "/Lists/messageNotification",
                async: false
            });
        //window.location.href = "/Lists/messageNotification";
    };
    webSocket.onclose = function (message) {
        processClose(message);
    };
    webSocket.onerror = function (message) {
        processError(message);
    };

    function processOpen(message) {
        document.getElementById('TuttiImessaggi').innerHTML = "Server Connect..." + "\n";
    }

    function processClose(message) {
        webSocket.send("client disconnected...");
        document.getElementById("TuttiImessaggi").innerHTML += "Server Disonnect..." + "\n";
    }

    function processMessage(message) {
        //list:user:message

        console.log(message.data);
        if ((message.data.split(":")[1] != user.textContent) && (message.data.split(":")[0] === slname.innerHTML)) {
            console.log(message.data.split(":")[1]);
            var m = message.data.split(":")[2];
            var usr = message.data.split(":")[1];
            replierMessage(m, usr);
            scrollDown();

        }
    }


    function sendMessage() {
        if (messaggioDaInviare.value != "close") {
            webSocket.send(slname.innerHTML + ":" + user.textContent + ":" + messaggioDaInviare.value);

            myMessage(messaggioDaInviare.value);
            messaggioDaInviare.value = "";
            scrollDown();
        }
    }

    function processError(message) {
        document.getElementById("TuttiImessaggi").innerHTML += "error..." + "\n";
    }


    function loadChatFile() {
        var req;
        req = new XMLHttpRequest();
        var slname = document.getElementById("shoplistName").innerHTML;
        console.log(slname);
        req.open('GET', 'chat/' + slname + '.json');
        req.onreadystatechange = function () {
            if ((req.readyState === 4) && (req.status === 200)) {
                var items = JSON.parse(req.responseText);
                console.log(items);
                var user = document.getElementById("Sender").textContent;
                var output = '<ul>';
                for (var key in items) {
                    console.log(items[key].message);
                    if (items[key].name == user) {
                        myMessage(items[key].message);
                    } else {
                        replierMessage(items[key].message,items[key].name);
                    }
                    scrollDown();
                }

            }
        }
        req.send();
    }

    $(window).on('keydown', function (e) {
        if (e.which == 13) {
            sendMessage();
            return false;
        }
    });

</script>

</body>
</html>
