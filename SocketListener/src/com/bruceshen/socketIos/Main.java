package com.bruceshen.socketIos;

import com.bruceshen.socketIos.data.DataManager;
import com.bruceshen.socketIos.socket.SocketServer;

/**
 * Created by zekunshen on 6/3/16.
 */
public class Main {

    public static void main(String[] args) {
        SocketServer server = new SocketServer(4000);
        DataManager dataManager = DataManager.getInstance();
        dataManager.startPrinting();
    }

}
