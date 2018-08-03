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
import java.io.IOException;
import static java.lang.System.out;
import java.net.URLEncoder;
import java.util.logging.Level;
import java.util.logging.Logger;
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
    UserDAO userdao = null;
    
    @Override
    public void init() throws ServletException{
          //carica la Connessione inizializzata in JDBCDAOFactory, quindi ritorna il Class.for() e la connessione
           DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
            if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        //assegna a userdao la connessione(costruttore) e salva la connessione in una variabile tipo Connection
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
        Boolean loginResult = true;
        
         try {
            String username = request.getParameter("email");
            String password = request.getParameter("password");
            String remember = request.getParameter("remember");
            
            //ritorna i dati dell`utente con email e password inserito
            user = userdao.getByEmailAndPassword(username, password);
       
                if(user != null){
                    loginResult = true;
                        String nominativo = user.getNominativo();
                        String tipo=user.getTipo();
                        String image=user.getImage();
                        String email=user.getEmail();
                        
                        Cookie cookie = null;
                        if(nominativo != null){
                         cookie = new Cookie("Nominativo", URLEncoder.encode(nominativo, "UTF-8"));  
                        }
                        Cookie typeCookie = new Cookie("Type", tipo);
                        Cookie imageCookie = new Cookie("Image", image);
                        Cookie emailCookie = new Cookie("Email", email);
                        Cookie logged = new Cookie("Logged", "on");
                        
                    
                        if(remember != null) {cookie.setMaxAge(30 * 24 * 60 * 60); imageCookie.setMaxAge(30 * 24 * 60 * 60); typeCookie.setMaxAge(30 * 24 * 60 * 60); emailCookie.setMaxAge(30 * 24 * 60 * 60); logged.setMaxAge(30 * 24 * 60 * 60);}
                        if(nominativo != null){response.addCookie(cookie);} response.addCookie(imageCookie); response.addCookie(typeCookie); response.addCookie(emailCookie); response.addCookie(logged);
                    
                        request.getSession().setAttribute("Nominativo", nominativo);
                        request.getSession().setAttribute("Image", image);
                        request.getSession().setAttribute("Email", email);
                        request.getSession().setAttribute("Type", tipo);
                        request.getSession().setAttribute("Logged", "on");
                        request.getSession().setAttribute("user", user);
                        
                    if ("standard".equals(user.getTipo())) {
                        url = "Pages/standard/standardType.jsp";
                    } else if ("amministratore".equals(user.getTipo())) {
                        url = "Pages/amministratore/amministratore.jsp";
                    } else {
                        url = "homepage.jsp";
                        out.println("Errore di tipo utente");
                    }
                }else {
                    System.out.println("user=null");
                    url = "homepage.jsp";
                    loginResult = false;
                }
            
            } catch (DAOException ex) {
            Logger.getLogger(LoginAction.class.getName()).log(Level.SEVERE, null, ex);
        }
         //gestisce un login non valido
         request.getSession().setAttribute("loginResult", loginResult);
         
            if(url != null){
                response.sendRedirect(url);
            }
            else out.print("Errore Imprevisto");
  
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
