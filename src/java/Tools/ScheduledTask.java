/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Tools;

import database.daos.ProductDAO;
import database.entities.ListProd;
import database.exceptions.DAOException;
import database.exceptions.DAOFactoryException;
import database.factories.DAOFactory;
import database.factories.JDBCDAOFactory;
import database.jdbc.JDBCProductDAO;
import java.util.ArrayList;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;

/**
 *
 * @author Martin
 */
public class ScheduledTask implements Runnable{

    ProductDAO productdao =null;
    ServletContextEvent sce = null;
    
    public ScheduledTask(ServletContextEvent sce) {
        this.sce = sce;
    }
    
    @Override
    public void run() {
        System.out.println("\nListener: " + new Date());        
                
        try {
            // executes method for DB connection
            getConn();
            //gets all products in List_Prod and compares them
            ArrayList<ListProd> prods = productdao.getAllChoosenProducts();
            for (ListProd p : prods) {
                int missingDays = dayDifference(p.getData_scadenza());
                if(missingDays >= 0 && missingDays <= 2){                    
                    System.out.println(p.getProdotto() + " nella lista " + p.getLista() + " scade in " + missingDays + " giorni");
                }
            }
        } catch (ServletException ex) {
            Logger.getLogger(ScheduledTask.class.getName()).log(Level.SEVERE, null, ex);
        } catch (DAOException ex) {
            Logger.getLogger(ScheduledTask.class.getName()).log(Level.SEVERE, null, ex);
        }       
        
    }
    
    //gets the created daoFactory connection
    private void getConn() throws ServletException{
        DAOFactory daoFactory = (DAOFactory) sce.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        
        productdao = new JDBCProductDAO(daoFactory.getConnection());        
    }
    
    //calcolates the missing days to expiration-date
    private int dayDifference(java.sql.Date exdate){
        Date date = new Date();
        java.sql.Date sqlDate = new java.sql.Date(date.getTime());
        long diffms = exdate.getTime() - sqlDate.getTime();
        return (int) (diffms / (1000*60*60*24));
    }

    
    
 

    
}
