package com.bruceshen.android_beacon;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.nfc.Tag;
import android.util.Log;

/**
 * Created by zekunshen on 7/6/16.
 */
public class AccelerationManager implements SensorEventListener{
    private static final String TAG = AccelerationManager.class.getCanonicalName();

    private SensorManager mSensorManager;
    private Sensor mSensor;
    private Context context;

    private float[] gravity = {0f, 0f, 0f};
    private float[] linear_acceleration = {0f, 0f, 0f};
    private Double[] accelerationOverTime = {0d,0d,0d,0d,0d};
    private int acceleratinIndex = 0;
    public Double averagedAcceleration = 0d;
    public boolean hasValue = false;

    public AccelerationManager(Context aContext) {
        context = aContext;
        mSensorManager = (SensorManager) context.getSystemService(Context.SENSOR_SERVICE);
        mSensor = mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
        registerListener();
    }


    public void unregisterListener() {
        mSensorManager.unregisterListener(this);
    }

    public void registerListener() {
        mSensorManager.registerListener(this, mSensor, SensorManager.SENSOR_DELAY_NORMAL);
    }

    private void calculateAverage() {
        Double sum = 0d;
        for(int i = 0; i < 5; i++) {
            sum += accelerationOverTime[i];
        }
        averagedAcceleration = sum/5d;
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int i) {

    }

    @Override
    public void onSensorChanged(SensorEvent sensorEvent) {
        Log.e(TAG, "onSensorChanged called");
        final float alpha = 0.8f;

        gravity[0] = alpha * gravity[0] + (1 - alpha) * sensorEvent.values[0];
        gravity[1] = alpha * gravity[1] + (1 - alpha) * sensorEvent.values[1];
        gravity[2] = alpha * gravity[2] + (1 - alpha) * sensorEvent.values[2];

        linear_acceleration[0] = sensorEvent.values[0] - gravity[0];
        linear_acceleration[1] = sensorEvent.values[1] - gravity[1];
        linear_acceleration[2] = sensorEvent.values[2] - gravity[2];

        accelerationOverTime[(acceleratinIndex++)%5] = (double) (linear_acceleration[0]*linear_acceleration[0]
                +linear_acceleration[1]*linear_acceleration[1]+linear_acceleration[2]*linear_acceleration[2]);
        calculateAverage();
        if(!hasValue) {
            hasValue = true;
        }
    }
}
