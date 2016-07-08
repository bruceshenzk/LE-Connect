package com.bruceshen.android_beacon;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.util.Log;

/**
 * Created by zekunshen on 7/6/16.
 */
public class AccelerationManager implements SensorEventListener{
    private static final String TAG = AccelerationManager.class.getCanonicalName();

    private SensorManager mSensorManager;
    private Sensor mSensor;
    private Context context;

    private MotionCalculation motionCalculation;

    public Double averagedAcceleration = 0d;
    public boolean hasValue = false;

    public AccelerationManager(Context aContext) {
        motionCalculation = new LinearMotionCalculation();
        context = aContext;
        mSensorManager = (SensorManager) context.getSystemService(Context.SENSOR_SERVICE);
        mSensor = mSensorManager.getDefaultSensor(motionCalculation.getSensor());
        if(mSensor == null) {
            motionCalculation = new LowFilterMotionCalculation();
            mSensor = mSensorManager.getDefaultSensor(motionCalculation.getSensor());
        }
        registerListener();
    }


    public void unregisterListener() {
        mSensorManager.unregisterListener(this);
    }

    public void registerListener() {
        mSensorManager.registerListener(this, mSensor, SensorManager.SENSOR_DELAY_NORMAL);
        if (! hasValue) {
            hasValue = true;
        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int i) {

    }

    @Override
    public void onSensorChanged(SensorEvent sensorEvent) {
        Log.e(TAG, "onSensorChanged called");
        averagedAcceleration = motionCalculation.calcMotion(sensorEvent);
    }
}
