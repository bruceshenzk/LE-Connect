package com.bruceshen.android_beacon;

import android.Manifest;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothGatt;
import android.bluetooth.BluetoothGattCharacteristic;
import android.bluetooth.BluetoothGattDescriptor;
import android.bluetooth.BluetoothGattServer;
import android.bluetooth.BluetoothGattServerCallback;
import android.bluetooth.BluetoothGattService;
import android.bluetooth.BluetoothManager;
import android.bluetooth.le.AdvertiseCallback;
import android.bluetooth.le.AdvertiseData;
import android.bluetooth.le.AdvertiseSettings;
import android.bluetooth.le.BluetoothLeAdvertiser;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.ParcelUuid;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.view.WindowManager;
import android.widget.TextView;
import android.widget.Toast;

import org.w3c.dom.Text;

import java.util.Arrays;
import java.util.HashSet;
import java.util.UUID;

public class MainActivity extends AppCompatActivity {


    private UUID TRANSFER_SERVICE_UUID = UUID.fromString("E20A39F4-73F5-4BC4-A12F-17D1AD07A961");
    private UUID MOTION_CHARACTERISTIC_UUID = UUID.fromString("16864516-21E0-11E6-B67B-9E71128CAE77");
    private UUID UUID_CHARACTERISTIC_UUID = UUID.fromString("D6F8BDCC-3885-11E6-AC61-9E71128CAE77");

    private static final int REQUEST_ENABLE_BT = 1;
    private static final String TAG = MainActivity.class.getCanonicalName();

    private TextView mAdvStatus;
    private BluetoothGattService mBluetoothGattService;
    private BluetoothGattCharacteristic mMotionCharacteristic, mUUIDCharacteristic;
    private BluetoothManager mBluetoothManager;
    private BluetoothAdapter mBluetoothAdapter;
    private AdvertiseData mAdvData;
    private AdvertiseSettings mAdvSettings;
    private BluetoothLeAdvertiser mAdvertiser;

    private final AdvertiseCallback mAdvCallback = new AdvertiseCallback() {
        @Override
        public void onStartFailure(int errorCode) {
            super.onStartFailure(errorCode);
            Log.e(TAG, "Not broadcasting: " + errorCode);
            int statusText;
            switch (errorCode) {
                case ADVERTISE_FAILED_ALREADY_STARTED:
                    statusText = R.string.status_advertising;
                    Log.w(TAG, "App was already advertising");
                    break;
                case ADVERTISE_FAILED_DATA_TOO_LARGE:
                    statusText = R.string.status_advDataTooLarge;
                    break;
                case ADVERTISE_FAILED_FEATURE_UNSUPPORTED:
                    statusText = R.string.status_advFeatureUnsupported;
                    break;
                case ADVERTISE_FAILED_INTERNAL_ERROR:
                    statusText = R.string.status_advInternalError;
                    break;
                case ADVERTISE_FAILED_TOO_MANY_ADVERTISERS:
                    statusText = R.string.status_advTooManyAdvertisers;
                    break;
                default:
                    statusText = R.string.status_notAdvertising;
                    Log.wtf(TAG, "Unhandled error: " + errorCode);
            }
            mAdvStatus.setText(statusText);
        }

        @Override
        public void onStartSuccess(AdvertiseSettings settingsInEffect) {
            super.onStartSuccess(settingsInEffect);
            Log.v(TAG, "Broadcasting");
            mAdvStatus.setText(R.string.status_advertising);
        }
    };

    private BluetoothGattServer mGattServer;
    private final BluetoothGattServerCallback mGattServerCallback = new BluetoothGattServerCallback() {

        @Override
        public void onCharacteristicReadRequest(BluetoothDevice device, int requestId, int offset,
                                                BluetoothGattCharacteristic characteristic) {
            super.onCharacteristicReadRequest(device, requestId, offset, characteristic);
            Log.d(TAG, "Device tried to read characteristic: " + characteristic.getUuid());
            Log.d(TAG, "Value: " + Arrays.toString(characteristic.getValue()));
            if (offset != 0) {
                mGattServer.sendResponse(device, requestId, BluetoothGatt.GATT_INVALID_OFFSET, offset,
            /* value (optional) */ null);
                return;
            }
            mGattServer.sendResponse(device, requestId, BluetoothGatt.GATT_SUCCESS,
                    offset, characteristic.getValue());
        }

        @Override
        public void onNotificationSent(BluetoothDevice device, int status) {
            super.onNotificationSent(device, status);
            Log.v(TAG, "Notification sent. Status: " + status);
        }


        @Override
        public void onDescriptorWriteRequest(BluetoothDevice device, int requestId,
                                             BluetoothGattDescriptor descriptor, boolean preparedWrite, boolean responseNeeded,
                                             int offset,
                                             byte[] value) {
            Log.v(TAG, "Descriptor Write Request " + descriptor.getUuid() + " " + Arrays.toString(value));
            super.onDescriptorWriteRequest(device, requestId, descriptor, preparedWrite, responseNeeded,
                    offset, value);
            if(responseNeeded) {
                mGattServer.sendResponse(device, requestId, BluetoothGatt.GATT_SUCCESS,
            /* No need to respond with offset */ 0,
            /* No need to respond with a value */ null);
            }
        }
    };
    private void resetStatusViews() {
        mAdvStatus.setText(R.string.status_notAdvertising);
    }

