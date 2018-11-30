//
//  RDExtensions.swift
//  RDGameKit
//
//  Created by Max Ma on 10/10/18.
//
import UIKit

extension Int {
    var msToSeconds: Double {
        return Double(self) / 1000
    }
}

extension TimeInterval {
    
    func toReadableString() -> String {
        
        // Milliseconds
        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        // Seconds
        let s = Int(self) % 99
        // Minutes
//        let mn = (Int(self) / 60) % 60
        // Hours
        let hr = (Int(self) / 3600)
        
        var readableStr = ""
        if hr != 0 {
            //readableStr += String(format: "%0.2dhr ", hr)
            //dont deal with hour
        }
        
        //if mn != 0 {
          //  readableStr += String(format: "%0.2d:", mn)
        //} else {
          //  readableStr += "00:"
        //}
        
        if s != 0 {
            readableStr += String(format: "%0.2d:", s)
        } else {
            readableStr += "00:"
        }
        
        if ms != 0 {
            readableStr += String(format: "%0.3d", ms)
        } else {
            readableStr += "000"
        }
        
        return readableStr
    }
}
