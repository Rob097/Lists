/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.jdbc;

import Notifications.Notification;
import database.daos.NotificationDAO;
import database.entities.ShopList;
import database.entities.User;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 *
 * @author della
 */
public class JDBCNotificationsDAO extends JDBCDAO implements NotificationDAO{

    public JDBCNotificationsDAO(Connection con) {
        super(con);
    }

    @Override
    public void addNotification(String userName, String type, String listName) throws DAOException {
        
        if (userName == null || type == null || listName == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("parameters are null"));
        }

        String qry = "insert into Notifications(User,Type,ListName) "
                + "values((select email from User where email = ?),?,?)";

        try (PreparedStatement statement = CON.prepareStatement(qry)) {
            statement.setString(1, userName);
            statement.setString(2, type);
            statement.setString(3, listName);

            if (statement.executeUpdate() == 1) {
                System.out.println("new notification ok");
            } else {
                throw new DAOException("Impossible to insert the Notification");
            }
        } catch (SQLException ex) {
            throw new DAOException(ex);

        }
    }
    
    @Override
    public ArrayList<User> getUsersWithWhoTheListIsShared(String listname) throws DAOException {
        try{
            PreparedStatement stm = CON.prepareStatement("select * from User where email in (select user from User_List where list = ?)");
            PreparedStatement stm2 = CON.prepareStatement("select * from User where email in (select creator from List where nome = ?)");
            ArrayList<User> userList = new ArrayList<>();

            stm.setString(1, listname);
            stm2.setString(1, listname);
            try{
                ResultSet rs = stm.executeQuery();
                ResultSet rs2 = stm2.executeQuery();
                while (rs.next()) {
                    User u = new User();
                    u.setEmail(rs.getString("email"));
                    u.setNominativo(rs.getString("nominativo"));
                    u.setImage(rs.getString("immagine"));
                    userList.add(u);
                }
                while(rs2.next()){
                    User u = new User();
                    u.setEmail(rs2.getString("email"));
                    u.setNominativo(rs2.getString("nominativo"));
                    u.setImage(rs2.getString("immagine"));
                    userList.add(u);
                }
                    
            } catch (SQLException ex) {
                throw new DAOException("Impossible to get the list of users #1", ex);
            }
            for(User u : userList){
                System.out.println("\n"+u.getEmail());
            }
            return userList;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users #2", ex);
        }
    }

    @Override
    public ArrayList<Notification> thereIsNewNotifications(String listName, String type, String userName) throws DAOException {
        if (userName == null || listName == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("parameters are null"));
        }

        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Notifications WHERE User = ? AND ListName = ?")) {
            ArrayList<Notification> notifiche = new ArrayList<>();

            stm.setString(1, userName);
            stm.setString(2, listName);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Notification sL = new Notification(type, listName, userName);

                    notifiche.add(sL);
                }

                return notifiche;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the notifications of users", ex);
        }
    }
    
    @Override
    public ArrayList<Notification> getAllNotifications(String userName) throws DAOException {
        if (userName == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("parameters are null"));
        }
        
        
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Notifications WHERE User = ?")) {
            ArrayList<Notification> notifiche = new ArrayList<>();

            stm.setString(1, userName);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Notification sL = new Notification();
                    sL.setUser(rs.getString("User"));
                    sL.setType(rs.getString("Type"));
                    sL.setListName(rs.getString("ListName"));
                    notifiche.add(sL);
                }

                return notifiche;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the notifications of users", ex);
        }
        
        
    }
    
    @Override
    public void deleteNotification(String email, String listname) throws DAOException {
        if (email == null || listname == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed email or listname is null"));
        }
        
        try(PreparedStatement statement = CON.prepareStatement("DELETE FROM Notifications WHERE User=? AND ListName=?")){
            statement.setString(1, email);
            statement.setString(2, listname);
            
            statement.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println("Problems with deleting shared user");
        }
    }

    @Override
    public void deleteNotificationFromArray(String tipo, String email, DAOFactory daoFactory, HttpServletRequest request) throws DAOException {
        ArrayList<Notification> notifiche = new ArrayList<>();
        HttpSession s = (HttpSession) request.getSession(false);
        if (daoFactory == null) {
            System.out.println("Impossible to get dao factory for user storage system");
        }
        NotificationDAO notificationdao = new JDBCNotificationsDAO(daoFactory.getConnection());
        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM Notifications WHERE Type = ? AND User = ?")) {
            stm.setString(1, tipo);
            stm.setString(2, email);
            System.out.println("FUNZIONE: array: " + tipo + " user: " + email);
            stm.executeUpdate();
            notifiche = notificationdao.getAllNotifications(email);
            s.setAttribute("notifiche", notifiche);
        } catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println("Problems with deleting shared user");
        }

    }

    @Override
    public void deleteALLNotification(String email) throws DAOException {
        if (email == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed email or listname is null"));
        }
        
        try(PreparedStatement statement = CON.prepareStatement("DELETE FROM Notifications WHERE User=?")){
            statement.setString(1, email);
            
            statement.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println("Problems with deleting shared user");
        }
    }
    
}