    private void ensureBleFeaturesAvailable() {
        if (mBluetoothAdapter == null) {
            Toast.makeText(this, R.string.bluetoothNotSupported, Toast.LENGTH_LONG).show();
            Log.e(TAG, "Bluetooth not supported");
            finish();
        } else if (!mBluetoothAdapter.isEnabled()) {
            // Make sure bluetooth is enabled.
            Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
            startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT);
        }
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        Log.d(TAG,"E1");
        mAdvStatus = (TextView) findViewById(R.id.textView_advertisingStatus);
        Log.d(TAG,"E2");
        if(mAdvStatus == null) {
            Log.d(TAG, "E3");
        }

        mBluetoothManager = (BluetoothManager) getSystemService(Context.BLUETOOTH_SERVICE);
        mBluetoothAdapter = mBluetoothManager.getAdapter();

        // If we are not being restored from a previous state then create and add the fragment.
        if (savedInstanceState == null) {

        } else {

        }
        mBluetoothGattService = new BluetoothGattService(TRANSFER_SERVICE_UUID,
                BluetoothGattService.SERVICE_TYPE_PRIMARY);
        mMotionCharacteristic = new BluetoothGattCharacteristic(MOTION_CHARACTERISTIC_UUID,
                BluetoothGattCharacteristic.PROPERTY_READ,
                BluetoothGattCharacteristic.PERMISSION_READ);
        mUUIDCharacteristic = new BluetoothGattCharacteristic(UUID_CHARACTERISTIC_UUID,
                BluetoothGattCharacteristic.PROPERTY_READ,
                BluetoothGattCharacteristic.PERMISSION_READ);

        String uuid = UUID.randomUUID().toString();
        mUUIDCharacteristic.setValue(uuid);

        mBluetoothGattService.addCharacteristic(mMotionCharacteristic);
        mBluetoothGattService.addCharacteristic(mUUIDCharacteristic);


        mAdvSettings = new AdvertiseSettings.Builder()
                .setAdvertiseMode(AdvertiseSettings.ADVERTISE_MODE_BALANCED)
                .setTxPowerLevel(AdvertiseSettings.ADVERTISE_TX_POWER_MEDIUM)
                .setConnectable(true)
                .build();
        mAdvData = new AdvertiseData.Builder()
                .setIncludeDeviceName(true)
                .setIncludeTxPowerLevel(true)
                .addServiceUuid(new ParcelUuid(TRANSFER_SERVICE_UUID))
                .build();

    }


    @Override
    protected void onStart() {
        super.onStart();
        resetStatusViews();
        mGattServer = mBluetoothManager.openGattServer(this, mGattServerCallback);
        if (mGattServer == null) {
            ensureBleFeaturesAvailable();
            return;
        }
        mGattServer.addService(mBluetoothGattService);
        if (mBluetoothAdapter.isMultipleAdvertisementSupported()) {
            mAdvertiser = mBluetoothAdapter.getBluetoothLeAdvertiser();
            mAdvertiser.startAdvertising(mAdvSettings, mAdvData, mAdvCallback);
        } else {
            mAdvStatus.setText(R.string.status_noLeAdv);
        }
    }

    @Override
    protected void onStop() {
        super.onStop();
        if (mGattServer != null) {
            mGattServer.close();
        }
        if (mBluetoothAdapter.isEnabled() && mAdvertiser != null) {
            // If stopAdvertising() gets called before close() a null
            // pointer exception is raised.
            mAdvertiser.stopAdvertising(mAdvCallback);
        }
        resetStatusViews();
    }
}
