/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ShopList;

import database.daos.ListDAO;
import database.daos.NotificationDAO;
import database.entities.Product;
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
public class statusALLProducts extends HttpServlet {

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        //assegna a userdao la connessione(costruttore) e salva la connessione in una variabile tipo Connection
        ListDAO listdao = new JDBCShopListDAO(daoFactory.getConnection());
        NotificationDAO notificationdao = new JDBCNotificationsDAO(daoFactory.getConnection());
        String tipo = (String) request.getParameter("tipo");
        ArrayList<Product> prodottiGuest = new ArrayList<>();
        
        if (session.getAttribute("user") != null) {
            try {
                listdao.changeStatusOfAllProduct(tipo, (String) session.getAttribute("shopListName"));
                //utenti con cui la lista è condivisa
                ArrayList<User> utenti = new ArrayList();
                try {
                    utenti = notificationdao.getUsersWithWhoTheListIsShared((String) session.getAttribute("shopListName"));
                } catch (DAOException e1x) {
                    Logger.getLogger(AddProductToList.class.getName()).log(Level.SEVERE, null, e1x);
                }

                //Inserimento del prodotto nel database
                //Invio della nootifica ad ogni utente della lista
                if (session.getAttribute("user") != null) {
                    User utente = (User) session.getAttribute("user");
                    try {
                        for (User u : utenti) {
                            //System.out.println("Nome: "+u.getNominativo() + "\nlista: " + lista);
                            if (!u.getEmail().equals(utente.getEmail())) {
                                notificationdao.addNotification(u.getEmail(), "change_status_product", (String) session.getAttribute("shopListName"));
                            }
                        }
                    } catch (DAOException ex) {
                        Logger.getLogger(AddProductToList.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
            } catch (DAOException ex) {
                System.out.println("Errore sign as buyed servlet");
                Logger.getLogger(signProductAsBuyed.class.getName()).log(Level.SEVERE, null, ex);
            }
        }else{
            if(session.getAttribute("prodottiGuest") != null){
                prodottiGuest = (ArrayList<Product>) session.getAttribute("prodottiGuest"); 
            }
            for(Product p : prodottiGuest){
                p.setStatus(tipo);
            }
            session.setAttribute("prodottiGuest", prodottiGuest);
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
