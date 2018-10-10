/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ShopList;

import database.daos.ListDAO;
import database.entities.ShopList;
import database.entities.User;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
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
 * @author Martin
 */
public class DeleteSharedUsers extends HttpServlet {

    ListDAO listdao;
    @Override
    public void init() throws ServletException {
        //carica la Connessione inizializzata in JDBCDAOFactory, quindi ritorna il Class.for() e la connessione
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        //assegna a userdao la connessione(costruttore) e salva la connessione in una variabile tipo Connection
        listdao = new JDBCShopListDAO(daoFactory.getConnection());        
    }

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
        
        //request dei parametri
        HttpSession session = (HttpSession)request.getSession(false);
        String[] sharedToDelete = request.getParameterValues("sharedToDelete");
        String listname = (String) session.getAttribute("shopListName");
        User user = (User) session.getAttribute("user");
        
        //cancellazione utenti condivisi selezionati
        try{
            for (String sharedEmail : sharedToDelete) {
                listdao.deleteSharedUser(sharedEmail, listname);
            }
        }catch(DAOException ex){ //mit DAOException ersetzen
            Logger.getLogger(ShareShopListServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        
            
         //modificare le variabili della sessione
         try{
            ArrayList<ShopList> li = listdao.getByEmail(user.getEmail());
            ArrayList<ShopList> sl = listdao.getListOfShopListsThatUserLookFor(user.getEmail());
            session.setAttribute("userLists", li);
            session.setAttribute("sharedLists", sl);
         }  catch (DAOException ex1) {
                Logger.getLogger(DeleteSharedUsers.class.getName()).log(Level.SEVERE, null, ex1);
            } 
         
         //redirecting to Shopping List
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