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
import java.util.ArrayList;
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
                    user.setSendEmail(rs.getBoolean("send"));
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
       try (PreparedStatement statement = CON.prepareStatement("insert into User(email,password,nominativo,tipo,immagine,send) values(?,?,?,?,?,?)")) {
            statement.setString(1, user.getEmail());
            statement.setString(2, user.getPassword());
            statement.setString(3, user.getNominativo());
            statement.setString(4, user.getTipo());
            statement.setString(5, user.getImage());
            statement.setBoolean(6, user.isSendEmail());
            if (statement.executeUpdate() > 0) {
                return user;
            } else {
                throw new DAOException("Impossible to insert the user");
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
                    user.setSendEmail(rs.getBoolean("send"));
                    return user;
                }
                return null;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the user", ex);
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
            System.out.println("Error delete user");
        }
    }

    @Override
    public User changeUser(User newUser, User oldUser) throws DAOException {
        if (newUser == null || oldUser==null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed old or new user is null"));
        }
        User finalUser = oldUser; 

        if(newUser.getPassword() != null && !"".equals(newUser.getPassword()) && (newUser.getPassword() == null ? oldUser.getPassword() != null : !newUser.getPassword().equals(oldUser.getPassword()))){
            try (PreparedStatement statement = CON.prepareStatement("UPDATE User SET password=? WHERE email=? ")){
            statement.setString(1, newUser.getPassword());
            statement.setString(2, oldUser.getEmail());
            statement.executeUpdate(); 
            finalUser.setPassword(newUser.getPassword());
            } catch (SQLException ex) {
             Logger.getLogger(JDBCUserDAO.class.getName()).log(Level.SEVERE, null, ex);
             System.out.println("errore update password");
            }   
        }
        
        if(newUser.getNominativo() != null && !"".equals(newUser.getNominativo()) && (newUser.getNominativo() == null ? oldUser.getNominativo() != null : !newUser.getNominativo().equals(oldUser.getNominativo()))){
            try (PreparedStatement statement = CON.prepareStatement("UPDATE User SET nominativo=? WHERE email=? ")){
            statement.setString(1, newUser.getNominativo());
            statement.setString(2, oldUser.getEmail());
            statement.executeUpdate(); 
            finalUser.setNominativo(newUser.getNominativo());
            } catch (SQLException ex) {
             Logger.getLogger(JDBCUserDAO.class.getName()).log(Level.SEVERE, null, ex);
             System.out.println("errore update nominativo");
            }   
        }
        
        if(newUser.getImage() != null && !"".equals(newUser.getImage()) && (newUser.getImage() == null ? oldUser.getImage() != null : !newUser.getImage().equals(oldUser.getImage()))){
            try (PreparedStatement statement = CON.prepareStatement("UPDATE User SET immagine=? WHERE email=? ")){
            statement.setString(1, newUser.getImage());
            statement.setString(2, oldUser.getEmail());
            statement.executeUpdate();
            finalUser.setImage(newUser.getImage());
            } catch (SQLException ex) {
             Logger.getLogger(JDBCUserDAO.class.getName()).log(Level.SEVERE, null, ex);
             System.out.println("errore update image");
            }   
        }
        
        if(newUser.getTipo() != null && !"".equals(newUser.getTipo()) && (newUser.getTipo() == null ? oldUser.getTipo() != null : !newUser.getTipo().equals(oldUser.getTipo()))){
            try (PreparedStatement statement = CON.prepareStatement("UPDATE User SET tipo=? WHERE email=? ")){
            statement.setString(1, newUser.getTipo());
            statement.setString(2, oldUser.getEmail());
            statement.executeUpdate();
            finalUser.setTipo(newUser.getTipo());
            } catch (SQLException ex) {
             Logger.getLogger(JDBCUserDAO.class.getName()).log(Level.SEVERE, null, ex);
             System.out.println("errore update usertype");
            }   
        }
        
        if(newUser.isSendEmail() != oldUser.isSendEmail()){
            try (PreparedStatement statement = CON.prepareStatement("UPDATE User SET send=? WHERE email=? ")){
            statement.setBoolean(1, newUser.isSendEmail());
            statement.setString(2, oldUser.getEmail());
            statement.executeUpdate();
            finalUser.setSendEmail(newUser.isSendEmail());
            } catch (SQLException ex) {
             Logger.getLogger(JDBCUserDAO.class.getName()).log(Level.SEVERE, null, ex);
             System.out.println("errore update usersend");
            }   
        }
                
        return finalUser;
    }
    
    
    @Override
    public ArrayList<User> getAllUsers() throws DAOException {
       
       ArrayList<User> listOfAllUsers = new ArrayList<>();
        
       try(PreparedStatement statement = CON.prepareStatement("select * from User")){
           
            try (ResultSet rs = statement.executeQuery()) {

                while (rs.next()) {
                    
                    User user = new User();                   
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setNominativo(rs.getString("nominativo"));
                    user.setTipo(rs.getString("tipo"));
                    user.setImage(rs.getString("immagine"));
                    user.setSendEmail(rs.getBoolean("send"));
                    listOfAllUsers.add(user);                    
                }
                
                return listOfAllUsers;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }
    }

    @Override
    public void changeRole(String user, String role, String list) throws DAOException {
        if(user==null || role == null || list == null){
          throw new DAOException("Parameters are mandatory fields", new NullPointerException("user, role or list is null"));
        }

        try (PreparedStatement statement = CON.prepareStatement("UPDATE User_List SET role=? WHERE user=? AND list =?")) {
            statement.setString(1, role);
            statement.setString(2, user);
            statement.setString(3, list);
            System.out.println("User: " + user + "; Role: " + role + "; List: " + list);
            
            if (statement.executeUpdate() == 1) {
            } else {
                throw new DAOException("Impossible to change the role");
            }            
        } catch (SQLException ex) {
            Logger.getLogger(JDBCUserDAO.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println("errore update role");
        }
    }

    @Override
    public void changePassword(String email, String password) throws DAOException {
        if(email==null || password == null){
          throw new DAOException("Parameters are mandatory fields", new NullPointerException("email or password is null"));
        }
        
        try (PreparedStatement statement = CON.prepareStatement("update User set password = ? where email = ? ")) {
            statement.setString(1, password);
            statement.setString(2, email);
            
            if(statement.executeUpdate()==1){
            }else{
                throw new DAOException("Impossible to change password");
            }
        } catch (SQLException ex) {
            Logger.getLogger(JDBCUserDAO.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println("errore chande password");
        }
    }
    
    @Override
        public void changeType(String email, String tipo) throws DAOException {
        if(email==null || tipo == null){
          throw new DAOException("Parameters are mandatory fields", new NullPointerException("email or type is null"));
        }
        
        try (PreparedStatement statement = CON.prepareStatement("update User set tipo = ? where email = ? ")) {
            statement.setString(1, tipo);
            statement.setString(2, email);
            if(statement.executeUpdate()==1){
            }else{
                throw new DAOException("Impossible to change tipo");
            }
        } catch (SQLException ex) {
            Logger.getLogger(JDBCUserDAO.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println("errore chande password");
        }
    }

    @Override
    public boolean checkIsSending(String email) throws DAOException {
        if(email==null){
           throw new DAOException("Email is a mandatory fields", new NullPointerException("email is null"));
        }
        email = email.replaceAll ("\r\n|\r|\n", "");
        boolean check = true;
        try(PreparedStatement statement = CON.prepareStatement("Select send from User where email=?")){
           statement.setString(1, email);
            try (ResultSet rs = statement.executeQuery()) {
                while (rs.next()) {
                    check = rs.getBoolean("send");
                }
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the user", ex);
        }
        return check;
    }
}
