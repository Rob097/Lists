/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ShopList;

import database.daos.ListDAO;
import database.daos.UserDAO;
import database.entities.User;
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
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Pattern;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import log.RegisterAction;

/**
 *
 * @author Dmytr
 */
@MultipartConfig(maxFileSize = 16177215)
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
        String nome;
        String descrizione;
        String immagine;
        String creator;
        String categoria;
        
        nome = request.getParameter("Nome");
        System.out.println("NOm22222222eeeeeeeeee" + nome);
        descrizione = request.getParameter("Descrizione");
        System.out.println("NOme33333333eeeeeeeee" + descrizione);
        categoria = request.getParameter("Categoria");
        System.out.println("NO111111meeeeeeeeee" + categoria);
        
        User temp = (User)request.getSession().getAttribute("user");
        creator = temp.getEmail();
        
        // IMMAGINE
        String listsFolder = "/Image/ListsImg";
        String rp = "/Image/ListsImg";
        listsFolder = getServletContext().getRealPath(listsFolder);
        listsFolder = listsFolder.replace("\\build", "");
        File uploadDirFile = new File(listsFolder);
        String filename1 = "";
        Part filePart1 = request.getPart("file1");
        if ((filePart1 != null) && (filePart1.getSize() > 0)) {
            
            String extension = Paths.get(filePart1.getSubmittedFileName()).getFileName().toString().split(Pattern.quote("."))[1];;
            String nomeIMG = creator + "-" + nome;
            
            filename1 = nomeIMG + "." + extension;
            filename1 = filename1.replaceAll("\\s+","");
            File file1 = new File(uploadDirFile, filename1);
            try (InputStream fileContent = filePart1.getInputStream()) {
                Files.copy(fileContent, file1.toPath());
            }
        }
        immagine = rp + "/" + filename1;
        immagine = immagine.replaceFirst("/", ""); 
        immagine = immagine.replaceAll("\\s+","");
        //FINE IMMAGINE
        
        
        nuovaLista.setImmagine(immagine);
        nuovaLista.setCategoria(categoria);
        nuovaLista.setCreator(creator);
        nuovaLista.setImmagine(immagine);
        nuovaLista.setDescrizione(descrizione);
        nuovaLista.setNome(nome);

        System.out.println(nuovaLista.getImmagine());

        try {
            //manda i dati del user, il metodo upate fa la parte statement 
            nuovaLista = listdao.Insert(nuovaLista);

        } catch (DAOException ex) {
            Logger.getLogger(RegisterAction.class.getName()).log(Level.SEVERE, null, ex);
        }
        if (nuovaLista != null) {
            regResult = true;
            request.getSession().setAttribute("regResult", regResult);
            User user =(User) request.getSession().getAttribute("user");
            ArrayList<ShopList> li;
            try {
                li = listdao.getByEmail(user.getEmail());
                request.getSession().setAttribute("userLists", li);
            } catch (DAOException ex) {
                Logger.getLogger(CreateShopList.class.getName()).log(Level.SEVERE, null, ex);
            }
            
        }

        response.sendRedirect("Pages/standard/standardType.jsp");

    }
    
    public String SetImgName(String name, String extension){
        
        String s;
        s = name;
        s = s.trim();
        s = s.replace("@", "");
        s = s.replace(".", "");
       
        return s + "." + extension;
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
