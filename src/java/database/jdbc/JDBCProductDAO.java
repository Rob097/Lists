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
public class JDBCProductDAO extends JDBCDAO implements ProductDAO {

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

    public ArrayList<Product> getAllProducts() throws DAOException {
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

    @Override
    public ArrayList<Product> getByCategory(String category) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Product WHERE categoria_prod = ?")) {
            ArrayList<Product> productLists = new ArrayList<>();

            stm.setString(1, category);
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
            throw new DAOException("Impossible to get bt category", ex);
        }
    }

    public ArrayList<String> getAllProductCategories() throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT nome FROM Category_Product")) {

            ArrayList<String> prd = new ArrayList<String>();

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    prd.add(rs.getString("nome"));
                }

                return prd;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get bt category", ex);
        }
    }

    public void Insert(Product l) throws DAOException {
        if (l == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed user is null"));
        }

        String qry = "insert into Product(nome,note,categoria_prod,immagine) "
                + "values(?,?,?,?)";

        try (PreparedStatement statement = CON.prepareStatement(qry)) {
            statement.setString(1, l.getNome());
            statement.setString(2, l.getNote());
            statement.setString(3, l.getCategoria_prodotto());
            statement.setString(4, l.getImmagine());

            if (statement.execute() == true) {
                System.out.println("inserito");
            } else {
                throw new DAOException("Impossible to update the User");
            }

        } catch (SQLException ex) {
            throw new DAOException(ex);

        }

    }

    public int LastPIDOfProducts() throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT PID FROM Product ORDER BY PID DESC LIMIT 1")) {

            int pid = 0;

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    pid = rs.getInt("PID");
                }

                return pid + 1;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get bt category", ex);
        }
    }
    
    @Override
    public void Delete(Product l) throws DAOException {
        if (l == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed user is null"));
        }

        String qry = "delete from Product where PID=?";

        try (PreparedStatement statement = CON.prepareStatement(qry)) {
            statement.setInt(1, l.getPid());

            if (statement.execute() == true) {
                System.out.println("inserito");
            } else {
                throw new DAOException("Impossible to update the User");
            }

        } catch (SQLException ex) {
            throw new DAOException(ex);

        }

    }
    
    @Override
    public Product getProductByID(int id) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Product WHERE PID = ?")) {
            
            Product p = new Product();
            
            stm.setInt(1, id);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    
                    p.setPid(rs.getInt("PID"));
                    p.setNome(rs.getString("nome"));
                    p.setNote(rs.getString("note"));
                    p.setCategoria_prodotto(rs.getString("categoria_prod"));
                    p.setImmagine(rs.getString("immagine"));
                }

                return p;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }
    }
}
