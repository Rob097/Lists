/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.daos;

import database.entities.Product;
import database.entities.ShopList;
import database.entities.User;
import database.exceptions.DAOException;
import java.util.ArrayList;

/**
 *
 * @author Martin
 */
//intefaccia di JDBCUserDAO 
public interface ListDAO {

    public ArrayList<ShopList> getByEmail(String email) throws DAOException;
    public ArrayList<User> getUsersWithWhoTheListIsShared(ShopList l) throws DAOException;
    public ShopList Insert(ShopList l) throws DAOException;
    public ArrayList<ShopList> getListOfShopListsThatUserLookFor(String email) throws DAOException;
    public ArrayList<Product> getAllProductsOfShopList(String name)throws DAOException;
    public ArrayList<User> getUsersWithWhoTheListIsShared(String listname) throws DAOException;
}
