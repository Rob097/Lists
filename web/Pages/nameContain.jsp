<%-- 
    Document   : nameContain
    Created on : 26-ott-2018, 19.09.44
    Author     : Roberto97
--%>

<%@page import="database.daos.ListDAO"%>
<%@page import="database.jdbc.JDBCShopListDAO"%>
<%@page import="database.entities.Product"%>
<%@page import="java.util.ArrayList"%>
<%@page import="database.jdbc.JDBCProductDAO"%>
<%@page import="database.daos.ProductDAO"%>
<%@page import="database.factories.DAOFactory"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        
        //assegna a userdao la connessione(costruttore) e salva la connessione in una variabile tipo Connection
        ProductDAO productdao = new JDBCProductDAO(daoFactory.getConnection());
        ListDAO listdao = new JDBCShopListDAO(daoFactory.getConnection());
        String shoplistName = (String) request.getSession().getAttribute("shopListName");
        
            String s = request.getParameter("s");
            ArrayList<Product> pp = null;
            if(s == null || s.equals("")){
                
            }else{
                pp = productdao.nameContian(s, request);
                for(Product p : pp){%>
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
                <%}
            }%>

