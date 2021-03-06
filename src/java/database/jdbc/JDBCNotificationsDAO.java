/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.jdbc;

import Notifications.Notification;
import database.daos.NotificationDAO;
import database.entities.User;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
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
        try(PreparedStatement stm = CON.prepareStatement("select * from Notifications where User=? AND Type=? AND ListName=?")){
            
            stm.setString(1, userName);
            stm.setString(2, type);
            stm.setString(3, listName);
            try(ResultSet rs = stm.executeQuery()){
                while (rs.next()) {
                    return;
                }
                rs.close();
            }
            stm.close();
        } catch (SQLException ex) {
            Logger.getLogger(JDBCNotificationsDAO.class.getName()).log(Level.SEVERE, null, ex);
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
        ArrayList<User> userList = new ArrayList<>();
        try (PreparedStatement stm = CON.prepareStatement("select * from User where email in (select user from User_List where list = ?)")) {
            try (PreparedStatement stm2 = CON.prepareStatement("select * from User where email in (select creator from List where nome = ?)")) {
                stm.setString(1, listname);
                stm2.setString(1, listname);
                try (ResultSet rs = stm.executeQuery()) {
                    try (ResultSet rs2 = stm2.executeQuery()) {
                        while (rs.next()) {
                            User u = new User();
                            u.setEmail(rs.getString("email"));
                            u.setNominativo(rs.getString("nominativo"));
                            u.setImage(rs.getString("immagine"));
                            userList.add(u);
                        }
                        while (rs2.next()) {
                            User u = new User();
                            u.setEmail(rs2.getString("email"));
                            u.setNominativo(rs2.getString("nominativo"));
                            u.setImage(rs2.getString("immagine"));
                            userList.add(u);
                        }
                        rs2.close();
                    } catch (SQLException ex) {
                        throw new DAOException("Impossible to get the list of users #1", ex);
                    }
                    rs.close();
                } catch (SQLException ex) {
                    throw new DAOException("Impossible to get the list of users #1", ex);
                }
                stm2.close();
            } catch (SQLException ex) {
                throw new DAOException("Impossible to get the list of users #2", ex);
            }
            stm.close();
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
        ArrayList<Notification> notifiche = null;
        HttpSession s = (HttpSession) request.getSession(false);
        NotificationDAO notificationdao = null ;
        if (daoFactory == null) {
            System.out.println("Impossible to get dao factory for user storage system");
        }else{
            notificationdao = new JDBCNotificationsDAO(daoFactory.getConnection());
        }
        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM Notifications WHERE Type = ? AND User = ?")) {
            stm.setString(1, tipo);
            stm.setString(2, email);
            System.out.println("FUNZIONE: array: " + tipo + " user: " + email);
            stm.executeUpdate();
            if(notificationdao != null)
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

    @Override
    public boolean checkReminderMail(String email, String lista) throws DAOException {
        try(PreparedStatement stm = CON.prepareStatement("select * from reminderMail where email=? AND lista=?")){            
            stm.setString(1, email);
            stm.setString(2, lista);
            try(ResultSet rs = stm.executeQuery()){
                while (rs.next()) {
                    return false;
                }
                rs.close();
            }
            stm.close();
        } catch (SQLException ex) {
            Logger.getLogger(JDBCNotificationsDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        String qry = "insert into reminderMail(email,lista,data) "
                + "values(?,?,?)";
        Date date = new Date();
        java.sql.Date sqlExpireDate = new java.sql.Date(date.getTime());
        try (PreparedStatement stm = CON.prepareStatement(qry)) {
            stm.setString(1, email);
            stm.setString(2, lista);
            stm.setDate(3, sqlExpireDate);
            
            if (stm.executeUpdate() == 1) {
                System.out.println("new email ok"); 
                return true;
            } else {
                throw new DAOException("Impossible to insert the email");
            }
        } catch (SQLException ex) {
            throw new DAOException(ex);

        }
    }
    
    @Override
    public boolean checkProximityMail(String email, String lista) throws DAOException {
        try(PreparedStatement stm = CON.prepareStatement("select * from proximityMail where email=? AND lista=?")){            
            stm.setString(1, email);
            stm.setString(2, lista);
            try(ResultSet rs = stm.executeQuery()){
                while (rs.next()) {
                    return false;
                }
                rs.close();
            }
            stm.close();
        } catch (SQLException ex) {
            Logger.getLogger(JDBCNotificationsDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        String qry = "insert into proximityMail(email,lista,data) "
                + "values(?,?,?)";
        Timestamp timestamp = new Timestamp(System.currentTimeMillis());
        try (PreparedStatement stm = CON.prepareStatement(qry)) {
            stm.setString(1, email);
            stm.setString(2, lista);
            stm.setTimestamp(3, timestamp);
            
            if (stm.executeUpdate() == 1) {
                System.out.println("new email ok"); 
                return true;
            } else {
                throw new DAOException("Impossible to insert the email in proximityMail");
            }
        } catch (SQLException ex) {
            throw new DAOException(ex);

        }
    }

    @Override
    public boolean checkNotification(String email, String type, String lista) throws DAOException {
        if (email == null || type == null || lista == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("parameters are null"));
        }
        try(PreparedStatement stm = CON.prepareStatement("select * from Notifications where User=? AND Type=? AND ListName=?")){            
            stm.setString(1, email);
            stm.setString(2, type);
            stm.setString(3, lista);
            try(ResultSet rs = stm.executeQuery()){
                while (rs.next()) {
                    return true;
                }
                rs.close();
            }
            stm.close();
        } catch (SQLException ex) {
            Logger.getLogger(JDBCNotificationsDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
    
}
