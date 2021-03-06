/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Products;

import database.daos.ListDAO;
import database.daos.ProductDAO;
import database.entities.Product;
import database.entities.User;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCProductDAO;
import database.jdbc.JDBCShopListDAO;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
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
 * @author Dmytr
 */
@MultipartConfig(maxFileSize = 16177215)
public class AddNewProductToDataBase extends HttpServlet {
    private static final long serialVersionUID = 6106269076155338045L;
    transient ListDAO listdao = null;
    transient ProductDAO productdao = null;

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
        HttpSession s =(HttpSession) request.getSession(false);
        Product nuovoProdotto = new Product();
        User user = (User) s.getAttribute("user");

        int pid = 0;
        String nome = "";
        String note= "";
        String categoria_prodotto= "";
        String immagine;
        String creator= "";

        try {
            nome = request.getParameter("NomeProdotto");

            note = request.getParameter("NoteProdotto");

            categoria_prodotto = request.getParameter("CategoriaProdotto");
            
            pid = productdao.lastPIDOfProducts();
            
        } catch (DAOException e) {
            System.out.println("ERRROREEEEE CATCH");
        }

        if (user != null) {
            if(user.getTipo().equals("amministratore")){
                nuovoProdotto.setCreator(user.getTipo());
            }else{
                nuovoProdotto.setCreator(user.getEmail());
            } 
        } else {
            creator = "ospite@lists.it";
        }

        String listsFolder = "/Image/ProductImg";
        String rp = "/Image/ProductImg";
        listsFolder = getServletContext().getRealPath(listsFolder);
        listsFolder = listsFolder.replace("\\build", "");
        File uploadDirFile = new File(listsFolder);
        String filename1 = "";
        Part filePart1 = request.getPart("ImmagineProdotto");
        if ((filePart1 != null) && (filePart1.getSize() > 0)) {

            String extension = Paths.get(filePart1.getSubmittedFileName()).getFileName().toString().split(Pattern.quote("."))[1];;
            String nomeIMG = Integer.toString(pid);

            filename1 = nomeIMG + "." + extension;
            filename1 = filename1.replaceAll("\\s+", "");
            File file1 = new File(uploadDirFile, filename1);
            try (InputStream fileContent = filePart1.getInputStream()) {
                Files.copy(fileContent, file1.toPath());
            }
        }

        immagine = rp + "/" + filename1;
        immagine = immagine.replaceFirst("/", "");
        immagine = immagine.replaceAll("\\s+", "");

        nuovoProdotto.setCategoria_prodotto(categoria_prodotto);
        nuovoProdotto.setImmagine(immagine);
        nuovoProdotto.setNome(nome);
        //nuovoProdotto.setPid(pid);
        nuovoProdotto.setNote(note);

        try {
            productdao.insert(nuovoProdotto);
        } catch (DAOException e) {
            System.out.println("EEEEEEEERRRRRRRROOEEEEEEEEEEEEEEEE");
        }

        response.sendRedirect(request.getContextPath() + "/Pages/ShowProducts.jsp");

    }

    /*public String setImgName(String name, String extension) {

        String s;
        s = name;
        s = s.trim();
        s = s.replace("@", "");
        s = s.replace(".", "");

        return s + "." + extension;
    }*/

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
