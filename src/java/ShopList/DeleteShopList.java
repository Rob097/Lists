/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ShopList;

import database.daos.ListDAO;
import database.entities.ShopList;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCShopListDAO;
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
public class DeleteShopList extends HttpServlet {
    private static final long serialVersionUID = 6106269076155338045L;
    transient ListDAO listdao;

    @Override
    public void init() throws ServletException {
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        listdao = new JDBCShopListDAO(daoFactory.getConnection());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = (HttpSession) request.getSession(false);
        String creator = "";
        if(request.getParameter("creator") != null){
            creator = request.getParameter("creator");
        }
        if(session.getAttribute("user") != null){
            String listname = (String) session.getAttribute("shopListName"); 

            try {
                ShopList list = listdao.getbyName(listname);
                System.out.println("NOME LISTAAA" + list.getNome());
                
                if (list.getImmagine() != null && !(list.getImmagine().equals(""))) {
                    String listsFolder = "";
                    listsFolder = getServletContext().getRealPath(listsFolder);
                    listsFolder = listsFolder.replace("\\build", "");
                    String imgfolder = list.getImmagine().replace("/Image/ListsImg", "");
                    deleteImgFromDirectory(listsFolder + imgfolder);
                }
                
                
                listdao.deleteList(listname);
            } catch (DAOException ex) {
                Logger.getLogger(DeleteShopList.class.getName()).log(Level.SEVERE, null, ex);
                System.out.println("ERRORE MOME LISTA");
            }
            String url  = "/Lists/userlists.jsp";
            response.sendRedirect(url);
            
        }else{
            session.setAttribute("guestList", null);
            session.setAttribute("prodottiGuest", null);
            try {
                listdao.deleteGuestListFromDB(creator);
            } catch (DAOException ex) {
                System.out.println("impossibile eliminare la guest list dal database");
                //Logger.getLogger(DeleteShopList.class.getName()).log(Level.SEVERE, null, ex);
            }
            response.sendRedirect("/Lists/homepage.jsp");
            
        }

    }
    
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
        
        HttpSession session = (HttpSession) request.getSession(false);
        String creator = "";
        if(request.getParameter("creator") != null){
            creator = request.getParameter("creator");
        }
        
        if(session.getAttribute("user") != null){
            String listname = (String) request.getParameter("shopListName");

            try {
                ShopList list = listdao.getbyName(listname);
                System.out.println("NOME LISTAAA" + list.getNome());
                
                if (list.getImmagine() != null && !(list.getImmagine().equals(""))) {
                    String listsFolder = "";
                    listsFolder = getServletContext().getRealPath(listsFolder);
                    listsFolder = listsFolder.replace("\\build", "");
                    String imgfolder = list.getImmagine().replace("/Image/ListsImg", "");
                    deleteImgFromDirectory(listsFolder + imgfolder);
                }
                
                
                listdao.deleteList(listname);
            } catch (DAOException ex) {
                Logger.getLogger(DeleteShopList.class.getName()).log(Level.SEVERE, null, ex);
                System.out.println("ERRORE MOME LISTA");
            }
            String url  = "/Lists/userlists.jsp";
            response.sendRedirect(url);
            
        }else{
            session.setAttribute("guestList", null);
            session.setAttribute("prodottiGuest", null);
            try {
                listdao.deleteGuestListFromDB(creator);
            } catch (DAOException ex) {
                System.out.println("impossibile eliminare la guest list dal database");
                Logger.getLogger(DeleteShopList.class.getName()).log(Level.SEVERE, null, ex);
            }
            response.sendRedirect("/Lists/homepage.jsp");
            
        }
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

    public void deleteImgFromDirectory(String fileName) {
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


