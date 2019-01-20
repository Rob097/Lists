/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Tools;

import ShopList.AddProductToList;
import database.daos.ListDAO;
import database.daos.NotificationDAO;
import database.daos.ProductDAO;
import database.entities.ListProd;
import database.entities.ShopList;
import database.entities.User;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCNotificationsDAO;
import database.jdbc.JDBCProductDAO;
import database.jdbc.JDBCShopListDAO;
import java.util.ArrayList;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletException;


/**
 *
 * @author Martin
 */
public class ScheduledTask implements Runnable{

    ProductDAO productdao =null;
    ListDAO listdao =null;
    ServletContextEvent sce = null;
    NotificationDAO notificationdao = null;
  
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
            ArrayList<User> utenti;
            for (ListProd p : prods) {
                utenti = notificationdao.getUsersWithWhoTheListIsShared(p.getLista());
                System.out.println("DATAA::: " + p.getData_scadenza());
                if(!p.getStato().equals("acquistato")){
                    int missingDays = dayDifference(p.getData_scadenza());
                    if(missingDays >= 0 && missingDays <= 2){
                        
                        for (User u : utenti) {
                            //System.out.println("Nome: "+u.getNominativo() + "\nlista: " + lista);
                            notificationdao.addNotification(u.getEmail(), "secondoReminder", p.getLista());
                            
                        }
                        System.out.println(p.getProdotto() + " nella lista " + p.getLista() + " deve essere comprato al più presto");
                    }else if(missingDays > 2 && missingDays <=4){
                        for (User u : utenti) {
                            //System.out.println("Nome: "+u.getNominativo() + "\nlista: " + lista);
                            notificationdao.addNotification(u.getEmail(), "primoReminder", p.getLista());
                            
                        }
                        System.out.println(p.getProdotto() + " nella lista " + p.getLista() + " `è vicino all`esauimento");
                    }     
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
        listdao = new JDBCShopListDAO(daoFactory.getConnection());
        notificationdao = new JDBCNotificationsDAO(daoFactory.getConnection());
    }
    
    //calcolates the missing days to expiration-date
    private int dayDifference(java.sql.Date exdate){
        Date date = new Date();
        if(exdate != null){
            java.sql.Date sqlDate = new java.sql.Date(date.getTime());
            long diffms = exdate.getTime() - sqlDate.getTime();
            return (int) (diffms / (1000*60*60*24));
        }else{
            return -1;
        }
    }

}
