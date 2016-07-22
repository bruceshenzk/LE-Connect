package com.bruceshen.android_beacon;

import android.hardware.Sensor;
import android.hardware.SensorEvent;

/**
 * Created by zekunshen on 7/8/16.
 */
public class LinearMotionCalculation implements MotionCalculation {

    private Double[] accelerationOverTime = {0d,0d,0d,0d,0d};
    private int acceleratinIndex = 0;

    @Override
    public double calcMotion(SensorEvent sensorEvent) {
        float[] values = sensorEvent.values;
        accelerationOverTime[acceleratinIndex++] = Math.sqrt((double) (values[0]*values[0]
                +values[1]*values[1]+values[2]*values[2]));
        return calculateAverage();
    }

    @Override
    public int getSensor() {
        return Sensor.TYPE_LINEAR_ACCELERATION;
    }


    private double calculateAverage() {
        Double sum = 0d;
        for(int i = 0; i < 5; i++) {
            sum += accelerationOverTime[i];
        }
        return sum/5d;
    }
}
