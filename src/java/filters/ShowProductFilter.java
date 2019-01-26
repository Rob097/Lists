/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package filters;

import database.daos.ListDAO;
import database.daos.ProductDAO;
import database.entities.Product;
import database.entities.ShopList;
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
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Martin
 */
public class ShowProductFilter implements Filter {
    
    private static final boolean debug = true;
    private FilterConfig filterConfig = null;
    private ListDAO listdao = null;
    private ProductDAO productdao = null;
    
    private void conInit(FilterConfig filterConfig) throws ServletException{
        DAOFactory daoFactory = (DAOFactory) filterConfig.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }        
   
        listdao = new JDBCShopListDAO(daoFactory.getConnection());
        productdao = new JDBCProductDAO(daoFactory.getConnection());
    }
    
    public ShowProductFilter() {
    }    
    
    private void doBeforeProcessing(ServletRequest request, ServletResponse response)
            throws IOException, ServletException {
        if (debug) {
            log("ShowProductFilter:DoBeforeProcessing");
        }
        if(request instanceof HttpServletRequest){
            ServletContext servletContext = ((HttpServletRequest) request).getServletContext();
            String contextPath = servletContext.getContextPath();
            if(!contextPath.endsWith("/")){
                contextPath += "/";
            }
            HttpSession session = ((HttpServletRequest)request).getSession(false);
            if(session != null){               
                User user = (User) session.getAttribute("user");                
                
                try {
                    //all product categories
                    ArrayList<String> allCategories;
                    allCategories = productdao.getAllProductCategories();
                    session.setAttribute("prodCategories", allCategories);
                    
                    ArrayList<Product> li = productdao.getallAdminProducts();                    
                    session.setAttribute("products", li);
                    
                    if(user != null){                        
                         ArrayList<String> allListsOfUser = listdao.getAllListsByCurentUser(user.getEmail());
                         session.setAttribute("allListsOfUser", allListsOfUser);                         
                    }
                    
                    if((request.getParameter("cat") == null || request.getParameter("cat").equals("all"))){
                        for(Product p : li){
                            session.setAttribute(p.getNome(), p.getNome());
                        }                        
                    }                    
                    
                } catch (DAOException ex) {
                    Logger.getLogger(ShowProductFilter.class.getName()).log(Level.SEVERE, null, ex);
                }
                
               /* if((user != null || guestList != null) && shopListName != null){
                    
                }else {
                  ((HttpServletResponse) response).sendRedirect(((HttpServletResponse) response).encodeRedirectURL(contextPath + "userlists.jsp"));
                return;  
                }     */                
            }else{
                ((HttpServletResponse) response).sendRedirect(((HttpServletResponse) response).encodeRedirectURL(contextPath + "homepage.jsp"));
                return;
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
            log("ShowProductFilter:doFilter()");
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
                log("ShowProductFilter:Initializing filter");
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
            return ("ShowProductFilter()");
        }
        StringBuffer sb = new StringBuffer("ShowProductFilter(");
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
