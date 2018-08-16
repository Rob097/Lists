<%-- 
    Document   : standardType
    Created on : 15-giu-2018, 17.13.06
    Author     : Roberto97
--%>

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

    if (u.getTipo().equals("standard")) {
        find = true;
    }

    if (find) {
        ArrayList<User> listautenti = listdao.getUsersWithWhoTheListIsShared(shoplistName);

%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="icon" href="img/favicon.png" sizes="16x16" type="image/png">
        <title>Products</title>

        <!-- CSS personalizzati -->
        <link href="https://fonts.googleapis.com/css?family=Poppins:300,400,500,600,700|Varela+Round" rel="stylesheet">
        <link rel="stylesheet" href="bootstrap/css/bootstrap.css" type="text/css">
        <link rel="stylesheet" href="fonts/font-awesome.css" type="text/css">
        <link rel="stylesheet" href="css/selectize.css" type="text/css">
        <link rel="stylesheet" href="css/style.css">
        <link rel="stylesheet" href="css/user.css">

        <style class="cp-pen-styles">

            #frame {
                width: 100%;
                min-width: 360px;
                max-width: 100%;
                height: 92vh;
                min-height: 300px;
                max-height: 609px;
                background: #E6EAEA;
            }


            @media screen and (max-width: 360px) {
                #frame {
                    width: 100%;
                    height: 100vh;
                }
            }
            #frame #sidepanel {
                float: left;
                min-width: 280px;
                max-width: 340px;
                width: 40%;
                height: 100%;
                background: #2c3e50;
                color: #f5f5f5;
                overflow: hidden;
                position: relative;
            }
            @media screen and (max-width: 735px) {
                #frame #sidepanel {
                    width: 58px;
                    min-width: 58px;
                }
            }
            #frame #sidepanel #profile {
                width: 80%;
                margin: 25px auto;
            }
            @media screen and (max-width: 735px) {
                #frame #sidepanel #profile {
                    width: 100%;
                    margin: 0 auto;
                    padding: 5px 0 0 0;
                    background: #32465a;
                }
            }
            #frame #sidepanel #profile.expanded .wrap {
                height: 210px;
                line-height: initial;
            }
            #frame #sidepanel #profile.expanded .wrap p {
                margin-top: 20px;
            }
            #frame #sidepanel #profile.expanded .wrap i.expand-button {
                -moz-transform: scaleY(-1);
                -o-transform: scaleY(-1);
                -webkit-transform: scaleY(-1);
                transform: scaleY(-1);
                filter: FlipH;
                -ms-filter: "FlipH";
            }
            #frame #sidepanel #profile .wrap {
                height: 60px;
                line-height: 60px;
                overflow: hidden;
                -moz-transition: 0.3s height ease;
                -o-transition: 0.3s height ease;
                -webkit-transition: 0.3s height ease;
                transition: 0.3s height ease;
            }
            @media screen and (max-width: 735px) {
                #frame #sidepanel #profile .wrap {
                    height: 55px;
                }
            }
            #frame #sidepanel #profile .wrap img {
                width: 50px;
                border-radius: 50%;
                padding: 3px;
                border: 2px solid #e74c3c;
                height: 50px;
                float: left;
                cursor: pointer;
                -moz-transition: 0.3s border ease;
                -o-transition: 0.3s border ease;
                -webkit-transition: 0.3s border ease;
                transition: 0.3s border ease;
            }
            @media screen and (max-width: 735px) {
                #frame #sidepanel #profile .wrap img {
                    width: 40px;
                    margin-left: 4px;
                }
            }
            #frame #sidepanel #profile .wrap img.online {
                border: 2px solid #2ecc71;
            }
            #frame #sidepanel #profile .wrap img.away {
                border: 2px solid #f1c40f;
            }
            #frame #sidepanel #profile .wrap img.busy {
                border: 2px solid #e74c3c;
            }
            #frame #sidepanel #profile .wrap img.offline {
                border: 2px solid #95a5a6;
            }
            #frame #sidepanel #profile .wrap p {
                float: left;
                margin-left: 15px;
            }
            @media screen and (max-width: 735px) {
                #frame #sidepanel #profile .wrap p {
                    display: none;
                }
            }
            #frame #sidepanel #profile .wrap i.expand-button {
                float: right;
                margin-top: 23px;
                font-size: 0.8em;
                cursor: pointer;
                color: #435f7a;
            }
            @media screen and (max-width: 735px) {
                #frame #sidepanel #profile .wrap i.expand-button {
                    display: none;
                }
            }
            #frame #sidepanel #profile .wrap #status-options {
                position: absolute;
                opacity: 0;
                visibility: hidden;
                width: 150px;
                margin: 70px 0 0 0;
                border-radius: 6px;
                z-index: 99;
                line-height: initial;
                background: #435f7a;
                -moz-transition: 0.3s all ease;
                -o-transition: 0.3s all ease;
                -webkit-transition: 0.3s all ease;
                transition: 0.3s all ease;
            }
            @media screen and (max-width: 735px) {
                #frame #sidepanel #profile .wrap #status-options {
                    width: 58px;
                    margin-top: 57px;
                }
            }
            #frame #sidepanel #profile .wrap #status-options.active {
                opacity: 1;
                visibility: visible;
                margin: 75px 0 0 0;
            }
            @media screen and (max-width: 735px) {
                #frame #sidepanel #profile .wrap #status-options.active {
                    margin-top: 62px;
                }
            }
            #frame #sidepanel #profile .wrap #status-options:before {
                content: '';
                position: absolute;
                width: 0;
                height: 0;
                border-left: 6px solid transparent;
                border-right: 6px solid transparent;
                border-bottom: 8px solid #435f7a;
                margin: -8px 0 0 24px;
            }
            @media screen and (max-width: 735px) {
                #frame #sidepanel #profile .wrap #status-options:before {
                    margin-left: 23px;
                }
            }
            #frame #sidepanel #profile .wrap #status-options ul {
                overflow: hidden;
                border-radius: 6px;
            }
            #frame #sidepanel #profile .wrap #status-options ul li {
                padding: 15px 0 30px 18px;
                display: block;
                cursor: pointer;
            }
            @media screen and (max-width: 735px) {
                #frame #sidepanel #profile .wrap #status-options ul li {
                    padding: 15px 0 35px 22px;
                }
            }
            #frame #sidepanel #profile .wrap #status-options ul li:hover {
                background: #496886;
            }
            #frame #sidepanel #profile .wrap #status-options ul li span.status-circle {
                position: absolute;
                width: 10px;
                height: 10px;
                border-radius: 50%;
                margin: 5px 0 0 0;
            }
            @media screen and (max-width: 735px) {
                #frame #sidepanel #profile .wrap #status-options ul li span.status-circle {
                    width: 14px;
                    height: 14px;
                }
            }
            #frame #sidepanel #profile .wrap #status-options ul li span.status-circle:before {
                content: '';
                position: absolute;
                width: 14px;
                height: 14px;
                margin: -3px 0 0 -3px;
                background: transparent;
                border-radius: 50%;
                z-index: 0;
            }
            @media screen and (max-width: 735px) {
                #frame #sidepanel #profile .wrap #status-options ul li span.status-circle:before {
                    height: 18px;
                    width: 18px;
                }
            }
            #frame #sidepanel #profile .wrap #status-options ul li p {
                padding-left: 12px;
            }
            @media screen and (max-width: 735px) {
                #frame #sidepanel #profile .wrap #status-options ul li p {
                    display: none;
                }
            }
            #frame #sidepanel #profile .wrap #status-options ul li#status-online span.status-circle {
                background: #2ecc71;
            }
            #frame #sidepanel #profile .wrap #status-options ul li#status-online.active span.status-circle:before {
                border: 1px solid #2ecc71;
            }
            #frame #sidepanel #profile .wrap #status-options ul li#status-away span.status-circle {
                background: #f1c40f;
            }
            #frame #sidepanel #profile .wrap #status-options ul li#status-away.active span.status-circle:before {
                border: 1px solid #f1c40f;
            }
            #frame #sidepanel #profile .wrap #status-options ul li#status-busy span.status-circle {
                background: #e74c3c;
            }
            #frame #sidepanel #profile .wrap #status-options ul li#status-busy.active span.status-circle:before {
                border: 1px solid #e74c3c;
            }
            #frame #sidepanel #profile .wrap #status-options ul li#status-offline span.status-circle {
                background: #95a5a6;
            }
            #frame #sidepanel #profile .wrap #status-options ul li#status-offline.active span.status-circle:before {
                border: 1px solid #95a5a6;
            }
            #frame #sidepanel #profile .wrap #expanded {
                padding: 100px 0 0 0;
                display: block;
                line-height: initial !important;
            }
            #frame #sidepanel #profile .wrap #expanded label {
                float: left;
                clear: both;
                margin: 0 8px 5px 0;
                padding: 5px 0;
            }
            #frame #sidepanel #profile .wrap #expanded input {
                border: none;
                margin-bottom: 6px;
                background: #32465a;
                border-radius: 3px;
                color: #f5f5f5;
                padding: 7px;
                width: calc(100% - 43px);
            }
            #frame #sidepanel #profile .wrap #expanded input:focus {
                outline: none;
                background: #435f7a;
            }
            #frame #sidepanel #search {
                border-top: 1px solid #32465a;
                border-bottom: 1px solid #32465a;
                font-weight: 300;
            }
            @media screen and (max-width: 735px) {
                #frame #sidepanel #search {
                    display: none;
                }
            }
            #frame #sidepanel #search label {
                position: absolute;
                margin: 10px 0 0 20px;
            }
            #frame #sidepanel #search input {
                font-family: "proxima-nova",  "Source Sans Pro", sans-serif;
                padding: 10px 0 10px 46px;
                width: calc(100% - 25px);
                border: none;
                background: #32465a;
                color: #f5f5f5;
            }
            #frame #sidepanel #search input:focus {
                outline: none;
                background: #435f7a;
            }
            #frame #sidepanel #search input::-webkit-input-placeholder {
                color: #f5f5f5;
            }
            #frame #sidepanel #search input::-moz-placeholder {
                color: #f5f5f5;
            }
            #frame #sidepanel #search input:-ms-input-placeholder {
                color: #f5f5f5;
            }
            #frame #sidepanel #search input:-moz-placeholder {
                color: #f5f5f5;
            }
            #frame #sidepanel #contacts {
                height: calc(100% - 177px);
                overflow-y: scroll;
                overflow-x: hidden;
            }
            @media screen and (max-width: 735px) {
                #frame #sidepanel #contacts {
                    height: calc(100% - 149px);
                    overflow-y: scroll;
                    overflow-x: hidden;
                }
                #frame #sidepanel #contacts::-webkit-scrollbar {
                    display: none;
                }
            }
            #frame #sidepanel #contacts.expanded {
                height: calc(100% - 334px);
            }
            #frame #sidepanel #contacts::-webkit-scrollbar {
                width: 8px;
                background: #2c3e50;
            }
            #frame #sidepanel #contacts::-webkit-scrollbar-thumb {
                background-color: #243140;
            }
            #frame #sidepanel #contacts ul li.contact {
                position: relative;
                padding: 10px 0 15px 0;
                font-size: 0.9em;
                cursor: pointer;
            }
            @media screen and (max-width: 735px) {
                #frame #sidepanel #contacts ul li.contact {
                    padding: 6px 0 46px 8px;
                }
            }
            #frame #sidepanel #contacts ul li.contact:hover {
                background: #32465a;
            }
            #frame #sidepanel #contacts ul li.contact.active {
                background: #32465a;
                border-right: 5px solid #435f7a;
            }
            #frame #sidepanel #contacts ul li.contact.active span.contact-status {
                border: 2px solid #32465a !important;
            }
            #frame #sidepanel #contacts ul li.contact .wrap {
                width: 88%;
                margin: 0 auto;
                position: relative;
            }
            @media screen and (max-width: 735px) {
                #frame #sidepanel #contacts ul li.contact .wrap {
                    width: 100%;
                }
            }
            #frame #sidepanel #contacts ul li.contact .wrap span {
                position: absolute;
                left: 0;
                margin: -2px 0 0 -2px;
                width: 10px;
                height: 10px;
                border-radius: 50%;
                border: 2px solid #2c3e50;
                background: #95a5a6;
            }
            #frame #sidepanel #contacts ul li.contact .wrap span.online {
                background: #2ecc71;
            }
            #frame #sidepanel #contacts ul li.contact .wrap span.away {
                background: #f1c40f;
            }
            #frame #sidepanel #contacts ul li.contact .wrap span.busy {
                background: #e74c3c;
            }
            #frame #sidepanel #contacts ul li.contact .wrap img {
                width: 40px;
                height: 40px;
                border-radius: 50%;
                float: left;
                margin-right: 10px;
            }
            @media screen and (max-width: 735px) {
                #frame #sidepanel #contacts ul li.contact .wrap img {
                    margin-right: 0px;
                }
            }
            #frame #sidepanel #contacts ul li.contact .wrap .meta {
                padding: 5px 0 0 0;
            }
            @media screen and (max-width: 735px) {
                #frame #sidepanel #contacts ul li.contact .wrap .meta {
                    display: none;
                }
            }
            #frame #sidepanel #contacts ul li.contact .wrap .meta .name {
                font-weight: 600;
            }
            #frame #sidepanel #contacts ul li.contact .wrap .meta .preview {
                margin: 5px 0 0 0;
                padding: 0 0 1px;
                font-weight: 400;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
                -moz-transition: 1s all ease;
                -o-transition: 1s all ease;
                -webkit-transition: 1s all ease;
                transition: 1s all ease;
            }
            #frame #sidepanel #contacts ul li.contact .wrap .meta .preview span {
                position: initial;
                border-radius: initial;
                background: none;
                border: none;
                padding: 0 2px 0 0;
                margin: 0 0 0 1px;
                opacity: .5;
            }
            #frame #sidepanel #bottom-bar {
                position: absolute;
                width: 100%;
                bottom: 0;
            }
            #frame #sidepanel #bottom-bar button {
                float: left;
                border: none;
                width: 50%;
                padding: 10px 0;
                background: #32465a;
                color: #f5f5f5;
                cursor: pointer;
                font-size: 0.85em;
                font-family: "proxima-nova",  "Source Sans Pro", sans-serif;
            }
            @media screen and (max-width: 735px) {
                #frame #sidepanel #bottom-bar button {
                    float: none;
                    width: 100%;
                    padding: 15px 0;
                }
            }
            #frame #sidepanel #bottom-bar button:focus {
                outline: none;
            }
            #frame #sidepanel #bottom-bar button:nth-child(1) {
                border-right: 1px solid #2c3e50;
            }
            @media screen and (max-width: 735px) {
                #frame #sidepanel #bottom-bar button:nth-child(1) {
                    border-right: none;
                    border-bottom: 1px solid #2c3e50;
                }
            }
            #frame #sidepanel #bottom-bar button:hover {
                background: #435f7a;
            }
            #frame #sidepanel #bottom-bar button i {
                margin-right: 3px;
                font-size: 1em;
            }
            @media screen and (max-width: 735px) {
                #frame #sidepanel #bottom-bar button i {
                    font-size: 1.3em;
                }
            }
            @media screen and (max-width: 735px) {
                #frame #sidepanel #bottom-bar button span {
                    display: none;
                }
            }
            #frame .content {
                float: right;
                width: 60%;
                height: 100%;
                overflow: hidden;
                position: relative;
            }
            @media screen and (max-width: 735px) {
                #frame .content {
                    width: calc(100% - 58px);
                    min-width: 300px !important;
                }
            }
            @media screen and (min-width: 900px) {
                #frame .content {
                    width: calc(100% - 340px);
                }
            }
            #frame .content .contact-profile {
                width: 100%;
                height: 60px;
                line-height: 60px;
                background: #f5f5f5;
            }
            #frame .content .contact-profile img {
                width: 40px;
                border-radius: 50%;
                float: left;
                margin: 9px 12px 0 9px;
            }
            #frame .content .contact-profile p {
                float: left;
            }
            #frame .content .contact-profile .social-media {
                float: right;
            }
            #frame .content .contact-profile .social-media i {
                margin-left: 14px;
                cursor: pointer;
            }
            #frame .content .contact-profile .social-media i:nth-last-child(1) {
                margin-right: 20px;
            }
            #frame .content .contact-profile .social-media i:hover {
                color: #435f7a;
            }
            #frame .content .messages {
                height: auto;
                min-height: calc(100% - 93px);
                max-height: calc(100% - 93px);
                overflow-y: scroll;
                overflow-x: hidden;
            }
            @media screen and (max-width: 735px) {
                #frame .content .messages {
                    max-height: calc(100% - 105px);
                }
            }
            #frame .content .messages::-webkit-scrollbar {
                width: 8px;
                background: transparent;
            }
            #frame .content .messages::-webkit-scrollbar-thumb {
                background-color: rgba(0, 0, 0, 0.3);
            }
            #frame .content .messages ul li {
                display: inline-block;
                clear: both;
                float: left;
                margin: 15px 15px 5px 15px;
                width: calc(100% - 25px);
                font-size: 0.9em;
            }
            #frame .content .messages ul li:nth-last-child(1) {
                margin-bottom: 20px;
            }
            #frame .content .messages ul li.sent img {
                margin: 6px 8px 0 0;
            }
            #frame .content .messages ul li.sent p {
                background: #435f7a;
                color: #f5f5f5;
            }
            #frame .content .messages ul li.replies img {
                float: right;
                margin: 6px 0 0 8px;
            }
            #frame .content .messages ul li.replies p {
                background: #f5f5f5;
                float: right;
            }
            #frame .content .messages ul li img {
                width: 22px;
                border-radius: 50%;
                float: left;
            }
            #frame .content .messages ul li p {
                display: inline-block;
                padding: 10px 15px;
                border-radius: 20px;
                max-width: 205px;
                line-height: 130%;
            }
            @media screen and (min-width: 735px) {
                #frame .content .messages ul li p {
                    max-width: 300px;
                }
            }
            #frame .content .message-input {
                position: absolute;
                bottom: 0;
                width: 100%;
                z-index: 99;
            }
            #frame .content .message-input .wrap {
                position: relative;
            }
            #frame .content .message-input .wrap input {
                font-family: "proxima-nova",  "Source Sans Pro", sans-serif;
                float: left;
                border: none;
                width: calc(100% - 90px);
                padding: 11px 32px 10px 8px;
                font-size: 0.8em;
                color: #32465a;
            }
            @media screen and (max-width: 735px) {
                #frame .content .message-input .wrap input {
                    padding: 15px 32px 16px 8px;
                }
            }
            #frame .content .message-input .wrap input:focus {
                outline: none;
            }
            #frame .content .message-input .wrap .attachment {
                position: absolute;
                right: 60px;
                z-index: 4;
                margin-top: 10px;
                font-size: 1.1em;
                color: #435f7a;
                opacity: .5;
                cursor: pointer;
            }
            @media screen and (max-width: 735px) {
                #frame .content .message-input .wrap .attachment {
                    margin-top: 17px;
                    right: 65px;
                }
            }
            #frame .content .message-input .wrap .attachment:hover {
                opacity: 1;
            }
            #frame .content .message-input .wrap button {
                float: right;
                border: none;
                width: 50px;
                padding: 12px 0;
                cursor: pointer;
                background: #32465a;
                color: #f5f5f5;
            }
            @media screen and (max-width: 735px) {
                #frame .content .message-input .wrap button {
                    padding: 16px 0;
                }
            }
            #frame .content .message-input .wrap button:hover {
                background: #435f7a;
            }
            #frame .content .message-input .wrap button:focus {
                outline: none;
            }

            .hero .page-title {
                padding-top: 0;
                padding-bottom: 0;
            }

            .hero:after {
                background-image: none;

            }

            .hero .hero-wrapper {
                padding-bottom: 0;
            }
        </style>




        <script type="text/javascript">
            function loadDoc(url, cFunction) {
                var xhttp;
                var message;
                xhttp = new XMLHttpRequest();
                xhttp.onreadystatechange = function () {
                    if (this.readyState == 4 && this.status == 200) {
                        cFunction(this);
                    }
                };
                var message = "messaggio=" + document.getElementById("messaggioDaInviare").value;
                var user = document.getElementById("Sender").innerHTML;
                url = url + message + "&Sender=" + user;
                xhttp.open("GET", url, true);
                xhttp.send();
            }

            function myFunction(xhttp) {
                document.getElementById("ricevente").innerHTML =
                        xhttp.responseText;
            }

            var x = 0;
            function prova() {
                x++;
                document.getElementById("ricevente").innerHTML = "troia" + x;
            }

            function loadChatFile() {
                var req;
                req = new XMLHttpRequest();
                
                req.open('GET', 'chat/Lemacchine.json');
                req.onreadystatechange = function(){
                    if((req.readyState === 4)&&(req.status===200)){
                        var items = JSON.parse(req.responseText);
                        console.log(items);
                        var user = document.getElementById("Sender").innerHTML;
                        var output = '<ul>';
                        for(var key in items){
                            console.log(items[key].message);
                            if(items[key].name == user){
                                output+= '<li class="sent">';
                            }else{
                                output+= '<li class="replies">';
                            }
                            output+='<img src="http://emilcarlsson.se/assets/mikeross.png" alt="" />';
                            output+='<p>'+items[key].message+'</p>';
                            output+= '</li>';
                        }
                        output+='</ul>';
                        document.getElementById('messages').innerHTML = output;
                    }
                }
                req.send();
            }
            setInterval(loadChatFile, 100);

        </script>

    </head>
    <body>        

        <%            
            String Nominativo = "";
            String Email = "";
            String Type = "";
            String image = "";

            //String Image = "";
            Nominativo = u.getNominativo();
            Email = u.getEmail();
            Type = u.getTipo();
            image = u.getImage();
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
                                        <i class="fa fa-sign-in"></i><c:out value="${user.nominativo}"/> / <c:out value="${user.tipo}"/> / <img src= "../${user.image}" width="25px" height="25px" style="border-radius: 100%;">
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
                                            <a class="nav-link" href="../../index.jsp">home</a>
                                        </li>
                                        <li class="nav-item has-child">
                                            <a class="nav-link" href="#">Listing</a>
                                            <!-- 1st level -->

                                            <!-- end 1st level -->
                                        </li>
                                        <li class="nav-item has-child">
                                            <a class="nav-link" href="#">Pages</a>
                                            <!-- 2nd level -->

                                            <!-- end 2nd level -->
                                        </li>
                                        <li class="nav-item has-child">
                                            <a class="nav-link" href="#">Extras</a>
                                            <!--1st level -->

                                        </li>
                                        <li class="nav-item">
                                            <a class="nav-link" href="ShowProducts.jsp">show all products</a>
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

                            <div id="frame">
                                <div id="sidepanel">


                                    <div id="profile">
                                        <div class="wrap">
                                            <img id="profile-img" src="../${user.image}" class="online" alt="" />
                                            <p id="Sender"><%=Nominativo%></p>
                                            <i class="fa fa-chevron-down expand-button" aria-hidden="true"></i>
                                            <div id="status-options">
                                                <ul>
                                                    <li id="status-online" class="active"><span class="status-circle"></span> <p>Online</p></li>
                                                    <li id="status-away"><span class="status-circle"></span> <p>Away</p></li>
                                                    <li id="status-busy"><span class="status-circle"></span> <p>Busy</p></li>
                                                    <li id="status-offline"><span class="status-circle"></span> <p>Offline</p></li>
                                                </ul>
                                            </div>
                                            <div id="expanded">
                                                <label for="twitter"><i class="fa fa-facebook fa-fw" aria-hidden="true"></i></label>
                                                <input name="twitter" type="text" value="mikeross" />
                                                <label for="twitter"><i class="fa fa-twitter fa-fw" aria-hidden="true"></i></label>
                                                <input name="twitter" type="text" value="ross81" />
                                                <label for="twitter"><i class="fa fa-instagram fa-fw" aria-hidden="true"></i></label>
                                                <input name="twitter" type="text" value="mike.ross" />
                                            </div>
                                        </div>
                                    </div>
                                    <div id="search">
                                        <label for=""><i class="fa fa-search" aria-hidden="true"></i></label>
                                        <input type="text" placeholder="Search contacts..." />
                                    </div>
                                    <div id="contacts">
                                        <ul>

                                            <%for (User utente : listautenti) {%>

                                            <li class="contact">
                                                <div class="wrap">
                                                    <span class="contact-status online"></span>
                                                    <img src="../<%=utente.getImage()%>" alt="" />
                                                    <div class="meta">
                                                        <a onclick="loadDoc('/Lists/chat?ricevente=<%=utente.getEmail()%>', myFunction)"><p class="name"><%=utente.getNominativo()%></p></a>

                                                    </div>
                                                </div>
                                            </li>

                                            <%}%>

                                        </ul>
                                    </div>
                                    <div id="bottom-bar">
                                        <button id="addcontact"><i class="fa fa-user-plus fa-fw" aria-hidden="true"></i> <span>Add contact</span></button>
                                        <button id="settings"><i class="fa fa-cog fa-fw" aria-hidden="true"></i> <span>Settings</span></button>
                                    </div>
                                </div>
                                <div class="content">
                                    <div class="contact-profile">
                                        <img src="http://emilcarlsson.se/assets/harveyspecter.png" alt="" />
                                        <p id="ricevente">Harvey Specter</p>
                                        <div class="social-media">
                                            <i class="fa fa-facebook" aria-hidden="true"></i>
                                            <i class="fa fa-twitter" aria-hidden="true"></i>
                                            <i class="fa fa-instagram" aria-hidden="true"></i>
                                        </div>
                                    </div>
                                    <div class="messages" id="messages">
                                        <ul>
                                            <li class="sent">
                                                <img src="http://emilcarlsson.se/assets/mikeross.png" alt="" />
                                                <p>How the hell am I supposed to get a jury to believe you when I am not even sure that I do?!</p>
                                            </li>
                                            <li class="replies">
                                                <img src="http://emilcarlsson.se/assets/harveyspecter.png" alt="" />
                                                <p>When you're backed against the wall, break the god damn thing down.</p>
                                            </li>
                                            <li class="replies">
                                                <img src="http://emilcarlsson.se/assets/harveyspecter.png" alt="" />
                                                <p>Excuses don't win championships.</p>
                                            </li>
                                            <li class="sent">
                                                <img src="http://emilcarlsson.se/assets/mikeross.png" alt="" />
                                                <p>Oh yeah, did Michael Jordan tell you that?</p>
                                            </li>
                                            <li class="replies">
                                                <img src="http://emilcarlsson.se/assets/harveyspecter.png" alt="" />
                                                <p>No, I told him that.</p>
                                            </li>
                                            <li class="replies">
                                                <img src="http://emilcarlsson.se/assets/harveyspecter.png" alt="" />
                                                <p>What are your choices when someone puts a gun to your head?</p>
                                            </li>
                                            <li class="sent">
                                                <img src="http://emilcarlsson.se/assets/mikeross.png" alt="" />
                                                <p>What are you talking about? You do what they say or they shoot you.</p>
                                            </li>
                                            <li class="replies">
                                                <img src="http://emilcarlsson.se/assets/harveyspecter.png" alt="" />
                                                <p>Wrong. You take the gun, or you pull out a bigger one. Or, you call their bluff. Or, you do any one of a hundred and forty six other things.</p>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="message-input">
                                        <div class="wrap">



                                            <input type="text" id="messaggioDaInviare" placeholder="Write your message..." />
                                            <i class="fa fa-paperclip attachment" aria-hidden="true"></i>

                                            <button class="submit" onclick="loadDoc('/Lists/chat?', myFunction)"><i class="fa fa-paper-plane" aria-hidden="true"></i></button>



                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <!--end container-->
                    </div>

                </div>
                <!--end hero-wrapper-->
            </header>
            <!--end hero-->


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

        <script src='//production-assets.codepen.io/assets/common/stopExecutionOnTimeout-b2a7b3fe212eaa732349046d8416e00a9dec26eb7fd347590fbced3ab38af52e.js'></script><script src='https://code.jquery.com/jquery-2.2.4.min.js'></script>
        <script >$(".messages").animate({scrollTop: $(document).height()}, "fast");

                                                    $("#profile-img").click(function () {
                                                        $("#status-options").toggleClass("active");
                                                    });

                                                    $(".expand-button").click(function () {
                                                        $("#profile").toggleClass("expanded");
                                                        $("#contacts").toggleClass("expanded");
                                                    });

                                                    $("#status-options ul li").click(function () {
                                                        $("#profile-img").removeClass();
                                                        $("#status-online").removeClass("active");
                                                        $("#status-away").removeClass("active");
                                                        $("#status-busy").removeClass("active");
                                                        $("#status-offline").removeClass("active");
                                                        $(this).addClass("active");

                                                        if ($("#status-online").hasClass("active")) {
                                                            $("#profile-img").addClass("online");
                                                        } else if ($("#status-away").hasClass("active")) {
                                                            $("#profile-img").addClass("away");
                                                        } else if ($("#status-busy").hasClass("active")) {
                                                            $("#profile-img").addClass("busy");
                                                        } else if ($("#status-offline").hasClass("active")) {
                                                            $("#profile-img").addClass("offline");
                                                        } else {
                                                            $("#profile-img").removeClass();
                                                        }
                                                        ;

                                                        $("#status-options").removeClass("active");
                                                    });

                                                    function newMessage() {
                                                        message = $(".message-input input").val();
                                                        if ($.trim(message) == '') {
                                                            return false;
                                                        }
                                                        $('<li class="sent"><img src="http://emilcarlsson.se/assets/mikeross.png" alt="" /><p>' + message + '</p></li>').appendTo($('.messages ul'));
                                                        $('.message-input input').val(null);
                                                        $('.contact.active .preview').html('<span>You: </span>' + message);
                                                        $(".messages").animate({scrollTop: $(document).height()}, "fast");
                                                    }
                                                    ;

                                                    $('.submit').click(function () {
                                                        newMessage();
                                                    });

                                                    $(window).on('keydown', function (e) {
                                                        if (e.which == 13) {
                                                            newMessage();
                                                            return false;
                                                        }
                                                    });
                                                    //# sourceURL=pen.js
        </script>

    </body>
</html>

<%
    } else
        response.sendRedirect("/Lists");
%>