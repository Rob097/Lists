/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.daos;

import database.entities.ListProd;
import database.entities.PeriodicProduct;
import database.entities.Product;
import database.exceptions.DAOException;
import java.util.ArrayList;
import java.util.Date;
import javax.servlet.http.HttpServletRequest;


/**
 *
 * @author Dmytr
 */
public interface ProductDAO {
    public ArrayList<Product> getByID(Integer id) throws DAOException;
    public ArrayList<Product> getByCategory(String category) throws DAOException;
    public ArrayList<Product> getAllProducts() throws DAOException;
    public ArrayList<Product> getGuestsProducts(String email) throws DAOException;
    public ArrayList<String> getAllProductCategories() throws DAOException;
    public void Insert(Product l) throws DAOException;
    public void GuestInsert(int pId, String creator, String nomeLista, String status, int quantity) throws DAOException;
    public int LastPIDOfProducts() throws DAOException;
    public void Delete(Product l) throws DAOException;
    public Product getProductByID(int id) throws DAOException;
    public ArrayList<Product> nameContian(String s, HttpServletRequest request) throws DAOException;
    public ArrayList<Product> getallAdminProducts() throws DAOException;
    public int LastPIDforInsert(Product p) throws DAOException;
    public int getQuantity(int idProd, String listName) throws DAOException;
    public void updateQuantity(int quantita, int idProd, String listName) throws DAOException;
    public ArrayList<ListProd> getAllChoosenProducts () throws DAOException;
    public void insertPeriodicProducts(int[] pids,String shopListName, int period, Date initday)throws DAOException;
    public ArrayList<Product> getPeriodicProducts(String shopListName) throws DAOException;
    public void deletePeriodicProducts(int[] pids, String shopListName) throws DAOException;
    public ArrayList<PeriodicProduct> getAllPeriodicProducts() throws DAOException;
    public void updatePeriodicDate(PeriodicProduct pp, java.sql.Date newDate)throws DAOException;
    public String getReminderDate(Product p, String lista)throws DAOException;
    public void updateReminder(int id, String lista, String data)throws DAOException;
}
