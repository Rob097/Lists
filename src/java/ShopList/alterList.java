/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ShopList;

import Tools.ImageDispatcher;
import static Tools.ImageDispatcher.getImageExtension;
import database.daos.ListDAO;
import database.entities.ShopList;
import database.entities.User;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCShopListDAO;
import java.io.IOException;
import java.io.PrintWriter;
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

/**
 *
 * @author Roberto97
 */
@MultipartConfig(maxFileSize = 16177215)
public class alterList extends HttpServlet {
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
    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("ALTER");
        HttpSession s = request.getSession();
        ShopList Lista = null;
        String nomeLista;
        if(s.getAttribute("user") != null){
            nomeLista = (String) s.getAttribute("alterList");       
            try {
                Lista = listdao.getbyName(nomeLista);
            } catch (DAOException ex) {
                Logger.getLogger(alterList.class.getName()).log(Level.SEVERE, null, ex);
            }
        }else{
            Lista = (ShopList) s.getAttribute("guestList");
        }
        Boolean regResult = false;
        String nome = Lista.getNome();
        String descrizione;
        String immagine = "Image/ListsImg/guestsList.jpg";
        String creator;
        String categoria;
        Part filePart1 = null;
        String url = "/Lists/userlists.jsp";
        String relativeListFolderPath = "/Image/ListsImg";

        //richiesa dei parametri
        if(request.getParameter("Nome") != null && request.getParameter("Nome") != "" && !request.getParameter("Nome").isEmpty()){
            nome = request.getParameter("Nome");
        }
        if(request.getParameter("Descrizione") != null && request.getParameter("Descrizione") != "" && !request.getParameter("Descrizione").isEmpty())
            descrizione = request.getParameter("Descrizione");
        else
            descrizione = Lista.getDescrizione();
        if(request.getParameter("Categoria") != null && request.getParameter("Categoria") != "" && !request.getParameter("Categoria").isEmpty())
            categoria = request.getParameter("Categoria");
        else
            categoria = Lista.getCategoria();
        if(request.getPart("file1") != null)
            filePart1 = request.getPart("file1");
        
            
        User temp = new User();
        
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

            if(filePart1.getContentType().contains("image/")){
                try{
                    String listsFolder = ObtainRootFolderPath(relativeListFolderPath);
                    String extension = getImageExtension(filePart1);
                    String imagineName = creator + "-" + nome + "." + extension;            
                    ImageDispatcher.DeleteImgFromDirectory(listsFolder+"/"+imagineName);
                    ImageDispatcher.InsertImgIntoDirectory(listsFolder, imagineName, filePart1);            
                    immagine = ImageDispatcher.savePathImgInDatabsae(relativeListFolderPath, imagineName);
                }catch(Exception e){
                    e.printStackTrace();
                    immagine = Lista.getImmagine();
                    System.out.println("Errore cambio immagine");
                }
            }else{
                immagine = Lista.getImmagine();
            }
        }else{
            Lista.setNome(nome);
            Lista.setDescrizione(descrizione);
            Lista.setCreator(creator);
            Lista.setCategoria(categoria);
        }

        try {

            //manda i dati del user, il metodo upate fa la parte statement 
            if (s.getAttribute("user") != null) {
                listdao.alterList((String) s.getAttribute("alterList"), nome, descrizione, immagine, creator, categoria);
            } else {
                s.setAttribute("guestList", Lista);
            }

        } catch (DAOException ex) {
            Logger.getLogger(RegisterAction.class.getName()).log(Level.SEVERE, null, ex);
        }
        if (Lista != null && s.getAttribute("user") != null) {
            regResult = true;
            s.setAttribute("regResult", regResult);         
        }
        s.setAttribute("regResult", false);
        response.sendRedirect(url);
    }
    
    public String SetImgName(String name, String extension) {

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
     *
     * @param relativePath se questa stringa è vuota allora il metodo
     * restituisce il percorso a "...Web/" altrimenti restituisce il percroso
     * alla cartella "...Web/[relativePath]" Esempio: relativePath =
     * "Image/AvatarImg"
     * @return web/Image/AvatarImg
     */
    public String ObtainRootFolderPath(String relativePath) {
        String folder = "";
        folder = relativePath;
        folder = getServletContext().getRealPath(folder);
        folder = folder.replace("\\build", "");
        return folder;
    }

}
