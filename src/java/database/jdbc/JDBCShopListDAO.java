/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.jdbc;

import database.daos.ListDAO;
import database.entities.ListProd;
import database.entities.PeriodicProduct;
import database.entities.Product;
import database.entities.ShopList;
import database.entities.User;
import database.exceptions.DAOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Martin
 */
public class JDBCShopListDAO extends JDBCDAO implements ListDAO {

    //costruttore per avere disponibile la connessione
    public JDBCShopListDAO(Connection con) {
        super(con);
    }

    @Override
    public ArrayList<ShopList> getByEmail(String email) throws DAOException {
        if(email==null){
          throw new DAOException("Email is a mandatory fields", new NullPointerException("email is null"));
        }
        
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM List WHERE creator = ?")) {
            stm.setString(1, email);
            
            ArrayList<ShopList> shoppingLists = new ArrayList<>();
            
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    ShopList sL = new ShopList();
                    sL.setNome(rs.getString("nome"));
                    sL.setDescrizione(rs.getString("descrizione"));
                    sL.setImmagine(rs.getString("immagine"));
                    sL.setCreator(rs.getString("creator"));
                    sL.setCategoria(rs.getString("categoria"));
                    sL.setPromemoria(rs.getInt("reminder"));
                    sL.setSharedUsers(getUsersWithWhoTheListIsShared(sL));

                    shoppingLists.add(sL);
                }

