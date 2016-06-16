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
        Logger.log("self.peripheralManager powered on.", level: 1)
        
        let data = "testing".dataUsingEncoding(NSUTF8StringEncoding)


        motionCharacteristic = CBMutableCharacteristic(type: CBUUID(string: UUIDs.MOTION_CHARACTERISTIC_UUID), properties: CBCharacteristicProperties.Read, value: nil, permissions: CBAttributePermissions.Readable)

        let transferService = CBMutableService(type: CBUUID(string: UUIDs.TRANSFER_SERVICE_UUID), primary: true)
        transferService.characteristics = [motionCharacteristic]
        peripheralManager.addService(transferService)
        
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey:[CBUUID(string: UUIDs.TRANSFER_SERVICE_UUID)]])
        
        motionCharacteristic.value = data!
        
        Logger.log("Characteristic Value:\(motionCharacteristic.value!)", level: 1)
        
        
    
    }
    
    func peripheralManager(peripheral: CBPeripheralManager, didReceiveReadRequest request: CBATTRequest) {
        if request.characteristic == motionCharacteristic {
            if accelerationManager.data != nil {
                motionCharacteristic.value = accelerationManager.data!
                Logger.log("data: \(accelerationManager.data!)", level: 1)
            }
            else {
                Logger.log("Error with acceleration manager data", level: 1)
                Logger.log("Value:\(motionCharacteristic.value!)", level: 1)
                let s = peripheralManager.updateValue(motionCharacteristic.value!, forCharacteristic: motionCharacteristic, onSubscribedCentrals: nil)
                if(s) {
                    Logger.log("Success", level: 1)
                }
                else {
                    Logger.log("Not Success", level: 1)
                }
//
            }
            request.value = motionCharacteristic.value
            peripheral.respondToRequest(request, withResult: CBATTError.Success)
        }
    }
    
    
    
    



}
