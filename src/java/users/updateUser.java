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
        
        HttpSession s = request.getSession();
        User user = new User();
        Boolean updateResult = false;
        User cgeUser = new User();
        user = (User) s.getAttribute("user");
        
        //Creazione variabili per l'immagine
        String email = request.getParameter("email");
        String nominativo = request.getParameter("nominativo");
        String password = request.getParameter("password");
        String url = null;
        String nomeIMG = user.getImage();
        String immagine = "";
       
        // IMMAGINE
            String imageFolder = "/Image/AvatarImg";
            String rp = "/Image/AvatarImg";
            imageFolder = getServletContext().getRealPath("");
            imageFolder = imageFolder.replace("\\build", "");
            File uploadDirFile = new File(imageFolder);
            
            //Controllo se l'immagine esiste già e in uesto caso la cancello col etodo DeleteImgFromDirectory
            if (uploadDirFile.exists()) {
                try {
                    DeleteImgFromDirectory(imageFolder + "/" + nomeIMG);
                } catch (Exception ex1) {
                    System.out.println("Causa Errore: ");
                    ex1.printStackTrace();
                }
            }
        
            
            String filename1 = "";
            Part filePart1 = request.getPart("file1"); //File di upload
            if ((filePart1 != null) && (filePart1.getSize() > 0)) {
                
                //Estensione
                String extension = Paths.get(filePart1.getSubmittedFileName()).getFileName().toString().split(Pattern.quote("."))[1];;
                
                
                filename1 = nomeIMG;
                filename1 = filename1.replaceAll("\\s+","");

                //Tolgo il primo /Image/AvatarImg
                filename1 = filename1.replaceFirst("/Image/AvatarImg", "");
                
                
                File file1 = new File(uploadDirFile, filename1);
                try (InputStream fileContent = filePart1.getInputStream()) {
                    String s1 = file1.toPath().toString().replaceFirst("/Image/AvatarImg", "");
                    File f = new File(s1);
                    
                    Files.copy(fileContent, f.toPath());
                }catch(Exception imgexception) {
                System.out.println("exception image #1");
                s.setAttribute("erroreIMG", "Esiste già una lista sul duo account con questo nome!");
            }
            }
            immagine = rp + "/" + filename1;
            immagine = immagine.replaceFirst("/", ""); 
            immagine = immagine.replaceAll("\\s+","");
            cgeUser.setImage(immagine);
            //FINE IMMAGINE
            
            //Aggiornamento dei campi nominativo, email, e password
            cgeUser.setEmail(email);
            cgeUser.setNominativo(nominativo);
            cgeUser.setPassword(password);

        try {
            user = userdao.changeUser(cgeUser, user);
        } catch (DAOException ex) {
            Logger.getLogger(updateUser.class.getName()).log(Level.SEVERE, null, ex);
        }

        if (user != null) {
            updateResult = true;
            request.getSession().setAttribute("user", user);
            request.getSession().setAttribute("updateResult", updateResult);
        }

        
        //Redirect
        if (s.getAttribute("user") != null) {
            url = "/Lists/Pages/"+ user.getTipo() +"/profile.jsp";
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

    public void DeleteImgFromDirectory(String fileName) {
        // Creo un oggetto file
        File f = new File(fileName);

        // Mi assicuro che il file esista
        if (!f.exists()) {
            throw new IllegalArgumentException("Il File o la Directory non esiste: " + fileName);
        }

        // Mi assicuro che il file sia scrivibile
        if (!f.canWrite()) {
            throw new IllegalArgumentException("Non ho il permesso di scrittura: " + fileName);
        }

        // Se è una cartella verifico che sia vuota
        if (f.isDirectory()) {
            String[] files = f.list();
            if (files.length > 0) {
                throw new IllegalArgumentException("La Directory non è vuota: " + fileName);
            }
        }

        // Profo a cancellare
        boolean success = f.delete();

        // Se si è verificato un errore...
        if (!success) {
            throw new IllegalArgumentException("Cancellazione fallita");
        }
    }

}
