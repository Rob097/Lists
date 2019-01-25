/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Categories;

import Tools.ImageDispatcher;
import static Tools.ImageDispatcher.getImageExtension;
import database.daos.CategoryDAO;
import database.entities.Category;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCCategoryDAO;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
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
public class AddCategoryImage extends HttpServlet {
    private static final long serialVersionUID = 6106269076155338045L;
    transient CategoryDAO categorydao;
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
      //inizializza variabili
        HttpSession session = (HttpSession) request.getSession(false);
        Category category = new Category();        
        category.setNome( (String) session.getAttribute("listname"));
        
        
        Part filePart1 = request.getPart("file1");
        
        
        if(filePart1!=null && filePart1.getSize()>0){
            String relativeListFolderPath = "/Image/CategoryIco";
            String listsFolder = obtainRootFolderPath1(relativeListFolderPath);
            DateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
            Date date = new Date();
            String extension = getImageExtension(filePart1);
            String imagineName =  category.getNome()+ dateFormat.format(date) + "." + extension;
            ImageDispatcher.InsertImgIntoDirectory(listsFolder, imagineName, filePart1);
            String immagine = ImageDispatcher.savePathImgInDatabsae(relativeListFolderPath, imagineName);
            category.setImmagine(immagine);
        
            try {
                categorydao.insertImmagine(category);
            } catch (DAOException ex) {
                System.out.println("non effetuato");
                Logger.getLogger(AddCategoryImage.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
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
    
     public String obtainRootFolderPath1(String relativePath) {
        String folder;
        folder = relativePath;
        folder = getServletContext().getRealPath(folder);
        folder = folder.replace("\\build", "");
        return folder;
    }

}
