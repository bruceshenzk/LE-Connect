package com.bruceshen.socketIos.data;

import java.util.UUID;
import java.util.concurrent.*;

/**
 * Created by zekunshen on 6/2/16.
 */
public class DataManager {
    ScheduledExecutorService executor = Executors.newScheduledThreadPool(1);
    private MotionManager motionManager;
    private RSSIManager rssiManager;

    public static volatile DataManager instance = null;

    private DataManager() {
        motionManager = new MotionManager();
        rssiManager = new RSSIManager();
    }

    public static DataManager getInstance() {
        if(instance == null) {
            synchronized (DataManager.class) {
                if(instance == null) {
                    instance = new DataManager();
                }
            }
        }
        return instance;
    }

    public void processData(DeviceData data) {
        // TODO:
        if(data.rssi != 0) {
            rssiManager.put(data.uuid, data.rssi);
        }
        if(data.motion != 0) {
            motionManager.put(data.uuid, data.motion);
        }
    }

    public void printData() {
        motionManager.printData();
        rssiManager.printData();
    }

    public void startPrinting() {
        executor.scheduleAtFixedRate(new PrintRunnable(this), 1000L, 5000L, TimeUnit.MILLISECONDS);
    }

    public void stopPrinting() {
        executor.shutdown();
    }

    private class PrintRunnable implements Runnable {
        DataManager dataManager;

        public PrintRunnable(DataManager aDataManager) {
            dataManager = aDataManager;
        }

        @Override
        public void run() {
            dataManager.printData();
        }
    }

}
