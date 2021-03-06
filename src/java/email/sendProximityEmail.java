/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package email;

import database.daos.NotificationDAO;
import database.entities.User;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCNotificationsDAO;
import java.io.IOException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Roberto97
 */
public class sendProximityEmail extends HttpServlet {
    private static final long serialVersionUID = 6106269076155338045L;
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
        //Dichiarazioni
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        NotificationDAO notificationdao = new JDBCNotificationsDAO(daoFactory.getConnection());
        //Raccolta dei dati dell'utente
        User u = (User) request.getSession().getAttribute("user");
        String nome = request.getParameter("nome");
        String email = request.getParameter("email");
        String lista = request.getParameter("lista");
        String intro = "Salve " + nome + ",\n";
        String corpo = "Ci risulta che si trova particolarmente vicino ad alcuni negozi inerenti alla sua lista " + lista + ". Controlli nella sezione 'Map della lista.'";
        String messaggio = intro + corpo;
        String oggetto = "Lists";
        System.out.println("EMAIL\nNOME: " + email);
        try {
            if (notificationdao.checkProximityMail(email, lista)) {
                    //Dati email Roberto
                    String to1 = email;
                    final String user1 = "dellantonio47@gmail.com";
                    final String pass1 = "jwjdxemvcgvppvgp";
                    Properties props1 = new Properties();
                    props1.put("mail.smtp.host", "smtp.gmail.com");
                    //below mentioned mail.smtp.port is optional
                    props1.put("mail.smtp.port", "587");
                    props1.put("mail.smtp.auth", "true");
                    props1.put("mail.smtp.starttls.enable", "true");
                    Session session2;
                    session2 = Session.getInstance(props1, new javax.mail.Authenticator() {
                        @Override
                        protected PasswordAuthentication getPasswordAuthentication() {
                            return new PasswordAuthentication(user1, pass1);
                        }
                    });
                    MimeMessage message = new MimeMessage(session2);
                    message.setFrom(new InternetAddress(user1));
                    message.addRecipient(Message.RecipientType.TO, new InternetAddress(to1));
                    message.setSubject(oggetto);
                    message.setText(messaggio);
                    
                    /* Transport class is used to deliver the message to the recipients */
                    if(u.isSendEmail()){
                        Transport.send(message);
                    }
                    notificationdao.addNotification(email, "proximityMail", lista);
            }
        } catch (DAOException ex) {
            System.out.println("#1 Errore nell'invio dell'email a " + email);
            Logger.getLogger(sendProximityEmail.class.getName()).log(Level.SEVERE, null, ex);
        } catch (MessagingException ex) {
            System.out.println("#2 Errore nell'invio dell'email a " + email);
            Logger.getLogger(sendProximityEmail.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

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
