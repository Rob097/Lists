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
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Roberto97
 */
public class LoginAction extends HttpServlet {
    private static final long serialVersionUID = 6106269076155338045L;
    static String url = null;
    transient UserDAO userdao = null;

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
        int COOKIE_MAX_AGE = 60*60*24*4;
        User user;       
        Boolean loginResult = true;                
        
        HttpSession session = (HttpSession) request.getSession(false); 
        
        session.setAttribute("errore", null);
        session.setAttribute("errore", null);
        try {
            //passed parameter values
            String username = request.getParameter("email");
            String password = request.getParameter("password");
            String remember = request.getParameter("remember");

            //ritorna i dati dell`utente con email e password inserito
            user = userdao.getByEmailAndPassword(username, password);            
            //System.out.println(user.getNominativo());
            if (user != null) {
                loginResult = true;                
                
                //sesssion vars
                session.setAttribute("Logged", "on");
                session.setAttribute("user", user); 
                
                //create remember me cookie
                if(remember != null){
                    String encodedText = user.getEmail();
                    Cookie coouser = new Cookie("User",encodedText);
                    coouser.setPath(request.getContextPath());
                    coouser.setMaxAge(COOKIE_MAX_AGE);
                    response.addCookie(coouser);                    
                } 
                
                //url for redirect
                url = "homepage.jsp";
            } else {                
                url = "homepage.jsp";
                loginResult = false;
            }
        } catch (DAOException ex) {
            Logger.getLogger(LoginAction.class.getName()).log(Level.SEVERE, null, ex);
        }
        //gestisce un login non valido
        session.setAttribute("loginResult", loginResult);
        //redirecting to given url
        if (url != null) {
            response.sendRedirect(url);
        } else {
            out.print("Errore Imprevisto");
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
