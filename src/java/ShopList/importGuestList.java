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
 * @author Roberto97
 */
public class importGuestList extends HttpServlet {

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        //SERVLET PER IMPORTARE UNA LISTA DI UN UTENTE NON REGISTRATO DAL DATABASE
        //RICEVE IN INPUT L'EMAIL DELL'UTENTE E CONTROLLA NEL DATABASE.
        //SE TROVA UNA LISTA CON QUELL'EMAIL RESTITUISCE E SALVA NEI RELATIVI ATTRIBUTI DI SESSIONE
        //SIA LA LISTA CHE I PRODOTTI CHE CONTIENE LA LISTA
        
        System.out.println("import servlet");
        HttpSession session = request.getSession();
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        //assegna a userdao la connessione(costruttore) e salva la connessione in una variabile tipo Connection
        ListDAO listdao = new JDBCShopListDAO(daoFactory.getConnection());
        ProductDAO productdao = new JDBCProductDAO(daoFactory.getConnection());
        
        String email = request.getParameter("creator");
        String password = request.getParameter("password");
        ShopList s = new ShopList();
        ArrayList<Product> pp = new ArrayList<>();
        try {
            s = listdao.getGuestList(email, password);
            pp = productdao.getGuestsProducts(email);
        } catch (DAOException ex) {
            System.out.println("ERRORE");
            Logger.getLogger(importGuestList.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        
        s.setProducts(pp);       
        
        if(s.getNome() != null){
            session.setAttribute("guestList", s);
            session.setAttribute("prodottiGuest", pp);
            session.setAttribute("importGL", true);
        }
        
        response.sendRedirect("/Lists/userlists.jsp");
        
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
