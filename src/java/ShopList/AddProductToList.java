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
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Dmytr
 */
@WebServlet(name = "AddProductToList", urlPatterns = {"/AddProductToList"})
public class AddProductToList extends HttpServlet {

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
        
        //Dichiarazioni
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        ListDAO listdao = new JDBCShopListDAO(daoFactory.getConnection());
        NotificationDAO notificationdao = new JDBCNotificationsDAO(daoFactory.getConnection());
        HttpSession s = (HttpSession) request.getSession(false);
        String prodotto = ""; String lista = "";
        String data = null;
        Date currentDate = null;
        Calendar c = null;
        
        if(request.getParameter("shopListName") != null){
            lista = (String) request.getParameter("shopListName");
        }else if(s.getAttribute("shopListName") != null){
            lista = (String) "" + s.getAttribute("shopListName");
        }else prodotto = "niente";

        //richieste dei parametri lista e prodotto
        if(request.getParameter("prodotto") != null){
            prodotto = request.getParameter("prodotto");
        }else if(s.getAttribute("prodotto") != null){
            prodotto = (String) "" + s.getAttribute("prodotto");
        }else prodotto = "niente";        
        
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String dataStr = sdf.format(new Date());
            currentDate = sdf.parse(dataStr);            
            
            c = Calendar.getInstance();
            c.setTime(currentDate);
            c.add(Calendar.DAY_OF_MONTH, listdao.getbyName(lista).getPromemoria());
            data = sdf.format(c.getTime());
        } catch (ParseException ex) {
            Logger.getLogger(AddProductToList.class.getName()).log(Level.SEVERE, null, ex);
        } catch (DAOException ex) {
            Logger.getLogger(AddProductToList.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        //utenti con cui la lista è condivisa
        ArrayList<User> utenti = new ArrayList();
        try {
            utenti = notificationdao.getUsersWithWhoTheListIsShared(lista);
             
        } catch (DAOException ex) {
            Logger.getLogger(AddProductToList.class.getName()).log(Level.SEVERE, null, ex);
        } 
        
        //Inserimento del prodotto nel database
        //Invio della nootifica ad ogni utente della lista
        if(s.getAttribute("user") != null){
            User utente = (User) s.getAttribute("user");
            try {
                listdao.insertProductToList(Integer.parseInt(prodotto), lista, data);
                for(User u : utenti){
                    //System.out.println("Nome: "+u.getNominativo() + "\nlista: " + lista);
                    if(!u.getEmail().equals(utente.getEmail())){
                        notificationdao.addNotification(u.getEmail(), "new_product", lista);
                    }
                }
            } catch (DAOException ex) {
                Logger.getLogger(AddProductToList.class.getName()).log(Level.SEVERE, null, ex);
            }            
        }else{
            try {
                listdao.insertProductToGuestList(Integer.parseInt(prodotto), "daAcquistare", request);
            } catch (DAOException ex) {
                Logger.getLogger(AddProductToList.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        //System.out.println("\nFINE\n");
        s.setAttribute("prodotto", prodotto);
        s.setAttribute("shopListName", lista);
        
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

