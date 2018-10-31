/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.daos;

import database.entities.Category_Product;
import database.exceptions.DAOException;
import java.util.ArrayList;

/**
 *
 * @author Martin
 */
public interface Category_ProductDAO {
    
    public ArrayList<Category_Product> getByNOME(String nome) throws DAOException;
    public ArrayList<Category_Product> getAllCategories() throws DAOException;
    public void insertProdCategory(Category_Product catProd) throws DAOException;
    public Category_Product getByName(String nome) throws DAOException;
    public void deleteProductCategory(Category_Product catProd) throws DAOException;
    
}
