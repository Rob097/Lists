/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Categories;

import Tools.ImageDispatcher;
import database.daos.Category_ProductDAO;
import database.entities.Category_Product;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCCategory_ProductDAO;
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
public class DeleteProductCategory extends HttpServlet {

    Category_ProductDAO catproddao;
    
    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        catproddao = new JDBCCategory_ProductDAO(daoFactory.getConnection());
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = (HttpSession) request.getSession(false);
        String listname =(String) request.getParameter("listname");
        Category_Product catProd = null;
        
        try {
            catProd = catproddao.getByName(listname);
        } catch (DAOException ex) {
            Logger.getLogger(DeleteProductCategory.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        if(catProd.getImmagine() != null){
            String listsFolder = "";
            String rp = "/Image/CategoryIco";
            listsFolder = getServletContext().getRealPath(listsFolder);
            listsFolder = listsFolder.replace("\\build", "");
            String imgfolder = catProd.getImmagine().replace("/Image/CategoryIco", "");
            ImageDispatcher.DeleteImgFromDirectory(listsFolder + imgfolder);            
        }
        
        try {
            catproddao.deleteProductCategory(catProd);
        } catch (DAOException ex) {
            System.out.println("cancellazione categoria-prodotto errata");
            Logger.getLogger(DeleteProductCategory.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        response.sendRedirect(request.getContextPath() + "/Pages/ShowProductCategories.jsp");
       
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
