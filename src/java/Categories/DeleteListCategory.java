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
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Martin
 */
public class DeleteListCategory extends HttpServlet {

    private static final long serialVersionUID = 6106269076155338045L;
    transient CategoryDAO categorydao;
    
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
        
        String listname =(String) request.getParameter("listname");
        Category category = null;
        
        try {
            category = categorydao.getByName(listname);
        } catch (DAOException ex) {
            Logger.getLogger(DeleteListCategory.class.getName()).log(Level.SEVERE, null, ex);
        }  
        if(category != null){
            if(category.getImmagini() == null){
                System.out.println("immagine null");
            }else{
                String listsFolder = "";
                listsFolder = getServletContext().getRealPath(listsFolder);
                listsFolder = listsFolder.replace("\\build", "");
                for (String img : category.getImmagini()) {
                    String imgfolder = img.replace("/Image/CategoryIco", "");
                    try{
                        ImageDispatcher.DeleteImgFromDirectory(listsFolder + imgfolder);
                    }catch(Exception e){
                        System.out.println("immagini non esiste");
                    }
                }
            }
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
