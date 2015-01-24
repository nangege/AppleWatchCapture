//
//  WindowKit.swift
//  AppleWatchSimulator
//
//  Created by nan.tang on 15/1/20.
//
//

import Foundation
import Cocoa
import AppKit

func findwindowID(idenifier:String,windowName:String) -> Int?{
    let windows = CGWindowListCopyWindowInfo(CGWindowListOption(kCGWindowListExcludeDesktopElements),CGWindowID(0)).takeUnretainedValue() as Array
    for window in windows {
        if window.objectForKey(kCGWindowOwnerName) as? String == idenifier &&
                window.objectForKey(kCGWindowName) as? String == windowName{
                return (window.objectForKey(kCGWindowNumber) as NSNumber).integerValue
        }
    }
    return nil
}

func snapWindow(windowNum:Int) -> CGImage{
    return CGWindowListCreateImage(CGRectNull,
        CGWindowListOption(kCGWindowListOptionIncludingWindow),
        CGWindowID( windowNum),
        CGWindowImageOption(kCGWindowImageBoundsIgnoreFraming)).takeRetainedValue()
}