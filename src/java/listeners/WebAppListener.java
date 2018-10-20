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
import javax.servlet.http.HttpSession;

        

/**
 * Web application lifecycle listener.
 *
 * @author Martin
 */
public class WebAppListener implements ServletContextListener {

    //Ascolta, se viene fatto una richiesta al sito crea una connessione con mysql
    @Override
    public void contextInitialized(ServletContextEvent sce) {       
       try{
           //Crea una daoFactory e la inizializza con un istanza di JDBCDAOFactoy(db driver e db connection)
           DAOFactory daoFactory = JDBCDAOFactory.getInstance();
           
           //l`evento sce mette nella Servlet-Context un attributo daoFactory ad accedere da ogni servlet
           sce.getServletContext().setAttribute("daoFactory", daoFactory);
                                  
       } catch (DAOFactoryException ex) {
            Logger.getLogger(getClass().getName()).severe(ex.toString());
            throw new RuntimeException(ex);
        }

    }
    
        //Quando il browser viene chiuso anche la connessione viene chiuso
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        //crea un oggetto daoFactory inizzializzato col attributo daoFactory (inizzializzato sopra)
       DAOFactory daoFactory =(DAOFactory) sce.getServletContext().getAttribute("daoFactory");
       
       //chiude la connessione 
       if(daoFactory != null){
           daoFactory.shutdown();
       }
       daoFactory = null;
    }
}
