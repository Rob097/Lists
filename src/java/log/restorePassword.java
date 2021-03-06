/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package log;

import database.daos.UserDAO;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCUserDAO;
import java.io.IOException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Roberto97
 */
public class restorePassword extends HttpServlet {
    private static final long serialVersionUID = 6106269076155338045L;
    transient UserDAO userdao = null;

    @Override
    public void init() throws ServletException {
        //carica la Connessione inizializzata in JDBCDAOFactory, quindi ritorna il Class.for() e la connessione
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        //assegna a userdao la connessione(costruttore) e salva la connessione in una variabile tipo Connection
        userdao = new JDBCUserDAO(daoFactory.getConnection());

    }

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
        String email = request.getParameter("emailrestore"); System.out.println("EMAILLLLL: " + email);
        HttpSession session = (HttpSession) request.getSession(false);
        try {
            if (userdao.getByEmail(email) != null) {

                String messaggioEM = "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n"
                        + "<html>\n"
                        + "\n"
                        + "<head>\n"
                        + "    <meta charset=\"UTF-8\">\n"
                        + "    <meta content=\"width=device-width, initial-scale=1\" name=\"viewport\">\n"
                        + "    <meta name=\"x-apple-disable-message-reformatting\">\n"
                        + "    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">\n"
                        + "    <meta content=\"telephone=no\" name=\"format-detection\">\n"
                        + "    <title></title>\n"
                        + "    <!--[if (mso 16)]>\n"
                        + "    <style type=\"text/css\">\n"
                        + "    a {text-decoration: none;}\n"
                        + "    </style>\n"
                        + "    <![endif]-->\n"
                        + "    <!--[if gte mso 9]><style>sup { font-size: 100% !important; }</style><![endif]-->\n"
                        + "    <!--[if !mso]><!-- -->\n"
                        + "    <link href=\"https://fonts.googleapis.com/css?family=Open+Sans:400,400i,700,700i\" rel=\"stylesheet\">\n"
                        + "    <!--<![endif]-->\n"
                        + "</head>\n"
                        + "\n"
                        + "<body>\n"
                        + "    <div class=\"es-wrapper-color\">\n"
                        + "        <!--[if gte mso 9]>\n"
                        + "			<v:background xmlns:v=\"urn:schemas-microsoft-com:vml\" fill=\"t\">\n"
                        + "				<v:fill type=\"tile\" color=\"#eeeeee\"></v:fill>\n"
                        + "			</v:background>\n"
                        + "		<![endif]-->\n"
                        + "        <table class=\"es-wrapper\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\">\n"
                        + "            <tbody>\n"
                        + "                <tr>\n"
                        + "                    <td class=\"esd-email-paddings\" valign=\"top\">\n"
                        + "                        <table class=\"es-content esd-header-popover\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\">\n"
                        + "                            <tbody>\n"
                        + "                                <tr> </tr>\n"
                        + "                                <tr>\n"
                        + "                                    <td class=\"esd-stripe\" esd-custom-block-id=\"7681\" align=\"center\">\n"
                        + "                                        <table class=\"es-header-body\" style=\"background-color: rgb(33, 37, 41);\" width=\"600\" cellspacing=\"0\" cellpadding=\"0\" bgcolor=\"#212529\" align=\"center\">\n"
                        + "                                            <tbody>\n"
                        + "                                                <tr>\n"
                        + "                                                    <td class=\"esd-structure es-p35t es-p35b es-p35r es-p35l\" align=\"left\">\n"
                        + "                                                        <!--[if mso]><table width=\"530\" cellpadding=\"0\" cellspacing=\"0\"><tr><td width=\"340\" valign=\"top\"><![endif]-->\n"
                        + "                                                        <table class=\"es-left\" cellspacing=\"0\" cellpadding=\"0\" align=\"left\">\n"
                        + "                                                            <tbody>\n"
                        + "                                                                <tr>\n"
                        + "                                                                    <td class=\"es-m-p0r es-m-p20b esd-container-frame\" width=\"340\" valign=\"top\" align=\"center\">\n"
                        + "                                                                        <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\">\n"
                        + "                                                                            <tbody>\n"
                        + "                                                                                <tr>\n"
                        + "                                                                                    <td class=\"esd-block-text es-m-txt-c\" align=\"left\">\n"
                        + "                                                                                        <h1 style=\"color: #ffffff; line-height: 100%;\">Lists</h1>\n"
                        + "                                                                                    </td>\n"
                        + "                                                                                </tr>\n"
                        + "                                                                            </tbody>\n"
                        + "                                                                        </table>\n"
                        + "                                                                    </td>\n"
                        + "                                                                </tr>\n"
                        + "                                                            </tbody>\n"
                        + "                                                        </table>\n"
                        + "                                                        <!--[if mso]></td><td width=\"20\"></td><td width=\"170\" valign=\"top\"><![endif]-->\n"
                        + "                                                        <table cellspacing=\"0\" cellpadding=\"0\" align=\"right\">\n"
                        + "                                                            <tbody>\n"
                        + "                                                                <tr class=\"es-hidden\">\n"
                        + "                                                                    <td class=\"es-m-p20b esd-container-frame\" esd-custom-block-id=\"7704\" width=\"170\" align=\"left\">\n"
                        + "                                                                        <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\">\n"
                        + "                                                                            <tbody>\n"
                        + "                                                                                <tr>\n"
                        + "                                                                                    <td align=\"center\" class=\"esd-block-image\">\n"
                        + "                                                                                        <a target=\"_blank\"> <img class=\"adapt-img\" src=\"https://fsbup.stripocdn.email/content/guids/33b07588-67c5-4427-b37d-5cbe0674345a/images/9851541860088889.png\" alt=\"\" style=\"display: block;\" width=\"36\"> </a>\n"
                        + "                                                                                    </td>\n"
                        + "                                                                                </tr>\n"
                        + "                                                                            </tbody>\n"
                        + "                                                                        </table>\n"
                        + "                                                                    </td>\n"
                        + "                                                                </tr>\n"
                        + "                                                            </tbody>\n"
                        + "                                                        </table>\n"
                        + "                                                        <!--[if mso]></td></tr></table><![endif]-->\n"
                        + "                                                    </td>\n"
                        + "                                                </tr>\n"
                        + "                                            </tbody>\n"
                        + "                                        </table>\n"
                        + "                                    </td>\n"
                        + "                                </tr>\n"
                        + "                            </tbody>\n"
                        + "                        </table>\n"
                        + "                        <table class=\"es-content esd-footer-popover\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\">\n"
                        + "                            <tbody>\n"
                        + "                                <tr>\n"
                        + "                                    <td class=\"esd-stripe\" align=\"center\">\n"
                        + "                                        <table class=\"es-content-body\" width=\"600\" cellspacing=\"0\" cellpadding=\"0\" bgcolor=\"#ffffff\" align=\"center\">\n"
                        + "                                            <tbody>\n"
                        + "                                                <tr>\n"
                        + "                                                    <td class=\"esd-structure es-p40t es-p35b es-p35r es-p35l\" esd-custom-block-id=\"7685\" style=\"background-color: rgb(247, 247, 247);\" bgcolor=\"#f7f7f7\" align=\"left\">\n"
                        + "                                                        <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\">\n"
                        + "                                                            <tbody>\n"
                        + "                                                                <tr>\n"
                        + "                                                                    <td class=\"esd-container-frame\" width=\"530\" valign=\"top\" align=\"center\">\n"
                        + "                                                                        <table width=\"100%\" cellspacing=\"0\" cellpadding=\"0\">\n"
                        + "                                                                            <tbody>\n"
                        + "                                                                                <tr>\n"
                        + "                                                                                    <td class=\"esd-block-image es-p20t es-p25b es-p35r es-p35l\" align=\"center\">\n"
                        + "                                                                                        <a target=\"_blank\" href=\"https://stripo.email/\"> <img src=\"https://my.stripo.email/content/guids/CABINET_8454848d0c8f91553c60d81453502d38/images/6541541870548519.png\" alt=\"ship\" style=\"display: block;\" title=\"ship\" width=\"150\"> </a>\n"
                        + "                                                                                    </td>\n"
                        + "                                                                                </tr>\n"
                        + "                                                                                <tr>\n"
                        + "                                                                                    <td class=\"esd-block-text es-p15b\" align=\"center\">\n"
                        + "                                                                                        <h2 style=\"color: #333333;\">Premi sul pulsante per recuperare la tua password</h2>\n"
                        + "                                                                                    </td>\n"
                        + "                                                                                </tr>\n"
                        + "                                                                                <tr>\n"
                        + "                                                                                    <td class=\"esd-block-text es-p15t es-p10b\" align=\"left\">\n"
                        + "                                                                                        <p style=\"font-size: 16px; color: #777777;\">Per recuperare la password di "+ email +" premi \"Recupera password\"&nbsp;</p>\n"
                        + "                                                                                    </td>\n"
                        + "                                                                                </tr>\n"
                        + "                                                                                <tr>\n"
                        + "                                                                                    <td class=\"esd-block-button es-p25t es-p20b es-p10r es-p10l\" align=\"center\"> <span class=\"es-button-border\" style=\"background: rgb(237, 28, 36);\"> <a href=\"http://localhost:8080/Lists/?restorePasswordOf="+email+"\" class=\"es-button\" target=\"_blank\" style=\"padding: 1.4rem 1.6rem; display: inline-block; border-radius: 1rem;font-weight: normal; border-width: 15px 30px; color: rgb(255, 255, 255); font-size: 18px; background: rgb(237, 28, 36); border-color: rgb(237, 28, 36);\">Recupera password</a> </span> </td>\n"
                        + "                                                                                </tr>\n"
                        + "                                                                                <tr>\n"
                        + "                                                                                    <td align=\"left\" class=\"esd-block-text\">\n"
                        + "                                                                                        <p>Se hai ricevuto questa email per sbaglio ignorala.</p>\n"
                        + "                                                                                        <p><br></p>\n"
                        + "                                                                                        <p>©Lists - 2019<br></p>\n"
                        + "                                                                                    </td>\n"
                        + "                                                                                </tr>\n"
                        + "                                                                            </tbody>\n"
                        + "                                                                        </table>\n"
                        + "                                                                    </td>\n"
                        + "                                                                </tr>\n"
                        + "                                                            </tbody>\n"
                        + "                                                        </table>\n"
                        + "                                                    </td>\n"
                        + "                                                </tr>\n"
                        + "                                            </tbody>\n"
                        + "                                        </table>\n"
                        + "                                    </td>\n"
                        + "                                </tr>\n"
                        + "                            </tbody>\n"
                        + "                        </table>\n"
                        + "                    </td>\n"
                        + "                </tr>\n"
                        + "            </tbody>\n"
                        + "        </table>\n"
                        + "    </div>\n"
                        + "</body>\n"
                        + "\n"
                        + "</html>";

                final String User1 = "dellantonio47@gmail.com";
                final String pass1 = "jwjdxemvcgvppvgp";
                Properties props = new Properties();

                /* Specifies the IP address of your default mail server
              for e.g if you are using gmail server as an email sever
              you will pass smtp.gmail.com as value of mail.smtp host. 
              As shown here in the code. 
              Change accordingly, if your email id is not a gmail id
                 */
                //Nel caso non riesca ad inviare la mail a info@macelleriadellantonio.it, prova ad inviarla a dellantonio47@gmail.
                props.put("mail.smtp.host", "smtp.gmail.com");
                //below mentioned mail.smtp.port is optional
                props.put("mail.smtp.port", "587");
                props.put("mail.smtp.auth", "true");
                props.put("mail.smtp.starttls.enable", "true");
                Session session2;
                session2 = Session.getInstance(props, new javax.mail.Authenticator() {
                    @Override
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(User1, pass1);
                    }
                });

                try {
                    MimeMessage message = new MimeMessage(session2);
                    message.setFrom(new InternetAddress(User1));
                    message.addRecipient(Message.RecipientType.TO, new InternetAddress(email));
                    message.setSubject("Recupero password - " + email);

                    Multipart mp = new MimeMultipart();
                    MimeBodyPart htmlPart = new MimeBodyPart();
                    htmlPart.setContent(messaggioEM, "text/html");
                    mp.addBodyPart(htmlPart);
                    message.setContent(mp);

                    /* Transport class is used to deliver the message to the recipients */
                    Transport.send(message);
                } catch (MessagingException mex) {
                }


/*#################################################################################################################################################################
                                                            FINE EMAIL
#################################################################################################################################################################*/
                response.sendRedirect("homepage.jsp");
                session.setAttribute("messaggio", "Controlla la tua email per recuperare la password!");
            } else {
                response.sendRedirect("homepage.jsp");
                session.setAttribute("errore", "Attenzione, non ci riuslta che esista un account con email uguale a " + email + ", se vuoi puoi <strong data-toggle=\"modal\" data-target=\"#RegisterModal\" style=\"cursor: pointer;\"><u>registrarti</u></strong>");
            }
        } catch (DAOException ex) {
            Logger.getLogger(restorePassword.class.getName()).log(Level.SEVERE, null, ex);
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
