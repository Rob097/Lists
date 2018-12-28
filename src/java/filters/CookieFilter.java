/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package filters;

import Notifications.Notification;
import database.daos.CategoryDAO;
import database.daos.Category_ProductDAO;
import database.daos.ListDAO;
import database.daos.NotificationDAO;
import database.daos.UserDAO;
import database.entities.Category;
import database.entities.Category_Product;
import database.entities.ShopList;
import database.entities.User;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCCategoryDAO;
import database.jdbc.JDBCCategory_ProductDAO;
import database.jdbc.JDBCNotificationsDAO;
import database.jdbc.JDBCShopListDAO;
import database.jdbc.JDBCUserDAO;
import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.apache.tomcat.util.codec.binary.Base64;

/**
 *
 * @author Martin
 */
public class CookieFilter implements Filter {
    
    private static final boolean debug = true;
    private FilterConfig filterConfig = null;
    private UserDAO userdao = null;
    private ListDAO listdao = null;
    private NotificationDAO notificationdao = null;
    private Category_ProductDAO category_productdao = null;
    private CategoryDAO categorydao = null;
    
    public CookieFilter() {
    }    
    
    private void conInit(FilterConfig filterConfig) throws ServletException{
        DAOFactory daoFactory = (DAOFactory) filterConfig.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }        
        userdao = new JDBCUserDAO(daoFactory.getConnection());        
        listdao = new JDBCShopListDAO(daoFactory.getConnection());
        notificationdao = new JDBCNotificationsDAO(daoFactory.getConnection());
        category_productdao = new JDBCCategory_ProductDAO(daoFactory.getConnection());
        categorydao = new JDBCCategoryDAO(daoFactory.getConnection());
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
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        if (debug) {
            log("CookieFilter:doFilter()");
        }
        //get servlet request, cookies and session
        HttpServletRequest req = (HttpServletRequest) request;
        Cookie[] cookies = req.getCookies();
        HttpSession session = (HttpSession) req.getSession(); 
        
        if(session != null){ 
            User user = (User) session.getAttribute("user");
                                 
            try {
                ArrayList<Category_Product> cP = category_productdao.getAllCategories();
                session.setAttribute("catProd", cP);
                
                ArrayList<Category> li = categorydao.getAllCategories();                     
                session.setAttribute("categorie", li);
                
            } catch (DAOException ex) {
                Logger.getLogger(CookieFilter.class.getName()).log(Level.SEVERE, null, ex);
            }            
            
            if (cookies != null && user == null){
                for (Cookie ck : cookies) {
                    if (ck.getName().equals("User")) {    
                        try {             
                            String value = new String(Base64.decodeBase64(ck.getValue().getBytes("UTF-8")));
                            User dbuser = userdao.getByEmail(value);
                            if(dbuser != null){
                                
                                session.setAttribute("user", dbuser);
                                user = dbuser;
                                
                            }
                        } catch (DAOException ex) {
                            Logger.getLogger(CookieFilter.class.getName()).log(Level.SEVERE, null, ex);
                        }                
                    }
                }
            }
            
            if(user != null){
                try{
                    
                    ArrayList<ShopList> li = listdao.getByEmail(user.getEmail());
                    session.setAttribute("userLists", li);

                    ArrayList<ShopList> sl = listdao.getListOfShopListsThatUserLookFor(user.getEmail());
                    session.setAttribute("sharedLists", sl);                    
                    
                    //### notifiche ###
                    ArrayList<Notification> allN = notificationdao.getAllNotifications(user.getEmail());
                    ArrayList<Notification> filteredN = new ArrayList<>();
                        boolean check = false;                        
                        for (Notification n : allN) {
                            check = false;
                            for (Notification nn : filteredN) {
                                if (n.getListName().equals(nn.getListName()) && n.getType().equals(nn.getType())) {
                                    check = true;
                                    break;
                                } else {
                                    check = false;
                                }
                            }
                            if (check == false) {
                                n.setListimage(listdao.getbyName(n.getListName()).getImmagine());
                                filteredN.add(n);
                            } else {
                                //System.out.println("Notifica già presente");
                            }
                        }
                        session.setAttribute("notifiche", filteredN);
                        //notifiche userlist
                        session.setAttribute("allNotifiche",allN);                       
                        //### fine notifiche ###
                        
                } catch (DAOException ex) {
                    Logger.getLogger(CookieFilter.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }
        
        Throwable problem = null;
        try {
            if(req != null && response != null){
                chain.doFilter(req, response);
            }else{
                System.out.println("req o respose = null");
            }
        } catch (Throwable t) {
            // If an exception is thrown somewhere down the filter chain,
            // we still want to execute our after processing, and then
            // rethrow the problem after that.
            problem = t;
            t.printStackTrace();
            
            
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
    public void destroy() {        
    }

    /**
     * Init method for this filter
     */
    public void init(FilterConfig filterConfig) throws ServletException {        
        this.filterConfig = filterConfig;
        if (filterConfig != null) {
            if (debug) {                
                log("CookieFilter:Initializing filter");
            }
        }    
        
        conInit(filterConfig);

    }

    /**
     * Return a String representation of this object.
     */
    @Override
    public String toString() {
        if (filterConfig == null) {
            return ("CookieFilter()");
        }
        StringBuffer sb = new StringBuffer("CookieFilter(");
        sb.append(filterConfig);
        sb.append(")");
        return (sb.toString());
    }
    
    private void sendProcessingError(Throwable t, ServletResponse response) {
        String stackTrace = getStackTrace(t);        
        
        if (stackTrace != null && !stackTrace.equals("")) {
            try {
                response.setContentType("text/html");
                PrintStream ps = new PrintStream(response.getOutputStream());
                PrintWriter pw = new PrintWriter(ps);                
                pw.print("<html>\n<head>\n<title>Error</title>\n</head>\n<body>\n"); //NOI18N

                // PENDING! Localize this for next official release
                pw.print("<h1>The resource did not process correctly</h1>\n<pre>\n");                
                pw.print(stackTrace);                
                pw.print("</pre></body>\n</html>"); //NOI18N
                pw.close();
                ps.close();
                response.getOutputStream().close();
            } catch (Exception ex) {
            }
        } else {
            try {
                PrintStream ps = new PrintStream(response.getOutputStream());
                t.printStackTrace(ps);
                ps.close();
                response.getOutputStream().close();
            } catch (Exception ex) {
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
        } catch (Exception ex) {
        }
        return stackTrace;
    }
    
    public void log(String msg) {
        filterConfig.getServletContext().log(msg);        
    }
    
}
