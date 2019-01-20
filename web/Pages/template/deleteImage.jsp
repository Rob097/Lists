<%-- 
    Document   : deleteImage
    Created on : 27-nov-2018, 12.03.57
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
    session.setAttribute("Immagini", imageList);
    session.setAttribute("listname", listname);
%>
<div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
        <div class="modal-header">
            <div class="page-title">
                <div class="container">
                    <h1 class="text-center">Scegliere l'immagine da cancellare</h1>
                </div>                             
            </div>
        </div> 
        <div class="modal-body">                        
            <div class="row">  
                <c:forEach items="${Immagini}" var="immagine">
                    <div class = "col-6"> 
                        <div class="thumbnail">
                            <a href="<%=request.getContextPath()%>/restricted/DeleteCategoryImage?image=${immagine}">
                                <img src="../${immagine}" alt="immagini categoria ${listname}">
                            </a>   
                        </div>
                    </div>
                </c:forEach>
            </div>                        
            <a data-dismiss="modal" class="btn btn-dark" style="color: white;">Close</a>                         
        </div>
    </div>                
</div>