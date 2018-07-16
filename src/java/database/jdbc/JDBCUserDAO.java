/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.jdbc;
import database.daos.UserDAO;
import database.entities.User;
import database.exceptions.DAOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;



/**
 *
 * @author Martin
 */
public class JDBCUserDAO extends JDBCDAO implements UserDAO{

    public JDBCUserDAO(Connection con) {
        super(con);
    }

    @Override
    public User getByEmailAndPassword(String email, String password) throws DAOException {
       if(email==null || password == null){
          throw new DAOException("Email and password are mandatory fields", new NullPointerException("email or password are null"));
       }
       try (PreparedStatement stm = CON.prepareStatement("Select * from USER where Email=? and Password=?")) {
            stm.setString(1, email);
            stm.setString(2, password);
            try (ResultSet rs = stm.executeQuery()) {
               

                int count = 0;
                while (rs.next()) {
                    count++;
                    if (count > 1) {
                        throw new DAOException("Unique constraint violated! There are more than one user with the same email! WHY???");
                    }
                    User user = new User();
                    user.setEmail(rs.getString("Email"));
                    user.setPassword(rs.getString("Password"));
                    user.setNominativo(rs.getString("Nominativo"));
                    user.setTipo(rs.getString("Tipo"));
                    user.setImage(rs.getString("Image"));

            

                    return user;
                }
                return null;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }
    }

    @Override
    public User update(User user) throws DAOException {
       if (user == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed user is null"));
        }
       try (PreparedStatement std = CON.prepareStatement("insert into USER(Email,Password,Nominativo,Tipo,Image) values(?,?,?,?,?)")) {
            std.setString(1, user.getEmail());
            std.setString(2, user.getPassword());
            std.setString(3, user.getNominativo());
            std.setString(4, user.getTipo());
            std.setString(5, user.getImage());
            if (std.executeUpdate() == 1) {
                return user;
            } else {
                throw new DAOException("Impossible to update the user");
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to update the user", ex);
        }
    }
    
}
