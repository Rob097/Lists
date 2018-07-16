/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package log;

import java.io.*;
import static java.lang.System.out;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.*;
import javax.servlet.http.*;

/**
 *
 * @author Roberto97
 */
public class DisplayImage extends HttpServlet {

    String dburl, dbusername, dbpassword;
    Connection conn;

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");  // MySQL database connection
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(DisplayImage.class.getName()).log(Level.SEVERE, null, ex);
        }
        dburl = "jdbc:mysql://sql2.freemysqlhosting.net:3306/sql2243047?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC&autoReconnect=true&useSSL=false";
        dbusername = "sql2243047";
        dbpassword = "mJ9*fQ4%";
        try {
            conn = DriverManager.getConnection(dburl, dbusername, dbpassword);
        } catch (SQLException ex) {
            Logger.getLogger(DisplayImage.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        
        
        
        
        Statement stmt;
        String sql;
        InputStream in = null;
        response.setContentType("image/jpeg");
        ServletOutputStream out;
        out = response.getOutputStream();
        BufferedInputStream bin;
        BufferedOutputStream bout;

        String Email = request.getParameter("Email");
        try {
            stmt = conn.createStatement();
            sql = "SELECT Image FROM USER WHERE Email=" + Email + "";
            ResultSet result = stmt.executeQuery(sql);
            if (result.next()) {
                in = result.getBinaryStream(5);//Since my data was in third column of table.
            }
            
            int ch;

        } catch (SQLException ex) {
            System.out.println("Something went wrong !! Please try again");
            System.out.println("Causa Chiusura ");
        }

    }
}
