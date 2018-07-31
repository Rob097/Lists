/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package users;

import database.daos.UserDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import database.entities.User;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCUserDAO;
import java.io.File;
import java.io.InputStream;
import static java.lang.System.out;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Pattern;
import javax.servlet.http.Part;

/**
 *
 * @author Martin
 */
public class updateUser extends HttpServlet {

    UserDAO userdao = null;
    
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
        
       User user = new User();
       User cgeUser = new User();
       user =(User) request.getSession().getAttribute("user");
        
      String avatarsFolder = "/Image/AvatarImg";
      String email = null;
      String nominativo = null;
      String password = null;
      String image = null;
      String url = null;
      
      email = request.getParameter("email");
      nominativo = request.getParameter("nominativo");
      password = request.getParameter("password");
        System.out.println(email + " " + nominativo + " "+ password);
      
      cgeUser.setEmail(email);
      cgeUser.setNominativo(nominativo);
      cgeUser.setPassword(password);
      
         System.out.println(cgeUser.getNominativo() + " " + cgeUser.getEmail() + " "+ cgeUser.getPassword());   
         
         Part filePart1 = null; 
         //filePart1 = request.getPart("file1");
         if(filePart1 != null){
            String filename1 = "/" + user.getImage();
            avatarsFolder = getServletContext().getRealPath(filename1);
            avatarsFolder = avatarsFolder.replace("\\build", "");
            File file = new File(avatarsFolder);
            if (file.delete()) {
                    System.out.println(file.getName() + " is deleted!");
                } 
      

            File uploadDirFile = new File(avatarsFolder);
            String rp = "/Image/AvatarImg";
            filename1 = "";
            if ((filePart1 != null) && (filePart1.getSize() > 0)) {
                String extension = Paths.get(filePart1.getSubmittedFileName()).getFileName().toString().split(Pattern.quote("."))[1];;
                filename1 = user.getEmail() + "." + extension;
                File file1 = new File(uploadDirFile, filename1);
                try (InputStream fileContent = filePart1.getInputStream()) {
                 Files.copy(fileContent, file1.toPath());
                }
            }
        
            String photo = rp + "/" + filename1;
            photo = photo.replaceFirst("/", "");
            cgeUser.setImage(photo);
         }else{cgeUser.setImage(null);}
        
       
        try {
           user =  userdao.changeUser(cgeUser, user);
        } catch (DAOException ex) {
            Logger.getLogger(updateUser.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        if(user != null){
            request.getSession().setAttribute("user", user);
        }
        
        if ("standard".equals(user.getTipo())) {
            url = "Pages/standard/standardType.jsp";
        } else if ("amministratore".equals(user.getTipo())) {
            url = "Pages/amministratore/amministratore.jsp";
        } else {
            url = "homepage.jsp";
            out.println("Errore di tipo utente");
        }

        response.sendRedirect(url);

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
