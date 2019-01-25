/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ShopList;

import database.daos.ListDAO;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCShopListDAO;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Roberto97
 */
public class updateDefaultReminder extends HttpServlet {
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
        ListDAO listdao = new JDBCShopListDAO(daoFactory.getConnection());
        
        String lista = request.getParameter("lista");
        int valore = Integer.parseInt(request.getParameter("valore"));
        System.out.println("Lista: " + lista + "; Valore: " + valore);
        try {
            listdao.updateReminder(lista, valore);
        } catch (DAOException ex) {
            Logger.getLogger(updateDefaultReminder.class.getName()).log(Level.SEVERE, null, ex);
        }
        try {
            System.out.println(listdao.getbyName(lista).getPromemoria());
        } catch (DAOException ex) {
            Logger.getLogger(updateDefaultReminder.class.getName()).log(Level.SEVERE, null, ex);
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
