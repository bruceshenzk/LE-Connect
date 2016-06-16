//
//  Logger.swift
//  Socket-IOS
//
//  Created by Zekun Shen on 5/24/16.
//  Copyright © 2016 Zekun Shen. All rights reserved.
//

import Foundation

class Logger {
    
    static var debugLevel = 0;// 0 is highest debug level: print everything
    
    static func log(items: Any..., level: Int) {
        if debugLevel <= level {
            for item in items {
                print(item)
            }
        }
    }
    
}
