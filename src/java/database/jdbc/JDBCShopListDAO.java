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
public class JDBCShopListDAO extends JDBCDAO implements ListDAO{

    //costruttore per avere disponibile la connessione
    public JDBCShopListDAO(Connection con) {
        super(con);
    }

    @Override
    public ArrayList<ShopList> getByEmail(String email) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM List WHERE nome IN (SELECT list FROM User_List WHERE user = ?)")) {
            ArrayList<ShopList> shoppingLists = new ArrayList<>();
            
                        
            stm.setString(1, email);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    ShopList sL = new ShopList();
                    sL.setNome(rs.getString("nome"));
                    sL.setDescrizione(rs.getString("descrizione"));
                    
                    sL.setCategoria("categoria");

                    shoppingLists.add(sL);
                }

                return shoppingLists;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }
    }
    
}
