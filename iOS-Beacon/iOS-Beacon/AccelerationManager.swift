//
//  AccelerationManager.swift
//  Socket-IOS
//
//  Created by Zekun Shen on 5/27/16.
//  Copyright © 2016 Zekun Shen. All rights reserved.
//

import Foundation
import CoreMotion

class AccelerationManager {
    // MARK: Properties
    var motionManager:CMMotionManager!
    var operationQueue: NSOperationQueue!
    var operation: NSOperation!
    var data:NSMutableData!
    var motionCalc: MotionCalculation!

    init() {
        motionManager = CMMotionManager()
        motionManager.startDeviceMotionUpdates()
        operationQueue = NSOperationQueue()
        motionCalc = LinearMotionCalculation()
    }

    func startUpdateVariable() {
        if(operationQueue.operationCount == 0) {
            operation = NSBlockOperation(block: {
                if self.motionManager.deviceMotionAvailable {
                    while(!self.operation.cancelled) {
                        if self.motionManager.deviceMotion?.userAcceleration != nil {
                            dispatch_async(dispatch_get_main_queue(), {
                                // Update variables if there is change in motion
                                
                                var result = self.motionCalc.calcMotion(self.motionManager)
                                
                                self.data = NSMutableData(bytes: &result, length: sizeof(Double))
                                
                            })
                        }
                        usleep(50)
                    }
                }
                else {
                    Logger.warning("Device Motion Not Available")
                }
            })
            operationQueue.addOperation(operation)
        }
    }
    
    func stopUpdateVariable() {
        operationQueue.cancelAllOperations()
    }





}