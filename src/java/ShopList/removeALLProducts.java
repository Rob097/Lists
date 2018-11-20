/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ShopList;

import database.daos.ListDAO;
import database.daos.NotificationDAO;
import database.entities.User;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCNotificationsDAO;
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
import javax.servlet.http.HttpSession;

/**
 *
 * @author della
 */
public class removeALLProducts extends HttpServlet {

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //Dichiarazioni
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        ListDAO listdao = new JDBCShopListDAO(daoFactory.getConnection());
        NotificationDAO notificationdao = new JDBCNotificationsDAO(daoFactory.getConnection());
        HttpSession s = (HttpSession) request.getSession();
        String lista = "";
        
        if(s.getAttribute("shopListName") != null) lista = (String) "" + s.getAttribute("shopListName");
        
        if(s.getAttribute("user") != null){
            try {
                listdao.removeALLProductToList(lista);
            } catch (DAOException ex) {
                System.out.println("impossibile eliminare i prodotti dalla lista "+lista);
                Logger.getLogger(removeProduct.class.getName()).log(Level.SEVERE, null, ex);
            }

            //utenti con cui la lista è condivisa
            ArrayList<User> utenti = new ArrayList();
            try {
                utenti = notificationdao.getUsersWithWhoTheListIsShared(lista);             
            } catch (DAOException ex) {
                Logger.getLogger(AddProductToList.class.getName()).log(Level.SEVERE, null, ex);
            } 

            if(s.getAttribute("user") != null){
                User utente = (User) s.getAttribute("user");
                try {
                    for(User u : utenti){
                        //System.out.println("Nome: "+u.getNominativo() + "\nlista: " + lista);
                        if(!u.getEmail().equals(utente.getEmail())){
                            notificationdao.addNotification(u.getEmail(), "empty_list", lista);
                        }
                    }
                } catch (DAOException ex) {
                    Logger.getLogger(AddProductToList.class.getName()).log(Level.SEVERE, null, ex);
                }            
            }
        }else{
            if(s.getAttribute("prodottiGuest") != null){
                s.setAttribute("prodottiGuest", null);
            }
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
