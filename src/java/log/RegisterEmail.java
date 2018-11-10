/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package log;

import database.daos.UserDAO;
import database.entities.User;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCUserDAO;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Pattern;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

/**
 *
 * @author Roberto97
 */
public class RegisterEmail extends HttpServlet {

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    
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
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session =(HttpSession) request.getSession(false);
        String email = request.getParameter("email"), nominativo = request.getParameter("nominativo"), password = request.getParameter("password"), tipo = request.getParameter("tipo"), photo = "";
        User utente = new User();
        Boolean regResult = false;
        
        String avatarsFolder = "/Image/AvatarImg";
        String rp = "/Image/AvatarImg";
        avatarsFolder = getServletContext().getRealPath(avatarsFolder);
        avatarsFolder = avatarsFolder.replace("\\build", "");
        File uploadDirFile = new File(avatarsFolder);
        String filename1 = "";
        InputStream filePart1 = (InputStream) session.getAttribute("RegisterImageInputStrem");
        String extension = (String) session.getAttribute("RegisterImageExtension");
        
        
        session.setAttribute("RegisterImageInputStrem", null);
        session.setAttribute("RegisterImageExtension", null);
        if ((filePart1 != null)) {
            System.out.println("ci sono");
            String email1 = email;

            filename1 = SetImgName(email1, extension);
            File file1 = new File(uploadDirFile, filename1);
            try (InputStream fileContent = filePart1) {
                Files.copy(fileContent, file1.toPath());
            }
        }
        photo = rp + "/" + filename1;
        photo = photo.replaceFirst("/", "");
        utente.setPassword(password); 
        utente.setTipo(tipo);
        utente.setEmail(email);
        utente.setNominativo(nominativo);
        utente.setImage(photo);
        
        try {
            //manda i dati del user, il metodo upate fa la parte statement 
            utente = userdao.update(utente);
            
        } catch (DAOException ex) {
            Logger.getLogger(RegisterAction.class.getName()).log(Level.SEVERE, null, ex);
        }
        if(utente != null){
            regResult = true;
            session.setAttribute("regResult", regResult);
        }
        
        response.sendRedirect("/Lists/homepage.jsp");
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
    
    public String SetImgName(String name, String extension) {

        String s;
        s = name;
        s = s.trim();
        s = s.replace("@", "");
        s = s.replace(".", "");

        return s + "." + extension;
    }

    public String GetImgFolderPath() {
        return "";
    }
}
