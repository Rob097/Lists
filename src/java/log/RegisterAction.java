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
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.regex.Pattern;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import static jdk.nashorn.internal.objects.NativeString.substring;

/**
 *
 * @author Roberto97
 */
@MultipartConfig(maxFileSize = 16177215)	// upload file's size up to 16MB
public class RegisterAction extends HttpServlet {

    /*@Override
    public void init() throws ServletException {
         //carica la Connessione inizializzata in JDBCDAOFactory
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
            assegna a userdao la connessione(costruttore)
        userdao = new JDBCUserDAO(daoFactory.getConnection());
        
    }
     */
    //-->UserDAO userdao = null;             
    // database connection settings
    private String dbURL = "jdbc:mysql://ourlists.ddns.net:3306/ourlists?zeroDateTimeBehavior=convertToNull";
    private String dbUser = "user";
    private String dbPass = "the_password";

    protected void doPost(HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
        //User user = new User();
        // gets values of text fields
        
        String avatarsFolder = getServletContext().getInitParameter("avatarsFolder");
        if (avatarsFolder == null) {
            throw new ServletException("Avatars folder not configured");
        }
        
        avatarsFolder = getServletContext().getRealPath(avatarsFolder);
        System.out.println("==========================" + avatarsFolder);
        avatarsFolder = avatarsFolder.replace("\\build", "");
        System.out.println("==========================" + avatarsFolder);

        String email, nominativo, password, Tipostandard, TipononStandard, photo, standard = "standard", nonStandard = "nonStandard";
        email = request.getParameter("email"); //txt_username
        System.out.println(email);
        nominativo = request.getParameter("nominativo"); //txt_name
        password = request.getParameter("password"); //txt_password
        Tipostandard = request.getParameter("standard"); //txt_standard
        TipononStandard = request.getParameter("nonStandard"); //txt_nonSstandard
        InputStream inputStream = null;	// input stream of the upload file

        // obtains the upload file part in this multipart request
        File uploadDirFile = new File(avatarsFolder);

        String filename1 = "";
        Part filePart1 = request.getPart("file1");
        if ((filePart1 != null) && (filePart1.getSize() > 0)) {
            String extension = Paths.get(filePart1.getSubmittedFileName()).getFileName().toString().split(Pattern.quote("."))[1];;
            filename1 = email + "." + extension;
            File file1 = new File(avatarsFolder, filename1);

            try (InputStream fileContent = filePart1.getInputStream()) {
                Files.copy(fileContent, file1.toPath());
            }
        }

        photo = avatarsFolder + "/" + filename1;

        Connection conn = null;	// connection to the database
        String message;	// message will be sent back to client

        try {
            // connects to the database
            DriverManager.registerDriver(new com.mysql.jdbc.Driver());
            conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

            //-->userdao.update(user);
            // constructs SQL statement
            String sql = "insert into User(email,password,nominativo,tipo,immagine) values(?,?,?,?,?)";
            PreparedStatement statement = conn.prepareStatement(sql);
            statement.setString(1, email);
            statement.setString(2, password);
            statement.setString(3, nominativo);
            if (Tipostandard != null) {
                Tipostandard = "standard";
                statement.setString(4, standard);
            } else if (TipononStandard != null) {
                TipononStandard = "Nonstandard";
                statement.setString(4, nonStandard);
            }
            
            statement.setString(5, photo);

            // sends the statement to the database server
            int row = statement.executeUpdate();
            if (row > 0) {
                message = "File uploaded and saved into database";
            }
        } catch (SQLException ex) {
            message = "ERROR: " + ex.getMessage();
            ex.printStackTrace();
        } finally {
            if (conn != null) {
                // closes the database connection
                try {
                    conn.close();
                } catch (SQLException ex) {
                    System.out.println("ERRORNEW: ");
                    ex.printStackTrace();
                }
            }
            // sets the message in request scope
            response.sendRedirect("homepage.jsp");

            // forwards to the message page
            //getServletContext().getRequestDispatcher("/Message.jsp").forward(request, response);
        }
    }

}
