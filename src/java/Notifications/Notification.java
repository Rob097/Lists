/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Notifications;

/**
 *
 * @author della
 */
public class Notification {
    String type;
    String listName;
    String user;

    public Notification() {
    }

    public Notification(String type, String listName, String user) {
        this.type = type;
        this.listName = listName;
        this.user = user;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getListName() {
        return listName;
    }

    public void setListName(String listName) {
        this.listName = listName;
    }

    public String getUser() {
        return user;
    }

    public void setUser(String user) {
        this.user = user;
    }
    
    
}
