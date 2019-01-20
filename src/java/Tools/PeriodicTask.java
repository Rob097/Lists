/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Tools;

import database.daos.ListDAO;
import database.daos.ProductDAO;
import database.daos.UserDAO;
import database.entities.ListProd;
import database.entities.PeriodicProduct;
import database.entities.Product;
import database.entities.ShopList;
import database.entities.User;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCProductDAO;
import database.jdbc.JDBCShopListDAO;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.concurrent.TimeUnit;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Martin
 */
public class PeriodicTask extends HttpServlet implements Runnable {
    
    ServletContextEvent sce;
    ProductDAO productdao;
    ListDAO listdao;
    UserDAO userdao;
    
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
               //controlla se mancano meno di 5 giorni fino alla data scadenza
               if(dayDifference(p.getData_scadenza())<5){
                   //se il prodotto non è ancora nella lista
                   if(!listdao.chckIfProductIsInTheList(p.getProdotto(), p.getLista())){
                       //inserisce il prodotto nella lista
                       listdao.insertProductToList(p.getProdotto(), p.getLista(), p.getData_scadenza().toString());                       
                       System.out.println("");
                       System.out.println("inserted: "+ p.getLista() + " " + p.getProdotto() + " " + p.getData_scadenza() );
                    //se è nella lista
                   } else if(listdao.chckIfProductIsInTheList(p.getProdotto(), p.getLista())){
                       //carica il prodotto
                        ListProd prod = listdao.getbyListAndProd(p.getLista(), p.getProdotto());
                        //controlla se è stato acquistato
                        if(prod.getStato().equals("acquistato")){
                            //cambia lo stato del prodotto
                            listdao.signProductAsBuyed(p.getProdotto(), "daAcquistare", p.getLista());
                            //somma la data scadenza al periodo e la atualizza nella tabella Periodic_Products
                            productdao.updatePeriodicDate(p, addPeriod(p.getData_scadenza(),p.getPeriodo())); 
                            //somma la data scadenza al periodo e la atualizza nella tabella List_Prod
                            listdao.updateExpirationDate(p, addPeriod(p.getData_scadenza(),p.getPeriodo()));
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
         System.out.println(date);
         long newDate = date.getTime() + TimeUnit.DAYS.toMillis(period);
         date = new java.sql.Date(newDate);         
         return date;
     }
    
}
