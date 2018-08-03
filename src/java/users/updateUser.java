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

        User user = new User();
        User cgeUser = new User();
        user = (User) request.getSession().getAttribute("user");

        String email = null;
        String nominativo = null;
        String password = null;
        String url = null;
        String Image = "";
        String avatarsFolder = "/Image/AvatarImg";
        String rp = "/Image/AvatarImg";
        String Tipostandard, TipoAmministratore, photo, standard = "standard", amministratore = "amministratore";
        avatarsFolder = getServletContext().getRealPath(avatarsFolder);
        avatarsFolder = avatarsFolder.replace("\\build", "");
        Image = user.getImage();

        email = request.getParameter("email");
        nominativo = request.getParameter("nominativo");
        password = request.getParameter("password");
        System.out.println(email + " " + nominativo + " " + password);

        cgeUser.setEmail(email);
        cgeUser.setNominativo(nominativo);
        cgeUser.setPassword(password);

        System.out.println(request.getPart("file1"));
        //Eliminazione dell'immagine dell'utente
        if ((request.getPart("file1") != null) && (request.getPart("file1").getSize() > 0)) {
            try {
                String filename = "/" + Image;
                System.out.println("==================== dal db:        " + filename);
                String avatarsFolder1 = getServletContext().getRealPath(filename);
                System.out.println("==================== get rela path" + avatarsFolder1);
                avatarsFolder1 = avatarsFolder1.replace("\\build", "");
                System.out.println("==================== senza build" + avatarsFolder1);
                File file = new File(avatarsFolder1);

                System.out.println("==================== path completo" + avatarsFolder1);

                if (file.delete()) {
                    System.out.println(file.getName() + " is deleted!");
                } else {
                    System.out.println(file.getAbsoluteFile() + "Delete operation is failed.");
                }

            } catch (Exception ex1) {
                System.out.println("Causa Errore: ");
                ex1.printStackTrace();
            }

            // obtains the upload file part in this multipart request
            File uploadDirFile = new File(avatarsFolder);
            System.out.println("2##########\n");
            String filename1 = "";
            System.out.println("3##########\n");
            Part filePart1 = request.getPart("file1");
            System.out.println("4##########\n");

            System.out.println("5##########\n");
            String extension = Paths.get(filePart1.getSubmittedFileName()).getFileName().toString().split(Pattern.quote("."))[1];;
            System.out.println("6##########\n");
            filename1 = user.getEmail() + "." + extension;
            System.out.println("7##########\n");
            File file1 = new File(uploadDirFile, filename1);
            System.out.println("8##########\n");
            try (InputStream fileContent = filePart1.getInputStream()) {
                System.out.println("9##########\n");
                Files.copy(fileContent, file1.toPath());
                System.out.println("10##########\n");
            }
            System.out.println("11##########\n");

            System.out.println("12##########\n");
            photo = rp + "/" + filename1;
            System.out.println("13##########\n");
            photo = photo.replaceFirst("/", "");
            System.out.println("14##########\n");
            user.setImage(photo);
            System.out.println("15##########\n");
        }

        try {
            user = userdao.changeUser(cgeUser, user);
        } catch (DAOException ex) {
            Logger.getLogger(updateUser.class.getName()).log(Level.SEVERE, null, ex);
        }

        if (user != null) {
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
