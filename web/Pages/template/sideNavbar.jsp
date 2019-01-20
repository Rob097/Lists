<%-- 
    Document   : sideNavbar
    Created on : 4-dic-2018, 14.58.50
    Author     : Roberto97
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${not empty user}">
    <nav class="nav flex-column side-nav">
        <a class="nav-link icon" href="/Lists/profile.jsp">
            <i class="fa fa-user"></i>Il mio profilo
        </a>
        <a class="nav-link active icon" href="/Lists/userlists.jsp">
            <i class="fa fa-bars"></i>Le mie liste
        </a>
        <a class="nav-link active icon" href="/Lists/foreignLists.jsp">
            <i class="fa fa-share-alt"></i>Liste condivise
        </a>
        <c:if test="${user.tipo=='amministratore'}">
            <div class="btn-group dropright">
                <a class="dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" href="#">
                    <i style="color: red;" class="fa fa-bookmark"></i>  Dashboard
                </a>
                <div class="dropdown-menu">
                    <a href="/Lists/Pages/AdminProducts.jsp" class="dropdown-item nav-link"><i style="color: red;" class="fa fa-bars"></i><b>Lista prodotti</b></a>
                    <a href="/Lists/Pages/ShowProductCategories.jsp" class="dropdown-item nav-link"><i style="color: red;" class="fa fa-bars"></i><b>Categorie prodotti</b></a>
                    <a href="/Lists/Pages/ShowListCategories.jsp" class="dropdown-item nav-link"><i style="color: red;" class="fa fa-bars"></i><b>Categorie lista</b></a>                                         
                </div>
            </div>                     
        </c:if>
    </nav>
</c:if>
