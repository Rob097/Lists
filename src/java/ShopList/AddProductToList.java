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
import java.io.PrintWriter;
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
        System.out.println("\nPRIMO\n");
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        ListDAO listdao = new JDBCShopListDAO(daoFactory.getConnection());

        HttpSession s = (HttpSession) request.getSession();
        String prodotto = ""; String lista = "";
        
        if(request.getParameter("prodotto") != null){
            prodotto = request.getParameter("prodotto");
        }else if(s.getAttribute("prodotto") != null){
            prodotto = (String) "" + s.getAttribute("prodotto");
        }else prodotto = "niente";
        System.out.println("\nSECONDO\nprodotto="+prodotto);
        
        if(request.getParameter("shopListName") != null){
            lista = (String) request.getParameter("shopListName");
        }else if(s.getAttribute("shopListName") != null){
            lista = (String) "" + s.getAttribute("shopListName");
        }else prodotto = "niente";
        System.out.println("\nTERZO\nlista="+lista);
        
        if(s.getAttribute("user") != null){            
            try {
                listdao.insertProductToList(Integer.parseInt(prodotto), lista);
            } catch (DAOException ex) {
                Logger.getLogger(AddProductToList.class.getName()).log(Level.SEVERE, null, ex);
            }            
        }else{
            try {
                listdao.insertProductToGuestList(Integer.parseInt(prodotto), request);
            } catch (DAOException ex) {
                Logger.getLogger(AddProductToList.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        System.out.println("\nFINE\n");
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
