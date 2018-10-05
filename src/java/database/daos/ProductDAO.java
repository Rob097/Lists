/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.daos;

import database.entities.Product;
import database.entities.User;
import database.exceptions.DAOException;
import java.util.ArrayList;


/**
 *
 * @author Dmytr
 */
public interface ProductDAO {
    public ArrayList<Product> getByID(Integer id) throws DAOException;
    public ArrayList<Product> getByCategory(String category) throws DAOException;
    public ArrayList<Product> getAllProducts() throws DAOException;
    public ArrayList<String> getAllProductCategories() throws DAOException;
    public void Insert(Product l) throws DAOException;
    public int LastPIDOfProducts() throws DAOException;
}
