/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Products;

import database.daos.ProductDAO;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCProductDAO;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
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
public class AddPeriodicProducts extends HttpServlet {

    private static final long serialVersionUID = 6106269076155338045L;
    transient ProductDAO productdao;
    @Override
    public void init() throws ServletException {       
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        productdao = new JDBCProductDAO(daoFactory.getConnection());
        
    }    
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       
        //get all variables by request
        HttpSession session = (HttpSession) request.getSession(false);
        String[] choosenProducts = request.getParameterValues("choosenProducts");
        String period = request.getParameter("period");
        String initday = request.getParameter("initday");
        String shopListName = (String) session.getAttribute("shopListName");
        
        //new parsed vars
        int[] pids = new int[choosenProducts.length];
        int periodtimer = 0;
        Date initdate = null;
        
        //parsing
       int i = 0;            
       for (String p : choosenProducts) {               
            pids[i] = Integer.parseInt(p);
            i++;
        } 
        
        
        if(period != null){
            periodtimer = Integer.parseInt(period);
        }
        
        if(initday != null){           
            try {
                System.out.println(initday);
                SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
                initdate = formatter.parse(initday);
            } catch (ParseException ex) {
                Logger.getLogger(AddPeriodicProducts.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        try {
            productdao.insertPeriodicProducts(pids, shopListName, periodtimer, initdate);
        } catch (DAOException ex) {
            System.out.println("insertPeriodicProduct Error");
            Logger.getLogger(AddPeriodicProducts.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        response.sendRedirect(request.getContextPath() +"/Pages/ShowUserList.jsp");
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
