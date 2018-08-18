/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ShopList;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Set;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

@ServerEndpoint("/wsServer")
public class wsServer {

    private static ArrayList<Session> allSessions = new ArrayList<Session>();
    private static ArrayList<String> liste = new ArrayList<String>();

    @OnOpen
    public void handleOpen(Session session) {
        System.out.println("client is now connecteddddddddddddddddddddddddddddddddddddd...");
        System.out.println("sessioneeeeeeee" + session.getId());
        allSessions.add(session);
    }

    @OnClose
    public void handleClose() throws UnsupportedEncodingException {
        System.out.println("client is now disconnected...");
        MessagesFromListToFile();
    }

    @OnMessage
    public void handleMessage(String message, Session session) throws UnsupportedEncodingException {

        System.out.println("receive from client: " + message);
        String replyMessage = message;
        liste.add(replyMessage);
        System.out.println("send to client: " + replyMessage);
        
        for (Session sess : allSessions) {

            System.out.println("SONO UNA SESSIONEEEEE");

            try {
                sess.getBasicRemote().sendText(replyMessage);
            } catch (IOException ioe) {
                System.out.println(ioe.getMessage());
            }
        }
    }

    @OnError
    public void handleError(Throwable t) {
        t.printStackTrace();
    }

    //ritorna il path della directory WEB
    //ma attenzione, perchè fa riferimento alla cartella della classe corrente
    public String getPath() throws UnsupportedEncodingException {
        String path = this.getClass().getClassLoader().getResource("").getPath();
        String fullPath = URLDecoder.decode(path, "UTF-8");
        fullPath = fullPath.replace("/build", "");
        fullPath = fullPath.replace("/WEB-INF/classes", "");
        return fullPath.replaceFirst("/", "");
    }

    public void JsonCreateFile(String fname, String sender, String message) throws org.json.simple.parser.ParseException {

        System.out.println("Write an JSON Object");
        /* Create simple object */
        JSONObject object = new JSONObject();
        object.put("name", sender);
        object.put("message", message);

        System.out.println("Simple object: " + object);

        /* json array added manualy */
        JSONArray array = new JSONArray();
        array.add(object);

        /* json array added from an ArrayList object */
        System.out.println("Array object: " + array);

        System.out.println("Complex object:" + object);

        /* write the complex object to a file */
        try {
            FileWriter file = new FileWriter(fname);
            file.write(array.toString());
            file.flush();
            file.close();

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static JSONArray readJSONObject(String p) {
        JSONParser parser = new JSONParser();
        try {
            /* Get the file content into the JSONObject */
            Object obj = parser.parse(new FileReader(p));
            JSONArray jsonObject = (JSONArray) obj;

            System.out.println("Object from file:" + jsonObject);
            return jsonObject;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void Append(String listname, String sender, String message) throws UnsupportedEncodingException {
        String folderWithChat = getPath() + "Pages/chat/" + listname + ".json";
        //String folderWithChat = getPath() + listname + ".json";
        System.out.println(folderWithChat);
        File jsonfile = new File(folderWithChat);
        if (jsonfile.exists()) {
            JSONArray arrayJson = readJSONObject(folderWithChat);

            JSONObject newObj = new JSONObject();
            newObj.put("name", sender);
            newObj.put("message", message);

            arrayJson.add(newObj);

            try {
                FileWriter file = new FileWriter(folderWithChat);
                file.write(arrayJson.toString());
                file.flush();
                file.close();

            } catch (IOException e) {
                e.printStackTrace();
            }
        } else {

            try {
                JsonCreateFile(folderWithChat, sender, message);
            } catch (Exception e) {
            }

        }
    }

    //@list lista che si è disconessa
    public void MessagesFromListToFile() throws UnsupportedEncodingException {
        for (String s : liste) {
            System.out.println(s);
            Append(s.split(":")[0], s.split(":")[1], s.split(":")[2]);

        }
        
        liste.clear();
    }

}
