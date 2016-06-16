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
    var accelerationsOverTime = [Double](count: 5, repeatedValue: 0.0)
    var accelerationIndex = 0

    init() {
        motionManager = CMMotionManager()
        motionManager.startDeviceMotionUpdates()
        operationQueue = NSOperationQueue()
    }

    func startUpdateVariable() {
        if(operationQueue.operationCount == 0) {
            operation = NSBlockOperation(block: {
                if self.motionManager.deviceMotionAvailable {
                    if self.motionManager.deviceMotionActive {
                        Logger.log("active",level: 1)
                        while(true && !self.operation.cancelled) {
                            if self.motionManager.deviceMotion?.userAcceleration != nil {
                                dispatch_async(dispatch_get_main_queue(), {
                                    let userAcceleration = self.motionManager.deviceMotion?.userAcceleration
                                    let x = userAcceleration!.x
                                    let y = userAcceleration!.y
                                    let z = userAcceleration!.z

                                    //Logger.log(String(format: "User Acceleration: %.5f", x*x+y*y+z*z), level: 2)

                                    self.accelerationsOverTime[self.accelerationIndex] = x*x+y*y+z*z
                                    self.accelerationIndex = (self.accelerationIndex+1)%5

                                    var average = self.calculateAverage()
                                    //Logger.log(String(format: "Average User Acceleration: %.5f",average), level: 2)

                                    self.data = NSMutableData(bytes: &average, length: sizeof(Double))
//                                    Logger.log("Data:\(self.data)", level: 1)
                                    
                                    
                                })
                            }
                            sleep(1)
                        }
                    }
                }
            })
            operationQueue.addOperation(operation)
        }
    }

    func calculateAverage() -> Double {
        var sum = 0.0
        for acc in accelerationsOverTime {
            sum += acc
        }
        return sum / Double(accelerationsOverTime.count)
    }

    func stopUpdateVariable() {
        operationQueue.cancelAllOperations()
    }





}