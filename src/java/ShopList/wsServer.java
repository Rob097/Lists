/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ShopList;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Set;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

/**
 *
 * @author Dmytr
 */
@ServerEndpoint("/wsServer")
public class wsServer {

    private static ArrayList<Session> allSessions = new ArrayList<Session>();

    @OnOpen
    public void handleOpen(Session session) {
        System.out.println("client is now connecteddddddddddddddddddddddddddddddddddddd...");
        System.out.println("sessioneeeeeeee" + session.getId());
        allSessions.add(session);
    }

    @OnClose
    public void handleClose() {
        System.out.println("client is now disconnected...");
    }

    @OnMessage
    public void handleMessage(String message, Session session) {

        System.out.println("receive from client: " + message);
        String replyMessage = "echo " + message;
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

    public void saveOnthefile(String message) throws IOException {
        String fname = null;
        fname = "C:\\Users\\Dmytr\\Documents\\NetBeansProjects\\ProvaWebSocket\\web\\prova.txt";
        String str = message;
        BufferedWriter writer = new BufferedWriter(new FileWriter(fname));
        writer.write(str);

        writer.close();

    }

    public void SendMessage(String msg, Session session) throws IOException {
        session.getBasicRemote().sendText("got your message ");
    }
}
