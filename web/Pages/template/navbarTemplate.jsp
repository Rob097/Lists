<%-- 
    Document   : navbarTemplate
    Created on : 28-nov-2018, 11.24.34
    Author     : della
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:choose>
    <c:when test="${not empty user}">
        <nav class="navbar navbar-expand-xl navbar-dark fixed-top " id="mainNav">
            <a class="navbar-brand">
                <img width= "50" src="/Lists/Pages/img/favicon.png" alt="Logo">
            </a>
            <a class="navbar-brand js-scroll-trigger" href="#home">LISTS</a>
            <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
                Menu
                <i class="fa fa-bars"></i>
            </button>
            <div class="collapse navbar-collapse" id="navbarResponsive">
                <ul class="navbar-nav text-uppercase ml-auto text-center">
                    <li class="nav-item js-scroll-trigger dropdown">
                        <div style="cursor: pointer;" class="nav-link dropdown-toggle" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="fa fa-bars"></i><b>Liste</b></div>
                        <div class="dropdown-menu" style="color: white;" aria-labelledby="navbarDropdown">
                            <a class="dropdown-item nav-link" href="userlists.jsp"><i class="fa fa-bars"></i><b>Le mie liste</b></a>
                            <a class="dropdown-item nav-link" href="foreignLists.jsp"><i class="fa fa-share-alt"></i><b>Liste condivise con me</b></a>                                        
                        </div>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link js-scroll-trigger" href="/Lists/profile.jsp">
                            <i class="fa fa-user"></i><b>Il mio profilo</b>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link js-scroll-trigger" href="<c:url context="/Lists" value="/restricted/LogoutAction" />" data-toggle="tooltip" data-placement="bottom" title="LogOut">
                            <i class="fa fa-sign-out"></i><b><c:out value="${user.nominativo}"/> / <c:out value="${user.tipo}"/> </b>/ <img src= "/Lists/${user.image}" width="25px" height="25px" style="border-radius: 100%;">
                        </a>
                    </li>                                
                </ul>
            </div>
        </nav>
    </c:when>
    <c:otherwise>
        <nav class="navbar navbar-expand-xl navbar-dark fixed-top " id="mainNav">
            <a class="navbar-brand">
                <img width= "50" src="/Lists/Pages/img/favicon.png" alt="Logo">
            </a>
            <a class="navbar-brand js-scroll-trigger" href="#home">LISTS</a>
            <button class="navbar-toggler navbar-toggler-right" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
                Menu
                <i class="fa fa-bars"></i>
            </button>
            <div class="collapse navbar-collapse" id="navbarResponsive">
                <ul class="navbar-nav text-uppercase ml-auto text-center">                               
                    <li class="nav-item js-scroll-trigger dropdown">
                        <div style="cursor: pointer;" class="nav-link dropdown-toggle" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="fa fa-bars"></i><b>Liste</b></div>
                        <div class="dropdown-menu" style="color: white;" aria-labelledby="navbarDropdown">
                            <a class="dropdown-item nav-link" href="/Lists/userlists.jsp"><i class="fa fa-bars"></i><b>Le mie liste</b></a>
                            <a class="dropdown-item nav-link disabled" data-toggle="tooltip" title="Registrati o fai il login per usare questa funzione"><i class="fa fa-share-alt"></i><b>Liste condivise con me</b></a>                                        
                        </div>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link js-scroll-trigger" data-toggle="modal" data-target="#LoginModal" style="cursor: pointer;">
                            <i class="fa fa-sign-in"></i><b>Login</b>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link js-scroll-trigger" data-toggle="modal" data-target="#RegisterModal" style="cursor: pointer;">
                            <i class="fa fa-pencil-square-o"></i><b>Registrati</b>
                        </a>
                    </li>
                </ul>
            </div>
        </nav>
    </c:otherwise>
</c:choose>

<script src="Pages/js/nav.js"></script>

