/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets.log;

import java.io.IOException;
import static java.lang.System.out;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import database.daos.UserDAO;
import database.factories.DAOFactory;
import database.entities.User;
import database.jdbc.*;




/**
 *
 * @author Roberto97
 */
public class LoginAction extends HttpServlet {
    private UserDAO userdao;
    String url = null;
    
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
        
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            String Nominativo = null;
            String Type = null;
            String image = null;
            String Email = null;
            String Password = null;
            String standard = request.getParameter("standard");
            String notstandard = request.getParameter("nonStandard");
            String remember = request.getParameter("remember");
          
      
            String contextPath = getServletContext().getContextPath();
        if (!contextPath.endsWith("/")) {
            contextPath += "/";
        }
      
            //Guarda se i campoi sono corretti e se l'utente è standard
            try{
                User user = userdao.getByEmailAndPassword(username, password);
            
            if (standard != null) {
                if (user.getTipo().equals("standard")) {

                    Nominativo = user.getNominativo();
                    Type = user.getTipo();
        //            image = user.getImage();
                    Email = user.getEmail();
                    Password = user.getPassword();


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
                    request.getSession().setAttribute("user", user);
                    url = "Pages/standardType.jsp";
                } else {
                    url = null;
                    out.println("Attenzione che tu sei un utente NONStandard");
                }
            } else //Guarda se i campoi sono corretti e se l'utente è NON standard
                
            if (notstandard != null) {
                if (user.getTipo().equals("nonstandard")) {

                    Nominativo = user.getNominativo();
                    Type = user.getTipo();
                    //image = user.getImage();
                    Email = user.getEmail();
                    
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
                    request.getSession().setAttribute("user", user);
                    
                    url = "Pages/notStandardType.jsp";
                } else {
                    url = null;
                    out.println("Attenzione che tu sei un utente Standard");
                }
            } else {
                url = null;
                out.println("Invalid login credentials");
            }
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
