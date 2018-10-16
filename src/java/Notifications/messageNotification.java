/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Notifications;

import ShopList.chat;
import database.daos.NotificationDAO;
import database.entities.ShopList;
import database.entities.User;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCNotificationsDAO;
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
public class messageNotification extends HttpServlet {

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
        
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        User sender;
        ShopList listname;
        NotificationDAO notificationdao = new JDBCNotificationsDAO(daoFactory.getConnection());
        ArrayList <User> users = new ArrayList<>();

        sender = (User) request.getSession().getAttribute("user");
        listname = (ShopList) request.getSession().getAttribute("shoplist");
        try {
            users = notificationdao.getUsersWithWhoTheListIsShared(listname.getNome());
            if(!users.isEmpty() && users != null){
                for(User u : users){
                    if(!u.getEmail().equals(sender.getEmail())){
                        notificationdao.addNotification(u.getEmail(), "new_message", listname.getNome());
                    }
                }
            }
        } catch (DAOException ex) {
            Logger.getLogger(chat.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println("Errore notifiche chat.java");
        }
        response.sendRedirect("/Lists/Pages/ThirdChatroom.jsp");
        
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
