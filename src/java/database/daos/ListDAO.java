/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.daos;

import database.entities.ShopList;
import database.entities.User;
import database.exceptions.DAOException;
import java.util.ArrayList;

/**
 * 
 * @author Martin
 */
//intefaccia di JDBCUserDAO 
public interface ListDAO{
    
    //returns the user with the given email and password
    public ShopList getByName(String name) throws DAOException;
    
    //update the user passed as parameter and returns it
    //public User update(ShopList list) throws DAOException;
    
    //returns user with the given email
    //public ShopList getByUser(String email) throws DAOException;
    
    //public void deleteList(ShopList list) throws DAOException;
    
    //public User changeList(ShopList newList, ShopList oldList) throws DAOException;
    
    public Integer insert(ShopList lista)throws DAOException;
    
    public boolean linkShoppingListToUser(ShopList shoppingList, User user) throws DAOException;
    
    public ArrayList<ShopList> getAllListByUserEmail(User user) throws DAOException;
}
