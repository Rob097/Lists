/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package listeners;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import database.factories.JDBCDAOFactory;
import database.factories.DAOFactory;
import database.exceptions.DAOFactoryException;
import java.util.logging.Logger;
        

/**
 * Web application lifecycle listener.
 *
 * @author Martin
 */
public class WebAppListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {       
       try{
           DAOFactory daoFactory = JDBCDAOFactory.getInstance();
           sce.getServletContext().setAttribute("daoFactory", daoFactory);
       } catch (DAOFactoryException ex) {
            Logger.getLogger(getClass().getName()).severe(ex.toString());
            throw new RuntimeException(ex);
        }

    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
       DAOFactory daoFactory =(DAOFactory) sce.getServletContext().getAttribute("daoFactory");
       if(daoFactory != null){
           daoFactory.shutdown();
       }
       daoFactory = null;
    }
}
