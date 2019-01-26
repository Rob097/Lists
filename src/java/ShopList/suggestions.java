/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ShopList;

import database.daos.ListDAO;
import database.entities.ListProd;
import database.exceptions.DAOException;
import database.factories.DAOFactory;
import database.jdbc.JDBCShopListDAO;
import java.io.IOException;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Dmytr
 */
public class suggestions extends HttpServlet {
    private static final long serialVersionUID = 6106269076155338045L;
    transient ListDAO listdao = null;

    @Override
    public void init() throws ServletException {
        //carica la Connessione inizializzata in JDBCDAOFactory, quindi ritorna il Class.for() e la connessione
        DAOFactory daoFactory = (DAOFactory) super.getServletContext().getAttribute("daoFactory");
        if (daoFactory == null) {
            throw new ServletException("Impossible to get dao factory for user storage system");
        }
        //assegna a userdao la connessione(costruttore) e salva la connessione in una variabile tipo Connection
        listdao = new JDBCShopListDAO(daoFactory.getConnection());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String listname = (String) request.getSession().getAttribute("shoplist");
        ArrayList<ListProd> listprod = new ArrayList<>();
        try {
            listprod = listdao.getProdList(listname);
        } catch (DAOException e) {
            System.out.println("ERRORE: non è stato possibile estatre i dati dalla tabella List_Prod, controllare da DAO delle liste");
        }

        for (ListProd elem : listprod) {
            /*
            
            VERSIONE DI SUGGERIMENTO CON LE DATE
            
            Date insertDate = elem.getData_inserimento();
            Date acquistoDate = elem.getDataAcquisto();
            Date currentDate = (Date) Calendar.getInstance().getTime();
            long difFrequence = differenceBetweenDates(insertDate, acquistoDate);
            long difLate = differenceBetweenDates(insertDate, acquistoDate);*/
            Calendar calendario = Calendar.getInstance();
            Date currentDate = null;
            try{
                currentDate = (Date) calendario.getTime();
            }catch(ClassCastException cce){                
            }
            Date acquistoDate = elem.getDataAcquisto();
            Date insertDate = elem.getData_inserimento();
            long difFrequence = differenceInMinutesBetweenDates(insertDate, acquistoDate);
            long difLate = differenceInMinutesBetweenDates(acquistoDate, currentDate);
            
            
            if (("Acquistato".equals(elem.getStato())) && ((difFrequence - difLate) < 3)) {
                System.out.println("Di solito in questo periodo acquisto questo prodotto, lo vuoi acquistare?" + elem.getProdotto());
            }

        }

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

    /**
     * il metodo restituisce la differenza in giorni tra due date
     *
     * @param uno
     * @param due
     * @return
     */
    public long differenceBetweenDates(Date uno, Date due) {
        Calendar c1 = Calendar.getInstance();
        Calendar c2 = Calendar.getInstance();
        c1.setTime(uno);
        c2.setTime(due);

        long giorni = (c2.getTime().getTime() - c1.getTime().getTime()) / (24 * 3600 * 1000);

        return giorni;
    }

    public int differenceInMinutesBetweenDates(Date d1, Date d2) {
        try {
            String strDate1 = "2007/04/15 12:35:05";
            String strDate2 = "2009/08/02 20:45:07";

            SimpleDateFormat fmt = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            fmt.setLenient(false);

            // Parses the two strings.
            //Date d1 = (Date) fmt.parse(strDate1);
            //Date d2 = (Date) fmt.parse(strDate2);

            // Calculates the difference in milliseconds.
            long millisDiff = d2.getTime() - d1.getTime();

            // Calculates days/hours/minutes/seconds.
            int seconds = (int) (millisDiff / 1000 % 60);
            int minutes = (int) (millisDiff / 60000 % 60);
            int hours = (int) (millisDiff / 3600000 % 24);
            int days = (int) (millisDiff / 86400000);

            System.out.println("Between " + strDate1 + " and " + strDate2 + " there are:");
            System.out.print(days + " days, ");
            System.out.print(hours + " hours, ");
            System.out.print(minutes + " minutes, ");
            System.out.println(seconds + " seconds");
            return minutes;
        } catch (Exception e) {
            System.err.println(e);
            return 0;
        }
    }
    
    /**
     * String strDate1 = "2007/04/15 12:35:05";
     * @param data
     * @return 
     */
    public Date dataDiProva(String data) {
        try {
            String strDate1 = data;
            String strDate2 = "2009/08/02 20:45:07";

            SimpleDateFormat fmt = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
            fmt.setLenient(false);

            // Parses the two strings.
            Date d1 = null;
            try{
                d1  = (Date) fmt.parse(strDate1);
            }catch(ClassCastException cce){}
            return d1;
        } catch (ParseException e) {
            System.out.println("sbagliata conversione data");
            return null;
        }
    }

}
