/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.jdbc;

import database.daos.Category_ProductDAO;
import database.entities.Category;
import database.entities.Category_Product;
import database.exceptions.DAOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 *
 * @author Martin
 */
public class JDBCCategory_ProductDAO extends JDBCDAO implements Category_ProductDAO {
    
    public JDBCCategory_ProductDAO(Connection con) {
        super(con);
    }

    @Override
    public ArrayList<Category_Product> getByNOME(String nome) throws DAOException {
       try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Category_Product WHERE nome = ?")) {
            ArrayList<Category_Product> categorie_prodotti = new ArrayList<>();

            stm.setString(1, nome.toString());
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Category_Product p = new Category_Product();
                    p.setNome(rs.getString("nome"));
                    p.setDescrizione(rs.getString("descrizione"));
                    p.setAdmin(rs.getString("admin"));
                    p.setImmagine(rs.getString("immagine"));
                    
                    categorie_prodotti.add(p);
                }

                return categorie_prodotti;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the category", ex);
        }
    }

    @Override
    public ArrayList<Category_Product> getAllCategories() throws DAOException {
         try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Category_Product")) {
            ArrayList<Category_Product> categorie_prodotto = new ArrayList<>();

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Category_Product p = new Category_Product();
                    p.setNome(rs.getString("nome"));
                    p.setDescrizione(rs.getString("descrizione"));
                    p.setAdmin(rs.getString("admin"));
                    p.setImmagine(rs.getString("immagine"));
                    categorie_prodotto.add(p);
                }

                return categorie_prodotto;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get categories", ex);
        }
    }
    
}
