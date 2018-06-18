/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package log;

import java.io.IOException;
import java.io.PrintWriter;
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
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            Class.forName("com.mysql.cj.jdbc.Driver");  // MySQL database connection
            String dburl = "jdbc:mysql://sql2.freemysqlhosting.net:3306/sql2243047?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC&autoReconnect=true&useSSL=false";
            String dbusername = "sql2243047";
            String dbpassword = "mJ9*fQ4%";
            Connection conn = DriverManager.getConnection(dburl, dbusername, dbpassword);
            PreparedStatement pst = conn.prepareStatement("Select * from USER where Email=? and Password=?");
            pst.setString(1, username);
            pst.setString(2, password);

            ResultSet rs = pst.executeQuery();
            String Nominativo = null;
            String Type = null;
            String image = null;
            String Email = null;
            String standard = request.getParameter("standard");
            String notstandard = request.getParameter("nonStandard");
            String remember = request.getParameter("remember");

            //Guarda se i campoi sono corretti e se l'utente è standard
            if (rs.next() && standard != null) {
                if (rs.getString("Tipo").equals("standard")) {

                    Nominativo = rs.getString("Nominativo");
                    Type = rs.getString("Tipo");
                    image = rs.getString("Image");
                    Email = rs.getString("Email");

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
                    
                    response.sendRedirect("Pages/standardType.jsp");
                } else {
                    System.out.println("Attenzione che tu sei un utente NONStandard");
                }
            } else //Guarda se i campoi sono corretti e se l'utente è NON standard
                
            if (notstandard != null) {
                if (rs.getString("Tipo").equals("nonStandard")) {

                    Nominativo = rs.getString("Nominativo");
                    Type = rs.getString("Tipo");
                    image = rs.getString("Image");
                    Email = rs.getString("Email");
                    
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
                    
                    response.sendRedirect("Pages/notStandardType.jsp");
                } else {
                    System.out.println("Attenzione che tu sei un utente Standard");
                }
            } else {
                System.out.println("Invalid login credentials");
            }
            
        } catch (Exception e) {
            System.out.println("Something went wrong !! Please try again");
            System.out.println("Causa Chiusura ");
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
