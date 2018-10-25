/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Products;

import database.daos.ListDAO;
import database.daos.NotificationDAO;
import database.daos.ProductDAO;
import database.entities.Product;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCNotificationsDAO;
import database.jdbc.JDBCProductDAO;
import database.jdbc.JDBCShopListDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author della
 */
public class InfinitContentServlet extends HttpServlet {
    private static Integer counter = 1;

    protected void processRequest(HttpServletRequest request,
        
        HttpServletResponse response) throws ServletException, IOException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        System.out.println("INFINITEEEEEEEEEEEE");
        //assegna a userdao la connessione(costruttore) e salva la connessione in una variabile tipo Connection
        ProductDAO productdao = new JDBCProductDAO(daoFactory.getConnection());
        ListDAO listdao = new JDBCShopListDAO(daoFactory.getConnection());
        
        PrintWriter out = response.getWriter();
        try {
            int number;
            if(request.getSession().getAttribute("number") == null){number = 0;}
            else{number = (int) request.getSession().getAttribute("number");}
            String resp = "";
            String shoplistName = (String) request.getSession().getAttribute("shoplistName");
            ArrayList<Product> pp; Product p = null;
            pp = productdao.getByRange(number, request);
            for (int i = 1; i <= 10; i++) {
                p= pp.get(i);
                resp += "<div class=\"item\">\n" +
"                                        <!--end ribbon-->\n" +
"                                        <div class=\"wrapper\">\n" +
"                                            <div class=\"image\">\n" +
"                                                <h3>\n" +
"                                                    <a href=\"#\" class=\"tag category\">"+p.getCategoria_prodotto()+"</a>\n" +
"                                                    <a href=\"single-listing-1.html\" class=\"title\">"+p.getNome()+"</a>\n" +
"                                                    <span class=\"tag\">Offer</span>\n" +
"                                                </h3>\n" +
"                                                <a href=\"single-listing-1.html\" class=\"image-wrapper background-image\">\n" +
"                                                    <img src=\"../"+p.getImmagine()+"\" alt=\"\">\n" +
"                                                </a>\n" +
"                                            </div>\\\n" +
"                                            <!--end image-->\n" +
"\n" +
"                                            <div class=\"price\">$80</div>\n" +
"\n" +
"                                            <!--end admin-controls-->\n" +
"                                            <div class=\"description\">\n" +
"                                                <p>"+p.getNote()+"</p>\n" +
"                                            </div>\n" +
"                                            <!--end description-->\n" +
"                                            <%if(listdao.chckIfProductIsInTheList("+p.getPid()+","+shoplistName+")){%>\n"+
"                                                <a class=\"detail text-caps underline\" style=\"cursor: pointer;\" id=\"addButton"+p.getPid()+"\" onclick=\"addProduct("+p.getPid()+");\">Add to your list</a>\n" +
"                                            <%}else{%>\n" +
"                                                <a class=\"detail\"><img src=\"img/correct.png\" id=\"addIco\"></a>\n" +
"                                            <%}%>\n" +
"                                            <a class=\"detail\"><img src=\"img/correct.png\" id=\"addIco"+p.getPid()+"\" class=\"dispNone\"></a>\n" +
"                                        </div>\n" +
"                                    </div>";
            }
            out.write(resp);
        } catch (DAOException ex) {
            Logger.getLogger(InfinitContentServlet.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            out.close();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        System.out.println("INFINITEEEEEEEEEEEE");
        //assegna a userdao la connessione(costruttore) e salva la connessione in una variabile tipo Connection
        ProductDAO productdao = new JDBCProductDAO(daoFactory.getConnection());
        ListDAO listdao = new JDBCShopListDAO(daoFactory.getConnection());
        
        PrintWriter out = response.getWriter();
        try {
            int number;
            if(request.getSession().getAttribute("number") == null){number = 0;}
            else{number = (int) request.getSession().getAttribute("number");}
            String resp = "";
            String shoplistName = (String) request.getSession().getAttribute("shoplistName");
            ArrayList<Product> pp; Product p = null;
            pp = productdao.getByRange(number, request);
            for (int i = 1; i <= 10; i++) {
                p= pp.get(i);
                resp += "<div class=\"item\">\n" +
"                                        <!--end ribbon-->\n" +
"                                        <div class=\"wrapper\">\n" +
"                                            <div class=\"image\">\n" +
"                                                <h3>\n" +
"                                                    <a href=\"#\" class=\"tag category\">"+p.getCategoria_prodotto()+"</a>\n" +
"                                                    <a href=\"single-listing-1.html\" class=\"title\">"+p.getNome()+"</a>\n" +
"                                                    <span class=\"tag\">Offer</span>\n" +
"                                                </h3>\n" +
"                                                <a href=\"single-listing-1.html\" class=\"image-wrapper background-image\">\n" +
"                                                    <img src=\"../"+p.getImmagine()+"\" alt=\"\">\n" +
"                                                </a>\n" +
"                                            </div>\\\n" +
"                                            <!--end image-->\n" +
"\n" +
"                                            <div class=\"price\">$80</div>\n" +
"\n" +
"                                            <!--end admin-controls-->\n" +
"                                            <div class=\"description\">\n" +
"                                                <p>"+p.getNote()+"</p>\n" +
"                                            </div>\n" +
"                                            <!--end description-->\n" +
"                                            <%if(listdao.chckIfProductIsInTheList("+p.getPid()+","+shoplistName+")){%>\n"+
"                                                <a class=\"detail text-caps underline\" style=\"cursor: pointer;\" id=\"addButton"+p.getPid()+"\" onclick=\"addProduct("+p.getPid()+");\">Add to your list</a>\n" +
"                                            <%}else{%>\n" +
"                                                <a class=\"detail\"><img src=\"img/correct.png\" id=\"addIco\"></a>\n" +
"                                            <%}%>\n" +
"                                            <a class=\"detail\"><img src=\"img/correct.png\" id=\"addIco"+p.getPid()+"\" class=\"dispNone\"></a>\n" +
"                                        </div>\n" +
"                                    </div>";
            }
            out.write(resp);
        } catch (DAOException ex) {
            Logger.getLogger(InfinitContentServlet.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            out.close();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        System.out.println("INFINITEEEEEEEEEEEE");
        //assegna a userdao la connessione(costruttore) e salva la connessione in una variabile tipo Connection
        ProductDAO productdao = new JDBCProductDAO(daoFactory.getConnection());
        ListDAO listdao = new JDBCShopListDAO(daoFactory.getConnection());
        
        PrintWriter out = response.getWriter();
        try {
            int number;
            if(request.getSession().getAttribute("number") == null){number = 0;}
            else{number = (int) request.getSession().getAttribute("number");}
            String resp = "";
            String shoplistName = (String) request.getSession().getAttribute("shoplistName");
            ArrayList<Product> pp; Product p = null;
            pp = productdao.getByRange(number, request);
            for (int i = 1; i <= 10; i++) {
                p= pp.get(i);
                resp += "<div class=\"item\">\n" +
"                                        <!--end ribbon-->\n" +
"                                        <div class=\"wrapper\">\n" +
"                                            <div class=\"image\">\n" +
"                                                <h3>\n" +
"                                                    <a href=\"#\" class=\"tag category\">"+p.getCategoria_prodotto()+"</a>\n" +
"                                                    <a href=\"single-listing-1.html\" class=\"title\">"+p.getNome()+"</a>\n" +
"                                                    <span class=\"tag\">Offer</span>\n" +
"                                                </h3>\n" +
"                                                <a href=\"single-listing-1.html\" class=\"image-wrapper background-image\">\n" +
"                                                    <img src=\"../"+p.getImmagine()+"\" alt=\"\">\n" +
"                                                </a>\n" +
"                                            </div>\\\n" +
"                                            <!--end image-->\n" +
"\n" +
"                                            <div class=\"price\">$80</div>\n" +
"\n" +
"                                            <!--end admin-controls-->\n" +
"                                            <div class=\"description\">\n" +
"                                                <p>"+p.getNote()+"</p>\n" +
"                                            </div>\n" +
"                                            <!--end description-->\n" +
"                                            <%if(listdao.chckIfProductIsInTheList("+p.getPid()+","+shoplistName+")){%>\n"+
"                                                <a class=\"detail text-caps underline\" style=\"cursor: pointer;\" id=\"addButton"+p.getPid()+"\" onclick=\"addProduct("+p.getPid()+");\">Add to your list</a>\n" +
"                                            <%}else{%>\n" +
"                                                <a class=\"detail\"><img src=\"img/correct.png\" id=\"addIco\"></a>\n" +
"                                            <%}%>\n" +
"                                            <a class=\"detail\"><img src=\"img/correct.png\" id=\"addIco"+p.getPid()+"\" class=\"dispNone\"></a>\n" +
"                                        </div>\n" +
"                                    </div>";
            }
            out.write(resp);
        } catch (DAOException ex) {
            Logger.getLogger(InfinitContentServlet.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            out.close();
        }
    }
}

