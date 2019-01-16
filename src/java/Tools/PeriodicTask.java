/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Tools;

import database.daos.ListDAO;
import database.daos.ProductDAO;
import database.entities.ListProd;
import database.entities.PeriodicProduct;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCProductDAO;
import database.jdbc.JDBCShopListDAO;
import java.util.ArrayList;
import java.util.Date;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletException;

/**
 *
 * @author Martin
 */
public class PeriodicTask implements Runnable {
    
    ServletContextEvent sce;
    ProductDAO productdao;
    ListDAO listdao;

    public PeriodicTask(ServletContextEvent sce) {
        this.sce = sce;
    }    
    
    @Override
    public void run() {
        System.out.println("\nPeriodicListener: " + new Date());
        try {
            //init connection
            getConnection();
            //get all periodic Products
           ArrayList<PeriodicProduct> products = productdao.getAllPeriodicProducts();
           for(PeriodicProduct p : products){                             
               if(dayDifference(p.getData_scadenza())<5){
                   if(!listdao.chckIfProductIsInTheList(p.getProdotto(), p.getLista())){
                       listdao.insertProductToList(p.getProdotto(), p.getLista(), p.getData_scadenza().toString());
                       System.out.println("");
                       System.out.println("inserted: "+ p.getLista() + " " + p.getProdotto() + " " + p.getData_scadenza() );
                   } else if(listdao.chckIfProductIsInTheList(p.getProdotto(), p.getLista())){
                        ListProd prod = listdao.getbyListAndProd(p.getLista(), p.getProdotto());
                        if(prod.getStato().equals("acquistato")){
                            //listdao.signProductAsBuyed(p.getProdotto(), "daAcquistare", p.getLista());
                            addPeriod(p.getData_scadenza(),p.getPeriodo());
                            //update periodic product no zu mochen
                        }
                   }
               }
           }           
           
        } catch (ServletException ex) {
            Logger.getLogger(PeriodicTask.class.getName()).log(Level.SEVERE, null, ex);
        } catch (DAOException ex) {
            Logger.getLogger(PeriodicTask.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        
    }
    
    private void getConnection() throws ServletException{
        DAOFactory daoFactory = (DAOFactory) sce.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        productdao = new JDBCProductDAO(daoFactory.getConnection());
        listdao = new JDBCShopListDAO(daoFactory.getConnection());
    }
    
     private int dayDifference(java.sql.Date exdate){
        Date date = new Date();
        java.sql.Date sqlDate = new java.sql.Date(date.getTime());
        long diffms = exdate.getTime() - sqlDate.getTime();
        return (int) (diffms / (1000*60*60*24));
    }
     
     private java.sql.Date addPeriod(java.sql.Date date, int period){
         System.out.println("");
         System.out.println(date);
         long newDate = date.getTime() + TimeUnit.DAYS.toMillis(period);
         date = new java.sql.Date(newDate);
         System.out.println(date);
         return date;
     }
    
}
