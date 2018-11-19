/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Products;

import Tools.ImageDispatcher;
import database.daos.ListDAO;
import database.daos.NotificationDAO;
import database.daos.ProductDAO;
import database.entities.Product;
import database.entities.ShopList;
import database.entities.User;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCNotificationsDAO;
import database.jdbc.JDBCProductDAO;
import database.jdbc.JDBCShopListDAO;
import java.io.IOException;
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

/**
 *
 * @author Martin
 */
@MultipartConfig(maxFileSize = 16177215)
public class CreateAndAddProduct extends HttpServlet {

    ListDAO listdao = null;
    ProductDAO productdao = null;
    NotificationDAO notificationdao = null;
    
    @Override
    public void init() throws ServletException {
        //carica la Connessione inizializzata in JDBCDAOFactory, quindi ritorna il Class.for() e la connessione
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        //assegna a userdao la connessione(costruttore) e salva la connessione in una variabile tipo Connection
        listdao = new JDBCShopListDAO(daoFactory.getConnection());
        productdao = new JDBCProductDAO(daoFactory.getConnection());
        notificationdao = new JDBCNotificationsDAO(daoFactory.getConnection());

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //variablili iniziali
        HttpSession session = (HttpSession) request.getSession(false);
        User user = (User) session.getAttribute("user");
        ShopList list = (ShopList) session.getAttribute("shoplist");
        Product newProduct = new Product();
        
        //-->##INSERIMENTO NEL DATABASE##<--
        //settare le variabili
        newProduct.setNome(request.getParameter("NomeProdotto"));
        newProduct.setNote(request.getParameter("NoteProdotto"));
        newProduct.setCategoria_prodotto(request.getParameter("CategoriaProdotto"));
        if (user != null) {
            newProduct.setCreator(user.getEmail());
        }
        
        int pid = 0;
        try {
            pid = productdao.LastPIDOfProducts();
        } catch (DAOException ex) {
            Logger.getLogger(CreateAndAddProduct.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        //##Immagine##
        Part filePart1 = request.getPart("ImmagineProdotto");
        if ((filePart1 != null) && (filePart1.getSize() > 0)){
            String listsFolder = "/Image/ProductImg";
            listsFolder = getServletContext().getRealPath(listsFolder);
            listsFolder = listsFolder.replace("\\build", "");
            String extension = Paths.get(filePart1.getSubmittedFileName()).getFileName().toString().split(Pattern.quote("."))[1];
            String nomeIMG = Integer.toString(pid);
            String filename1 = nomeIMG + "." + extension;
            ImageDispatcher.InsertImgIntoDirectory(listsFolder, filename1, filePart1);
            
            String immagine = "Image/ProductImg/" + filename1;
            immagine = immagine.replaceAll("\\s+", "");
            newProduct.setImmagine(immagine);
        }
         //##fineImmagine##
         //inserimetno prodotto 
        try {
            productdao.Insert(newProduct);
            System.out.println("entra in insert product");
        } catch (DAOException ex) {
            Logger.getLogger(CreateAndAddProduct.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println("errore insert product");
        }
        //-->##INSERIMENTO NELLA LISTA##<--
        ArrayList<User> utenti;
        try { 
            utenti = notificationdao.getUsersWithWhoTheListIsShared(list.getNome());
            pid = productdao.LastPIDforInsert(newProduct);
            listdao.insertProductToList(pid, list.getNome());
            System.out.println("++++"+pid+"+++++");
            for(User u : utenti){
                if(!u.getEmail().equals(user.getEmail())){
                    notificationdao.addNotification(u.getEmail(), "new_product", list.getNome());
                }
            }
            
        } catch (DAOException ex) {
            Logger.getLogger(CreateAndAddProduct.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        response.sendRedirect(request.getContextPath() +"/Pages/ShowUserList.jsp");
        

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
