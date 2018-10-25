/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package database.jdbc;

import database.daos.ListDAO;
import database.entities.ListProd;
import database.entities.Product;
import database.entities.ShopList;
import database.entities.User;
import database.exceptions.DAOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
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
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM List WHERE creator = ?")) {
            ArrayList<ShopList> shoppingLists = new ArrayList<>();

            stm.setString(1, email);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    ShopList sL = new ShopList();
                    sL.setNome(rs.getString("nome"));
                    sL.setDescrizione(rs.getString("descrizione"));
                    sL.setImmagine(rs.getString("immagine"));
                    sL.setCreator(rs.getString("creator"));
                    sL.setCategoria(rs.getString("categoria"));
                    sL.setSharedUsers(getUsersWithWhoTheListIsShared(sL));

                    shoppingLists.add(sL);
                }

                return shoppingLists;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }
    }

    @Override
    public ArrayList<User> getUsersWithWhoTheListIsShared(ShopList l) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("select email from User where email in (select user from User_List where list = ?)")) {
            ArrayList<User> userList = new ArrayList<>();

            stm.setString(1, l.getNome());
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    User u = new User();
                    u.setEmail(rs.getString("email"));

                    userList.add(u);
                }

                return userList;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }
    }

    @Override
    public ArrayList<User> getUsersWithWhoTheListIsShared(String listname) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("select * from User where email in (select user from User_List where list = ?)")) {
            ArrayList<User> userList = new ArrayList<>();

            stm.setString(1, listname);
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
    public ShopList Insert(ShopList l) throws DAOException {

        if (l == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed user is null"));
        }

        String qry = "insert into List(nome,descrizione,immagine,creator,categoria) "
                + "values(?,?,?,"
                + "(select email from User where email = ?),"
                + "(select nome from Category where nome = ?))";

        try (PreparedStatement statement = CON.prepareStatement(qry)) {
            statement.setString(1, l.getNome());
            statement.setString(2, l.getDescrizione());
            statement.setString(3, l.getImmagine());
            statement.setString(4, l.getCreator());
            statement.setString(5, l.getCategoria());

            if (statement.executeUpdate() == 1) {
                return l;
            } else {
                throw new DAOException("Impossible to insert the List");
            }
        } catch (SQLException ex) {
            throw new DAOException(ex);

        }
    }
    
    @Override
    public ShopList GuestSave(ShopList l, String creator) throws DAOException{
        if (l == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed user is null"));
        }

        String qry = "insert into guestLists(nome,descrizione,immagine,creator,categoria) "
                + "values(?,?,?,?,?)";

        try (PreparedStatement statement = CON.prepareStatement(qry)) {
            statement.setString(1, l.getNome());
            statement.setString(2, l.getDescrizione());
            statement.setString(3, l.getImmagine());
            statement.setString(4, creator);
            statement.setString(5, l.getCategoria());

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
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM List WHERE nome IN (SELECT list FROM User_List where user = ?)")) {
            ArrayList<ShopList> shoppingLists = new ArrayList<>();

            stm.setString(1, email);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    ShopList sL = new ShopList();
                    sL.setNome(rs.getString("nome"));
                    sL.setDescrizione(rs.getString("descrizione"));
                    sL.setImmagine(rs.getString("immagine"));
                    sL.setCreator(rs.getString("creator"));
                    sL.setCategoria("categoria");
                    sL.setSharedUsers(getUsersWithWhoTheListIsShared(sL));

                    shoppingLists.add(sL);
                }

                return shoppingLists;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }
    }

    @Override
    public ArrayList<Product> getAllProductsOfShopList(String name) throws DAOException {

        try (PreparedStatement stm = CON.prepareStatement("select * from Product where PID in (select prodotto from List_Prod where lista = ?)")) {
            ArrayList<Product> productLists = new ArrayList<>();
            stm.setString(1, name);
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
            throw new DAOException("Impossible to get the list of users", ex);
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
                System.out.println("successful operation");
            } else {
                throw new DAOException("Impossible to insert the query");
            }
        } catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public void deleteList(ShopList list) throws DAOException {
        if (list == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed list is null"));
        }
        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM User_List WHERE list=?")) {
            stm.setString(1, list.getNome().replace(" ", ""));
            stm.executeUpdate();
            
        } catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM List_Prod WHERE lista=?")) {
            stm.setString(1, list.getNome());
            
        } catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM List WHERE nome=?")) {
            stm.setString(1, list.getNome());
            if (stm.executeUpdate() == 1) {

            } else {
                throw new DAOException("Impossible to Delete the List");
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
                    sL.setCategoria("categoria");
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
    public void insertProductToList(int prodotto, String lista) throws DAOException {
        if (lista == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed email or listname is null"));
        }

        try (PreparedStatement stm = CON.prepareStatement("INSERT INTO List_Prod VALUES (?,?,'2008-7-04','2008-7-04','daAcquistare')")) {
            stm.setString(1, lista);
            stm.setInt(2, prodotto);

            if (stm.executeUpdate() == 1) {
                System.out.println("successful operation");
            } else {
                throw new DAOException("Impossible to insert the query");
            }
        } catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    @Override
    public void insertProductToGuestList(int prodotto, HttpServletRequest request) throws DAOException {
        
        try (PreparedStatement stm = CON.prepareStatement("select * from Product where PID = ?")) {
            
            HttpSession s = (HttpSession) request.getSession();
            ArrayList <Product> productLists = new ArrayList();
            if(s.getAttribute("prodottiGuest") != null){
                productLists = (ArrayList<Product>) s.getAttribute("prodottiGuest");
            }
            stm.setInt(1, prodotto);
            
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
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM User_List INNER JOIN List ON User_List.list=List.nome where user = ?")) {
            ArrayList<ShopList> shoppingLists = new ArrayList<>();

            stm.setString(1, email);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    ShopList sL = new ShopList();
                    sL.setNome(rs.getString("nome"));
                    sL.setDescrizione(rs.getString("descrizione"));
                    sL.setImmagine(rs.getString("immagine"));
                    sL.setCreator(rs.getString("creator"));
                    sL.setCategoria(rs.getString("categoria"));
                    sL.setSharedUsers(getUsersWithWhoTheListIsShared(sL));

                    shoppingLists.add(sL);
                }

                return shoppingLists;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
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
            
            statement.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println("Problems with deleting shared user");
        }
    }

    @Override
    public ShopList getGuestList(String email) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM guestLists WHERE creator =?")) {
            ShopList shoppingLists = new ShopList();

            stm.setString(1, email);
            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    shoppingLists.setNome(rs.getString("nome"));
                    shoppingLists.setDescrizione(rs.getString("descrizione"));
                    shoppingLists.setImmagine(rs.getString("immagine"));
                    shoppingLists.setCreator(rs.getString("creator"));
                    shoppingLists.setCategoria("categoria");
                }

                return shoppingLists;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }
    }

    @Override
    public void checkIfGuestListExistInDatabase(String creator) throws DAOException {
        
        boolean check = false;
        try (PreparedStatement stm = CON.prepareStatement("select * from guestLists where creator = ?")) {
            stm.setString(1, creator);

            try (ResultSet rs = stm.executeQuery()) {
                while (rs.next()) {
                    check = true;
                }
            }catch (SQLException ex) {
                Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
            
            if(check){
                try (PreparedStatement stm1 = CON.prepareStatement("DELETE FROM guestLists WHERE creator=?")) {
                    
                    stm1.setString(1, creator);
                    if (stm1.executeUpdate() == 1) {
                        System.out.println("successful delete GuestList");
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
        
        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM guestLists WHERE creator=?")) {
            stm.setString(1, creator);
            stm.executeUpdate();
            
        } catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public void removeProductToList(int prodotto, String lista) throws DAOException {
        if (lista == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed email or listname is null"));
        }

        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM List_Prod WHERE lista = ? AND prodotto = ?")) {
            stm.setString(1, lista);
            stm.setInt(2, prodotto);

            if (stm.executeUpdate() == 1) {
                System.out.println("successful operation");
            } else {
                throw new DAOException("Impossible to insert the query");
            }
        } catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public void removeALLProductToList(String lista) throws DAOException {
        if (lista == null) {
            throw new DAOException("parameter not valid", new IllegalArgumentException("The passed email or listname is null"));
        }

        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM List_Prod WHERE lista = ?")) {
            stm.setString(1, lista);

            if (stm.executeUpdate() == 1) {
                System.out.println("successful operation");
            } else {
                throw new DAOException("Impossible to insert the query");
            }
        } catch (SQLException ex) {
            Logger.getLogger(JDBCShopListDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    public String checkRole(String user, String list) throws DAOException {
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

    @Override
    public boolean checkBuyed(int id, String lista) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("select stato from List_Prod where lista = ? AND prodotto = ?")) {
            boolean check = false;
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
    }

    @Override
    public void changeStatusOfAllProduct(String tipo, String lista) throws DAOException {
        ArrayList<Product> p = getAllProductsOfShopList(lista);
        System.out.println("TIPOOOOOOO: " + tipo);
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
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM List_Prod WHERE lista = ?")) {
            ArrayList<ListProd> listProdlink = new ArrayList<ListProd>();

            stm.setString(1, listaname);
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
            throw new DAOException("Impossible to get the list of users", ex);
        }
    }

}
