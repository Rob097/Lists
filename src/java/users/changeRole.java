/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package users;

import database.daos.NotificationDAO;
import database.daos.UserDAO;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCNotificationsDAO;
import database.jdbc.JDBCUserDAO;
import java.io.IOException;
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
public class changeRole extends HttpServlet {

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
        System.out.println("\nchange role servlet\n");
        HttpSession session = request.getSession();
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        //assegna a userdao la connessione(costruttore) e salva la connessione in una variabile tipo Connection
        UserDAO userdao = new JDBCUserDAO(daoFactory.getConnection());
        NotificationDAO notificationdao = new JDBCNotificationsDAO(daoFactory.getConnection());
        
        String user = request.getParameter("user");
        String roleOld = request.getParameter("role"); String roleNew = request.getParameter("new");;
        String list = request.getParameter("list"); System.out.println("LISTA::: " + list);
        Boolean check = false;
        
        try {
            userdao.changeRole(user, roleNew, list);
            check = true;
        } catch (DAOException ex) {
            System.out.println("\nError servlet changeRole\n");
            Logger.getLogger(changeRole.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        if(check){
            try {
                notificationdao.addNotification(user, "role_change", list);
            } catch (DAOException ex) {
                System.out.println("impossible to send notification of role change");
                Logger.getLogger(changeRole.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        session.setAttribute("role", user);
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
