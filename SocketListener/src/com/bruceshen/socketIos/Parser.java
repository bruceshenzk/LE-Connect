package com.bruceshen.socketIos;

import com.bruceshen.socketIos.data.DataManager;
import com.bruceshen.socketIos.data.DeviceData;

import java.util.UUID;

/**
 * Created by zekunshen on 6/3/16.
 */
public class Parser {


    public static void parse(String string) {
        String[] splits = string.split(";");
        String uuid = null;
        double motion = 0;
        int rssi = 0;
        boolean canUse = false;
        for(String str: splits) {
            if(str.startsWith("peripheral:")) {
                uuid = str.substring("peripheral:".length());
                canUse = true;
            }
            else if(str.startsWith("userAcceleration:")) {
                motion = Double.parseDouble(str.substring("userAcceleration:".length()));
            }
            else if(str.startsWith("rssi:")) {
                rssi = Integer.parseInt(str.substring("rssi:".length()));
            }
        }
        if(canUse) {
            DataManager.getInstance().processData(new DeviceData(motion, rssi, uuid));
        }
    }

}
