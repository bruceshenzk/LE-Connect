package com.bruceshen.socketIos.data;


/**
 * Created by zekunshen on 6/3/16.
 */
public class DeviceData {
    double motion;
    int rssi;
    String uuid;

    public DeviceData(double aMotion, int aRssi, String aUuid) {
        motion = aMotion;
        rssi = aRssi;
        uuid = aUuid;
    }
}
