//
//  Logger.swift
//  Socket-IOS
//
//  Created by Zekun Shen on 5/24/16.
//  Copyright © 2016 Zekun Shen. All rights reserved.
//

import Foundation

class Logger {
    
    private static var info = true;
    private static var warning = true;
    private static var debug = true;
    private static var error = true;
    
    
    static func info(items: Any...) {
        if info {
            for item in items {
                print("[INFO]: \(item)")
            }
        }
    }
    
    static func warning(items: Any...) {
        if warning {
            for item in items {
                print("[WARNING]: \(item)")
            }
        }
    }
    
    static func debug(items: Any...) {
        if debug {
            for item in items {
                print("[DEBUG]: \(item)")
            }
        }
    }
    
    static func error(items: Any...) {
        if error {
            for item in items {
                print("[ERROR]: \(item)")
            }
        }
    }
    
}
