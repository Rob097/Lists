/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.factories;

import java.sql.Connection;

/**
 *
 * @author Martin
 */
public interface DAOFactory {
    
    //shutdown the connection
    public void shutdown();
    
    public Connection getConnection();
   
    
}
