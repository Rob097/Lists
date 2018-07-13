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
public class JDBCDAOFactory implements DAOFactory{
    private final  String DRIVER = "com.mysql.jdbc.Driver";
    private static final String DBURL = "jdbc:mysql://sql2.freemysqlhosting.net:3306/sql2243047?zeroDateTimeBehavior=convertToNull";
    private final  String USERNAME = "sql2243047";
    private final String PASSWORD ="mJ9*fQ4%";
    private final transient Connection CON;
    private static JDBCDAOFactory instance;
    
    
     public static JDBCDAOFactory getInstance() throws DAOFactoryException {
        if (instance == null) {
            instance = new JDBCDAOFactory(DBURL);
        } else {
            throw new DAOFactoryException("DAOFactory already configured. You can call configure only one time");
        }
         if (instance == null) {
            throw new DAOFactoryException("DAOFactory not yet configured. Call DAOFactory.configure(String dbUrl) before use the class");
        }
        return instance;
    }
    
    private JDBCDAOFactory(String dbUrl) throws DAOFactoryException {
        super();

        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException cnfe) {
            throw new RuntimeException(cnfe.getMessage(), cnfe.getCause());
        }

        try {
            CON = DriverManager.getConnection(dbUrl,USERNAME,PASSWORD);
        } catch (SQLException sqle) {
            throw new DAOFactoryException("Cannot create connection", sqle);
        }
        
    }
    @Override
    public Connection getConnection(){
        return CON;
    }
    

    @Override
    public void shutdown() {
        try {
            CON.close();
        } catch (SQLException ex) {
            Logger.getLogger(JDBCDAOFactory.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
}
