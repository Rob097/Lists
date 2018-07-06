/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.factories;

import database.daos.DAO;
import database.exceptions.DAOFactoryException;

/**
 *
 * @author Martin
 */
public interface DAOFactory {
    
    //shutdown the connection
    public void shutdown();
    
    
    //Returns the concrete {@link DAO dao} which type is the class passed as parameter
   
    public <DAO_CLASS extends DAO> DAO_CLASS getDAO(Class<DAO_CLASS> daoInterface) throws DAOFactoryException;
    
}
