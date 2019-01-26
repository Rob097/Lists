/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.daos;

import database.entities.ListProd;
import database.entities.PeriodicProduct;
import database.entities.Product;
import database.entities.ShopList;
import database.entities.User;
import database.exceptions.DAOException;
import java.util.ArrayList;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Martin
 */
//intefaccia di JDBCUserDAO 
public interface ListDAO {

    public ArrayList<ShopList> getByEmail(String email) throws DAOException;
    public ArrayList<User> getUsersWithWhoTheListIsShared(ShopList l) throws DAOException;
    public ShopList Insert(ShopList l) throws DAOException;
    public ShopList GuestSave(ShopList l, String creator, String password) throws DAOException;
    public void deleteGuestListFromDB(String creator) throws DAOException;
    public void checkIfGuestListExistInDatabase(String creator, String password) throws DAOException;
    public ShopList getGuestList(String email, String password) throws DAOException;
    public ArrayList<ShopList> getListOfShopListsThatUserLookFor(String email) throws DAOException;
    public ArrayList<Product> getAllProductsOfShopList(String name)throws DAOException;
    public boolean chckIfProductIsInTheList(int id, String list)throws DAOException;
    public ArrayList<User> getUsersWithWhoTheListIsShared(String listname) throws DAOException;
    public void insertSharedUser(String email, String nomeLista) throws DAOException;
    public void deleteList(String list) throws DAOException;
    public ShopList getbyName(String nome) throws DAOException;
    public ArrayList<String> getAllListsByCurentUser(String nome) throws DAOException;
    public void insertProductToList(int prodotto, String lista, String data) throws DAOException;
    public void removeProductToList(int prodotto, String lista) throws DAOException;
    public void removeALLProductToList(String lista) throws DAOException;
    public void insertProductToGuestList(int prodotto, String status, HttpServletRequest request) throws DAOException;
    public ArrayList<ShopList> getAllSharedList(String email) throws DAOException;
    public void deleteSharedUser(String email, String listname)throws DAOException;
    public String checkRole(String user, String list) throws DAOException;
    public void signProductAsBuyed(int id, String tipo, String lista) throws DAOException;
    public void changeGuestProductsStatus(int id, String tipo, HttpServletRequest request) throws DAOException;
    public void changeStatusOfAllProduct(String tipo, String lista) throws DAOException;
    public boolean checkBuyed(int id, String lista, HttpSession request) throws DAOException;
    public ArrayList<ListProd> getProdList(String listaname) throws DAOException;
    public ArrayList<ShopList> getAllObjectListsByCurentUser(String nome) throws DAOException;
    public ListProd getbyListAndProd(String lista, int prod) throws DAOException;
    public void updateExpirationDate(PeriodicProduct pp,java.sql.Date newDate) throws DAOException;
    public void updateReminder(String lista, int valore) throws DAOException;
    public void alterList(String oldName, String nome, String descrizione, String immagine, String creator, String categoria) throws DAOException;
    
}
