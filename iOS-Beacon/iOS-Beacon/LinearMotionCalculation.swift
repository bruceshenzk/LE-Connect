//
//  LinearMotionCalculation.swift
//  iOS-Beacon
//
//  Created by Zekun Shen on 7/8/16.
//  Copyright © 2016 bruceshenzk. All rights reserved.
//

import CoreMotion

class LinearMotionCalculation: MotionCalculation {
    var accelerationsOverTime = [Double](count: 5, repeatedValue: 0.0)
    var accelerationIndex = 0
    
    func calcMotion(motionManager: CMMotionManager) -> Double {
        if motionManager.deviceMotionActive {
            let userAcceleration = motionManager.deviceMotion?.userAcceleration
            let x = userAcceleration!.x
            let y = userAcceleration!.y
            let z = userAcceleration!.z
            
            accelerationsOverTime[accelerationIndex] = x*x+y*y+z*z
        }
        else {
            accelerationsOverTime[accelerationIndex] =
                self.accelerationsOverTime[(accelerationIndex-1)%5]
        }
        
        self.accelerationIndex = (self.accelerationIndex+1)%5
        
        return calculateAverage()
    }
    
    func calculateAverage() -> Double {
        var sum = 0.0
        for acc in accelerationsOverTime {
            sum += acc
        }
        return sum / Double(accelerationsOverTime.count)
    }
}
