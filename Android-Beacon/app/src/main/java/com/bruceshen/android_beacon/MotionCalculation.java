package com.bruceshen.android_beacon;

import android.hardware.SensorEvent;

/**
 * Created by zekunshen on 7/8/16.
 */
public interface MotionCalculation {
    double calcMotion(SensorEvent sensorEvent);
    int getSensor();
}
