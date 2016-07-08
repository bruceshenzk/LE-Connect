//
//  LowFilterMotionCalculation.swift
//  iOS-Beacon
//
//  Created by Zekun Shen on 7/8/16.
//  Copyright © 2016 bruceshenzk. All rights reserved.
//

import CoreMotion

class LowFilterMotionCalculation: MotionCalculation {
    
    final var  alpha = 0.8
    var gravity = [Double](count: 3, repeatedValue: 0.0)
    var linear_acceleration = [Double](count:3, repeatedValue: 0.0)
    
    var accelerationsOverTime = [Double](count: 5, repeatedValue: 0.0)
    var accelerationIndex = 0
    
    func calcMotion(motionManager: CMMotionManager) -> Double {
        if motionManager.accelerometerData != nil {
            
            gravity[0] = alpha * gravity[0] + (1 - alpha) * motionManager.accelerometerData!.acceleration.x;
            gravity[1] = alpha * gravity[1] + (1 - alpha) * motionManager.accelerometerData!.acceleration.y;
            gravity[2] = alpha * gravity[2] + (1 - alpha) * motionManager.accelerometerData!.acceleration.z;
            
            linear_acceleration[0] = motionManager.accelerometerData!.acceleration.x - gravity[0];
            linear_acceleration[1] = motionManager.accelerometerData!.acceleration.y - gravity[1];
            linear_acceleration[2] = motionManager.accelerometerData!.acceleration.z - gravity[2];
            
            accelerationsOverTime[(accelerationIndex)%5] = (Double) (linear_acceleration[0] * linear_acceleration[0] + linear_acceleration[1] * linear_acceleration[1] + linear_acceleration[2] * linear_acceleration[2]);
            accelerationIndex = accelerationIndex + 1
            
            return calculateAverage()
        }
        else {
            return 0
        }
    }
    
    func calculateAverage() -> Double {
        var sum = 0.0
        for acc in accelerationsOverTime {
            sum += acc
        }
        return sum / Double(accelerationsOverTime.count)
    }
}
