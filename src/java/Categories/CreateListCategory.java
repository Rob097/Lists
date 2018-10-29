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
import database.entities.User;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCCategoryDAO;
import java.io.IOException;
import java.util.ArrayList;
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
public class CreateListCategory extends HttpServlet {

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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //inizializza variabili
        HttpSession session = (HttpSession) request.getSession(false);
        Category category = new Category();
        User user = (User) session.getAttribute("user");
        
        //set category
        String nome = request.getParameter("Nome");
        String descrizione = request.getParameter("Descrizione");
        Part filePart1 = request.getPart("file1");
        
        //salva immagine
        if(filePart1!=null){
            String relativeListFolderPath = "/Image/CategoryIco";
            String listsFolder = ObtainRootFolderPath(relativeListFolderPath);
            String extension = getImageExtension(filePart1);
            String imagineName =  category.getNome() + "." + extension;
            ImageDispatcher.InsertImgIntoDirectory(listsFolder, imagineName, filePart1);
            
            String immagine = ImageDispatcher.savePathImgInDatabsae(relativeListFolderPath, imagineName);
            category.setImmagine(immagine);
        }
        category.setNome(nome);
        category.setDescrizione(descrizione);
        category.setAdmin(user.getEmail());
        
        try {
            categorydao.createCategory(category);
        } catch (DAOException ex) {
            Logger.getLogger(CreateListCategory.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        response.sendRedirect("/Lists/Pages/ShowListCategories.jsp");
        
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
    
    public String ObtainRootFolderPath(String relativePath) {
        String folder = "";
        folder = relativePath;
        folder = getServletContext().getRealPath(folder);
        folder = folder.replace("\\build", "");
        return folder;
    }

}
