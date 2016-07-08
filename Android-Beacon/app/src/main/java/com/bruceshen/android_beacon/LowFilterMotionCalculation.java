package com.bruceshen.android_beacon;

import android.hardware.Sensor;
import android.hardware.SensorEvent;

/**
 * Created by zekunshen on 7/8/16.
 */
public class LowFilterMotionCalculation implements MotionCalculation {

    private float[] gravity = {0f, 0f, 0f};
    private float[] linear_acceleration = {0f, 0f, 0f};
    private Double[] accelerationOverTime = {0d,0d,0d,0d,0d};
    private int acceleratinIndex = 0;


    @Override
    public double calcMotion(SensorEvent sensorEvent) {
        final float alpha = 0.8f;

        gravity[0] = alpha * gravity[0] + (1 - alpha) * sensorEvent.values[0];
        gravity[1] = alpha * gravity[1] + (1 - alpha) * sensorEvent.values[1];
        gravity[2] = alpha * gravity[2] + (1 - alpha) * sensorEvent.values[2];

        linear_acceleration[0] = sensorEvent.values[0] - gravity[0];
        linear_acceleration[1] = sensorEvent.values[1] - gravity[1];
        linear_acceleration[2] = sensorEvent.values[2] - gravity[2];

        accelerationOverTime[(acceleratinIndex++)%5] = (double) (linear_acceleration[0]*linear_acceleration[0]
                +linear_acceleration[1]*linear_acceleration[1]+linear_acceleration[2]*linear_acceleration[2]);
        return calculateAverage();
    }

    @Override
    public int getSensor() {
        return Sensor.TYPE_ACCELEROMETER;
    }

    private double calculateAverage() {
        Double sum = 0d;
        for(int i = 0; i < 5; i++) {
            sum += accelerationOverTime[i];
        }
        return sum/5d;
    }
}
