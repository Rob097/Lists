/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.jdbc;
import database.daos.CategoryDAO;
import database.daos.ProductDAO;
import database.daos.UserDAO;
import database.entities.Category;
import database.entities.Product;
import database.entities.ShopList;
import database.entities.User;
import database.exceptions.DAOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;




/**
 *
 * @author Roberto
 */
public class JDBCCategoryDAO extends JDBCDAO implements CategoryDAO{

    //costruttore per avere disponibile la connessione
    public JDBCCategoryDAO(Connection con) {
        super(con);
    }
    
    @Override
    public ArrayList<Category> getByNOME(String nome) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Category_Product WHERE nome = ?")) {
            ArrayList<Category> categorie = new ArrayList<>();

            stm.setString(1, nome.toString());
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Category p = new Category();
                    p.setNome(rs.getString("nome"));
                    p.setDescrizione(rs.getString("descrizione"));
                    p.setAdmin(rs.getString("admin"));
                    p.setImmagine(rs.getString("immagine"));
                    categorie.add(p);
                }

                return categorie;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the category", ex);
        }
    }

    @Override
    public ArrayList<Category> getAllCategories() throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Category_Product")) {
            ArrayList<Category> categorie = new ArrayList<>();

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Category p = new Category();
                    p.setNome(rs.getString("nome"));
                    p.setDescrizione(rs.getString("descrizione"));
                    p.setAdmin(rs.getString("admin"));
                    p.setImmagine(rs.getString("immagine"));
                    categorie.add(p);
                }

                return categorie;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get categories", ex);
        }
    }
    

    
}
