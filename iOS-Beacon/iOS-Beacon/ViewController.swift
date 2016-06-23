//
//  ViewController.swift
//  iOS-Beacon
//
//  Created by Zekun Shen on 6/15/16.
//  Copyright (c) 2016 bruceshenzk. All rights reserved.
//


import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBPeripheralManagerDelegate {

    var peripheralManager: CBPeripheralManager!
    var accelerationManager: AccelerationManager!
    var motionCharacteristic: CBMutableCharacteristic!
    var uuidCharacteristic: CBMutableCharacteristic!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        accelerationManager = AccelerationManager()
        accelerationManager.startUpdateVariable()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        peripheralManager.stopAdvertising()
        accelerationManager.stopUpdateVariable()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }

    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        if (peripheral.state != CBPeripheralManagerState.PoweredOn) {
            return
        }
        Logger.info("self.peripheralManager powered on." )
        
        let data = "testing".dataUsingEncoding(NSUTF8StringEncoding)


        motionCharacteristic = CBMutableCharacteristic(type: CBUUID(string: UUIDs.MOTION_CHARACTERISTIC_UUID), properties: CBCharacteristicProperties.Read, value: nil, permissions: CBAttributePermissions.Readable)

        let UUIDString = UIDevice.currentDevice().identifierForVendor!.UUIDString
        Logger.info("UUIDString: \(UUIDString)" )
        Logger.info("UUIDStringData: \(UUIDString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))" )
        uuidCharacteristic = CBMutableCharacteristic(type: CBUUID(string: UUIDs.UUID_CHARACTERISTIC_UUID), properties: CBCharacteristicProperties.Read, value: UUIDString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), permissions: CBAttributePermissions.Readable)
        
        let transferService = CBMutableService(type: CBUUID(string: UUIDs.TRANSFER_SERVICE_UUID), primary: true)
        transferService.characteristics = [motionCharacteristic, uuidCharacteristic]
        peripheralManager.addService(transferService)
        
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey:[CBUUID(string: UUIDs.TRANSFER_SERVICE_UUID)]])
        
        motionCharacteristic.value = data!
        
        Logger.info("Characteristic Value:\(motionCharacteristic.value!)" )
        
        
    
    }
    
    func peripheralManager(peripheral: CBPeripheralManager, didReceiveReadRequest request: CBATTRequest) {
        if request.characteristic == motionCharacteristic {
            if accelerationManager.data != nil {
                motionCharacteristic.value = accelerationManager.data!
                Logger.info("data: \(accelerationManager.data!)" )
            }
            else {
                Logger.info("Error with acceleration manager data" )
                Logger.info("Value:\(motionCharacteristic.value!)" )
                let s = peripheralManager.updateValue(motionCharacteristic.value!, forCharacteristic: motionCharacteristic, onSubscribedCentrals: nil)
                if(s) {
                    Logger.info("Success" )
                }
                else {
                    Logger.info("Not Success" )
                }
//
            }
            request.value = motionCharacteristic.value
            peripheral.respondToRequest(request, withResult: CBATTError.Success)
        }
        else if request.characteristic == uuidCharacteristic {
            request.value = UIDevice.currentDevice().identifierForVendor?.UUIDString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            peripheral.respondToRequest(request, withResult: CBATTError.Success)
        }
    }
    
    
    
    



}
