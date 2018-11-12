/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.daos;

import Notifications.Notification;
import database.entities.User;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import java.util.ArrayList;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author della
 */
public interface NotificationDAO {
    public void addNotification(String userName, String type, String listName) throws DAOException;
    public ArrayList<User> getUsersWithWhoTheListIsShared(String l) throws DAOException;
    public ArrayList<Notification> thereIsNewNotifications(String listName, String type, String userName) throws DAOException;
    public ArrayList<Notification> getAllNotifications(String userName) throws DAOException;
    public void deleteNotification(String email, String listname) throws DAOException;
    public void deleteNotificationFromArray(String tipo, String email, DAOFactory daoFactory, HttpServletRequest request) throws DAOException;
}
