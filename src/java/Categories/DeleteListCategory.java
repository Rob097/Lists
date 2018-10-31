/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Categories;

import Tools.ImageDispatcher;
import database.daos.CategoryDAO;
import database.entities.Category;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCCategoryDAO;
import java.io.File;
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
public class DeleteListCategory extends HttpServlet {


    CategoryDAO categorydao;
    
    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        categorydao = new JDBCCategoryDAO(daoFactory.getConnection());
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = (HttpSession) request.getSession(false);
        String listname =(String) request.getParameter("listname");
        Category category = null;
        
        try {
            category = categorydao.getByName(listname);
        } catch (DAOException ex) {
            Logger.getLogger(DeleteListCategory.class.getName()).log(Level.SEVERE, null, ex);
        }        
            
        if(category.getImmagine() != null){
            String listsFolder = "";
            String rp = "/Image/CategoryIco";
            listsFolder = getServletContext().getRealPath(listsFolder);
            listsFolder = listsFolder.replace("\\build", "");
            String imgfolder = category.getImmagine().replace("/Image/CategoryIco", "");
            ImageDispatcher.DeleteImgFromDirectory(listsFolder + imgfolder);            
        }
        
        try {
            categorydao.deleteCategory(category);
        } catch (DAOException ex) {
            System.out.println("cancellazione categoria errata");
            Logger.getLogger(DeleteListCategory.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        response.sendRedirect(request.getContextPath() + "/Pages/ShowListCategories.jsp");
        
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
