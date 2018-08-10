/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ShopList;

import database.daos.ListDAO;
import database.daos.UserDAO;
import database.entities.ShopList;
import database.entities.User;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCShopListDAO;
import database.jdbc.JDBCUserDAO;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Pattern;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import log.RegisterAction;

/**
 *
 * @author Dmytr
 */
public class CreateShopList extends HttpServlet {

    ListDAO listdao = null;

    @Override
    public void init() throws ServletException {
        //carica la Connessione inizializzata in JDBCDAOFactory, quindi ritorna il Class.for() e la connessione
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        //assegna a userdao la connessione(costruttore) e salva la connessione in una variabile tipo Connection
        listdao = new JDBCShopListDAO(daoFactory.getConnection());

    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ShopList nuovaLista = new ShopList();
        Boolean regResult = false;
        // gets values of text fields
        String avatarsFolder = "/Image/AvatarImg";
        String rp = "/Image/AvatarImg";
        
        String nome = null;
        String descrizione = null;
        String immagine = null;
        String creator = null;
        String categoria = null;
        
        avatarsFolder = getServletContext().getRealPath(avatarsFolder);
        avatarsFolder = avatarsFolder.replace("\\build", "");
        
        nome = request.getParameter("Nome");
        System.out.println("NOm22222222eeeeeeeeee" + nome);
        descrizione = request.getParameter("Descrizione");
        System.out.println("NOme33333333eeeeeeeee" + descrizione);
        categoria = request.getParameter("Categoria");
        System.out.println("NO111111meeeeeeeeee" + categoria);
        
        User temp = (User)request.getSession().getAttribute("user");
        creator = temp.getEmail();
        
        nuovaLista.setCategoria(categoria);
        nuovaLista.setCreator(creator);
        nuovaLista.setDescrizione(descrizione);
        nuovaLista.setNome(nome);


        try {
            //manda i dati del user, il metodo upate fa la parte statement 
            nuovaLista = listdao.Insert(nuovaLista);

        } catch (DAOException ex) {
            Logger.getLogger(RegisterAction.class.getName()).log(Level.SEVERE, null, ex);
        }
        if (nuovaLista != null) {
            regResult = true;
            request.getSession().setAttribute("regResult", regResult);
        }

        response.sendRedirect("Pages/standard/standardType.jsp");

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
