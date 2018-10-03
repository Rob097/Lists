/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.jdbc;

import database.daos.ListDAO;
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
public class JDBCShopListDAO extends JDBCDAO implements ListDAO {

    //costruttore per avere disponibile la connessione
    public JDBCShopListDAO(Connection con) {
        super(con);
    }

    @Override
    public ArrayList<ShopList> getByEmail(String email) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM List WHERE creator = ?")) {
            ArrayList<ShopList> shoppingLists = new ArrayList<>();
            

            stm.setString(1, email);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    ShopList sL = new ShopList();
                    sL.setNome(rs.getString("nome"));
                    sL.setDescrizione(rs.getString("descrizione"));
                    sL.setImmagine(rs.getString("immagine"));
                    sL.setCreator(rs.getString("creator"));
                    sL.setCategoria(rs.getString("categoria"));
                    sL.setSharedUsers(getUsersWithWhoTheListIsShared(sL));

                    shoppingLists.add(sL);
                }

                return shoppingLists;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }
    }

    @Override
    public ArrayList<User> getUsersWithWhoTheListIsShared(ShopList l) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("select email from User where email in (select user from User_List where list = ?)")) {
            ArrayList<User> userList = new ArrayList<>();

            stm.setString(1, l.getNome());
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setEmail(rs.getString("email"));

                    userList.add(u);
                }

                return userList;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }
    }
    
    @Override
    public ArrayList<User> getUsersWithWhoTheListIsShared(String listname) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("select * from User where email in (select user from User_List where list = ?)")) {
            ArrayList<User> userList = new ArrayList<>();

            stm.setString(1, listname);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setEmail(rs.getString("email"));
                    u.setNominativo(rs.getString("nominativo"));
                    u.setImage(rs.getString("immagine"));
                    userList.add(u);
                }

                return userList;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }
    }

    @Override
    public ShopList Insert(ShopList l) throws DAOException {

        if (l == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed user is null"));
        }
        
        System.out.println(l.getCreator());
        
        String qry = "insert into List(nome,descrizione,immagine,creator,categoria) "
                + "values(?,?,?,"
                + "(select email from User where email = ?),"
                + "(select nome from Category where nome = ?))";

        
        try (PreparedStatement statement = CON.prepareStatement(qry)) {
            statement.setString(1, l.getNome());
            statement.setString(2, l.getDescrizione());
            statement.setString(3, l.getImmagine());
            statement.setString(4, l.getCreator());
            statement.setString(5, l.getCategoria());

            if (statement.executeUpdate() == 1) {
                return l;
            } else {
                throw new DAOException("Impossible to insert the User");
            }
        } catch (SQLException ex) {
            throw new DAOException(ex);
            
        }
    }
    
    @Override
    public ArrayList<ShopList> getListOfShopListsThatUserLookFor(String email) throws DAOException{
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM List WHERE nome IN (SELECT list FROM User_List where user = ?)")) {
            ArrayList<ShopList> shoppingLists = new ArrayList<>();

            stm.setString(1, email);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    ShopList sL = new ShopList();
                    sL.setNome(rs.getString("nome"));
                    sL.setDescrizione(rs.getString("descrizione"));
                    sL.setImmagine(rs.getString("immagine"));
                    sL.setCreator(rs.getString("creator"));
                    sL.setCategoria("categoria");
                    sL.setSharedUsers(getUsersWithWhoTheListIsShared(sL));

                    shoppingLists.add(sL);
                }

                return shoppingLists;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }
    }
    
    @Override
    public ArrayList<Product> getAllProductsOfShopList(String name)throws DAOException{
        
        try (PreparedStatement stm = CON.prepareStatement("select * from Product where PID in (select prodotto from List_Prod where lista = ?)")) {
            ArrayList<Product> productLists = new ArrayList<>();
            System.out.println("LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL" + name);
            stm.setString(1, name);
            try (ResultSet rs = stm.executeQuery()) {
                System.out.println("YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY" + name);
                while (rs.next()) {
                    
                    Product sL = new Product();
                    System.out.println("WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW" + name);
                    String n = rs.getString("nome");
                    System.out.println(n);
                    sL.setNome(n);
                    System.out.println("NNNNNNNNNNNNNNNNNNNNNNNNOME" + name);
                    sL.setCategoria_prodotto(rs.getString("categoria_prod"));
                    System.out.println("CCCCCCCCCCCCCCCCCCCCCCATEGORIA" + name);
                    sL.setPid(rs.getInt("PID"));
                    System.out.println("PPPPPPPPPPPPPPPPPPPPPPPPPPPPPID" + name);
                    sL.setNote(rs.getString("note"));
                    sL.setImmagine(rs.getString("immagine"));
                    System.out.println("NTTTTTTTTTTTTTEEEEEE" + name);

                    productLists.add(sL);
                }
                
                System.out.println("ENNNNDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD" + name);
                return productLists;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }
    }

    @Override
    public void insertSharedUser(String email, String nomeLista) throws DAOException {
        if (email == null || nomeLista == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed email or listname is null"));
        }
        
        try(PreparedStatement stm = CON.prepareStatement("INSERT INTO User_List VALUES (?,?)")){
            stm.setString(1, email);
            stm.setString(2, nomeLista);
            
            if (stm.executeUpdate() == 1) {
                System.out.println("successful operation");
            } else {
                throw new DAOException("Impossible to insert the query");
            }
        } catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public void deleteList(ShopList list) throws DAOException {
        if ( list == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed list is null"));
        }
        try(PreparedStatement stm = CON.prepareStatement("DELETE FROM User_List WHERE list=?")){
            stm.setString(1, list.getNome());
            if (stm.executeUpdate() == 1) {
               
            } else {
                throw new DAOException("Impossible to insert the User");
            }
        } catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        try(PreparedStatement stm = CON.prepareStatement("DELETE FROM List_Prod WHERE lista=?")){
            stm.setString(1, list.getNome());
            if (stm.executeUpdate() == 1) {
               
            } else {
                throw new DAOException("Impossible to insert the User");
            }
        } catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        try(PreparedStatement stm = CON.prepareStatement("DELETE FROM List WHERE nome=?")){
            stm.setString(1, list.getNome());
            if (stm.executeUpdate() == 1) {
              
            } else {
                throw new DAOException("Impossible to insert the User");
            }
        } catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public ShopList getbyName(String nome) throws DAOException {
        if ( nome == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed name is null"));
        }
        ShopList sL = new ShopList();
        try(PreparedStatement stm = CON.prepareStatement("SELECT * FROM List where nome=?")){
            stm.setString(1, nome);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    sL.setNome(rs.getString("nome"));
                    sL.setDescrizione(rs.getString("descrizione"));
                    sL.setImmagine(rs.getString("immagine"));
                    sL.setCreator(rs.getString("creator"));
                    sL.setCategoria("categoria");
                    sL.setSharedUsers(getUsersWithWhoTheListIsShared(sL));
                }
            } catch (SQLException ex) {
                Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        } catch (SQLException ex) {
                Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        return sL;
    }

}
