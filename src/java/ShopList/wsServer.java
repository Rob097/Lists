/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ShopList;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.ArrayList;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

@ServerEndpoint("/wsServer")
public class wsServer {

    private static final ArrayList<Session> ALLSESSION = new ArrayList<Session>();
    private static final ArrayList<String> LISTE = new ArrayList<String>();
    
    
    @OnOpen
    public void handleOpen(Session session) {
        System.out.println("client is now connecteddddddddddddddddddddddddddddddddddddd...");
        System.out.println("sessioneeeeeeee" + session.getId());
        ALLSESSION.add(session);
    }

    @OnClose
    public void handleClose(Session session) throws UnsupportedEncodingException, IOException {
        System.out.println("client is now disconnected...");
        messagesFromListToFile();
    }

    @OnMessage
    public void handleMessage(String message, Session session) throws UnsupportedEncodingException {

        System.out.println("receive from client: " + message);
        String replyMessage = message;
        LISTE.add(replyMessage);
        System.out.println("send to client: " + replyMessage);

        ALLSESSION.stream().filter((sess) -> (sess.isOpen())).map((sess) -> {
            System.out.println("SONO UNA SESSIONEEEEE");
            return sess;
        }).forEachOrdered((sess) -> {
            try {
                sess.getAsyncRemote().sendText(replyMessage);
            } catch (Exception ioe) {
                System.out.println(ioe.getMessage());
            }
        });
    }

    @OnError
    public void handleError(Throwable t) {
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

    public void jsonCreateFile(String fname, String sender, String message) throws org.json.simple.parser.ParseException {

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
            try (FileWriter file = new FileWriter(fname)) {
                file.write(array.toString());
                file.flush();
            }

        } catch (IOException e) {
        }
    }

    public static JSONArray readJSONObject(String p) {
        JSONParser parser = new JSONParser();
        try {

            Object obj;
            try ( /* Get the file content into the JSONObject */ FileReader fr = new FileReader(p)) {
                obj = parser.parse(fr);
            }
            JSONArray jsonObject = (JSONArray) obj;

            System.out.println("Object from file:" + jsonObject);
            return jsonObject;
        } catch (IOException | ParseException e) {
        }
        return null;
    }

    public void append(String listname, String sender, String message) throws UnsupportedEncodingException, IOException {
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

            
            try(FileWriter file = new FileWriter(folderWithChat)){
                file.write(arrayJson.toString());
                file.flush();
                file.close();
            }
        } else {

            try {
                jsonCreateFile(folderWithChat, sender, message);
            } catch (ParseException e) {
            }

        }
    }

    //@list lista che si è disconessa
    public void messagesFromListToFile() throws UnsupportedEncodingException, IOException {
        if (!LISTE.isEmpty()) {
            for (String s : LISTE) {
                System.out.println(s);
                append(s.split(":")[0], s.split(":")[1], s.split(":")[2]);

            }
            LISTE.clear();
        }
    }

}
