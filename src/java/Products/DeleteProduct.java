/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Products;

import database.daos.ProductDAO;
import database.daos.UserDAO;
import database.entities.Product;
import database.factories.DAOFactory;
import database.jdbc.JDBCProductDAO;
import database.jdbc.JDBCUserDAO;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Cody
 */
public class DeleteProduct extends HttpServlet {

    UserDAO userdao;
    ProductDAO productdao;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        userdao = new JDBCUserDAO(daoFactory.getConnection());
        productdao = new JDBCProductDAO(daoFactory.getConnection());
    }

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

        String PID = request.getParameter("PID");
        
        System.out.println("PID" + PID);
        Product p  =null;
        try {
            p = productdao.getProductByID(Integer.parseInt(PID));
        } catch (Exception e) {
        }
        
        System.out.println("PID CLASSE PRDODOTTO");

        System.out.println("PID integer " + Integer.parseInt(PID));
        try {
            System.out.println("SONO NEL TRY DI CALNCELLA PRODOTTO");
            productdao.Delete(p);
        } catch (Exception e) {
        }

        String listsFolder = "";
        String rp = "/Image/ProductImg";
        listsFolder = getServletContext().getRealPath(listsFolder);
        listsFolder = listsFolder.replace("\\build", "");
        String imgfolder = p.getImmagine().replace("/Image/ProductImg", "");
        System.out.println("FOLDER DELL IMMAGINE ============== " + imgfolder);
        
        DeleteImgFromDirectory(listsFolder + imgfolder);

        response.sendRedirect("/Lists/Pages/AdminPages/AdminProducts.jsp");
    }

    public void DeleteImgFromDirectory(String fileName) {
        // Creo un oggetto file
        File f = new File(fileName);

        // Mi assicuro che il file esista
        if (!f.exists()) {
            throw new IllegalArgumentException("Il File o la Directory non esiste: " + fileName);
        }

        // Mi assicuro che il file sia scrivibile
        if (!f.canWrite()) {
            throw new IllegalArgumentException("Non ho il permesso di scrittura: " + fileName);
        }

        // Se è una cartella verifico che sia vuota
        if (f.isDirectory()) {
            String[] files = f.list();
            if (files.length > 0) {
                throw new IllegalArgumentException("La Directory non è vuota: " + fileName);
            }
        }

        // Profo a cancellare
        boolean success = f.delete();

        // Se si è verificato un errore...
        if (!success) {
            throw new IllegalArgumentException("Cancellazione fallita");
        }
    }

}
