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
import java.util.LinkedList;
import java.util.List;
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
        if(nome == null ){
          throw new DAOException("nome is a mandatory field", new NullPointerException("nome is null"));
        }
        
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Category WHERE nome = ?")) {
            ArrayList<Category> categorie = new ArrayList<>();

            stm.setString(1, nome.toString());
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Category p = new Category();
                    p.setNome(rs.getString("nome"));
                    p.setDescrizione(rs.getString("descrizione"));
                    p.setAdmin(rs.getString("admin"));
                    p.setImmagini(getImmagini(p));
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
                    p.setImmagini(getImmagini(p));
                    if(!p.getImmagini().isEmpty()){
                         p.setImmagine(p.getImmagini().remove(0));
                    }
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
        if(category == null){
          throw new DAOException("category is a mandatory field", new NullPointerException("category is null"));
       }
        
       try(PreparedStatement statement = CON.prepareStatement("insert into Category (nome, descrizione, admin) values (?, ?, ?)")){
           statement.setString(1, category.getNome());
           statement.setString(2, category.getDescrizione());
           statement.setString(3, category.getAdmin());
           
           if(statement.executeUpdate() == 1){
               return;
           }else{
               throw new DAOException("Impossible to insert the category");
           }
       } catch (SQLException ex) {
           System.out.println("insert categoria non effetuato");
            Logger.getLogger(JDBCCategoryDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public Category getByName(String nome) throws DAOException {
        if(nome == null){
          throw new DAOException("nome is a mandatory field", new NullPointerException("name is null"));
        }
        
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Category WHERE nome = ?")) {
            stm.setString(1, nome.toString());
            
            Category categoria = new Category();
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {                    
                    categoria.setNome(rs.getString("nome"));
                    categoria.setDescrizione(rs.getString("descrizione"));
                    categoria.setAdmin(rs.getString("admin"));
                    categoria.setImmagini(getImmagini(categoria)); 
                    
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

            if (statement.executeUpdate() > 0) {
                return;
            } else {
                throw new DAOException("Impossible to delete Category");
            }

        } catch (SQLException ex) {
            throw new DAOException(ex);
        }
    }
    
    @Override
    public void insertImmagine(Category categoria) throws DAOException{
        if (categoria == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed category is null"));
        } 
        
        try(PreparedStatement statement = CON.prepareStatement("insert into Category_Image (categoria, immagine) values (?, ?)")){
           statement.setString(1, categoria.getNome());
           statement.setString(2, categoria.getImmagine());
           
           if(statement.executeUpdate() == 1){
               return;
           }else{
               throw new DAOException("impossible to insert category-immage");
           }
       } catch (SQLException ex) {
           System.out.println("insert immagine non effetuato");
            Logger.getLogger(JDBCCategoryDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public List<String> getImmagini(Category categoria) throws DAOException{
        if (categoria == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed category is null"));
        } 
        
        try (PreparedStatement stm = CON.prepareStatement("SELECT categoria,immagine FROM Category_Image WHERE categoria = ?")) {
            stm.setString(1, categoria.getNome());
            
            List<String> immagini = new LinkedList<>();
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    immagini.add(rs.getString("immagine"));
                }

                return immagini;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the immages", ex);
        }
    }
    
    @Override
    public void deleteImage(String image) throws DAOException {
       if (image == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed image is null"));
        }

        try (PreparedStatement statement = CON.prepareStatement("delete from Category_Image where immagine=?")) {
            statement.setString(1, image);

            if (statement.executeUpdate() > 0) {
                System.out.println("cancellato");
            } else {
                throw new DAOException("Impossible to delete the image");
            }

        } catch (SQLException ex) {
            throw new DAOException(ex);
        }
    }

    @Override
    public List<String> getAllImagesbyName(String name) throws DAOException {
        if(name == null ){
          throw new DAOException("nome is a mandatory field", new NullPointerException("name is null"));
        }
        
        try (PreparedStatement stm = CON.prepareStatement("SELECT immagine FROM Category_Image WHERE categoria = ?")) {
            stm.setString(1, name);
            
            List<String> immagini = new LinkedList<>();
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    immagini.add(rs.getString("immagine"));
                }

                return immagini;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the immages", ex);
        }
    }
}
