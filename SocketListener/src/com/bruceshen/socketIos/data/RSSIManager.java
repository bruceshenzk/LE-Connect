package com.bruceshen.socketIos.data;

import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Created by zekunshen on 6/3/16.
 */
class RSSIManager extends MapManager {


    RSSIManager() {
        map = new ConcurrentHashMap<UUID, Integer>();
    }
    @Override
    public void printData() {
        System.out.println("RSSI Data");
        for(Object object:  map.entrySet()) {
            Map.Entry<UUID, Integer> entry = (Map.Entry)(object);
            System.out.format("    UUID: %s      Motion: %3d", entry.getKey().toString(), entry.getValue());
        }
        System.out.println();
    }
}
