<%-- 
    Document   : elements
    Created on : 25-ott-2018, 12.18.07
    Author     : della
--%>

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
<%DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        System.out.println("INFINITEEEEEEEEEEEE");
        //assegna a userdao la connessione(costruttore) e salva la connessione in una variabile tipo Connection
        ProductDAO productdao = new JDBCProductDAO(daoFactory.getConnection());
        ListDAO listdao = new JDBCShopListDAO(daoFactory.getConnection());
        
            int number;
            if(request.getSession().getAttribute("number") == null){number = 0;}
            else{number = (int) request.getSession().getAttribute("number");}
            String resp = "";
            String shoplistName = (String) request.getSession().getAttribute("shopListName");
            ArrayList<Product> pp;
            pp = productdao.getByRange(number, request);
            for (Product p : pp) {%>
                <div class="item">
                    <!--end ribbon-->
                    <div class="wrapper">
                        <div class="image">
                            <h3>
                                <a href="#" class="tag category"><%=p.getCategoria_prodotto()%></a>
                                <a href="single-listing-1.html" class="title"><%=p.getNome()%></a>
                                <span class="tag">Offer</span>
                            </h3>
                            <a href="single-listing-1.html" class="image-wrapper background-image" style="background-image: url('../<%=p.getImmagine()%>')">
                                <%System.out.println("IMAGINEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE: " + p.getImmagine());%>
                                <img src="../<%=p.getImmagine()%>" alt="">
                            </a>
                        </div>
                        <!--end image-->

                        <div class="price"><%=p.getPid()%></div>

                        <!--end admin-controls-->
                        <div class="description">
                            <p><%=p.getNote()%></p>
                        </div>
                        <!--end description-->
                        <%if (listdao.chckIfProductIsInTheList(p.getPid(), shoplistName) == false) {%>
                        <a class="detail text-caps underline" style="cursor: pointer;" id="addButton<%=p.getPid()%>" onclick="addProduct(<%=p.getPid()%>);">Aggiungi ad una lista</a>
                        <%} else {%> 
                        <a class="detail"><img src="img/correct.png" id="addIco"></a>
                            <%}%>
                        <a class="detail"><img src="img/correct.png" id="addIco<%=p.getPid()%>" class="dispNone"></a>
                    </div>
                </div>
                <%}%>
