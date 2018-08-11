/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.jdbc;
import database.daos.ProductDAO;
import database.daos.UserDAO;
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
 * @author Martin
 */
public class JDBCProductDAO extends JDBCDAO implements ProductDAO{

    //costruttore per avere disponibile la connessione
    public JDBCProductDAO(Connection con) {
        super(con);
    }
    

    @Override
    public ArrayList<Product> getByID(Integer id) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM List WHERE creator = ?")) {
            ArrayList<Product> productLists = new ArrayList<>();

            stm.setString(1, id.toString());
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setPid(rs.getInt("PID"));
                    p.setNome(rs.getString("nome"));
                    p.setNote(rs.getString("note"));
                    p.setImmagine(rs.getString("immagine"));
                    productLists.add(p);
                }

                return productLists;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }
    }
    
    public ArrayList<Product> getAllProducts() throws DAOException{
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Product")) {
            ArrayList<Product> productLists = new ArrayList<>();

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setPid(rs.getInt("PID"));
                    p.setNome(rs.getString("nome"));
                    p.setNote(rs.getString("note"));
                    p.setCategoria_prodotto(rs.getString("categoria_prod"));
                    p.setImmagine(rs.getString("immagine"));
                    productLists.add(p);
                }

                return productLists;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }
    }
    

    
}
