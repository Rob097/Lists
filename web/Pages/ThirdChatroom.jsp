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

<c:if test="${user == null}">
    <c:redirect url="/homepage.jsp"/>
</c:if>

<%

    DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
    if (daoFactory == null) {
        throw new ServletException("Impossible to get dao factory for user storage system");
    }
    UserDAO userdao = new JDBCUserDAO(daoFactory.getConnection());
    ListDAO listdao = new JDBCShopListDAO(daoFactory.getConnection());
    ProductDAO productdao = new JDBCProductDAO(daoFactory.getConnection());

    HttpSession s = (HttpSession) request.getSession();
    String shoplistName = (String) s.getAttribute("shopListName");
    User u = null;
    boolean find = false;

    u = (User) s.getAttribute("user");

    if (u.getTipo().equals("standard") || u.getTipo().equals("amministratore")) {
        find = true;
    }

    if (find) {
        ArrayList<User> listautenti = listdao.getUsersWithWhoTheListIsShared(shoplistName);

%>


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

        <%            String Nominativo = "";
            String Email = "";
            String Type = "";
            String image = "";

            //String Image = "";
            Nominativo = u.getNominativo();
            Email = u.getEmail();
            Type = u.getTipo();
            image = u.getImage();
        %>
        <div class="page sub-page">
            <!--*********************************************************************************************************-->
            <!--************ HERO ***************************************************************************************-->
            <!--*********************************************************************************************************-->
            <header class="hero">
                <div class="hero-wrapper">
                    <!--============ Secondary Navigation ===============================================================-->
                    <div class="secondary-navigation">
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
                                    <a href="my-ads.html">
                                        <i class="fa fa-heart"></i>My Ads
                                    </a>
                                </li>
                                <li>
                                    <a href="sign-in.html">
                                        <i class="fa fa-sign-in"></i>Sign In
                                    </a>
                                </li>
                                <li>
                                    <a href="register.html">
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

                    <!--============ End Main Navigation ================================================================-->
                    <!--============ Hero Form ==========================================================================-->

                    <!--end hero-form-->
                </div>
                <!--end collapse-->
                <!--============ End Hero Form ======================================================================-->
                <!--============ Page Title =========================================================================-->
                <div class="page-title">
                    <div class="container">
                        <h1>Messages</h1>
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

                                    <%for (User utente : listautenti) {%>

                                    <li>
                                        <a href="#" class="messaging__person">
                                            <figure class="messaging__image-item" data-background-image="../<%=utente.getImage()%>"></figure>
                                            <figure class="content">
                                                <h5><%=utente.getNominativo()%></h5>

                                            </figure>
                                            <figure class="messaging__image-person" ></figure>
                                        </a>
                                        <!--messaging__person-->
                                    </li>

                                    <%}%>


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
                                    <h5 class="font-weight-bold" id="Sender"><%=Nominativo%></h5>
                                    <input type = "hidden" name = "senderEmail" id = "senderEmail" value = "<%=Email%>">
                                    <figure class="mr-4 messaging__image-person" data-background-image="assets/img/author-02.jpg"></figure>
                                </div>
                                <div class="float-right messaging__person">
                                    <h5 class="mr-4" id="shoplistName"><%=shoplistName%></h5>
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

<%
    } else
        response.sendRedirect("/Lists");
%>