/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package log;

import java.io.IOException;
import java.io.PrintWriter;
import static java.lang.System.out;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Roberto97
 */
public class LoginAction extends HttpServlet {
    String url = null;
    
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
        try {
            String username = request.getParameter("email");
            String password = request.getParameter("password");
            Class.forName("com.mysql.jdbc.Driver");  // MySQL database connection
            String dburl = "jdbc:mysql://ourlists.ddns.net:3306/ourlists?zeroDateTimeBehavior=convertToNull";
            String dbusername = "user";
            String dbpassword = "the_password";
            Connection conn = DriverManager.getConnection(dburl, dbusername, dbpassword);
            PreparedStatement pst = conn.prepareStatement("Select * from User where email=? and password=?");
            pst.setString(1, username);
            pst.setString(2, password);

            ResultSet rs = pst.executeQuery();
            String Nominativo;
            String Type;
            String image;
            String Email;
            String standard = request.getParameter("standard");
            String notstandard = request.getParameter("amministratore");
            String remember = request.getParameter("remember");

            //Guarda se i campoi sono corretti e se l'utente è standard
            if (rs.next()) {

                    Nominativo = rs.getString("nominativo");
                    Type = rs.getString("tipo");
                    Email = rs.getString("email");
                    image = rs.getString("immagine");
                    

                    Cookie cookie = new Cookie("Nominativo", Nominativo);
                    Cookie typeCookie = new Cookie("Type", Type);
                    Cookie imageCookie = new Cookie("Image", image);
                    Cookie emailCookie = new Cookie("Email", Email);
                    Cookie logged = new Cookie("Logged", "on");
                    
                    if(remember != null) {cookie.setMaxAge(30 * 24 * 60 * 60); imageCookie.setMaxAge(30 * 24 * 60 * 60); typeCookie.setMaxAge(30 * 24 * 60 * 60); emailCookie.setMaxAge(30 * 24 * 60 * 60); logged.setMaxAge(30 * 24 * 60 * 60);}
                    response.addCookie(cookie); response.addCookie(imageCookie); response.addCookie(typeCookie); response.addCookie(emailCookie); response.addCookie(logged);
                    
                    request.getSession().setAttribute("Nominativo", Nominativo);
                    request.getSession().setAttribute("Image", image);
                    request.getSession().setAttribute("Email", Email);
                    request.getSession().setAttribute("Type", Type);
                    request.getSession().setAttribute("Logged", "on");
                if (rs.getString("tipo").equals("standard")) {
                    url = "Pages/standard/standardType.jsp";
                } else if (rs.getString("tipo").equals("amministratore")) {
                    url = "Pages/amministratore/amministratore.jsp";
                } else {
                    url = null;
                    out.println("Errore di tipo utente");
                }
            
            }else System.out.println("Errore next");
            if(url != null){
                response.sendRedirect(url);
            }
            else out.print("Errore Imprevisto");
            
            
        } catch (Exception e) {
            out.println("Something went wrong !! Please try again");
            out.println("Causa Chiusura ");
            e.printStackTrace();
        }

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
