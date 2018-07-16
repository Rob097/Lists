/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package log;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;


/**
 *
 * @author Roberto97
 */
@MultipartConfig(maxFileSize = 16177215)	// upload file's size up to 16MB
public class RegisterAction extends HttpServlet {

   
	
	// database connection settings
	private String dbURL = "jdbc:mysql://sql2.freemysqlhosting.net:3306/sql2243047?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC&autoReconnect=true&useSSL=false";
	private String dbUser = "sql2243047";
	private String dbPass = "mJ9*fQ4%";
	
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// gets values of text fields
		String username=null, nome=null, password=null, Tipostandard=null, TipononStandard=null, photo=null, standard="standard", nonStandard="nonStandard";
		username=request.getParameter("username"); //txt_username
        nome=request.getParameter("nominativo"); //txt_name
        password=request.getParameter("password"); //txt_password
        Tipostandard=request.getParameter("standard"); //txt_standard
        TipononStandard=request.getParameter("nonStandard"); //txt_nonSstandard
        InputStream inputStream = null;	// input stream of the upload file
		
		// obtains the upload file part in this multipart request
		Part filePart = request.getPart("image");
		if (filePart != null) {
			// prints out some information for debugging
			System.out.println(filePart.getName());
			System.out.println(filePart.getSize());
			System.out.println(filePart.getContentType());
			
			// obtains input stream of the upload file
			inputStream = filePart.getInputStream();
		}
		
		Connection conn = null;	// connection to the database
		String message = null;	// message will be sent back to client
		
		try{
			// connects to the database
			DriverManager.registerDriver(new com.mysql.cj.jdbc.Driver());
			conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

			// constructs SQL statement
			String sql = "insert into USER(Email,Password,Nominativo,Tipo,Image) values(?,?,?,?,?)";
			PreparedStatement statement = conn.prepareStatement(sql);
			statement.setString(1,username);
                        statement.setString(2,password);
                        statement.setString(3,nome);
                        if(Tipostandard != null) {Tipostandard = "standard"; statement.setString(4,standard);}
                        else if(TipononStandard != null) {TipononStandard = "Nonstandard"; statement.setString(4,nonStandard);}
                        if (inputStream != null) {
                        // fetches input stream of the upload file for the blob column
                            statement.setBlob(5, inputStream);
                        }   

			// sends the statement to the database server
			int row = statement.executeUpdate();
			if (row > 0) {
				message = "File uploaded and saved into database";
			}
		}catch (SQLException ex) {
			message = "ERROR: " + ex.getMessage();
			ex.printStackTrace();
		}finally {
			if (conn != null) {
				// closes the database connection
				try {
					conn.close();
				} catch (SQLException ex) {
					ex.printStackTrace();
				}
			}
			// sets the message in request scope
			response.sendRedirect("homepage.jsp");
			
			// forwards to the message page
			//getServletContext().getRequestDispatcher("/Message.jsp").forward(request, response);
		}
	}
    }

