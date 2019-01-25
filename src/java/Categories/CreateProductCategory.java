/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Categories;

import Tools.ImageDispatcher;
import static Tools.ImageDispatcher.getImageExtension;
import database.daos.Category_ProductDAO;
import database.entities.Category_Product;
import database.entities.User;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCCategory_ProductDAO;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

/**
 *
 * @author Martin
 */
@MultipartConfig(maxFileSize = 16177215)
public class CreateProductCategory extends HttpServlet {
    private static final long serialVersionUID = 6106269076155338045L;
    transient Category_ProductDAO catproddao = null;
    @Override
    public void init() throws ServletException {
        //carica la Connessione inizializzata in JDBCDAOFactory, quindi ritorna il Class.for() e la connessione
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        //assegna a userdao la connessione(costruttore) e salva la connessione in una variabile tipo Connection
        catproddao = new JDBCCategory_ProductDAO(daoFactory.getConnection());
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //inizializza variabili di base
        HttpSession session = (HttpSession) request.getSession(false);
        Category_Product catProduct = new Category_Product();
        User user = (User) session.getAttribute("user");
        
        //set prod-category
        catProduct.setNome(request.getParameter("Nome"));
        catProduct.setDescrizione(request.getParameter("Descrizione"));
        catProduct.setAdmin(user.getEmail());
        Part filePart1 = request.getPart("file1");
        
        //immagine
        if(filePart1!=null){
             String relativeListFolderPath = "/Image/CategoryIco";
            String listsFolder = obtainRootFolderPath(relativeListFolderPath);
            String extension = getImageExtension(filePart1);
            String imagineName =  catProduct.getNome() + "." + extension;
            ImageDispatcher.InsertImgIntoDirectory(listsFolder, imagineName, filePart1);
            
            String immagine = ImageDispatcher.savePathImgInDatabsae(relativeListFolderPath, imagineName);
            catProduct.setImmagine(immagine);
        }
        
        try {
            catproddao.insertProdCategory(catProduct);
        } catch (DAOException ex) {
            Logger.getLogger(CreateProductCategory.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        response.sendRedirect(request.getContextPath() +"/Pages/ShowProductCategories.jsp");
       
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
    
    public String obtainRootFolderPath(String relativePath) {
        String folder;
        folder = relativePath;
        folder = getServletContext().getRealPath(folder);
        folder = folder.replace("\\build", "");
        return folder;
    }

}
