/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ShopList;

import database.daos.ListDAO;
import database.daos.ProductDAO;
import database.entities.Product;
import database.entities.ShopList;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCProductDAO;
import database.jdbc.JDBCShopListDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Roberto97
 */
public class SaveGuestList extends HttpServlet {

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

        //SERVLET PER SALVARE NEL DATABASE UNA LISTA DI UN UTENTE NON REGISTRATO.
        //PRENDE IL CONTENUTO DELL'ATTRIBUTO DI SESSIONE CONTENENTE LA LISTA E
        //QUELLO CONTENENTE I PRODOTTI.
        //INSERISCE NEL DATABASE CON FOREIGN KEY LA EMAIL DELL'UTENTE CHE PASSA NELLA FORM.
        
        
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        ListDAO listdao = new JDBCShopListDAO(daoFactory.getConnection());
        ProductDAO productdao = new JDBCProductDAO(daoFactory.getConnection());

        System.out.println("\nSAVE GUEST");
        HttpSession s = request.getSession();
        ShopList lista = (ShopList) s.getAttribute("guestList");
        String creator = request.getParameter("creator");
        String password = request.getParameter("password");
        ArrayList<Product> prodotti = new ArrayList<>();
        if (s.getAttribute("prodottiGuest") != null) {
            prodotti = (ArrayList<Product>) s.getAttribute("prodottiGuest"); //Prendi l'attributo di sessione contenente i prodotti se non è nullo
        }
        boolean check = false;
        try {
            listdao.checkIfGuestListExistInDatabase(creator, password);
            listdao.GuestSave(lista, creator, password);
            check = true;
        } catch (DAOException ex) {
            check = false;
            ex.printStackTrace();
            Logger.getLogger(SaveGuestList.class.getName()).log(Level.SEVERE, null, ex);
        }

        if (check) {
            for (Product p : prodotti) {
                try {
                    productdao.GuestInsert(p.getPid(), creator, lista.getNome(), p.getStatus());
                } catch (DAOException ex) {
                    Logger.getLogger(SaveGuestList.class.getName()).log(Level.SEVERE, null, ex);
                }
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
