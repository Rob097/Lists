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
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Roberto97
 */
public class RegisterAction extends HttpServlet {

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
        Connection conn = null;
            
            try{
                Class.forName("com.mysql.jdbc.Driver");  // MySQL database connection
                String dburl = "jdbc:mysql://sql2.freemysqlhosting.net:3306/sql2243047?zeroDateTimeBehavior=convertToNull";
                String dbusername = "sql2243047";
                String dbpassword = "mJ9*fQ4%";
                conn = DriverManager.getConnection(dburl, dbusername, dbpassword);
            
            }catch(Exception e){
                System.out.println("Errore di connessione RegisterAction");
            }
            
            
            
            String username=null, nome=null, password=null, Tipostandard=null, TipononStandard=null, photo=null, standard="standard", nonStandard="nonStandard";    
                username=request.getParameter("username"); //txt_username
                nome=request.getParameter("nominativo"); //txt_name
                password=request.getParameter("password"); //txt_password
                Tipostandard=request.getParameter("standard"); //txt_standard
                TipononStandard=request.getParameter("nonStandard"); //txt_nonSstandard
                photo="ciao";
                
                
            try{
                PreparedStatement pstmt=null; //create statement     
                pstmt=conn.prepareStatement("insert into USER(Email,Password,Nominativo,Tipo,Image) values(?,?,?,?,?)"); //sql insert query
                pstmt.setString(1,username);
                pstmt.setString(2,password);
                pstmt.setString(3,nome);
                if(Tipostandard != null) {Tipostandard = "standard"; pstmt.setString(4,standard);}
                else if(TipononStandard != null) {TipononStandard = "Nonstandard"; pstmt.setString(4,nonStandard);}
                pstmt.setString(5,photo);
                

                pstmt.executeUpdate();
                Cookie cookie = new Cookie("Nominativo", nome);
                Cookie emailCookie = new Cookie("Email", username);
                Cookie imageCookie = new Cookie("Image", photo);
                Cookie typeCookie = null;   if(Tipostandard != null){
                                                typeCookie = new Cookie("Type", Tipostandard);
                                            }
                                            else if(TipononStandard != null){
                                                typeCookie = new Cookie("Type", TipononStandard);
                                            }
                Cookie logged = new Cookie("Logged", "on");
                cookie.setMaxAge(60*60*24); imageCookie.setMaxAge(60*60*24); typeCookie.setMaxAge(60*60*24); emailCookie.setMaxAge(60*60*24); logged.setMaxAge(60*60*24);
                response.addCookie(cookie); response.addCookie(imageCookie); response.addCookie(typeCookie); response.addCookie(emailCookie); response.addCookie(logged);
                
                request.getSession().setAttribute("Nominativo", nome);
                request.getSession().setAttribute("Email", username);
                request.getSession().setAttribute("Image", photo);
                request.getSession().setAttribute("Type", typeCookie);
                request.getSession().setAttribute("Logged", "on");
                
                //request.setAttribute("successMsg","Register Successfully...! Please login"); //register success messeage
                if(Tipostandard != null) response.sendRedirect("Pages/standardType.jsp");
                else if(TipononStandard != null) response.sendRedirect("Pages/notStandardType.jsp");
                conn.close(); //close connection
                
            }catch(Exception e){
                System.out.println("Errore database RegisterAction");
                System.out.println(e);
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
