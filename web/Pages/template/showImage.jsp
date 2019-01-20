<%-- 
    Document   : showImage
    Created on : 27-nov-2018, 12.22.45
    Author     : della
--%>

<%@page import="java.util.List"%>
<%@page import="database.jdbc.JDBCCategoryDAO"%>
<%@page import="database.daos.CategoryDAO"%>
<%@page import="java.util.logging.Level"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="database.exceptions.DAOException"%>
<%@page import="database.entities.Product"%>
<%@page import="java.util.ArrayList"%>
<%@page import="database.daos.ListDAO"%>
<%@page import="database.jdbc.JDBCShopListDAO"%>
<%@page import="database.jdbc.JDBCProductDAO"%>
<%@page import="database.daos.ProductDAO"%>
<%@page import="database.factories.DAOFactory"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
    if (daoFactory == null) {
        throw new ServletException("Impossible to get dao factory for user storage system");
    }
    CategoryDAO categorydao = new JDBCCategoryDAO(daoFactory.getConnection());

    String listname = "";
    if (session.getAttribute("listname") != null) {
        listname = (String) session.getAttribute("listname");
    }

    List<String> imageList = categorydao.getAllImagesbyName(listname);
    String firstImg = imageList.remove(0);
    session.setAttribute("firstImg", firstImg);
    session.setAttribute("Immagini", imageList);
%>

<div class="modal-dialog modal-dialog-centered" role="document" style="width: -webkit-fill-available; width: -moz-fill-available;">
    <div class="modal-content" style="height: max-content;">
        <div class="modal-body">
            <div id="carouselCategoryList" class="carousel slide" data-ride="carousel">
                <div class="carousel-inner text-center">
                    <div class="carousel-item active">
                        <img style="width: 250px;" class="text-center" src="../${firstImg}">
                    </div>
                    <c:forEach items="${Immagini}" var="immagine">
                        <div class="carousel-item">
                            <img style="width: 250px;" class="text-center" src="../${immagine}">
                        </div>
                    </c:forEach>
                </div>
                <a style="background-image: linear-gradient(to left, transparent, #000000c9 90%);" class="carousel-control-prev" href="#carouselCategoryList" role="button" data-slide="prev">
                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                    <span class="sr-only">Previous</span>
                </a>
                <a style="background-image: linear-gradient(to left, #000000c9, transparent 90%);" class="carousel-control-next" href="#carouselCategoryList" role="button" data-slide="next">
                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                    <span class="sr-only">Next</span>
                </a>
            </div>
            <div class="text-center">
                <a data-dismiss="modal" class="btn btn-dark" style="color: white;">Close</a> 
            </div>
        </div>
    </div>
</div>