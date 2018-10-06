/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Products;

import database.daos.ProductDAO;
import database.daos.UserDAO;
import database.entities.Product;
import database.factories.DAOFactory;
import database.jdbc.JDBCProductDAO;
import database.jdbc.JDBCUserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Cody
 */
public class DeleteProduct extends HttpServlet {
    
    UserDAO userdao;
    ProductDAO productdao;
   
    @Override
    public void init() throws ServletException{
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
         if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
         }
         userdao = new JDBCUserDAO(daoFactory.getConnection());
         productdao =  new JDBCProductDAO(daoFactory.getConnection());
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
        
        String PID = request.getParameter("PID");
        System.out.println("PID" + PID);
        Product p = new Product();
        p.setPid(Integer.parseInt(PID));
        System.out.println("PID CLASSE PRDODOTTO");
        
        System.out.println("PID integer " + Integer.getInteger(PID));
        try {
            /*productdao Delete(p);*/
        } catch (Exception e) {
        }
        
        response.sendRedirect("/Lists/Pages/AdminPages/AdminProducts.jsp");
    }

   

}
