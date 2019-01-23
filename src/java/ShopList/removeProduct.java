/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ShopList;

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
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author della
 */
public class removeProduct extends HttpServlet {

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
        //Dichiarazioni
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        ListDAO listdao = new JDBCShopListDAO(daoFactory.getConnection());
        ProductDAO productdao = new JDBCProductDAO(daoFactory.getConnection());
        NotificationDAO notificationdao = new JDBCNotificationsDAO(daoFactory.getConnection());
        HttpSession s = (HttpSession) request.getSession();
        int prodotto = 0; String lista = ""; ShopList sl; ArrayList<Product> prod = null;
        
        if(request.getParameter("prodotto") != null) prodotto = Integer.parseInt(request.getParameter("prodotto"));
        if(s.getAttribute("shopListName") != null && s.getAttribute("user") != null) 
            lista = (String) "" + s.getAttribute("shopListName");
        else{
            sl = (ShopList) s.getAttribute("guestList");
            prod = (ArrayList<Product>) s.getAttribute("prodottiGuest");
        }
        if(s.getAttribute("user") != null){ 
            try {
               listdao.removeProductToList(prodotto, lista);
               Product product =  productdao.getProductByID(prodotto);

                if(!product.getCreator().equals("amministratore")){
                    productdao.Delete(product);
                    if(product.getImmagine() != null && !(product.getImmagine().equals(""))){  
                        String listsFolder = "";
                        listsFolder = getServletContext().getRealPath(listsFolder);
                        listsFolder = listsFolder.replace("\\build", "");
                        String imgfolder = product.getImmagine().replace("/Image/ProductImg", "");
                        ImageDispatcher.DeleteImgFromDirectory(listsFolder + imgfolder); 
                    }
                }

            } catch (DAOException ex) {
                System.out.println("impossibile eliminare il prodotto "+prodotto+" dalla lista "+lista);
                Logger.getLogger(removeProduct.class.getName()).log(Level.SEVERE, null, ex);
            }

            //utenti con cui la lista è condivisa
            ArrayList<User> utenti = new ArrayList();
            try {
                utenti = notificationdao.getUsersWithWhoTheListIsShared(lista);             
            } catch (DAOException ex) {
                Logger.getLogger(AddProductToList.class.getName()).log(Level.SEVERE, null, ex);
            } 
            User utente = (User) s.getAttribute("user");
            try {
                for(User u : utenti){
                    //System.out.println("Nome: "+u.getNominativo() + "\nlista: " + lista);
                    if(!u.getEmail().equals(utente.getEmail())){
                        notificationdao.addNotification(u.getEmail(), "remove_product", lista);
                    }
                }
            } catch (DAOException ex) {
                Logger.getLogger(AddProductToList.class.getName()).log(Level.SEVERE, null, ex);
            }            
        }else{
            for(Product u : prod){
                if(u.getPid() == prodotto)
                    prod.remove(u);
            }            
        }
        
        response.sendRedirect("/Lists/Pages/ShowUserList.jsp");
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
