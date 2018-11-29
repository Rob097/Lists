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
import database.daos.ProductDAO;
import database.daos.UserDAO;
import database.entities.Category;
import database.entities.Category_Product;
import database.entities.Product;
import database.entities.User;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCCategoryDAO;
import database.jdbc.JDBCCategory_ProductDAO;
import database.jdbc.JDBCNotificationsDAO;
import database.jdbc.JDBCProductDAO;
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
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Martin
 */
public class HomepageFilter implements Filter {
    
    private static final boolean debug = true;

    // The filter configuration object we are associated with.  If
    // this value is null, this filter instance is not currently
    // configured. 
    private FilterConfig filterConfig = null;
    private ListDAO listdao = null;
    private ProductDAO productdao = null;
    private NotificationDAO notificationdao = null;
    private  Category_ProductDAO category_productdao = null;
    private CategoryDAO categorydao = null;
    private UserDAO userdao = null;
    
    public HomepageFilter() {
    }    
    
    private void conInit(FilterConfig filterConfig) throws ServletException{
        DAOFactory daoFactory = (DAOFactory) filterConfig.getServletContext().getAttribute("daoFactory");
            if (daoFactory == null) {
                throw new ServletException("Impossible to get dao factory for user storage system");
            }
        listdao = new JDBCShopListDAO(daoFactory.getConnection());
        productdao = new JDBCProductDAO(daoFactory.getConnection());
        notificationdao = new JDBCNotificationsDAO(daoFactory.getConnection());
        category_productdao = new JDBCCategory_ProductDAO(daoFactory.getConnection());
        categorydao = new JDBCCategoryDAO(daoFactory.getConnection());
        userdao = new JDBCUserDAO(daoFactory.getConnection());
    }
    
    private void doBeforeProcessing(ServletRequest request, ServletResponse response)
            throws IOException, ServletException {
        if (debug) {
            log("HomepageFilter:DoBeforeProcessing");
        }
        
        if( request instanceof HttpServletRequest){
            ServletContext servletContext = ((HttpServletRequest) request).getServletContext();
            HttpSession session = ((HttpServletRequest)request).getSession(false);
            
            if(session != null){
                
                try {
                    ArrayList<Category_Product> cP = category_productdao.getAllCategories();                     
                    session.setAttribute("catProd", cP);
                } catch (DAOException ex) {
                    Logger.getLogger(HomepageFilter.class.getName()).log(Level.SEVERE, null, ex);
                }
                
                User user = (User) session.getAttribute("user");
                
                if(user != null){
                    session.setAttribute("user", user);
                    
                    try {
                        
                        ArrayList<Notification> notifiche = notificationdao.getAllNotifications(user.getEmail());
                        ArrayList<Category> li = categorydao.getAllCategories();                        
                        
                        
                        session.setAttribute("notifiche", notifiche);
                        session.setAttribute("categorie", li);
                        
                        
                    } catch (DAOException ex) {
                        Logger.getLogger(HomepageFilter.class.getName()).log(Level.SEVERE, null, ex);
                    } 
                    
                }else{
                    
                }
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
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {
        
        if (debug) {
            log("HomepageFilter:doFilter()");
        }
        
        doBeforeProcessing(request, response);
        
        Throwable problem = null;
        try {
            chain.doFilter(request, response);
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
                log("HomepageFilter:Initializing filter");
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
            return ("HomepageFilter()");
        }
        StringBuffer sb = new StringBuffer("HomepageFilter(");
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
