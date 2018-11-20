/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.jdbc;

import database.daos.ProductDAO;
import database.entities.Product;
import database.exceptions.DAOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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
                    p.setCreator(rs.getString("creator"));
                    productLists.add(p);
                }

                return productLists;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }
    }

    @Override
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
                    p.setCreator(rs.getString("creator"));
                    productLists.add(p);
                }

                return productLists;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of products", ex);
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
                    p.setCreator("creator");
                    productLists.add(p);
                }

                return productLists;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get bt category", ex);
        }
    }

    @Override
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

        String qry = "insert into Product(nome,note,categoria_prod,immagine,creator) "
                + "values(?,?,?,?,?)";

        try (PreparedStatement statement = CON.prepareStatement(qry)) {
            statement.setString(1, l.getNome());
            statement.setString(2, l.getNote());
            statement.setString(3, l.getCategoria_prodotto());
            statement.setString(4, l.getImmagine());
            statement.setString(5, l.getCreator());

            if (statement.executeUpdate()>0) {
                System.out.println("inserito");
            } else {
                throw new DAOException("Impossible to update the User");
            }

        } catch (SQLException ex) {
            throw new DAOException(ex);

        }

    }
    
    @Override
    public void GuestInsert(int Pid, String creator, String nomeLista, String status) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("insert into guestListProd(creator, prodotto, nomeLista, status) values(?,?,?,?)")){
            
            
            try{
                stm.setString(1, creator);
                stm.setInt(2, Pid);
                stm.setString(3, nomeLista);
                stm.setString(4, status);
                
                if (stm.executeUpdate() == 1) {
                    System.out.println("INSERITO");
                } else {
                    throw new DAOException("Impossible to insert the Guest Product");
                }

            } catch (SQLException ex) {
                throw new DAOException(ex);
            }
            
        } catch (SQLException ex) {
            throw new DAOException("Impossible to update the Products #2", ex);
        }

    }

    @Override
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
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed product is null"));
        }

        String qry = "delete from Product where PID=?";

        try (PreparedStatement statement = CON.prepareStatement(qry)) {
            statement.setInt(1, l.getPid());

            if (statement.executeUpdate() > 0) {
                System.out.println("cancellato");
            } else {
                throw new DAOException("Impossible to delete the product");
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
                    p.setCreator(rs.getString("creator"));
                }

                return p;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }
    }

    @Override
    public ArrayList<Product> getGuestsProducts(String email) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("select * from Product INNER JOIN guestListProd ON Product.PID=guestListProd.prodotto where guestListProd.creator = ?")) {
            ArrayList<Product> productLists = new ArrayList<>();
            stm.setString(1, email);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setPid(rs.getInt("PID"));
                    p.setNome(rs.getString("nome"));
                    p.setNote(rs.getString("note"));
                    p.setCategoria_prodotto(rs.getString("categoria_prod"));
                    p.setImmagine(rs.getString("immagine"));
                    p.setStatus(rs.getString("status"));
                    productLists.add(p);
                }

                return productLists;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }
    }

    @Override
    public ArrayList<Product> getByRange(int number, HttpServletRequest request) throws DAOException {
        
        HttpSession session = request.getSession();
        ArrayList<Product> products = new ArrayList<>();
        
            try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Product ORDER BY PID LIMIT 10 OFFSET ?;")) {
                stm.setInt(1, number);
                try (ResultSet rs = stm.executeQuery()) {
                    while (rs.next()) {
                        Product p = new Product();
                        p.setPid(rs.getInt("PID"));
                        p.setNome(rs.getString("nome"));
                        p.setNote(rs.getString("note"));
                        p.setCategoria_prodotto(rs.getString("categoria_prod"));
                        p.setImmagine(rs.getString("immagine"));
                        p.setCreator(rs.getString("creator"));
                        products.add(p);
                        session.setAttribute(p.getNome(), p.getNome());
                    }
                }catch(Exception ex){
                    ex.printStackTrace();
                }
            } catch (SQLException ex) {
                throw new DAOException("Impossible number product", ex);
            }
        
        session.setAttribute("number", number+10);
        return products;
    }

    @Override
    public ArrayList<Product> nameContian(String s, HttpServletRequest request) throws DAOException {
        HttpSession session = request.getSession(false);
        ArrayList<Product> a = getAllProducts();
        ArrayList<Product> b = new ArrayList();
        boolean check = false;
        for(Product p : a){
            if(p.getNome().toLowerCase().contains(s.toLowerCase()) && session.getAttribute(p.getNome()) == null){
                b.add(p);
                session.setAttribute(p.getNome(), p.getNome());
            }
        }
        return b;
    }

    @Override
    public ArrayList<Product> getallAdminProducts() throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Product where creator = ?")) {
            stm.setString(1, "amministratore");
            
            ArrayList<Product> productLists = new ArrayList<>();
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setPid(rs.getInt("PID"));
                    p.setNome(rs.getString("nome"));
                    p.setNote(rs.getString("note"));
                    p.setCategoria_prodotto(rs.getString("categoria_prod"));
                    p.setImmagine(rs.getString("immagine"));
                    p.setCreator(rs.getString("creator"));
                    productLists.add(p);
                }

                return productLists;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of adminproducts", ex);
        }
    }

    @Override
    public int LastPIDforInsert(Product p) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT PID FROM Product WHERE nome = ? AND creator = ? ORDER BY PID DESC LIMIT 1")) {
            stm.setString(1, p.getNome());
            stm.setString(2, p.getCreator());
            
            int pid = 0;
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    pid = rs.getInt("PID");
                }
                return pid;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get bt category", ex);
        }
    }

}
