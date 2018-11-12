/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Categories;

import Tools.ImageDispatcher;
import database.daos.CategoryDAO;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCCategoryDAO;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Martin
 */
public class DeleteCategoryImage extends HttpServlet {

    CategoryDAO categorydao;
    @Override
    public void init() throws ServletException {
        //carica la Connessione inizializzata in JDBCDAOFactory, quindi ritorna il Class.for() e la connessione
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        //assegna a userdao la connessione(costruttore) e salva la connessione in una variabile tipo Connection
        categorydao = new JDBCCategoryDAO(daoFactory.getConnection());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = (HttpSession) request.getSession(false);
        String image = request.getParameter("image");
        if(image!=null){
            try {
                String listsFolder = "";
                listsFolder = getServletContext().getRealPath(image);
                listsFolder = listsFolder.replace("\\build", "");
                ImageDispatcher.DeleteImgFromDirectory(listsFolder);
        
                categorydao.deleteImage(image);
            } catch (DAOException ex) {
                Logger.getLogger(DeleteCategoryImage.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        session.setAttribute("deleteImage", false);
        response.sendRedirect(request.getContextPath() +"/Pages/ShowListCategories.jsp");
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