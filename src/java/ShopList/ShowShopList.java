/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ShopList;

import database.daos.UserDAO;
import database.entities.User;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
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

    @Override
    public void init() throws ServletException {
        //carica la Connessione inizializzata in JDBCDAOFactory, quindi ritorna il Class.for() e la connessione
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        //assegna a userdao la connessione(costruttore) e salva la connessione in una variabile tipo Connection
        userdao = new JDBCUserDAO(daoFactory.getConnection());        
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
        ArrayList<User> users = new ArrayList<>();
        User user = (User) session.getAttribute("user");
        User dbuser = null;
        try {
            dbuser = userdao.getByEmail(user.getEmail());
        } catch (DAOException ex) {
            Logger.getLogger(ShowShopList.class.getName()).log(Level.SEVERE, null, ex);
        }
        int index;
        
        try {
            users = userdao.getAllUsers();
            Iterator<User> i = users.iterator();
            while(i.hasNext()){
                if(i.next().getEmail().equals(user.getEmail())){
                    i.remove();
                }
            }
        } catch (DAOException ex) {
            Logger.getLogger(ShowShopList.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println("problems with getAllUsers()");
        }
        String s = request.getParameter("nome");
        
        System.out.println("==========================" + s);
        
        session.setAttribute("shopListName", s);
        if(users != null){
            session.setAttribute("Users", users);
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
