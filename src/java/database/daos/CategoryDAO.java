/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.daos;

import database.entities.Category;
import database.exceptions.DAOException;
import java.util.ArrayList;


/**
 *
 * @author Roberto
 */
public interface CategoryDAO {
    public ArrayList<Category> getByNOME(String nome) throws DAOException;
    public ArrayList<Category> getAllCategories() throws DAOException;
}
