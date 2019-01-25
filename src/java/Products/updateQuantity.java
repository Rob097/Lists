/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Products;

import database.daos.ProductDAO;
import database.entities.Product;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCProductDAO;
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
 * @author della
 */
public class updateQuantity extends HttpServlet {
    private static final long serialVersionUID = 6106269076155338045L;
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
        
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        HttpSession s = request.getSession();
        ProductDAO productdao = new JDBCProductDAO(daoFactory.getConnection());
        
        String lista = request.getParameter("lista");
        int id = Integer.parseInt(request.getParameter("id"));
        int quantita = Integer.parseInt(request.getParameter("quantita"));
        ArrayList<Product> prod;
        if(s.getAttribute("user") != null){
            try {
                productdao.updateQuantity(quantita, id, lista);
            } catch (DAOException ex) {
                System.out.println("errore update quantity in servlet");
                Logger.getLogger(updateQuantity.class.getName()).log(Level.SEVERE, null, ex);
            }
        }else{
            prod = (ArrayList<Product>) s.getAttribute("prodottiGuest");
            prod.stream().filter((u) -> (u.getPid() == id)).forEachOrdered((u) -> {
                u.setQuantity(quantita);
            }); 
        }
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
