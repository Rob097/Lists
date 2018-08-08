/*
 * AA 2017-2018
 * Introduction to Web Programming
 * Lab 09 - ShoppingList List
 * UniTN
 */


import database.daos.ListDAO;
import database.entities.User;
import database.exceptions.DAOException;
import database.jdbc.JDBCDAO;
import database.entities.ShopList;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;


/**
 * The JDBC implementation of the {@link ShoppingListDAO} interface.
 *
 * @author Stefano Chirico &lt;stefano dot chirico at unitn dot it&gt;
 * @since 2018.04.21
 */
public class JDBCListDAO extends JDBCDAO implements ListDAO {
    
    /**
     * The default constructor of the class.
     *
     * @param con the connection to the persistence system.
     *
     * @author Stefano Chirico
     * @since 1.0.180421
     */
    public JDBCListDAO(Connection con) {
        super(con);
    }

    /**
     * Returns the {@link ShoppingList shopping_lists} with the primary key
     * equals to the one passed as parameter.
     *
     * @param primaryKey the {@code id} of the {@code shopping_list} to get.
     * @return the {@code shopping_list} with the id equals to the one passed as
     * parameter or {@code null} if no entities with that id are present into
     * the storage system.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     *
     * @author Stefano Chirico
     * @since 1.0.180421
     */
    @Override
    public ShopList getByName(String name) throws DAOException {
        if (name == null) {
            throw new DAOException("primaryKey is null");
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM shopping_lists WHERE nome= ?")) {
            stm.setString(1, name);
            try (ResultSet rs = stm.executeQuery()) {

                rs.next();
                ShopList shoppingList = new ShopList();
                shoppingList.setNome(rs.getString("name"));
                shoppingList.setDescrizione(rs.getString("descrizione"));
                shoppingList.setCategoria("Categoria");

                return shoppingList;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the shopping_list for the passed primary key", ex);
        }
    }

    /**
     * Returns the list of all the valid {@link ShoppingList shopping_lists}
     * stored by the storage system.
     *
     * @return the list of all the valid {@code shopping_lists}.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     *
     * @author Stefano Chirico
     * @since 1.0.180421
     */
    /*@Override
    public List<ShoppingList> getAll() throws DAOException {
        List<ShoppingList> shoppingLists = new ArrayList<>();

        try (Statement stm = CON.createStatement()) {
            try (ResultSet rs = stm.executeQuery("SELECT * FROM shopping_lists ORDER BY name")) {

                while (rs.next()) {
                    ShoppingList shoppingList = new ShoppingList();
                    shoppingList.setId(rs.getInt("id"));
                    shoppingList.setName(rs.getString("name"));
                    shoppingList.setDescription(rs.getString("description"));

                    shoppingLists.add(shoppingList);
                }
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of shopping_lists", ex);
        }

        return shoppingLists;
    }*/

    /**
     * Persists the new {@link ShoppingList shopping-list} passed as parameter
     * to the storage system.
     * @param shoppingList the new {@code shopping-list} to persist.
     * @return the id of the new persisted record.
     * @throws DAOException if an error occurred during the persist action.
     * 
     * @author Stefano Chirico
     * @since 1.0.180421
     */
    @Override
    public Integer insert(ShopList shoppingList) throws DAOException {
        if (shoppingList == null) {
            //TODO: Thinking to return an error instead of null.
            return null;
        }
        try (PreparedStatement ps = CON.prepareStatement("INSERT INTO shopping_lists (name, description) VALUES (?,?)", Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, shoppingList.getNome());
            ps.setString(2, shoppingList.getDescrizione());

            
            
            return 1;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to insert the new shopping_list", ex);
        }
    }
    
    /**
     * Persists the already existing {@link ShoppingList shopping-list} passed
     * as parameter to the storage system.
     * @param shoppingList the {@code shopping-list} to persist.
     * @return the old record.
     * @throws DAOException if an error occurred during the persist action.
     * 
     * @author Stefano Chirico
     * @since 1.0.180421
     */
    
    /*@Override
    public ShoppingList update(ShoppingList shoppingList) throws DAOException {
        if (shoppingList == null) {
            //TODO: Thinking to return an error instead of null.
            return null;
        }
        
        Integer shoppingListId = shoppingList.getId();
        if (shoppingListId == null) {
            //TODO: Thinking to insert it as a new record.
            throw new DAOException("ShppiingList is not valid", new NullPointerException("ShoppingList id is null"));
        }
        
        ShoppingList oldShoppingList = null;
        try (PreparedStatement ps = CON.prepareStatement("SELECT * FROM shopping_lists WHERE id = ?")) {
            ps.setInt(1, shoppingListId);
            ResultSet oldResultSet = ps.executeQuery();
            
            if (oldResultSet.next()) {
                oldShoppingList = new ShoppingList();
                oldShoppingList.setId(shoppingListId);
                oldShoppingList.setName(oldResultSet.getString("name"));
                oldShoppingList.setDescription(oldResultSet.getString("description"));
            }
            
        } catch (SQLException ex) {
            //TODO: log the exception
        }
        
        try (PreparedStatement ps = CON.prepareStatement("UPDATE shopping_lists SET name = ?, description = ? WHERE id = ?")) {
            
            ps.setString(1, shoppingList.getName());
            ps.setString(2, shoppingList.getDescription());
            ps.setInt(3, shoppingListId);
            
            int count = ps.executeUpdate();
            if (count != 1) {
                throw new DAOException("Update affected an invalid number of records: " + count);
            }
            
            return oldShoppingList;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to update the shopping_list", ex);
        }
    }*/
    
    /**
     * Links the passed {@code shopping_list} with the passed {@code user}.
     * @param shoppingList the shopping_list to link.
     * @param user the user to link.
     * @return {@code true} if the link has correctly persisted on the storage
     * system.
     * @throws DAOException if an error occurred during the persist action.
     * 
     * @author Stefano Chirico
     * @since 1.0.180421
     */
    /*@Override
    public boolean linkShoppingListToUser(ShoppingList shoppingList, User user) throws DAOException {
        if ((shoppingList == null) || (user == null)) {
            throw new DAOException("Shopping_list and user are mandatory fields", new NullPointerException("shopping_list or user are null"));
        }
        
        try (PreparedStatement ps = CON.prepareStatement("INSERT INTO users_shopping_lists (id_user, id_shopping_list) VALUES (?, ?)")) {

            ps.setInt(1, user.getId());
            ps.setInt(2, shoppingList.getId());

            return ps.executeUpdate() == 1;
        } catch (SQLException ex) {
            if (ex.getSQLState().startsWith("23") && ex.getSQLState().length() == 5) {
                //TODO: Duplicated key. The link already exists. Update the record data (modification data and user id)
                return false;
            }
            throw new DAOException("Impossible to link the passed shopping_list with the passed user", ex);
        }
    }*/

    /**
     * Returns the list of {@link ShoppingList shopping-lists} with the
     * {@code id_user} is the one passed as parameter.
     *
     * @param userId the {@code id} of the {@code user} for which retrieve the
     * shopping-lists list.
     * @return the list of {@code shopping-list} with the user id equals to the
     * one passed as parameter or an empty list if user id is not linked to any
     * to-dos.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     *
     * @author Stefano Chirico
     * @since 1.0.180421
     */
    /*@Override
    public List<ShoppingList> getByUserId(Integer userId) throws DAOException {
        if (userId == null) {
            throw new DAOException("userId is mandatory field", new NullPointerException("userId is null"));
        }
        
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM shopping_lists WHERE id IN (SELECT id_shopping_list FROM users_shopping_lists WHERE id_user = ?) ORDER BY name")) {
            List<ShoppingList> shoppingLists = new ArrayList<>();
            stm.setInt(1, userId);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    ShoppingList shoppingList = new ShoppingList();
                    shoppingList.setId(rs.getInt("id"));
                    shoppingList.setName(rs.getString("name"));
                    shoppingList.setDescription(rs.getString("description"));

                    shoppingLists.add(shoppingList);
                }

                return shoppingLists;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }
    }*/

   /* @Override
    public User update(database.entities.List list) throws DAOException {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public database.entities.List getByUser(String email) throws DAOException {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public void deleteList(database.entities.List list) throws DAOException {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public User changeList(database.entities.List newList, database.entities.List oldList) throws DAOException {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }*/

}
