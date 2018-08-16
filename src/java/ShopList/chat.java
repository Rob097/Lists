/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ShopList;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.catalina.connector.CoyoteWriter;
import org.json.simple.JSONObject;

/**
 *
 * @author Dmytr
 */
public class chat extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String sender;
        String msg;
        String listaname;
        ArrayList<String> m = new ArrayList<String>();

        msg = (String) request.getParameter("messaggio");
        sender = (String) request.getParameter("Sender");
        listaname = (String) request.getSession().getAttribute("shopListName");
        m.add(sender + ":" + msg);

        String chatFolder = "/Pages/chat";
        chatFolder = getServletContext().getRealPath(chatFolder);
        chatFolder = chatFolder.replace("\\build", "");
        chatFolder = chatFolder + "/" + listaname + ".json";

        SaveMessage(m, chatFolder);

    }

    public void SaveMessage(ArrayList<String> m, String listname) throws IOException {
        boolean last = false;
        for (String s : m) {
            if(m.indexOf(m) == m.size())
                last = true;
            else
                last = false;
            
            appendToCheckbook(listname, s.split(":")[0], s.split(":")[1], last);
        }
        

    }

    public void WriteOnTheFile(String fname, String content) throws IOException {
        BufferedWriter bw = null;
        FileWriter fw = null;

        try {
            String data = " This is new content";

            File file = new File(fname);

            // if file doesnt exists, then create it
            if (!file.exists()) {
                file.createNewFile();
            }

            // true = append file
            fw = new FileWriter(file.getAbsoluteFile(), true);
            bw = new BufferedWriter(fw);

            bw.write(content);

            System.out.println("Done");

        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (bw != null) {
                    bw.close();
                }
                if (fw != null) {
                    fw.close();
                }
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
    }
    
    public void appendToCheckbook (String fname, String name, String message, boolean last) {

      BufferedWriter bw = null;

      try {
         // APPEND MODE SET HERE
         bw = new BufferedWriter(new FileWriter(fname, true));
	 bw.write("[");
	 bw.newLine();
         bw.write("{");
         bw.newLine();
         bw.write("\"name\""+": "+name+",");
         bw.newLine();
         bw.write("\"message\""+": "+message);
         bw.newLine();
         if(last)
             bw.write("},");
         else
             bw.write("}]");
	 bw.flush();
      } catch (IOException ioe) {
	 ioe.printStackTrace();
      } finally {                       // always close the file
	 if (bw != null) try {
	    bw.close();
	 } catch (IOException ioe2) {
	    // just ignore it
	 }
      } // end try/catch/finally

   } // end test()
    
    public void CreateJSONfile(String fname, String message, String name){
        JSONObject obj = new JSONObject();
        obj.put("name", name);
        obj.put("message",message);

        try (FileWriter file = new FileWriter(fname,true)) {

            file.write(obj.toJSONString());
            file.flush();

        } catch (IOException e) {
            e.printStackTrace();
        }

        System.out.print(obj);
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
