/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Tools;

import database.factories.DAOFactory;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;

/**
 *
 * @author Martin
 */
public class ScheduledTask extends HttpServlet implements Runnable{

    @Override
    public void init() throws ServletException{
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
         if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
    }
    
    @Override
    public void run() {
        System.out.println("Listener: " + new Date());
        
    }
    
    
    
}
