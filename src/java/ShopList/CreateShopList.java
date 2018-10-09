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
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import log.RegisterAction;
import Tools.ImageDispatcher;
import static Tools.ImageDispatcher.getImageExtension;

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
        
        HttpSession s = request.getSession();
        ShopList nuovaLista = new ShopList();
        Boolean regResult = false;        
        String nome;
        String descrizione;
        String immagine = "/Image/ListsImg/guestsList.jpg";
        String creator;
        String categoria;
        String url = "/Lists/Pages/guest/guest.jsp";
        
        nome = request.getParameter("Nome");
        System.out.println("NOm22222222eeeeeeeeee" + nome);
        descrizione = request.getParameter("Descrizione");
        System.out.println("NOme33333333eeeeeeeee" + descrizione);
        categoria = request.getParameter("Categoria");
        
        System.out.println("NO111111meeeeeeeeee" + categoria);
        
        if(s.getAttribute("user") != null){
            User temp = (User)s.getAttribute("user");
            url = "/Lists/Pages/" + temp.getTipo() + "/" + temp.getTipo() + ".jsp";
            creator = temp.getEmail();
        }else{
            creator = "ospite@lists.it";
        }
        
        if(!creator.equals("ospite@lists.it")){
            // IMMAGINE
            String relativeListFolderPath = "/Image/ListsImg";
            String listsFolder = ObtainRootFolderPath(relativeListFolderPath);
            //prendo il file dalla form
            File uploadDirFile = new File(listsFolder);
            Part filePart1 = request.getPart("file1");
            String extension = getImageExtension(filePart1);
            String imagineName = creator + "-" + nome+"."+extension;
            //verfico se il file non è nullo
            if ((filePart1 != null) && (filePart1.getSize() > 0)) {

                ImageDispatcher.InsertImgIntoDirectory(listsFolder, imagineName,filePart1);
                        
            }
            immagine = ImageDispatcher.savePathImgInDatabsae(relativeListFolderPath, imagineName);
            
        }
        
        
        nuovaLista.setImmagine(immagine);
        nuovaLista.setCategoria(categoria);
        nuovaLista.setCreator(creator);
        nuovaLista.setDescrizione(descrizione);
        nuovaLista.setNome(nome);

        System.out.println(nuovaLista.getImmagine());

        
        try {
            System.out.println(creator);
            
            //manda i dati del user, il metodo upate fa la parte statement 
            if(s.getAttribute("user") != null){
                nuovaLista = listdao.Insert(nuovaLista);
            }else{
                s.setAttribute("guestList", nuovaLista);
            }

        } catch (DAOException ex) {
            Logger.getLogger(RegisterAction.class.getName()).log(Level.SEVERE, null, ex);
        }
        if (nuovaLista != null && s.getAttribute("user") != null) {
            regResult = true;
            s.setAttribute("regResult", regResult);
            User user =(User) s.getAttribute("user");
            ArrayList<ShopList> li;
            try {
                li = listdao.getByEmail(user.getEmail());
                s.setAttribute("userLists", li);
            } catch (DAOException ex) {
                Logger.getLogger(CreateShopList.class.getName()).log(Level.SEVERE, null, ex);
            }
            
        }
        s.setAttribute("regResult", false);
        System.out.println(url);
        response.sendRedirect(url);

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
    
    /**
     * Questo metodo restituisce il percorso il percorso alla directory
     * @param relativePath se questa stringa è vuota allora il metodo restituisce il percorso a "...Web/"
     * altrimenti restituisce il percroso alla cartella "...Web/[relativePath]"
     * Esempio: relativePath = "Image/AvatarImg" 
     * @return web/Image/AvatarImg
     */
    public String ObtainRootFolderPath(String relativePath){
        String folder = "";
        folder = relativePath;
        folder = getServletContext().getRealPath(folder);
        folder = folder.replace("\\build", "");
        return folder;
    }

}
