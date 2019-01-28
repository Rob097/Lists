/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.daos;

import database.entities.User;
import database.exceptions.DAOException;
import java.util.ArrayList;

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
    
    //returns user with the given email
    public User getByEmail(String email) throws DAOException;
    
    public void deleteUser(User user) throws DAOException;
    
    public User changeUser(User newUser, User oldUser) throws DAOException;
    
    public ArrayList<User> getAllUsers() throws DAOException;
    
    public void changeRole (String user, String role, String list) throws DAOException;
    
    public void changePassword (String email, String password) throws DAOException;
    
    public void changeType (String email, String tipo) throws DAOException;
    
    public boolean checkIsSending (String email) throws DAOException;
}
