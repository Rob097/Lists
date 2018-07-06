/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.daos;

import database.exceptions.DAOException;
import database.exceptions.DAOFactoryException;
import java.util.List;

/**
 *
 * @author Martin
 */
public interface DAO<ENTITY_CLASS, PRIMARY_KEY_CLASS> {
    
    
     /**
     * Returns the number of records of {@code ENTITY_CLASS} stored on the
     * persistence system of the application.   
     */
    public Long getCount() throws DAOException;
    
     /**
     * Returns the {@code ENTITY_CLASS} instance of the storage system record
     * with the primary key equals to the one passed as parameter.
     */
    public ENTITY_CLASS getByPrimaryKey(PRIMARY_KEY_CLASS primaryKey) throws DAOException;
    
    /**
     * Returns the list of all the valid entities of type {@code ENTITY_CLASS}
     * stored by the storage system.
     * */
    public List<ENTITY_CLASS> getAll() throws DAOException;
    
     /**
     * If this DAO can interact with it, then returns the DAO of class passed as
     * parameter.
     * */
    public <DAO_CLASS extends DAO> DAO_CLASS getDAO(Class<DAO_CLASS> daoClass) throws DAOFactoryException;
    
}
