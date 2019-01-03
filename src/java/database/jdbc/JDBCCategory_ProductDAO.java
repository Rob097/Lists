/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.jdbc;

import database.daos.Category_ProductDAO;
import database.entities.Category_Product;
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
 * @author Martin
 */
public class JDBCCategory_ProductDAO extends JDBCDAO implements Category_ProductDAO {
    
    public JDBCCategory_ProductDAO(Connection con) {
        super(con);
    }

    @Override
    public ArrayList<Category_Product> getByNOME(String nome) throws DAOException {
        if(nome == null ){
          throw new DAOException("nome is a mandatory field", new NullPointerException("nome is null"));
        }
        
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

    @Override
    public void insertProdCategory(Category_Product catProd) throws DAOException {
        if(catProd == null ){
          throw new DAOException("catProd is a mandatory field", new NullPointerException("product-category is null"));
        }
        
         try(PreparedStatement statement = CON.prepareStatement("insert into Category_Product (nome, descrizione, admin, immagine) values (?, ?, ?, ?)")){
           statement.setString(1, catProd.getNome());
           statement.setString(2, catProd.getDescrizione());
           statement.setString(3, catProd.getAdmin());
           statement.setString(4, catProd.getImmagine());
           
           if(statement.executeUpdate() == 1){
               return;               
           }else{
               throw new DAOException("Impossible to insert product-category");
           }
       } catch (SQLException ex) {
           System.out.println("insert categoria prodotto non effetuato");
            Logger.getLogger(JDBCCategory_ProductDAO.class.getName()).log(Level.SEVERE, null, ex);
            
        }
    }

    @Override
    public Category_Product getByName(String nome) throws DAOException {
        if(nome == null ){
          throw new DAOException("nome is a mandatory field", new NullPointerException("nome is null"));
        }
        
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Category_Product WHERE nome = ?")) {
            stm.setString(1, nome.toString());
            
            Category_Product categoria = new Category_Product();
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
    public void deleteProductCategory(Category_Product catProd) throws DAOException {
       if (catProd == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed category is null"));
        }

        try (PreparedStatement statement = CON.prepareStatement("delete from Category_Product where nome=?")) {
            statement.setString(1, catProd.getNome());

            if (statement.executeUpdate() > 0) {
                return;
            } else {
                throw new DAOException("Impossible to delete CategoryProduct");
            }

        } catch (SQLException ex) {
            throw new DAOException(ex);
        }
    }    

    @Override
    public int inUse(Category_Product catProd) throws DAOException {
        if(catProd == null ){
          throw new DAOException("category is a mandatory field", new NullPointerException("category is null"));
        }
        
        try (PreparedStatement stm = CON.prepareStatement("SELECT COUNT(categoria_prod) FROM Product WHERE categoria_prod = ?")){
           stm.setString(1, catProd.getNome()); 
           
           try(ResultSet rs = stm.executeQuery()){             
                while (rs.next()) {
                    return rs.getInt(1);
                }              
           }          
                      
        } catch (SQLException ex) {
            Logger.getLogger(JDBCCategoryDAO.class.getName()).log(Level.SEVERE, null, ex);
        }      
        
        return 0;
    }
}
