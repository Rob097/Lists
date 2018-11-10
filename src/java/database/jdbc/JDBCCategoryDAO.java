/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.jdbc;
import database.daos.CategoryDAO;
import database.entities.Category;
import database.exceptions.DAOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
;




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
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Category WHERE nome = ?")) {
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
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Category")) {
            ArrayList<Category> categorie = new ArrayList<>();

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Category p = new Category();
                    p.setNome(rs.getString("nome"));
                    p.setDescrizione(rs.getString("descrizione"));
                    p.setAdmin(rs.getString("admin"));
                    //p.setImmagine(rs.getString("immagine"));
                    categorie.add(p);
                }

                return categorie;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get categories", ex);
        }
    }

    @Override
    public void createCategory(Category category) throws DAOException {
       try(PreparedStatement statement = CON.prepareStatement("insert into Category (nome, descrizione, admin, immagine) values (?, ?, ?, ?)")){
           statement.setString(1, category.getNome());
           statement.setString(2, category.getDescrizione());
           statement.setString(3, category.getAdmin());
           statement.setString(4, category.getImmagine());
           statement.executeUpdate();
       } catch (SQLException ex) {
           System.out.println("insert categoria non effetuato");
            Logger.getLogger(JDBCCategoryDAO.class.getName()).log(Level.SEVERE, null, ex);
            
        }
    }

    @Override
    public Category getByName(String nome) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Category WHERE nome = ?")) {
            stm.setString(1, nome.toString());
            
            Category categoria = new Category();
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    
                    categoria.setNome(rs.getString("nome"));
                    categoria.setDescrizione(rs.getString("descrizione"));
                    categoria.setAdmin(rs.getString("admin"));
                    categoria.setImmagine(rs.getString("immagine"));
                    
                }

                return categoria;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the category", ex);
        }
    }

    @Override
    public void deleteCategory(Category category) throws DAOException {
        if (category == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed category is null"));
        }

        try (PreparedStatement statement = CON.prepareStatement("delete from Category where nome=?")) {
            statement.setString(1, category.getNome());

            if (statement.execute() == true) {
                System.out.println("cancellato");
            } else {
                throw new DAOException("Impossible to cancellato the User");
            }

        } catch (SQLException ex) {
            throw new DAOException(ex);

        }

    }

    

    
}
