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
        <a class="nav-link icon" href="/Lists/Pages/ShowProducts.jsp">
            <i class="fa fa-recycle"></i>Tutti i Prodotti
        </a>
        <c:if test="${user.tipo=='amministratore'}">
            <a class="nav-link icon" href="/Lists/Pages/ShowProductCategories.jsp">
                <i class="fa fa-bookmark"></i>Tutte le categorie per prodotti
            </a>
            <a class="nav-link icon" href="/Lists/Pages/ShowListCategories.jsp">
                <i class="fa fa-bookmark"></i>Tutte le categorie per liste
            </a>                                        
        </c:if>
    </nav>
</c:if>
