/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package users;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.regex.Pattern;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

/**
 *
 * @author Roberto97
 */
public class deleteUser extends HttpServlet {

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
        System.out.println("DeleteUser opening####################");
        Connection conn = null;
        Statement stmt = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            String url = "jdbc:mysql://ourlists.ddns.net:3306/ourlists?zeroDateTimeBehavior=convertToNull";
            String username = "user";
            String password = "the_password";
            conn = DriverManager.getConnection(url, username, password);
            stmt = conn.createStatement();

        } catch (Exception e) {
            System.out.println("Causa Connessione: ");
            e.printStackTrace();
        }

        Cookie cookie = null;
        Cookie[] cookies = null;

        // Get an array of Cookies associated with the this domain
        cookies = request.getCookies();
        String Email = "";
        try {
            //String Image = "";
            if (cookies != null) {
                for (int i = 0; i < cookies.length; i++) {
                    cookie = cookies[i];
                    if (cookie.getName().equals("JSESSIONID")); else {
                        if (cookie.getName().equals("Email")) {
                            Email += cookie.getValue();
                        }
                        /*if (cookie.getName().equals("Image")) {
                            Image += cookie.getValue();
                        }*/
                        PreparedStatement statement1 = conn.prepareStatement("DELETE FROM User WHERE email= ?");
                        statement1.setString(1, Email);
                        statement1.executeUpdate();
                    }
                }
            } else {
                System.out.println("<h2>Erroe eliminazione utente</h2>");
            }
        } catch (Exception ex) {
            System.out.println("Causa Errore: ");
            ex.printStackTrace();
        }

        //Eliminazione dell'immagine dell'utente
        try {
            String avatarsFolder = "/Image/AvatarImg";
            File file = new File(avatarsFolder);
            String filename1 = "";
            Part filePart1 = request.getPart("file1");
            if ((filePart1 != null) && (filePart1.getSize() > 0)) {
                String extension = Paths.get(filePart1.getSubmittedFileName()).getFileName().toString().split(Pattern.quote("."))[1];;
                filename1 = Email + "." + extension;
                File file1 = new File(avatarsFolder, filename1);

                if (file.delete()) {
                    System.out.println(file.getName() + " is deleted!");
                } else {
                    System.out.println(file.getAbsoluteFile() + "Delete operation is failed.");
                }
            }
        } catch (Exception ex1) {
            System.out.println("Causa Errore: ");
            ex1.printStackTrace();
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

}
