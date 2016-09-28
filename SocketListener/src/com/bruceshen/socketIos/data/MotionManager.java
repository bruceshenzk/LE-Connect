package com.bruceshen.socketIos.data;

import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Created by zekunshen on 6/3/16.
 */
class MotionManager extends MapManager {

    MotionManager() {
        map = new ConcurrentHashMap<UUID, Double>();
    }

    @Override
    public void printData() {
        System.out.println("Motion Data");
        for(Object object:  map.entrySet()) {
            Map.Entry<UUID, Double> entry = (Map.Entry)(object);
            System.out.format("    UUID: %s      Motion: %7.5f", entry.getKey(), entry.getValue());
        }
        System.out.println();
    }
}
