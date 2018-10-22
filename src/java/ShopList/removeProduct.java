/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ShopList;

import database.daos.ListDAO;
import database.daos.NotificationDAO;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCNotificationsDAO;
import database.jdbc.JDBCShopListDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author della
 */
public class removeProduct extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //Dichiarazioni
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        ListDAO listdao = new JDBCShopListDAO(daoFactory.getConnection());
        NotificationDAO notificationdao = new JDBCNotificationsDAO(daoFactory.getConnection());
        HttpSession s = (HttpSession) request.getSession();
        int prodotto = 0; String lista = "";
        
        if(request.getParameter("prodotto") != null) prodotto = Integer.parseInt(request.getParameter("prodotto"));
        if(s.getAttribute("shopListName") != null) lista = (String) "" + s.getAttribute("shopListName");
        
        try {
            listdao.removeProductToList(prodotto, lista);
        } catch (DAOException ex) {
            System.out.println("impossibile eliminare il prodotto "+prodotto+" dalla lista "+lista);
            Logger.getLogger(removeProduct.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        response.sendRedirect("/Lists/Pages/ShowUserList.jsp");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