                return shoppingLists;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the shoppinglist", ex);
        }
    }

    @Override
    public ArrayList<User> getUsersWithWhoTheListIsShared(ShopList list) throws DAOException {
        if(list==null){
          throw new DAOException("Shoppinglist is a mandatory fields", new NullPointerException("list is null"));
        }
        try (PreparedStatement stm = CON.prepareStatement("select email from User where email in (select user from User_List where list = ?)")) {
            stm.setString(1, list.getNome());
            
            ArrayList<User> userList = new ArrayList<>();
            
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setEmail(rs.getString("email"));

                    userList.add(u);
                }

                return userList;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get shared users", ex);
        }
    }

    @Override
    public ArrayList<User> getUsersWithWhoTheListIsShared(String listname) throws DAOException {
        if(listname==null){
          throw new DAOException("listname is a mandatory fields", new NullPointerException("listname is null"));
        }
        try (PreparedStatement stm = CON.prepareStatement("select * from User where email in (select user from User_List where list = ?)")) {
            stm.setString(1, listname);
            
            ArrayList<User> userList = new ArrayList<>();
            
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setEmail(rs.getString("email"));
                    u.setNominativo(rs.getString("nominativo"));
                    u.setImage(rs.getString("immagine"));
                    u.setTipo(rs.getString("tipo"));
                    userList.add(u);
                }

                return userList;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }
    }

    @Override
    public ShopList Insert(ShopList list) throws DAOException {
        if (list == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed shoppinglist is null"));
        }

        String qry = "insert into List(nome,descrizione,immagine,creator,categoria) "
                + "values(?,?,?,"
                + "(select email from User where email = ?),"
                + "(select nome from Category where nome = ?))";

        try (PreparedStatement statement = CON.prepareStatement(qry)) {
            statement.setString(1, list.getNome());
            statement.setString(2, list.getDescrizione());
            statement.setString(3, list.getImmagine());
            statement.setString(4, list.getCreator());
            statement.setString(5, list.getCategoria());

            if (statement.executeUpdate() == 1) {
                return list;
            } else {
                throw new DAOException("Impossible to insert the List");
            }
        } catch (SQLException ex) {
            throw new DAOException(ex);
        }
    }
    
    @Override
    public ShopList GuestSave(ShopList l, String creator, String password) throws DAOException{
        if (l == null || creator == null || password == null) {
            throw new DAOException("parameters not valid", new IllegalArgumentException("The passed list or creator or password is null"));
        }

        String qry = "insert into guestLists(nome,descrizione,immagine,creator,password,categoria) "
                + "values(?,?,?,?,?,?,?)";

        try (PreparedStatement statement = CON.prepareStatement(qry)) {
            statement.setString(1, l.getNome());
            statement.setString(2, l.getDescrizione());
            statement.setString(3, l.getImmagine());
            statement.setString(4, creator);
            statement.setString(5, password);
            statement.setString(6, l.getCategoria());
            statement.setInt(7, l.getPromemoria());

            if (statement.executeUpdate() == 1) {
                return l;
            } else {
                throw new DAOException("Impossible to insert the GuestList");
            }
        } catch (SQLException ex) {
            throw new DAOException(ex);
        }
    }

    @Override
    public ArrayList<ShopList> getListOfShopListsThatUserLookFor(String email) throws DAOException {
        if (email == null) {
            throw new DAOException("parameters not valid", new IllegalArgumentException("The passed email is null"));
        }
        
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM List WHERE nome IN (SELECT list FROM User_List where user = ?)")) {
            stm.setString(1, email);
            
            ArrayList<ShopList> shoppingLists = new ArrayList<>();
            
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    ShopList sL = new ShopList();
                    sL.setNome(rs.getString("nome"));
                    sL.setDescrizione(rs.getString("descrizione"));
                    sL.setImmagine(rs.getString("immagine"));
                    sL.setCreator(rs.getString("creator"));
                    sL.setCategoria("categoria");
                    sL.setPromemoria(rs.getInt("reminder"));
                    sL.setSharedUsers(getUsersWithWhoTheListIsShared(sL));

                    shoppingLists.add(sL);
                }

                return shoppingLists;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of Lists", ex);
        }
    }

    @Override
    public ArrayList<Product> getAllProductsOfShopList(String name) throws DAOException {
        if (name == null) {
            throw new DAOException("parameters not valid", new IllegalArgumentException("The passed name is null"));
        }
        
        try (PreparedStatement stm = CON.prepareStatement("select * from Product where PID in (select prodotto from List_Prod where lista = ?)")) {
            stm.setString(1, name);
            
            ArrayList<Product> productLists = new ArrayList<>();
            
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {

                    Product sL = new Product();
                    String n = rs.getString("nome");
                    sL.setNome(n);
                    sL.setCategoria_prodotto(rs.getString("categoria_prod"));
                    sL.setPid(rs.getInt("PID"));
                    sL.setNote(rs.getString("note"));
                    sL.setImmagine(rs.getString("immagine"));

                    productLists.add(sL);
                }

                return productLists;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of products", ex);
        }
    }

    @Override
    public void insertSharedUser(String email, String nomeLista) throws DAOException {
        if (email == null || nomeLista == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed email or listname is null"));
        }

        try (PreparedStatement stm = CON.prepareStatement("INSERT INTO User_List VALUES (?,?, 'Read')")) {
            stm.setString(1, email);
            stm.setString(2, nomeLista);

            if (stm.executeUpdate() == 1) {
                return;
            } else {
                throw new DAOException("Impossible to insert the user");
            }
        } catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public void deleteList(String list) throws DAOException {
        if (list == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed list is null"));
        }
        
        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM User_List WHERE list=?")) {
            stm.setString(1, list);
            System.out.println(list);
            if(stm.executeUpdate()>0){
                
            }else{
                System.out.println("Impossible to delete the list");
            }
            
        } catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM List_Prod WHERE lista=?")) {
            stm.setString(1, list);
            
            if (stm.executeUpdate() >0) {
                
            } else {
                System.out.println("Impossible to Delete the List");
            }
            
        } catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM List WHERE nome=?")) {
            stm.setString(1, list);
            
            if (stm.executeUpdate() >0) {
                
            } else {
                System.out.println("Impossible to Delete the List");
            }            
        } catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public ShopList getbyName(String nome) throws DAOException {
        if (nome == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed name is null"));
        }
        
        ShopList sL = new ShopList();
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM List where nome=?")) {
            stm.setString(1, nome);
            
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    
                    sL.setNome(rs.getString("nome"));
                    sL.setDescrizione(rs.getString("descrizione"));
                    sL.setImmagine(rs.getString("immagine"));
                    sL.setCreator(rs.getString("creator"));
                    sL.setCategoria(rs.getString("categoria"));
                    sL.setPromemoria(rs.getInt("reminder"));
                    sL.setSharedUsers(getUsersWithWhoTheListIsShared(sL));
                    
                }
            } catch (SQLException ex) {
                Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        } catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return sL;
    }

    @Override
    public ArrayList<String> getAllListsByCurentUser(String nome) throws DAOException {
        if (nome == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed name is null"));
        }
        
        ArrayList<String> liste = new ArrayList<>();
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM List where creator=?")) {
            stm.setString(1, nome);
            
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    
                    liste.add(rs.getString("nome"));
                    
                }
            } catch (SQLException ex) {
                Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        } catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM User_List where user=?")) {
            stm.setString(1, nome);
            
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    
                    liste.add(rs.getString("list"));
                    
                }
            } catch (SQLException ex) {
                Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        } catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return liste;
    }

    @Override
    public void insertProductToList(int prodotto, String lista, String data) throws DAOException {
        
            if (lista == null) {
                throw new DAOException("parameter not valid", new IllegalArgumentException("The passed listname is null"));
            }
            Date date1 = null;
            Date date2 = null;
            try {
                SimpleDateFormat dformat = new SimpleDateFormat("yyyy-MM-dd");
                Date datetdy = new Date();
                date2 = new SimpleDateFormat("yyyy-MM-dd").parse(dformat.format(datetdy));
            } catch (ParseException ex) {
                Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
                try {
                date1=new SimpleDateFormat("yyyy-MM-dd").parse(data);
                } catch (ParseException ex) {
                Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
                }
            
            java.sql.Date sqlExpireDate = new java.sql.Date(date1.getTime());
            java.sql.Date sqlInsertDate = new java.sql.Date(date2.getTime());
            
            
            
            try (PreparedStatement stm = CON.prepareStatement("INSERT INTO List_Prod VALUES (?,?,?,?,'daAcquistare', 1, null)")) {
            stm.setString(1, lista);
            stm.setInt(2, prodotto);
            stm.setDate(3, sqlExpireDate);
            stm.setDate(4, sqlInsertDate);
            
            if (stm.executeUpdate() == 1) {
            return;
            } else {
            throw new DAOException("Impossible to insert the product");
            }
            } catch (SQLException ex) {
                Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
            }     
        
    }
    
    @Override
    public void insertProductToGuestList(int prodotto, String status, HttpServletRequest request) throws DAOException {
        if (status == null || request == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed status or request is null"));
        }
        
        try (PreparedStatement stm = CON.prepareStatement("select * from Product where PID = ?")) {
            stm.setInt(1, prodotto);
            
            HttpSession s = (HttpSession) request.getSession(false);
            ArrayList <Product> productLists = new ArrayList();
            if(s.getAttribute("prodottiGuest") != null){
                productLists = (ArrayList<Product>) s.getAttribute("prodottiGuest");
            }            
            
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    
                    Product sL = new Product();
                    String n = rs.getString("nome");
                    sL.setNome(n);
                    sL.setCategoria_prodotto(rs.getString("categoria_prod"));
                    sL.setPid(rs.getInt("PID"));
                    sL.setNote(rs.getString("note"));
                    sL.setImmagine(rs.getString("immagine"));
                    sL.setStatus(status);
                    productLists.add(sL);
                    s.setAttribute("prodottiGuest", productLists);
                    
                }
            }catch (SQLException ex) {
                throw new DAOException("Impossible to insert the product in the guest list", ex);
            }            
        } catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
        }        
    }

    @Override
    public ArrayList<ShopList> getAllSharedList(String email) throws DAOException {
        if (email == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed email is null"));
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM User_List INNER JOIN List ON User_List.list=List.nome where user = ?")) {
            stm.setString(1, email);
            
            ArrayList<ShopList> shoppingLists = new ArrayList<>();
            
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    
                    ShopList sL = new ShopList();
                    sL.setNome(rs.getString("nome"));
                    sL.setDescrizione(rs.getString("descrizione"));
                    sL.setImmagine(rs.getString("immagine"));
                    sL.setCreator(rs.getString("creator"));
                    sL.setCategoria(rs.getString("categoria"));
                    sL.setPromemoria(rs.getInt("reminder"));
                    sL.setSharedUsers(getUsersWithWhoTheListIsShared(sL));

                    shoppingLists.add(sL);
                }
                return shoppingLists;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the shared lists", ex);
        }
    }

    @Override
    public void deleteSharedUser(String email, String listname) throws DAOException {
        if (email == null || listname == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed email or listname is null"));
        }
        
        try(PreparedStatement statement = CON.prepareStatement("DELETE FROM User_List WHERE user=? AND list=?")){
            statement.setString(1, email);
            statement.setString(2, listname);
            
            if(statement.executeUpdate() > 0){
                return;
            }else{
                throw new DAOException("Impossible to delete the user");
            }
        } catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println("Problems with deleting shared user");
        }
    }

    @Override
    public ShopList getGuestList(String email, String password) throws DAOException {
        if (email == null || password == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed email or password is null"));
        }
        
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM guestLists WHERE creator =? and password = ?")) {
            stm.setString(1, email);
            stm.setString(2, password);
            
            ShopList shoppingLists = new ShopList();
            
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    
                    shoppingLists.setNome(rs.getString("nome"));
                    shoppingLists.setDescrizione(rs.getString("descrizione"));
                    shoppingLists.setImmagine(rs.getString("immagine"));
                    shoppingLists.setCreator(rs.getString("creator"));
                    shoppingLists.setCategoria("categoria");
                    shoppingLists.setPromemoria(rs.getInt("reminder"));
                    
                }
                return shoppingLists;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the GuestList", ex);
        }
    }

    @Override
    public void checkIfGuestListExistInDatabase(String creator, String password) throws DAOException {
        if (creator == null || password == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed creator or password is null"));
        }
        
        boolean check = false;
        try (PreparedStatement stm = CON.prepareStatement("select * from guestLists where creator = ? and password = ?")) {
            stm.setString(1, creator);
            stm.setString(2, password);

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    check = true;
                }
            }catch (SQLException ex) {
                Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            if(check){
                try (PreparedStatement stm1 = CON.prepareStatement("DELETE FROM guestLists WHERE creator=? and password = ?")) {                    
                    stm1.setString(1, creator);
                    stm.setString(2, password);
                    
                    if (stm1.executeUpdate() == 1) {
                        
                    } else {
                        throw new DAOException("Impossible to delete the GuestList");
                    }         
                } catch (SQLException ex) {
                    Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
                }
            }            
        } catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public void deleteGuestListFromDB(String creator) throws DAOException {
        if (creator == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed creator is null"));
        }
        
        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM guestLists WHERE creator=?")) {
            stm.setString(1, creator);
            
            if(stm.executeUpdate() >0){
                return;
            }else{
                throw new DAOException("impossible to delete guest list");
            }
            
        } catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public void removeProductToList(int prodotto, String lista) throws DAOException {
        if (lista == null || prodotto ==0) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed product or list is null"));
        }

        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM List_Prod WHERE lista = ? AND prodotto = ?")) {
            stm.setString(1, lista);
            stm.setInt(2, prodotto);

            if (stm.executeUpdate() == 1) {
                System.out.println("successful operation");
            } else {
                throw new DAOException("Impossible to delete the product from a list");
            }
            
        } catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public void removeALLProductToList(String lista) throws DAOException {
        if (lista == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed list is null"));
        }

        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM List_Prod WHERE lista = ?")) {
            stm.setString(1, lista);

            if (stm.executeUpdate() == 1) {
                return;
            } else {
                throw new DAOException("Impossible to remove all products");
            }
            
        } catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public String checkRole(String user, String list) throws DAOException {
        if (list == null || user == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed list or user is null"));
        }
        
        String role = "";
        try (PreparedStatement stm = CON.prepareStatement("select * from List where nome = ?")) {
            stm.setString(1, list);

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    if(rs.getString("creator").equals(user)){
                        role = "creator";
                    }else {
                        try (PreparedStatement stm1 = CON.prepareStatement("select role from User_List where user = ? AND list = ?")) {
                            stm1.setString(1, user);
                            stm1.setString(2, list);

                            try (ResultSet rs1 = stm1.executeQuery()) {
                                while (rs1.next()) {
                                    role = rs1.getString("role");
                                }
                            } catch (SQLException ex) {
                                Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
                            }
                        } catch (SQLException ex) {
                            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
                        }
                    }
                }
            }catch (SQLException ex) {
                Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        } catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return role;
    }

    @Override
    public boolean chckIfProductIsInTheList(int id, String list) throws DAOException {
                
        try (PreparedStatement stm = CON.prepareStatement("select * from Product where PID in (select prodotto from List_Prod where lista = ? AND PID = ?)")) {            
            stm.setString(1, list);
            stm.setInt(2, id);
            
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                   return true;
                }
                return false;
            }
        } catch (SQLException ex) {            
            throw new DAOException("Impossible to check if product is in th list", ex);
        }
    }

    @Override
    public void signProductAsBuyed(int id, String tipo, String lista) throws DAOException {
        if (tipo == null || lista == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed list or type is null"));
        }
        
        try (PreparedStatement statement = CON.prepareStatement("UPDATE List_Prod SET stato=? WHERE lista=?  AND prodotto= ?")) {
            statement.setString(1, tipo);
            statement.setString(2, lista );
            statement.setInt(3, id);
            
            if(statement.executeUpdate() >0){
                return;
            }else{
                throw new DAOException("impossible to sign product as buyed");
            }
        } catch (SQLException ex) {
            Logger.getLogger(JDBCUserDAO.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println("errore update product status");
        }
    }

    @Override
    public boolean checkBuyed(int id, String lista, HttpSession s) throws DAOException {
        if (lista == null || s == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed list or session is null"));
        }
        
        ArrayList<Product> p = new ArrayList<>();
        boolean check = false;
        
        if(s.getAttribute("user") != null){
            try (PreparedStatement stm = CON.prepareStatement("select stato from List_Prod where lista = ? AND prodotto = ?")) {
                stm.setString(1, lista);
                stm.setInt(2, id);
                
                try (ResultSet rs = stm.executeQuery()) {
                    while (rs.next()) {
                        if(rs.getString("stato").equals("acquistato")) return true;
                    }

                    return false;
                }
            } catch (SQLException ex) {            
                throw new DAOException("Impossible to check if product is in th list", ex);
            }
        }else{
            if (s.getAttribute("prodottiGuest") != null) {
                p = (ArrayList<Product>) s.getAttribute("prodottiGuest");
            }
            for(Product pp : p){
                if(pp.getPid() == id){
                    System.out.println("stato: " + pp.getStatus());
                    if(pp.getStatus() != null){
                        if(pp.getStatus().equals("acquistato")) return true;
                    }
                }
            }
            return false;
        }
    }

    @Override
    public void changeStatusOfAllProduct(String tipo, String lista) throws DAOException {
        if (tipo == null || lista == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed type or list is null"));
        }
        
        ArrayList<Product> p = getAllProductsOfShopList(lista);
        
        int id;
        for(Product pp : p){
            id = pp.getPid();
            try (PreparedStatement statement = CON.prepareStatement("UPDATE List_Prod SET stato=? WHERE lista=?  AND prodotto= ?")) {
                statement.setString(1, tipo);
                statement.setString(2, lista );
                statement.setInt(3, id);
                
                statement.executeUpdate();
            } catch (SQLException ex) {
                Logger.getLogger(JDBCUserDAO.class.getName()).log(Level.SEVERE, null, ex);
                System.out.println("errore update product status");
            }
        }
    }
    
    
    /**questo metodo prende in input una lista della spesa e restituisce
     * LsitProd: cioè i prodotto acquistati e non acquistati
     * successivamente sarà elaborato un metodo che distingue tra i prodotti acquistati e non
     * 
     * lista
     * prodotto
     * data_scadenza
     * data_inserimento
     * stato
     * data_acquisto
     * quantita
     * 
     * il metodo è stato creato per verificare le preferenze di un cliente per una certa lista
     * e con quale frequenza compra un certo prodotto
     * 
     * @param listaname
     * @return
     * @throws DAOException 
     */
    @Override
    public ArrayList<ListProd> getProdList(String listaname) throws DAOException {
        if (listaname == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed listname is null"));
        }
        
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM List_Prod WHERE lista = ?")) {
            stm.setString(1, listaname);
            
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
    public void changeGuestProductsStatus(int id, String tipo, HttpServletRequest request) throws DAOException {
        if (tipo == null || request == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed type or request is null"));
        }
        
        HttpSession s = (HttpSession) request.getSession(false);
        ArrayList<Product> p = new ArrayList<>();
        if(s.getAttribute("prodottiGuest") != null){
            p = (ArrayList<Product>) s.getAttribute("prodottiGuest");
        }
        for(Product pp : p){
            if(pp.getPid() == id){
                pp.setStatus(tipo);
            }
        }
    }
    
    @Override
    public ArrayList<ShopList> getAllObjectListsByCurentUser(String nome) throws DAOException {
        if (nome == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed name is null"));
        }

        ArrayList<String> all = getAllListsByCurentUser(nome);

        ArrayList<ShopList> liste = new ArrayList<>();

        for (String s : all) {
            try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM List where nome=?")) {
                stm.setString(1, s);

                try (ResultSet rs = stm.executeQuery()) {
                    while (rs.next()) {
                        ShopList lista = new ShopList();
                        lista.setNome(rs.getString("nome"));
                        lista.setDescrizione(rs.getString("descrizione"));
                        lista.setImmagine(rs.getString("immagine"));
                        lista.setCreator(rs.getString("creator"));
                        lista.setCategoria(rs.getString("categoria"));
                        lista.setPromemoria(rs.getInt("reminder"));
                        liste.add(lista);
                    }

                } catch (SQLException ex) {
                    Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
                }
            } catch (SQLException ex) {
                Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        return liste;
    }

    @Override
    public ListProd getbyListAndProd(String lista, int prod) throws DAOException {
        ListProd p = null;
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM List_Prod where lista=? and prodotto=?")) {
            stm.setString(1, lista);
            stm.setInt(2, prod);
            
            try (ResultSet rs = stm.executeQuery()) {
                
                while (rs.next()) {                        
                    p = new ListProd();
                    p.setLista(rs.getString("lista"));
                    p.setProdotto(rs.getString("prodotto"));
                    p.setData_scadenza(rs.getDate("data_scadenza"));
                    p.setData_inserimento(rs.getDate("data_inserimento"));
                    p.setStato(rs.getString("stato"));
                    p.setQuantita(rs.getString("quantita"));
                    p.setDataAcquisto(rs.getDate("data_acquisto"));
                }
            }
            
        } catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return p;
    }

    @Override
    public void updateExpirationDate(PeriodicProduct pp, java.sql.Date newDate) throws DAOException {
        if (pp == null || newDate==null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed product or date is null"));
        }
        try(PreparedStatement stm = CON.prepareStatement("UPDATE List_Prod SET data_scadenza=? WHERE lista=? and prodotto=?")){
            stm.setDate(1, newDate);
            stm.setString(2, pp.getLista());
            stm.setInt(3, pp.getProdotto());
            
            if(stm.executeUpdate() == 1){
                return;
            }else{
                throw new DAOException("impossible update date");
            }
        }   catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    @Override
    public void updateReminder(String lista, int valore) throws DAOException{
        try(PreparedStatement stm = CON.prepareStatement("UPDATE List SET reminder=? WHERE nome=?")){
            stm.setInt(1, valore);
            stm.setString(2, lista);
            
            if(stm.executeUpdate() == 1){
                return;
            }else{
                throw new DAOException("impossible update reminder");
            }
        }   catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
