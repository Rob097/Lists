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
import log.RegisterAction;
import Tools.ImageDispatcher;
import static Tools.ImageDispatcher.getImageExtension;

/**
 *
 * @author Dmytr
 */
@MultipartConfig(maxFileSize = 16177215)
public class CreateShopList extends HttpServlet {
    private static final long serialVersionUID = 6106269076155338045L;
    transient ListDAO listdao = null;

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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("CREATEEEE");
        HttpSession s = request.getSession();
        ShopList nuovaLista = new ShopList();
        Boolean regResult;
        String nome;
        String descrizione;
        String immagine = "Image/ListsImg/guestsList.jpg";
        String creator;
        String categoria;
        String url = "/Lists/userlists.jsp";
        String relativeListFolderPath = "/Image/ListsImg";

        //richiesa dei parametri
        nome = request.getParameter("Nome");
        descrizione = request.getParameter("Descrizione");
        categoria = request.getParameter("Categoria");
        Part filePart1 = request.getPart("file1");
        User temp;
        
        if (s.getAttribute("user") != null) {
            temp = (User) s.getAttribute("user");
            creator = temp.getEmail();
        } else {
            creator = "ospite@lists.it";
        }        
        
        if(request.getParameter("showProduct") != null){
            if(request.getParameter("showProduct").equals("true")){
                s.setAttribute("LISTMODAL", true);
                url = "/Lists/Pages/ShowProducts.jsp";
            }
        }
        else if (s.getAttribute("user") != null) {
            url = "/Lists/userlists.jsp";
        }
        
        
        

        if (!creator.equals("ospite@lists.it")) {

            String listsFolder = obtainRootFolderPath(relativeListFolderPath);
            String extension = getImageExtension(filePart1);
            String imagineName = creator + "-" + nome + "." + extension;
            ImageDispatcher.insertImgIntoDirectory(listsFolder, imagineName, filePart1);
            
            immagine = ImageDispatcher.savePathImgInDatabsae(relativeListFolderPath, imagineName);

        }

        nuovaLista.setImmagine(immagine);
        nuovaLista.setCategoria(categoria);
        nuovaLista.setCreator(creator);
        nuovaLista.setDescrizione(descrizione);
        nuovaLista.setNome(nome);

        try {

            //manda i dati del user, il metodo upate fa la parte statement 
            if (s.getAttribute("user") != null) {
                listdao.insert(nuovaLista);
            } else {
                s.setAttribute("guestList", nuovaLista);
            }

        } catch (DAOException ex) {
            Logger.getLogger(RegisterAction.class.getName()).log(Level.SEVERE, null, ex);
        }
        regResult = true;
        s.setAttribute("regResult", regResult);         
        
        s.setAttribute("regResult", false);
        System.out.println(url);
        response.sendRedirect(url);

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
     *
     * @param relativePath se questa stringa è vuota allora il metodo
     * restituisce il percorso a "...Web/" altrimenti restituisce il percroso
     * alla cartella "...Web/[relativePath]" Esempio: relativePath =
     * "Image/AvatarImg"
     * @return web/Image/AvatarImg
     */
    public String obtainRootFolderPath(String relativePath) {
        String folder;
        folder = relativePath;
        folder = getServletContext().getRealPath(folder);
        folder = folder.replace("\\build", "");
        return folder;
    }

}
