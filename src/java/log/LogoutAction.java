/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package log;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import database.entities.User;

/**
 *
 * @author Roberto97
 */
public class LogoutAction extends HttpServlet {

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if( cookie.getName().equals(request.getSession().getAttribute("Nominativo")) 
                    || cookie.getName().equals(request.getSession().getAttribute("Image"))
                    || cookie.getName().equals(request.getSession().getAttribute("Email"))
                    || cookie.getName().equals(request.getSession().getAttribute("Type"))){
                        
                        System.out.println(request.getSession().getAttribute("Nominativo") + cookie.getValue() + "\n");
                        System.out.println(request.getSession().getAttribute("Image") + cookie.getValue() + "\n");
                        System.out.println(request.getSession().getAttribute("Email") + cookie.getValue() + "\n");
                        System.out.println(request.getSession().getAttribute("Type") + cookie.getValue() + "\n");
                        
                }
                
            cookie.setMaxAge(0);
            response.addCookie(cookie);
            }
        }
        HttpSession session = request.getSession(false);
        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                session.setAttribute("user", null);
                session.invalidate();
                user = null;
            }
        }
         
        response.setHeader("Refresh", "0; URL=/Lists/homepage.jsp");
         
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
