/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.daos;

import database.entities.Category;
import database.exceptions.DAOException;
import java.util.ArrayList;
import java.util.List;


/**
 *
 * @author Roberto
 */
public interface CategoryDAO {
    public ArrayList<Category> getByNOME(String nome) throws DAOException;
    public ArrayList<Category> getAllCategories() throws DAOException;
    public void createCategory(Category category) throws DAOException;
    public Category getByName(String nome) throws DAOException;
    public void deleteCategory(Category category) throws DAOException;
    public void insertImmagine(Category categoria) throws DAOException;
    public List<String> getAllImagesbyName(String name) throws DAOException;
    public void deleteImage(String image) throws DAOException;
}
