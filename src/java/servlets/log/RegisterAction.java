/**
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package servlets.log;

import database.factories.DAOFactory;
import database.jdbc.JDBCUserDAO;
import database.daos.UserDAO;
import database.entities.User;
import database.exceptions.DAOException;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
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
           //User user = new User();
                    // gets values of text fields
                    Part email = request.getPart("username");
                    Part password = request.getPart("password");
                    Part nome = request.getPart("nominativo");
                    Part tipo =request.getPart("standard");
                    
		/*String username=null, nome=null, password=null, Tipostandard=null, TipononStandard=null, photo=null, standard="standard", nonStandard="nonStandard";
		username=request.getParameter("username"); //txt_username
        nome=request.getParameter("nominativo"); //txt_name
        password=request.getParameter("password"); //txt_password
        Tipostandard=request.getParameter("standard"); //txt_standard
        TipononStandard=request.getParameter("nonStandard"); //txt_nonSstandard
                    */
        InputStream inputStreamE = null;	// input stream of the upload file
        inputStreamE = email.getInputStream();
        InputStream inputStreamP =password.getInputStream();
        InputStream inputStreamN =nome.getInputStream();
		
		// obtains the upload file part in this multipart request
		Part filePart = request.getPart("image");
		if (filePart != null) {
			// prints out some information for debugging
			System.out.println(filePart.getName());
			System.out.println(filePart.getSize());
			System.out.println(filePart.getContentType());
			
			// obtains input stream of the upload file
			InputStream inputStream = filePart.getInputStream();
		}
              
		user.setEmail(email.toString());
                user.setNominativo(nome.toString());
                user.setPassword(password.toString());
                user.setTipo("standard");
                try {
                   user= userdao.update(user);
                } catch (DAOException ex) {
                    Logger.getLogger(RegisterAction.class.getName()).log(Level.SEVERE, null, ex);
                }

			// sets the message in request scope
			response.sendRedirect("homepage.jsp");
			
			// forwards to the message page
			//getServletContext().getRequestDispatcher("/Message.jsp").forward(request, response);
		
	
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


