/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ShopList;

import database.daos.ListDAO;
import database.daos.UserDAO;
import database.entities.ShopList;
import database.entities.User;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCShopListDAO;
import database.jdbc.JDBCUserDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
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
public class ShowShopList extends HttpServlet {
    UserDAO userdao;
    ListDAO listdao;

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
        System.out.println("ShowShopList:\n\n");
        HttpSession session =(HttpSession) request.getSession(false);
        String s = request.getParameter("nome");
        ShopList shoplist ;
        
        if(session.getAttribute("user") != null) {
            ArrayList<User> users = new ArrayList<>();
            User user = (User) session.getAttribute("user");
            User dbuser = null;
            ArrayList<User> sharedusers = new ArrayList<>();

            try {
                dbuser = userdao.getByEmail(user.getEmail());
                sharedusers = listdao.getUsersWithWhoTheListIsShared(s);
                shoplist = listdao.getbyName(s);
                session.setAttribute("shoplist", shoplist);
            } catch (DAOException ex) {
                System.out.println("try error showShopList.java\n");
                Logger.getLogger(ShowShopList.class.getName()).log(Level.SEVERE, null, ex);
            }

            try {
                users = userdao.getAllUsers();
                Iterator<User> i = users.iterator();
                while(i.hasNext()){
                    //remove your username
                    if(i.next().getEmail().equals(user.getEmail())){
                        i.remove();
                    }
                }
                //remove just linked usernames
                for (int j = 0; j < users.size(); j++) {
                    for (int k = 0; k < sharedusers.size(); k++) {
                        if(users.get(j).getEmail().equals(sharedusers.get(k).getEmail())){
                            users.remove(j);
                        }
                    }
                }
            } catch (DAOException ex) {
                Logger.getLogger(ShowShopList.class.getName()).log(Level.SEVERE, null, ex);
                System.out.println("problems with getAllUsers()");
            }
            session.setAttribute("Users", users);
        }
        System.out.println("==========================" + s);
        
        session.setAttribute("shopListName", s); 
        
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
