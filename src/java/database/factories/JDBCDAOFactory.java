/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.factories;
import database.exceptions.DAOFactoryException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Martin
 */
//implementa i metodi di DAOFactory shutdown e getConnection e crea la connessione
public class JDBCDAOFactory implements DAOFactory{
    private final  String DRIVER = "com.mysql.jdbc.Driver";
    private static final String DBURL = "jdbc:mysql://ourlists.ddns.net:3306/ourlists?zeroDateTimeBehavior=convertToNull";
    private final  String USERNAME = "user";
    private final String PASSWORD ="the_password";
    private final transient Connection CON;
    private static JDBCDAOFactory instance;
    
    //ritorna un istanza di questa Classe
     public static JDBCDAOFactory getInstance() throws DAOFactoryException {
        if (instance == null) {
            //crea un istanza di questa classe e la inizializza con il costruttore. 
            instance = new JDBCDAOFactory(DBURL);
        } else {
            throw new DAOFactoryException("DAOFactory already configured. You can call configure only one time");
        }
         if (instance == null) {
            throw new DAOFactoryException("DAOFactory not yet configured. Call DAOFactory.configure(String dbUrl) before use the class");
        }
        return instance;
    }
    //Costruttore
    private JDBCDAOFactory(String dbUrl) throws DAOFactoryException {
        super();

        try {
            // dynamically loading the appropriate driver class with a call to Class.forName()
            Class.forName(DRIVER);
        } catch (ClassNotFoundException cnfe) {
            throw new RuntimeException(cnfe.getMessage(), cnfe.getCause());
        }

        try {
            //assegna la connessione
            CON = DriverManager.getConnection(dbUrl,USERNAME,PASSWORD);
        } catch (SQLException sqle) {
            throw new DAOFactoryException("Cannot create connection", sqle);
        }
        
    }
    //ritorna una connessione
    @Override
    public Connection getConnection(){
        return CON;
    }
    
    //Chiude la connessione
    @Override
    public void shutdown() {
        try {
            CON.close();
        } catch (SQLException ex) {
            Logger.getLogger(JDBCDAOFactory.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
}
