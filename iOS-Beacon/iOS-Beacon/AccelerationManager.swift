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
                    while(!self.operation.cancelled) {
                        if self.motionManager.deviceMotion?.userAcceleration != nil {
                            dispatch_async(dispatch_get_main_queue(), {
                                // Update variables if there is change in motion
                                if self.motionManager.deviceMotionActive {
                                    let userAcceleration = self.motionManager.deviceMotion?.userAcceleration
                                    let x = userAcceleration!.x
                                    let y = userAcceleration!.y
                                    let z = userAcceleration!.z

                                    self.accelerationsOverTime[self.accelerationIndex] = x*x+y*y+z*z
                                }
                                else {
                                    self.accelerationsOverTime[self.accelerationIndex] =
                                        self.accelerationsOverTime[(self.accelerationIndex-1)%5]
                                }
                                
                                self.accelerationIndex = (self.accelerationIndex+1)%5

                                var average = self.calculateAverage()

                                self.data = NSMutableData(bytes: &average, length: sizeof(Double))
                                
                            })
                        }
                        usleep(200)
                    }
                }
                else {
                    Logger.warning("Device Motion Not Available")
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