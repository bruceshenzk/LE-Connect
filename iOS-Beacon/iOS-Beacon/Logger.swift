//
//  Logger.swift
//  Socket-IOS
//
//  Created by Zekun Shen on 5/24/16.
//  Copyright © 2016 Zekun Shen. All rights reserved.
//

import Foundation

class Logger {
    
    static var info = true;
    static var warning = true;
    static var debug = false;
    static var error = true;
    
    
    static func info(items: Any...) {
        if info {
            print("[INFO]: \(items)")
        }
    }
    
    static func warning(items: Any...) {
        if warning {
            print("[WARNING]: \(items)")
        }
    }
    
    static func debug(items: Any...) {
        if debug {
            print("[DEBUG]: \(items)")
        }
    }
    
    static func error(items: Any...) {
        if error {
            print("[ERROR]: \(items)")
        }
    }
    
}
