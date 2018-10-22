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
import javax.servlet.http.HttpServletRequest;

/**
 *
 * @author Martin
 */
//intefaccia di JDBCUserDAO 
public interface ListDAO {

    public ArrayList<ShopList> getByEmail(String email) throws DAOException;
    public ArrayList<User> getUsersWithWhoTheListIsShared(ShopList l) throws DAOException;
    public ShopList Insert(ShopList l) throws DAOException;
    public ShopList GuestSave(ShopList l, String creator) throws DAOException;
    public void deleteGuestListFromDB(String creator) throws DAOException;
    public void checkIfGuestListExistInDatabase(String creator) throws DAOException;
    public ShopList getGuestList(String email) throws DAOException;
    public ArrayList<ShopList> getListOfShopListsThatUserLookFor(String email) throws DAOException;
    public ArrayList<Product> getAllProductsOfShopList(String name)throws DAOException;
    public ArrayList<User> getUsersWithWhoTheListIsShared(String listname) throws DAOException;
    public void insertSharedUser(String email, String nomeLista) throws DAOException;
    public void deleteList(ShopList list) throws DAOException;
    public ShopList getbyName(String nome) throws DAOException;
    public ArrayList<String> getAllListsByCurentUser(String nome) throws DAOException;
    public void insertProductToList(int prodotto, String lista) throws DAOException;
    public void removeProductToList(int prodotto, String lista) throws DAOException;
    public void removeALLProductToList(String lista) throws DAOException;
    public void insertProductToGuestList(int prodotto, HttpServletRequest request) throws DAOException;
    public ArrayList<ShopList> getAllSharedList(String email) throws DAOException;
    public void deleteSharedUser(String email, String listname)throws DAOException;
}
