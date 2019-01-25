/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ShopList;


import database.daos.ListDAO;
import database.daos.NotificationDAO;
import database.daos.UserDAO;
import database.entities.User;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCNotificationsDAO;
import database.jdbc.JDBCShopListDAO;
import database.jdbc.JDBCUserDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Dmytr
 */
public class ShowShopList extends HttpServlet {
    private static final long serialVersionUID = 6106269076155338045L;
    transient UserDAO userdao;
    transient ListDAO listdao;
    transient NotificationDAO notificationdao;

    @Override
    public void init() throws ServletException {
        //carica la Connessione inizializzata in JDBCDAOFactory, quindi ritorna il Class.for() e la connessione
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        //assegna a userdao la connessione(costruttore) e salva la connessione in una variabile tipo Connection
        userdao = new JDBCUserDAO(daoFactory.getConnection()); 
        listdao = new JDBCShopListDAO(daoFactory.getConnection());
        notificationdao = new JDBCNotificationsDAO(daoFactory.getConnection());
    }
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
        HttpSession session =(HttpSession) request.getSession(false);
        String shopListName = request.getParameter("nome");       
        
        if(session.getAttribute("user") != null) {
            
            User user = (User) session.getAttribute("user");
             try{
                notificationdao.deleteNotification(user.getEmail(), shopListName);
            } catch (DAOException ex) {
                System.out.println("Non ci sono notifiche da eliminare\n");
            }
        }
      
        session.setAttribute("shopListName", shopListName); 
               
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
