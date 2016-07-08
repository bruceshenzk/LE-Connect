//
//  MotionCalculation.swift
//  iOS-Beacon
//
//  Created by Zekun Shen on 7/8/16.
//  Copyright © 2016 bruceshenzk. All rights reserved.
//
import CoreMotion

protocol MotionCalculation {
    func calcMotion(motionManager: CMMotionManager) ->  Double
}
