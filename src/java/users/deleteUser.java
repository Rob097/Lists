/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package users;

import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import database.factories.DAOFactory;
import database.jdbc.JDBCUserDAO;
import database.daos.UserDAO;
import database.entities.User;
import database.exceptions.DAOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Roberto97
 */
public class deleteUser extends HttpServlet {

    UserDAO userdao;
   
    @Override
    public void init() throws ServletException{
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
         if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
         }
         userdao = new JDBCUserDAO(daoFactory.getConnection());
    }
    
     /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = (HttpSession) request.getSession();
        User user =(User) session.getAttribute("user");
        System.out.println("DeleteUser opening####################");
        
        String Image = "";
        Image = user.getImage();
        
        try {
            userdao.deleteUser(user);
        } catch (DAOException ex) {
            Logger.getLogger(deleteUser.class.getName()).log(Level.SEVERE, null, ex);
        }

        //Eliminazione dell'immagine dell'utente
        try {
            String filename1 = "/" + Image;
            System.out.println("==================== dal db:        " + filename1);
            String avatarsFolder = getServletContext().getRealPath(filename1);
            System.out.println("==================== get rela path" + avatarsFolder);
            avatarsFolder = avatarsFolder.replace("\\build", "");
            System.out.println("==================== senza build" + avatarsFolder);
            File file = new File(avatarsFolder);
            
            
            System.out.println("==================== path completo" + avatarsFolder);

            if (file.delete()) {
                System.out.println(file.getName() + " is deleted!");
            } else {
                System.out.println(file.getAbsoluteFile() + "Delete operation is failed.");
            }

        } catch (Exception ex1) {
            System.out.println("Causa Errore: ");
            ex1.printStackTrace();
        }
        
         // Get an array of Cookies associated with the this domain
        //remove Remember Me cookie
        Cookie cookie = new Cookie("User", "");
        cookie.setDomain("localhost");
        cookie.setPath(request.getContextPath());
        cookie.setMaxAge(0);
        response.addCookie(cookie);
        
        if (session != null) {
                session.invalidate();                
        }

        response.setHeader("Refresh", "0; URL=/Lists/homepage.jsp");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
