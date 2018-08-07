/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package log;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.regex.Pattern;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import database.factories.DAOFactory;
import database.entities.User;
import database.daos.UserDAO;
import database.exceptions.DAOException;
import database.jdbc.JDBCUserDAO;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Roberto97
 */
@MultipartConfig(maxFileSize = 16177215)	// upload file's size up to 16MB
public class RegisterAction extends HttpServlet {

    UserDAO userdao = null;

    @Override
    public void init() throws ServletException {
        //carica la Connessione inizializzata in JDBCDAOFactory, quindi ritorna il Class.for() e la connessione
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        //assegna a userdao la connessione(costruttore) e salva la connessione in una variabile tipo Connection
        userdao = new JDBCUserDAO(daoFactory.getConnection());

    }

    protected void doPost(HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {

        User user = new User();
        Boolean regResult = false;
        // gets values of text fields
        String avatarsFolder = "/Image/AvatarImg";
        String rp = "/Image/AvatarImg";
        String Tipostandard, TipoAmministratore, photo, standard = "standard", amministratore = "amministratore";
        avatarsFolder = getServletContext().getRealPath(avatarsFolder);
        avatarsFolder = avatarsFolder.replace("\\build", "");
        
        user.setEmail(request.getParameter("email")); 
        System.out.println(user.getEmail());
        user.setNominativo(request.getParameter("nominativo")); 
        user.setPassword(request.getParameter("password")); 
        Tipostandard = request.getParameter("standard"); //txt_standard
        TipoAmministratore = request.getParameter("amministratore"); //txt_amministratore

        // obtains the upload file part in this multipart request
        File uploadDirFile = new File(avatarsFolder);
        String filename1 = "";
        Part filePart1 = request.getPart("file1");
        if ((filePart1 != null) && (filePart1.getSize() > 0)) {
            
            String extension = Paths.get(filePart1.getSubmittedFileName()).getFileName().toString().split(Pattern.quote("."))[1];;
            String email = user.getEmail();
            
            filename1 = SetImgName(email, extension);
            File file1 = new File(uploadDirFile, filename1);
            try (InputStream fileContent = filePart1.getInputStream()) {
                Files.copy(fileContent, file1.toPath());
            }
        }
        photo = rp + "/" + filename1;
        photo = photo.replaceFirst("/", "");
        user.setImage(photo);

        if (Tipostandard != null) {
            Tipostandard = "standard";
            user.setTipo(standard);
        } else if (TipoAmministratore != null) {
            TipoAmministratore = "amministratore";
            user.setTipo(amministratore);
        }

        try {
            //manda i dati del user, il metodo upate fa la parte statement 
            user = userdao.update(user);

        } catch (DAOException ex) {
            Logger.getLogger(RegisterAction.class.getName()).log(Level.SEVERE, null, ex);
        }
        if(user != null){
            regResult = true;
            request.getSession().setAttribute("regResult", regResult);
        }

        response.sendRedirect("homepage.jsp");
        // sets the message in request scope

        // forwards to the message page
        //getServletContext().getRequestDispatcher("/Message.jsp").forward(request, response);
    }
    
    public String uploadImg(String avatarsFolder, Part filePart1, String email) throws IOException{
        String rp = avatarsFolder;
        avatarsFolder = getServletContext().getRealPath(avatarsFolder);
        avatarsFolder = avatarsFolder.replace("\\build", "");

        File uploadDirFile = new File(avatarsFolder);
        String filename1 = "";

        if ((filePart1 != null) && (filePart1.getSize() > 0)) {
            String extension = Paths.get(filePart1.getSubmittedFileName()).getFileName().toString().split(Pattern.quote("."))[1];;
            filename1 = email + "." + extension;
            File file1 = new File(avatarsFolder, filename1);

            try (InputStream fileContent = filePart1.getInputStream()) {
                Files.copy(fileContent, file1.toPath());
            }
        }      
        return (rp + "/" + filename1).replaceFirst("/", "");
    }
    
    public String SetImgName(String name, String extension){
        
        String s;
        s = name;
        s = s.trim();
        s = s.replace("@", "");
        s = s.replace(".", "");
       
        return s + "." + extension;
    }
    
    public String GetImgFolderPath(){
        return "";
    }
}
