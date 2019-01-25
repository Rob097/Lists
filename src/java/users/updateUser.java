/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package users;

import Tools.ImageDispatcher;
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
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

/**
 *
 * @author Martin
 */
@MultipartConfig(maxFileSize = 16177215)
public class updateUser extends HttpServlet {

    UserDAO userdao = null;

    @Override
    public void init() throws ServletException {
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
        
        String FOLDER = "/Image/AvatarImg";
        HttpSession session = (HttpSession) request.getSession(false);
        User user = (User) session.getAttribute("user");
        Boolean updateResult = false;
        User cgeUser = new User();
        
        //Creazione variabili 
        String email = user.getEmail();
        String nominativo = request.getParameter("nominativo");
        String password = request.getParameter("password");
        Boolean send;
        if(request.getParameter("send") != null)
            send = true;
        else
            send = false;
        String url = null;
        
        //IMMAGINE  ################################################################################
        Part filePart = request.getPart("file1");
        if((filePart != null) && (filePart.getSize() > 0)){
            //delete current immage
            String imageFolder = getServletContext().getRealPath(user.getImage()); //cerca il link assoluto dell immagine
            if(imageFolder != null){
                imageFolder = imageFolder.replace("\\build", ""); //rimuove build dal link assoluto
                File currentFile = new File(imageFolder); //carica il file nel ogetto 
                if(currentFile.exists()){       //controlla se esiste il file
                    try{
                        ImageDispatcher.DeleteImgFromDirectory(imageFolder);
                        cgeUser.setImage(null);
                    }catch(Exception e){
                        System.out.println("Cancella immagine errata");
                        System.out.println(e);
                    }
                }
            }
            //save new immage
            String extension = Paths.get(filePart.getSubmittedFileName()).getFileName().toString().split(Pattern.quote("."))[1];
            String foldername = getServletContext().getRealPath(FOLDER);
            foldername = foldername.replace("\\build", "");
            String filename;
            if(email.equals("") || email == null){
                filename = ImageDispatcher.SetImgName(user.getEmail(), extension);
            }else{
                filename = ImageDispatcher.SetImgName(email, extension);
            }
            File file1 = new File(foldername,filename);
            try (InputStream fileContent = filePart.getInputStream()) {
                Files.copy(fileContent, file1.toPath());
                cgeUser.setImage("Image/AvatarImg/" + filename);
            }catch(Exception e){
                System.out.println(e);
            }
        }
        //IMMAGINE  ################################################################################

        //Aggiornamento dei campi nominativo, email, e password
        cgeUser.setEmail(email);
        cgeUser.setNominativo(nominativo);
        cgeUser.setPassword(password);
        cgeUser.setSendEmail(send);
        
        try {
           User finaluser = userdao.changeUser(cgeUser, user);
           if (finaluser != null) {
                updateResult = true;
                session.setAttribute("user", finaluser);
                session.setAttribute("updateResult", updateResult);
            }
        } catch (DAOException ex) {
            Logger.getLogger(updateUser.class.getName()).log(Level.SEVERE, null, ex);
        }

        //Redirect
        if (session.getAttribute("user") != null) {
            url = "/Lists/profile.jsp";
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
