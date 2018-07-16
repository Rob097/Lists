/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.daos;

import database.entities.User;
import database.exceptions.DAOException;

/**
 * 
 * @author Martin
 */
//intefaccia di JDBCUserDAO 
public interface UserDAO{
    
    //returns the user with the given email and password
    public User getByEmailAndPassword(String email, String password) throws DAOException;
    
    //update the user passed as parameter and returns it
    public User update(User user) throws DAOException;
}
