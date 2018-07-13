/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets.log;

import database.factories.DAOFactory;
import database.jdbc.JDBCUserDAO;
import database.daos.UserDAO;
import database.entities.User;
import java.io.IOException;
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

    private UserDAO userdao;
    
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
            
           String Tipostandard=null, TipononStandard=null, photo=null;    
                user.setEmail(request.getParameter("username")); //txt_username
                user.setNominativo(request.getParameter("nominativo")); //txt_name
                user.setPassword(request.getParameter("password"));//txt_password
                Tipostandard=request.getParameter("standard"); //txt_standard
                TipononStandard=request.getParameter("nonStandard"); //txt_nonSstandard
                user.setImage(photo="ciao");
                if(Tipostandard!=null){
                    user.setTipo(Tipostandard);
                }
                if(TipononStandard!=null){
                    user.setTipo(TipononStandard);
                }
                
                
            try{
                user = userdao.update(user);
                Cookie cookie = new Cookie("Nominativo", user.getNominativo());
                Cookie emailCookie = new Cookie("Email", user.getEmail());
                Cookie imageCookie = new Cookie("Image", user.getImage());
                Cookie typeCookie = null;   if(Tipostandard != null){
                                                typeCookie = new Cookie("Type", Tipostandard);
                                            }
                                            else if(TipononStandard != null){
                                                typeCookie = new Cookie("Type", TipononStandard);
                                            }
                Cookie logged = new Cookie("Logged", "on");
                cookie.setMaxAge(60*60*24); imageCookie.setMaxAge(60*60*24); typeCookie.setMaxAge(60*60*24); emailCookie.setMaxAge(60*60*24); logged.setMaxAge(60*60*24);
                response.addCookie(cookie); response.addCookie(imageCookie); response.addCookie(typeCookie); response.addCookie(emailCookie); response.addCookie(logged);
                
                request.getSession().setAttribute("user", user);
                request.getSession().setAttribute("Nominativo", user.getNominativo());
                request.getSession().setAttribute("Email", user.getEmail());
                request.getSession().setAttribute("Image", user.getImage());
                request.getSession().setAttribute("Type", typeCookie);
                request.getSession().setAttribute("Logged", "on");
                
                
                //request.setAttribute("successMsg","Register Successfully...! Please login"); //register success messeage
                if(Tipostandard != null) response.sendRedirect("Pages/standardType.jsp");
                else if(TipononStandard != null) response.sendRedirect("Pages/notStandardType.jsp");
        
                
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
