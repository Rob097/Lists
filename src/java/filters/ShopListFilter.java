/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package filters;

import ShopList.ShowShopList;
import database.daos.Category_ProductDAO;
import database.daos.ListDAO;
import database.daos.ProductDAO;
import database.daos.UserDAO;
import database.entities.Category_Product;
import database.entities.Product;
import database.entities.ShopList;
import database.entities.User;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCCategory_ProductDAO;
import database.jdbc.JDBCProductDAO;
import database.jdbc.JDBCShopListDAO;
import database.jdbc.JDBCUserDAO;
import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Martin
 */
@WebFilter(filterName = "ShopListFilter", urlPatterns = {"/Pages/ShowUserList.jsp"})
public class ShopListFilter implements Filter {
    
    private static final boolean DEBUG = true;
    private FilterConfig filterConfig = null;
    private UserDAO userdao = null;
    private ListDAO listdao = null;
    private Category_ProductDAO category_productdao = null;
    private ProductDAO productdao = null;
    
    public ShopListFilter() {
    }    
    
    private void conInit(FilterConfig filterConfig) throws ServletException{
        DAOFactory daoFactory = (DAOFactory) filterConfig.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }        
        userdao = new JDBCUserDAO(daoFactory.getConnection());        
        listdao = new JDBCShopListDAO(daoFactory.getConnection());
        category_productdao = new JDBCCategory_ProductDAO(daoFactory.getConnection());;
        productdao = new JDBCProductDAO(daoFactory.getConnection());
    }
    
    private void doBeforeProcessing(ServletRequest request, ServletResponse response)
            throws IOException, ServletException {
        if (DEBUG) {
            log("ShopListFilter:DoBeforeProcessing");
        }
        
        if(request instanceof HttpServletRequest){
            ServletContext servletContext = ((HttpServletRequest) request).getServletContext();
            String contextPath = servletContext.getContextPath();
            if(!contextPath.endsWith("/")){
                contextPath += "/";
            }
            HttpSession session = ((HttpServletRequest)request).getSession(false);
            if(session != null){
                User user =(User) session.getAttribute("user");
                String shopListName = (String) session.getAttribute("shopListName");
                ShopList guestList = (ShopList) session.getAttribute("guestList");
               
                //categories of products
                try {
                    ArrayList<Category_Product> allPrcategories;
                    allPrcategories = category_productdao.getAllCategories();
                    session.setAttribute("catProd", allPrcategories);
                } catch (DAOException ex) {
                    Logger.getLogger(ShopListFilter.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                if(user != null && shopListName != null){
                    try {
                        //shoplist
                        ShopList shoplist = listdao.getbyName(shopListName);
                        session.setAttribute("lista", shoplist);
                        
                        //user role
                        user.setRuolo(listdao.checkRole(user.getEmail(), shopListName));
                        session.setAttribute("user", user);
                        
                        //sharedusers
                        ArrayList<User> sharedusers = listdao.getUsersWithWhoTheListIsShared(shopListName);  
                        //role sharedusers 
                        for (User su : sharedusers) {
                            su.setRuolo(listdao.checkRole(su.getEmail(), shopListName));
                        }
                        session.setAttribute("sharedUsers", sharedusers);
                        
                        //Products of list
                        ArrayList<Product> products = listdao.getAllProductsOfShopList(shopListName); 
                        //status products
                        for (Product p : products) {
                            if(listdao.checkBuyed(p.getPid(), shopListName, session))
                            p.setStatus("acquistato");
                            p.setQuantity(productdao.getQuantity(p.getPid(), shopListName));
                            p.setData_scadenza(productdao.getReminderDate(p, shopListName));
                        }                        
                        session.setAttribute("listProducts", products);                       
                         
                        //not shared users                   
                        try {
                           ArrayList<User> users = userdao.getAllUsers();
                            Iterator<User> i = users.iterator();
                            while(i.hasNext()){
                                //remove your username
                                if(i.next().getEmail().equals(user.getEmail())){
                                    i.remove();
                                }
                            }
                            for (int j = 0; j < users.size(); j++) {
                                for (int k = 0; k < sharedusers.size()-1; k++) {
                                    if(users.get(j).getEmail().equals(sharedusers.get(k).getEmail())){
                                        users.remove(j);
                                    }
                                }
                            }
                            session.setAttribute("Users", users);
                            
                        } catch (DAOException ex) {
                            Logger.getLogger(ShowShopList.class.getName()).log(Level.SEVERE, null, ex);
                            System.out.println("problems with getAllUsers()");
                        }
                    } catch (DAOException ex) {
                        System.out.println("SHOPLISTFILTER ERROR");
                        Logger.getLogger(ShopListFilter.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }else if (user == null && guestList != null && shopListName != null){ //for guestlist
                    
                    //products of guestlist  
                    try {
                        if (session.getAttribute("prodottiGuest") != null) {
                            ArrayList<Product> li = (ArrayList<Product>) session.getAttribute("prodottiGuest"); //Prendi l'attributo di sessione contenente i prodotti se non è nullo
                            if(session.getAttribute("importGL") != null){
                                for (Product p : li) {
                                    if(listdao.checkBuyed(p.getPid(), shopListName, session)){
                                        p.setStatus("acquistato");                                        
                                    }
                                }
                            }
                            session.setAttribute("listProducts", li);
                        }
                    } catch (DAOException ex) {
                        System.out.println("GUESTLIST SHOPLISTFILTER ERROR");
                           Logger.getLogger(ShopListFilter.class.getName()).log(Level.SEVERE, null, ex);
                    }
                } else{
                  ((HttpServletResponse) response).sendRedirect(((HttpServletResponse) response).encodeRedirectURL(contextPath + "userlists.jsp"));
                }                       
            }else{
                ((HttpServletResponse) response).sendRedirect(((HttpServletResponse) response).encodeRedirectURL(contextPath + "homepage.jsp"));
            }
        }     

    }    
    

    /**
     *
     * @param request The servlet request we are processing
     * @param response The servlet response we are creating
     * @param chain The filter chain we are processing
     *
     * @exception IOException if an input/output error occurs
     * @exception ServletException if a servlet error occurs
     */
    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {
        
        if (DEBUG) {
            log("ShopListFilter:doFilter()");
        }
        
        doBeforeProcessing(request, response);
        
        Throwable problem = null;
        try {
            chain.doFilter(request, response);
        } catch (IOException | ServletException t) {
            // If an exception is thrown somewhere down the filter chain,
            // we still want to execute our after processing, and then
            // rethrow the problem after that.
            problem = t;
        }

        // If there was a problem, we want to rethrow it if it is
        // a known type, otherwise log it.
        if (problem != null) {
            if (problem instanceof ServletException) {
                throw (ServletException) problem;
            }
            if (problem instanceof IOException) {
                throw (IOException) problem;
            }
            sendProcessingError(problem, response);
        }
    }

    /**
     * Return the filter configuration object for this filter.
     * @return 
     */
    public FilterConfig getFilterConfig() {
        return (this.filterConfig);
    }

    /**
     * Set the filter configuration object for this filter.
     *
     * @param filterConfig The filter configuration object
     */
    public void setFilterConfig(FilterConfig filterConfig) {
        this.filterConfig = filterConfig;
    }

    /**
     * Destroy method for this filter
     */
    @Override
    public void destroy() {        
    }

    /**
     * Init method for this filter
     * @param filterConfig
     * @throws javax.servlet.ServletException
     */
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {        
        this.filterConfig = filterConfig;
        if (filterConfig != null) {
            if (DEBUG) {                
                log("ShopListFilter:Initializing filter");
            }
            conInit(filterConfig);
        }
    }

    /**
     * Return a String representation of this object.
     * @return 
     */
    @Override
    public String toString() {
        if (filterConfig == null) {
            return ("ShopListFilter()");
        }
        StringBuilder sb = new StringBuilder("ShopListFilter(");
        sb.append(filterConfig);
        sb.append(")");
        return (sb.toString());
    }
    
    private void sendProcessingError(Throwable t, ServletResponse response) {
        String stackTrace = getStackTrace(t);        
        
        if (stackTrace != null && !stackTrace.equals("")) {
            try {
                response.setContentType("text/html");
                try (PrintStream ps = new PrintStream(response.getOutputStream()); PrintWriter pw = new PrintWriter(ps)) {
                    pw.print("<html>\n<head>\n<title>Error</title>\n</head>\n<body>\n"); //NOI18N
                    
                    // PENDING! Localize this for next official release
                    pw.print("<h1>The resource did not process correctly</h1>\n<pre>\n");
                    pw.print(stackTrace);
                    pw.print("</pre></body>\n</html>"); //NOI18N
                }
                response.getOutputStream().close();
            } catch (IOException ex) {
            }
        } else {
            try {
                try (PrintStream ps = new PrintStream(response.getOutputStream())) {
                    t.printStackTrace(ps);
                }
                response.getOutputStream().close();
            } catch (IOException ex) {
            }
        }
    }
    
    public static String getStackTrace(Throwable t) {
        String stackTrace = null;
        try {
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            t.printStackTrace(pw);
            pw.close();
            sw.close();
            stackTrace = sw.getBuffer().toString();
        } catch (IOException ex) {
        }
        return stackTrace;
    }
    
    public void log(String msg) {
        filterConfig.getServletContext().log(msg);        
    }
    
}
