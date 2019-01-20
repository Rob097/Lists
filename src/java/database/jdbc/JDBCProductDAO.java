/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.jdbc;

import database.daos.ListDAO;
import database.daos.ProductDAO;
import database.entities.ListProd;
import database.entities.PeriodicProduct;
import database.entities.Product;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Martin
 */
public class JDBCProductDAO extends JDBCDAO implements ProductDAO {

    //costruttore per avere disponibile la connessione
    public JDBCProductDAO(Connection con) {
        super(con);
    }

    @Override
    public ArrayList<Product> getByID(Integer id) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM List WHERE creator = ?")) {
            ArrayList<Product> productLists = new ArrayList<>();

            stm.setString(1, id.toString());
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setPid(rs.getInt("PID"));
                    p.setNome(rs.getString("nome"));
                    p.setNote(rs.getString("note"));
                    p.setCategoria_prodotto(rs.getString("categoria_prod"));
                    p.setImmagine(rs.getString("immagine"));
                    p.setCreator(rs.getString("creator"));
                    productLists.add(p);
                }

                return productLists;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }
    }

    @Override
    public ArrayList<Product> getAllProducts() throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Product")) {
            ArrayList<Product> productLists = new ArrayList<>();

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setPid(rs.getInt("PID"));
                    p.setNome(rs.getString("nome"));
                    p.setNote(rs.getString("note"));
                    p.setCategoria_prodotto(rs.getString("categoria_prod"));
                    p.setImmagine(rs.getString("immagine"));
                    p.setCreator(rs.getString("creator"));
                    productLists.add(p);
                }

                return productLists;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of products", ex);
        }
    }

    @Override
    public ArrayList<Product> getByCategory(String category) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Product WHERE categoria_prod = ?")) {
            ArrayList<Product> productLists = new ArrayList<>();

            stm.setString(1, category);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setPid(rs.getInt("PID"));
                    p.setNome(rs.getString("nome"));
                    p.setNote(rs.getString("note"));
                    p.setCategoria_prodotto(rs.getString("categoria_prod"));
                    p.setImmagine(rs.getString("immagine"));
                    p.setCreator("creator");
                    productLists.add(p);
                }

                return productLists;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get bt category", ex);
        }
    }

    @Override
    public ArrayList<String> getAllProductCategories() throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT nome FROM Category_Product")) {

            ArrayList<String> prd = new ArrayList<String>();

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    prd.add(rs.getString("nome"));
                }

                return prd;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get bt category", ex);
        }
    }

    public void Insert(Product l) throws DAOException {
        if (l == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed user is null"));
        }

        String qry = "insert into Product(nome,note,categoria_prod,immagine,creator) "
                + "values(?,?,?,?,?)";

        try (PreparedStatement statement = CON.prepareStatement(qry)) {
            statement.setString(1, l.getNome());
            statement.setString(2, l.getNote());
            statement.setString(3, l.getCategoria_prodotto());
            statement.setString(4, l.getImmagine());
            statement.setString(5, l.getCreator());

            if (statement.executeUpdate()>0) {
                System.out.println("inserito");
            } else {
                throw new DAOException("Impossible to update the User");
            }

        } catch (SQLException ex) {
            throw new DAOException(ex);

        }

    }
    
    @Override
    public void GuestInsert(int Pid, String creator, String nomeLista, String status) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("insert into guestListProd(creator, prodotto, nomeLista, status) values(?,?,?,?)")){
            
            
            try{
                stm.setString(1, creator);
                stm.setInt(2, Pid);
                stm.setString(3, nomeLista);
                stm.setString(4, status);
                
                if (stm.executeUpdate() == 1) {
                    System.out.println("INSERITO");
                } else {
                    throw new DAOException("Impossible to insert the Guest Product");
                }

            } catch (SQLException ex) {
                throw new DAOException(ex);
            }
            
        } catch (SQLException ex) {
            throw new DAOException("Impossible to update the Products #2", ex);
        }

    }

    @Override
    public int LastPIDOfProducts() throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT PID FROM Product ORDER BY PID DESC LIMIT 1")) {

            int pid = 0;

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    pid = rs.getInt("PID");
                }

                return pid + 1;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get bt category", ex);
        }
    }
    
    @Override
    public void Delete(Product l) throws DAOException {
        if (l == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed product is null"));
        }

        String qry = "delete from Product where PID=?";

        try (PreparedStatement statement = CON.prepareStatement(qry)) {
            statement.setInt(1, l.getPid());

            if (statement.executeUpdate() > 0) {
                System.out.println("cancellato");
            } else {
                throw new DAOException("Impossible to delete the product");
            }

        } catch (SQLException ex) {
            throw new DAOException(ex);

        }

    }
    
    @Override
    public Product getProductByID(int id) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Product WHERE PID = ?")) {
            
            Product p = new Product();
            
            stm.setInt(1, id);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    
                    p.setPid(rs.getInt("PID"));
                    p.setNome(rs.getString("nome"));
                    p.setNote(rs.getString("note"));
                    p.setCategoria_prodotto(rs.getString("categoria_prod"));
                    p.setImmagine(rs.getString("immagine"));
                    p.setCreator(rs.getString("creator"));
                }

                return p;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }
    }

    @Override
    public ArrayList<Product> getGuestsProducts(String email) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("select * from Product INNER JOIN guestListProd ON Product.PID=guestListProd.prodotto where guestListProd.creator = ?")) {
            ArrayList<Product> productLists = new ArrayList<>();
            stm.setString(1, email);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setPid(rs.getInt("PID"));
                    p.setNome(rs.getString("nome"));
                    p.setNote(rs.getString("note"));
                    p.setCategoria_prodotto(rs.getString("categoria_prod"));
                    p.setImmagine(rs.getString("immagine"));
                    p.setStatus(rs.getString("status"));
                    productLists.add(p);
                }

                return productLists;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }
    }

    

    @Override
    public ArrayList<Product> nameContian(String s, HttpServletRequest request) throws DAOException {
        HttpSession session = request.getSession(false);
        ArrayList<Product> a = getallAdminProducts();
        ArrayList<Product> b = new ArrayList();
        boolean check = false;
        for(Product p : a){
            if(p.getNome().toLowerCase().contains(s.toLowerCase()) && session.getAttribute(p.getNome()) == null){
                b.add(p);
                session.setAttribute(p.getNome(), p.getNome());
            }
        }
        return b;
    }

    @Override
    public ArrayList<Product> getallAdminProducts() throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM Product where creator = ?")) {
            stm.setString(1, "amministratore");
            
            ArrayList<Product> productLists = new ArrayList<>();
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setPid(rs.getInt("PID"));
                    p.setNome(rs.getString("nome"));
                    p.setNote(rs.getString("note"));
                    p.setCategoria_prodotto(rs.getString("categoria_prod"));
                    p.setImmagine(rs.getString("immagine"));
                    p.setCreator(rs.getString("creator"));
                    productLists.add(p);
                }

                return productLists;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of adminproducts", ex);
        }
    }

    @Override
    public int LastPIDforInsert(Product p) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT PID FROM Product WHERE nome = ? AND creator = ? ORDER BY PID DESC LIMIT 1")) {
            stm.setString(1, p.getNome());
            stm.setString(2, p.getCreator());
            
            int pid = 0;
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    pid = rs.getInt("PID");
                }
                return pid;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get bt category", ex);
        }
    }

    @Override
    public int getQuantity(int idProd, String listName) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("select quantita from List_Prod where prodotto = ? and lista = ?")) {
            stm.setInt(1, idProd);
            stm.setString(2, listName);
            int quantita = 1;
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    quantita = rs.getInt("quantita");
                }
                return quantita;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get bt category", ex);
        }
    }

    @Override
    public void updateQuantity(int quantita, int idProd, String listName) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("update List_Prod set quantita = ? where prodotto = ? and lista = ?")){
          
            try{
                stm.setInt(1, quantita);
                stm.setInt(2, idProd);
                stm.setString(3, listName);
                
                if (stm.executeUpdate() == 1) {
                    System.out.println("Qty Updt");
                } else {
                    throw new DAOException("Impossible to update quantity");
                }

            } catch (SQLException ex) {
                throw new DAOException(ex);
            }
            
        } catch (SQLException ex) {
            throw new DAOException("Impossible to update quantity #2", ex);
        }
    }

    @Override
    public ArrayList<ListProd> getAllChoosenProducts() throws DAOException {
        
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM List_Prod")) {           
            
            ArrayList<ListProd> listProdlink = new ArrayList<ListProd>();
            
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    
                    ListProd link = new ListProd();
                    link.setLista(rs.getString("lista"));
                    link.setProdotto(rs.getString("prodotto"));
                    link.setData_scadenza(rs.getDate("data_Scadenza"));
                    link.setData_inserimento(rs.getDate("data_inserimento"));
                    link.setStato(rs.getString("stato"));
                    link.setDataAcquisto(rs.getDate("data_acquisto"));
                    link.setQuantita(rs.getString("quantita"));

                    listProdlink.add(link);
                }

                return listProdlink;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of products", ex);
        }
    }

    @Override
    public void insertPeriodicProducts(int[] pids, String shopListName, int period, Date initday) throws DAOException {
        java.sql.Date sqlinitday = new java.sql.Date(initday.getTime());
        System.out.println("sql: " + sqlinitday);
        System.out.println("date: "+ initday);
        for(int pid : pids){
           try(PreparedStatement stm = CON.prepareStatement("Insert into Periodic_Products (lista, prodotto, data_scadenza, periodo) values (?,?,?,?)")){
               stm.setString(1, shopListName);
               stm.setInt(2, pid);
               stm.setDate(3, sqlinitday);
               stm.setInt(4, period);
               
               if (stm.executeUpdate() == 1) {
                    
                } else {
                    throw new DAOException("Impossible to insert periodic product");
                }               
               
           } catch (SQLException ex) {
                Logger.getLogger(JDBCProductDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    @Override
    public ArrayList<Product> getPeriodicProducts(String shopListName) throws DAOException {
        ArrayList<Product> productLists = new ArrayList<>();
        
        try(PreparedStatement stm = CON.prepareStatement("SELECT * FROM Product where PID IN (Select prodotto from Periodic_Products where lista = ?)")){
            stm.setString(1, shopListName);            
            
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setPid(rs.getInt("PID"));
                    p.setNome(rs.getString("nome"));
                    p.setNote(rs.getString("note"));
                    p.setCategoria_prodotto(rs.getString("categoria_prod"));
                    p.setImmagine(rs.getString("immagine"));
                    p.setCreator(rs.getString("creator"));
                    productLists.add(p);
                }                
                
            }
            
        } catch (SQLException ex) {
            Logger.getLogger(JDBCProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return productLists;
    }

    @Override
    public void deletePeriodicProducts(int[] pids, String shopListName) throws DAOException {
        
        for(int pid : pids){
          try (PreparedStatement statement = CON.prepareStatement("delete from Periodic_Products where lista = ? and prodotto = ?")){
                statement.setString(1, shopListName);
                statement.setInt(2, pid);
                
                if (statement.executeUpdate() > 0) {
                    
                } else {
                    throw new DAOException("Impossible to delete the product");
                }
                
            } catch (SQLException ex) {
                Logger.getLogger(JDBCProductDAO.class.getName()).log(Level.SEVERE, null, ex);
            }  
        }
        
    }

    @Override
    public ArrayList<PeriodicProduct> getAllPeriodicProducts() throws DAOException {
         ArrayList<PeriodicProduct> list = new ArrayList<>();
         
        try (PreparedStatement statement = CON.prepareStatement("Select * from Periodic_Products")){
            try(ResultSet rs = statement.executeQuery()){               
                PeriodicProduct p;
                while(rs.next()){
                    p = new PeriodicProduct();
                    p.setLista(rs.getString("lista"));
                    p.setProdotto(rs.getInt("prodotto"));
                    p.setData_scadenza(rs.getDate("data_scadenza"));
                    p.setPeriodo(rs.getInt("periodo"));
                    list.add(p);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(JDBCProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    @Override
    public void updatePeriodicDate(PeriodicProduct pp, java.sql.Date newDate) throws DAOException {
        if (pp == null || newDate==null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed product or date is null"));
        }
        try(PreparedStatement stm = CON.prepareStatement("UPDATE Periodic_Products SET data_scadenza=? WHERE lista=? and prodotto=?")){
            stm.setDate(1, newDate);
            stm.setString(2, pp.getLista());
            stm.setInt(3, pp.getProdotto());
            if(stm.executeUpdate() == 1){
                return;
            }else{
                throw new DAOException("impossible update date");
            }
        } catch (SQLException ex) {
            Logger.getLogger(JDBCProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }   
    
    @Override
    public String getReminderDate(Product p, String lista)throws DAOException{
        
        Date dateReminder = null;
        String dataStr = "";
        try (PreparedStatement statement = CON.prepareStatement("Select * from List_Prod where prodotto=? AND lista=?")){
            statement.setInt(1, p.getPid());
            statement.setString(2, lista);
            try(ResultSet rs = statement.executeQuery()){  
                while (rs.next()) {
                    dateReminder = rs.getDate("data_scadenza");
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    dataStr = sdf.format(dateReminder);          
                }
                //sessione.setAttribute("reminder-lista-"+p.getPid(), dataStr);
            }
        }catch (SQLException ex) {
            Logger.getLogger(JDBCProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return dataStr;
    }
    
    @Override
    public void updateReminder(int id, String lista, String data)throws DAOException{
        try(PreparedStatement stm = CON.prepareStatement("UPDATE List_Prod SET data_scadenza=? WHERE lista=? and prodotto=?")){
            Date date1=new SimpleDateFormat("yyyy-MM-dd").parse(data);
            java.sql.Date sqlExpireDate = new java.sql.Date(date1.getTime());
            stm.setDate(1, sqlExpireDate);
            stm.setString(2, lista);
            stm.setInt(3, id);
            if(stm.executeUpdate() == 1){
            }else{
                throw new DAOException("impossible update date");
            }
        } catch (SQLException ex) {
            Logger.getLogger(JDBCProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ParseException ex) {
            Logger.getLogger(JDBCProductDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
