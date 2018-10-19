/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ShopList;

import database.daos.ListDAO;
import database.daos.NotificationDAO;
import database.entities.ShopList;
import database.entities.User;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCNotificationsDAO;
import database.jdbc.JDBCShopListDAO;
import java.io.IOException;
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
 * @author Dmytr
 */
public class ShareShopListServlet extends HttpServlet {

    ListDAO listdao;
    NotificationDAO notificationdao;
    @Override
    public void init() throws ServletException {
        //carica la Connessione inizializzata in JDBCDAOFactory, quindi ritorna il Class.for() e la connessione
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        //assegna a userdao la connessione(costruttore) e salva la connessione in una variabile tipo Connection
        listdao = new JDBCShopListDAO(daoFactory.getConnection());        
        notificationdao = new JDBCNotificationsDAO(daoFactory.getConnection());
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
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
        
        String n = request.getParameter("nome");
        request.setAttribute("ClickedListName", n);

        
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       
            User user ;           
            String[] emailsharedUsers = request.getParameterValues("sharedUsers");
            HttpSession session =(HttpSession) request.getSession(false);
            String listname = (String) session.getAttribute("shopListName");            
            ArrayList<User> users = (ArrayList<User>) session.getAttribute("Users");
            user = (User) session.getAttribute("user");
            
            
            ArrayList<User> listUsers = new ArrayList<>();
                        try {
                listUsers = notificationdao.getUsersWithWhoTheListIsShared(listname);
            } catch (DAOException ex) {
                Logger.getLogger(ShareShopListServlet.class.getName()).log(Level.SEVERE, null, ex);
            }            
            
            
            //Per ogni utente con cui vuoi condividere la lista, aggiungilo alla lista e a tutti gli altri invia una notifica.s
            try {
                for (String emailsharedUser : emailsharedUsers) {
                    listdao.insertSharedUser(emailsharedUser, listname);                    
                    for(User u : listUsers){
                        if(!u.getEmail().equals(user.getEmail())){
                            notificationdao.addNotification(u.getEmail(), "new_user", listname);
                        }
                    }
                }
            } catch (DAOException ex) {
                Logger.getLogger(ShareShopListServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            //rimuove gli utenti appena condivisi dal dropdown
            for (int j = 0; j < users.size(); j++) {
                    for (int k = 0; k <emailsharedUsers.length; k++) {
                        if(users.get(j).getEmail().equals(emailsharedUsers[k])){
                            users.remove(j);
                        }
                    }
                }
            session.setAttribute("Users", users);
            
        try {
            ArrayList<ShopList> li = listdao.getByEmail(user.getEmail());
            ArrayList<ShopList> sl = listdao.getListOfShopListsThatUserLookFor(user.getEmail());
            ShopList shoplist = listdao.getbyName(listname);             
            session.setAttribute("userLists", li);
            session.setAttribute("sharedLists", sl);
            session.setAttribute("shoplist", shoplist);
            } catch (DAOException ex) {
                Logger.getLogger(ShareShopListServlet.class.getName()).log(Level.SEVERE, null, ex);
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
