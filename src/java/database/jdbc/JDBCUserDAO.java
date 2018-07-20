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

    //costruttore per avere disponibile la connessione
    public JDBCUserDAO(Connection con) {
        super(con);
    }
    
    //implementa metodo di Userdao, ritorna le informazioni dell`utente con i dati login
    @Override
    public User getByEmailAndPassword(String email, String password) throws DAOException {
       if(email==null || password == null){
          throw new DAOException("Email and password are mandatory fields", new NullPointerException("email or password are null"));
       }
       try (PreparedStatement stm = CON.prepareStatement("Select * from Utente where email=? and password=?")) {
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
                    //user.setImage(rs.getString("Image"));

            

                    return user;
                }
                return null;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }
    }
    
    //implementa il metodo update di Userdao che aggiunge un nuovo utente nel database
    @Override
    public User update(User user) throws DAOException {
       if (user == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed user is null"));
        }
       try (PreparedStatement std = CON.prepareStatement("INSERT INTO User(email,password,nominativo,tipo) VALUES(?,?,?,?)")) {
            std.setString(1, user.getEmail());
            std.setString(2, user.getPassword());
            std.setString(3, user.getNominativo());
            std.setString(4, user.getTipo());
            //std.setBlob(5, inputStream);
            if (std.executeUpdate() == 1) {
                return user;
            } else {
                throw new DAOException("Impossible to update the User");
            }
        } catch (SQLException ex) {
            throw new DAOException(ex);
            
        }
    }
    
}
