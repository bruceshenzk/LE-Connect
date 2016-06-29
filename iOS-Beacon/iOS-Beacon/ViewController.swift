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
    var requestingUUIDCentralList: [NSUUID]!
    var requestingUUIDDic: [NSUUID: Double]!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Disable application auto lock screen
        UIApplication.sharedApplication().idleTimerDisabled = true
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        accelerationManager = AccelerationManager()
        accelerationManager.startUpdateVariable()
        requestingUUIDCentralList = [NSUUID]()
        requestingUUIDDic = [NSUUID: Double]()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
//        peripheralManager.stopAdvertising()
//        accelerationManager.stopUpdateVariable()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }

    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        if (peripheral.state != CBPeripheralManagerState.PoweredOn) {
            return
        }
        Logger.info("PeripheralManager powered on." )
        
        let data = "testing".dataUsingEncoding(NSUTF8StringEncoding)


        motionCharacteristic = CBMutableCharacteristic(type: CBUUID(string: UUIDs.MOTION_CHARACTERISTIC_UUID), properties: CBCharacteristicProperties.Read, value: nil, permissions: CBAttributePermissions.Readable)

        let UUIDString = UIDevice.currentDevice().identifierForVendor!.UUIDString
        Logger.info("UUIDString: \(UUIDString)" )
        Logger.info("UUIDStringData: \(UUIDString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))" )
        uuidCharacteristic = CBMutableCharacteristic(type: CBUUID(string: UUIDs.UUID_CHARACTERISTIC_UUID), properties: CBCharacteristicProperties.Read, value: nil, permissions: CBAttributePermissions.Readable)
        
        let transferService = CBMutableService(type: CBUUID(string: UUIDs.TRANSFER_SERVICE_UUID), primary: true)
        transferService.characteristics = [motionCharacteristic, uuidCharacteristic]
        peripheralManager.addService(transferService)
        
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey:[CBUUID(string: UUIDs.TRANSFER_SERVICE_UUID)]])
        
        motionCharacteristic.value = data!
        uuidCharacteristic.value = UUIDString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        Logger.info("Characteristic Value:\(motionCharacteristic.value!)" )
    
    }
    
    func peripheralManager(peripheral: CBPeripheralManager, didReceiveReadRequest request: CBATTRequest) {
        if request.characteristic == motionCharacteristic {
            if accelerationManager.data != nil {
                motionCharacteristic.value = accelerationManager.data!
                Logger.info("data: \(accelerationManager.data!)" )
                request.value = motionCharacteristic.value
                peripheral.respondToRequest(request, withResult: CBATTError.Success)
            }
            else {
                Logger.error("Error with acceleration manager data" )
                peripheral.respondToRequest(request, withResult: CBATTError.InsufficientResources)
            }
        }
        else if request.characteristic == uuidCharacteristic {
            let deviceUUID = request.central.identifier
            if requestingUUIDDic[deviceUUID] != nil {
                if (NSDate().timeIntervalSince1970 - requestingUUIDDic[deviceUUID]!) < 10 {
                    // if the central device just request for uuid within 10 seconds
                    requestingUUIDDic[deviceUUID] = nil
                    request.value = uuidCharacteristic.value!.subdataWithRange(NSMakeRange(19, uuidCharacteristic.value!.length - 19))
                    Logger.debug("\(request.value!)")
                    peripheral.respondToRequest(request, withResult: CBATTError.Success)
                    return
                }
                // requested long ago and expire
            }
            // never request
            requestingUUIDDic[deviceUUID] = NSDate().timeIntervalSince1970
            request.value = uuidCharacteristic.value!.subdataWithRange(NSMakeRange(0, 19))
            peripheral.respondToRequest(request, withResult: CBATTError.Success)
            Logger.debug("\(request.value!)")
        }
    }

}
