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
import java.util.logging.Level;
import java.util.logging.Logger;




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
       try (PreparedStatement stm = CON.prepareStatement("Select * from User where email=? and password=?")) {
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
                   
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setNominativo(rs.getString("nominativo"));
                    user.setTipo(rs.getString("tipo"));
                    user.setImage(rs.getString("immagine"));

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
       try (PreparedStatement statement = CON.prepareStatement("insert into User(email,password,nominativo,tipo,immagine) values(?,?,?,?,?)")) {
            statement.setString(1, user.getEmail());
            statement.setString(2, user.getPassword());
            statement.setString(3, user.getNominativo());
            statement.setString(4, user.getTipo());
            statement.setString(5, user.getImage());
            
            if (statement.executeUpdate() == 1) {
                return user;
            } else {
                throw new DAOException("Impossible to update the User");
            }
        } catch (SQLException ex) {
            throw new DAOException(ex);
            
        }
    }

    @Override
    public User getByEmail(String email) throws DAOException {
       if(email==null){
           throw new DAOException("Email is a mandatory fields", new NullPointerException("email is null"));
       }
       
       try(PreparedStatement statement = CON.prepareStatement("Select * from User where email=?")){
           statement.setString(1, email);
            try (ResultSet rs = statement.executeQuery()) {

                int count = 0;
                
                while (rs.next()) {
                    count++;
                    if (count > 1) {
                        throw new DAOException("Unique constraint violated! There are more than one user with the same email! WHY???");
                    }
                    User user = new User();
                   
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setNominativo(rs.getString("nominativo"));
                    user.setTipo(rs.getString("tipo"));
                    user.setImage(rs.getString("immagine"));

                    return user;
                }
                return null;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }
    }

    @Override
    public void deleteUser(User user) throws DAOException {
       if (user == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed user is null"));
        }
       
       try (PreparedStatement statement = CON.prepareStatement("DELETE FROM User WHERE email= ?")){
        statement.setString(1, user.getEmail());
        statement.executeUpdate(); 
       
        }catch (SQLException ex) {
            Logger.getLogger(JDBCUserDAO.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println("Errore eliminazione utente");
        }
    }
    

    
}
