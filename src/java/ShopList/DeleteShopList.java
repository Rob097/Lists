/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ShopList;

import database.daos.ListDAO;
import database.entities.ShopList;
import database.entities.User;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCShopListDAO;
import java.io.File;
import java.io.IOException;
import static java.lang.System.out;
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

    ListDAO listdao;

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
        String listname = (String) session.getAttribute("shopListName");
        User user = null;
        if (session.getAttribute("user") != null) {
            user = (User) session.getAttribute("user");
        }

        try {
            ShopList list = listdao.getbyName(listname);
            System.out.println("NOME LISTAAA" + list.getNome());
            listdao.deleteList(list);
        } catch (DAOException ex) {
            Logger.getLogger(DeleteShopList.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println("ERRORE MOME LISTA");
        }
        String url;
        if (user != null) {
            url = "/Lists/Pages/" + user.getTipo() + "/" + user.getTipo() + ".jsp";
        } else {
            url = "homepage.jsp";
        }

        if (url != null) {
            response.sendRedirect(url);
        } else {
            out.print("Errore Imprevisto");
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


