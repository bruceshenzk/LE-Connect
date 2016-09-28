package com.bruceshen.socketIos.socket;

import com.bruceshen.socketIos.Parser;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;

/**
 * Created by zekunshen on 6/3/16.
 */
public class SocketThread extends Thread {
    Socket clientSocket;

    public SocketThread(Socket aClientSocket) {
        clientSocket = aClientSocket;
    }

    public void run() {
        super.run();
        try {

            PrintWriter out =
                    new PrintWriter(clientSocket.getOutputStream(), true);
            BufferedReader in = new BufferedReader(
                    new InputStreamReader(clientSocket.getInputStream()));


            String inputLine;
            while ((inputLine = in.readLine()) != null) {
                // got input from socket
                //System.out.println("Received: "+ inputLine);
                Parser.parse(inputLine);
                if (inputLine.equalsIgnoreCase("quit"))
                    break;
            }
            clientSocket.close();
        }
        catch (IOException e) {

        }
    }
}