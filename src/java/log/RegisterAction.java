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
     
    /*
    // database connection settings -->fatti in init()
    private String dbURL = "jdbc:mysql://ourlists.ddns.net:3306/ourlists?zeroDateTimeBehavior=convertToNull";
    private String dbUser = "user";
    private String dbPass = "the_password";
    */
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
        
            User user = new User();
            // gets values of text fields
            String avatarsFolder ="/Image/AvatarImg";
            String rp ="/Image/AvatarImg";
            if (avatarsFolder == null) {
                throw new ServletException("Avatars folder not configured");
            }   avatarsFolder = getServletContext().getRealPath(avatarsFolder);
            System.out.println("==========================" + avatarsFolder);
            avatarsFolder = avatarsFolder.replace("\\build", "");
            System.out.println("==========================" + avatarsFolder);
            
            String Tipostandard, TipoAmministratore, photo, standard = "standard", amministratore = "amministratore";
            user.setEmail(request.getParameter("email")); //email = request.getParameter("email"); //txt_username
            System.out.println(user.getEmail());
            user.setNominativo(request.getParameter("nominativo")); //nominativo = request.getParameter("nominativo"); //txt_name
            user.setPassword(request.getParameter("password")); //password = request.getParameter("password"); //txt_password
            Tipostandard = request.getParameter("standard"); //txt_standard
            TipoAmministratore = request.getParameter("amministratore"); //txt_amministratore
            InputStream inputStream = null;	// input stream of the upload file
            // obtains the upload file part in this multipart request
            File uploadDirFile = new File(avatarsFolder);
            String filename1 = "";
            Part filePart1 = request.getPart("file1");
            if ((filePart1 != null) && (filePart1.getSize() > 0)) {
                String extension = Paths.get(filePart1.getSubmittedFileName()).getFileName().toString().split(Pattern.quote("."))[1];;
                filename1 = user.getEmail() + "." + extension;
                File file1 = new File(avatarsFolder, filename1);
                
                try (InputStream fileContent = filePart1.getInputStream()) {
                    Files.copy(fileContent, file1.toPath());
                }
            }   photo = rp + "/" + filename1;
            photo = photo.replaceFirst("/", "");
            user.setImage(photo);
 
            if (Tipostandard != null) {
                Tipostandard = "standard";
                user.setTipo(standard);
            } else if (TipoAmministratore != null) {
                TipoAmministratore = "amministratore";
                user.setTipo(amministratore);
            }

            /*
            //-->adesso nella classe JDBCUserDAO
            Connection conn = null;	// connection to the database
            String message;	// message will be sent back to client
            */ 
            try {
            /*
            // connects to the database-->fatto gia con il WebContextListener(quindi fa solo una volta)
            DriverManager.registerDriver(new com.mysql.jdbc.Driver());
            conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
            */
            
            //manda i dati del user, il metodo upate fa la parte statement 
            userdao.update(user);
            
            /*-->adesso nella classe JDBCUserDAO nel metodo update
            // constructs SQL statement
            String sql = "insert into User(email,password,nominativo,tipo,immagine) values(?,?,?,?,?)";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setString(1, email);
            statement.setString(2, password);
            statement.setString(3, nominativo);
            if (Tipostandard != null) {
            Tipostandard = "standard";
            statement.setString(4, standard);
            } else if (TipoAmministratore != null) {
            TipoAmministratore = "amministratore";
            statement.setString(4, amministratore);
            }
            
            statement.setString(5, photo);

            // sends the statement to the database server
            int row = statement.executeUpdate();
            if (row > 0) {
            message = "File uploaded and saved into database";
            }
            */
        } catch (DAOException ex) {
            Logger.getLogger(RegisterAction.class.getName()).log(Level.SEVERE, null, ex);
        }
            /*finally { //-->connection close nella classe WebContextListener(chiude quando viene chiuso il sito)
        if (conn != null) {
        // closes the database connection
        try {
        conn.close();
        } catch (SQLException ex) {
        System.out.println("ERRORNEW: ");
        ex.printStackTrace();
        }
        }
         */ 
        
             response.sendRedirect("homepage.jsp");
             // sets the message in request scope
           
            // forwards to the message page
            //getServletContext().getRequestDispatcher("/Message.jsp").forward(request, response);
        }
            
}
        
    


