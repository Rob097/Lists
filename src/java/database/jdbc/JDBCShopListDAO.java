/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.jdbc;

import database.daos.ListDAO;
import database.daos.UserDAO;
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
                    sL.setCreator(rs.getString("creator"));
                    sL.setCategoria("categoria");

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
    public ShopList Insert(ShopList l) throws DAOException {

        if (l == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed user is null"));
        }
        
        String qry = "insert into List(nome,descrizione,immagine,creator,categoria) "
                + "values(?,?,?,"
                + "(select email from User where email = ?),"
                + "(select nome from Category where nome = ?))";

        
        try (PreparedStatement statement = CON.prepareStatement(qry)) {
            statement.setString(1, l.getNome());
            statement.setString(2, l.getDescrizione());
            statement.setString(3, "default");
            statement.setString(4, "tdimatuccillo@gmail.com");
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

}
