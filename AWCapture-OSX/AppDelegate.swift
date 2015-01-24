//
//  AppDelegate.swift
//  AWCapture-OSX
//
//  Created by nan.tang on 15/1/20.
//
//

import Cocoa

let kiOSSimBundleID         = "com.apple.iphonesimulator";
let IOSSimulatorIdentifier  = "iOS Simulator"
let windowName42MM          = "Apple Watch 42mm"
let windowName38MM          = "Apple Watch 38mm"
let AppReconnectDelay:Int64 = 1

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate,PTChannelDelegate {

    var connectingToDeviceID:NSNumber?
    var connectedDeviceID:NSNumber?
    var connectedChannel:PTChannel?
    var notConnectedQueue:dispatch_queue_t?
    var connectedDeviceProperties:NSDictionary?
    
    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        notConnectedQueue = dispatch_queue_create("AppleWatchCapture.notConnectedQueue", DISPATCH_QUEUE_SERIAL)
        startListenDevice()
    }
    
    func startListenDevice(){
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserverForName(PTUSBDeviceDidAttachNotification, object: PTUSBHub.sharedHub(), queue: nil) { (notification:NSNotification!) -> Void in
            let deviceID: NSNumber? = notification.userInfo!["DeviceID"] as? NSNumber
            if let deviceID = deviceID {
                if self.connectingToDeviceID == nil || !deviceID.isEqualToNumber(self.connectingToDeviceID!){
                    self.disconnectFromCurrentChannel()
                    self.connectingToDeviceID = deviceID
                    self.connectedDeviceProperties = notification.userInfo!["Properties"] as? NSDictionary
                    self.enqueueConnectToUSBDevice()
                }
            }
        }
    }
    
    func disconnectFromCurrentChannel(){
        if connectingToDeviceID != nil && connectedChannel != nil {
            connectedChannel?.close()
            connectingToDeviceID = nil
        }
    }
    
    func enqueueConnectToUSBDevice(){
        
        dispatch_async(notConnectedQueue!){
            dispatch_async(dispatch_get_main_queue()) {
                self.connectedToUSBDevice()
            }
        }
    }
    
    func connectedToUSBDevice(){
        var channel = PTChannel(delegate: self)
        channel.userInfo = connectingToDeviceID
        
        channel.connectToPort(IPv4PortNumber, overUSBHub: PTUSBHub.sharedHub(), deviceID: connectingToDeviceID,callback:{
            (error:NSError?) -> () in
            if let error = error {
  
                let time = dispatch_time(DISPATCH_TIME_NOW, AppReconnectDelay)
                
                if channel.userInfo as? NSObject == self.connectingToDeviceID {
                    dispatch_after(time, dispatch_get_main_queue()) {
                        NSThread.detachNewThreadSelector(Selector("enqueueConnectToUSBDevice"), toTarget: self, withObject: nil)
                    }
                }
                
            }
            else{
                self.connectedDeviceID = self.connectingToDeviceID
                self.connectedChannel =  channel;
                
                NSTimer.scheduledTimerWithTimeInterval(1.0/60.0, target: self, selector: Selector("sendImage:"), userInfo: nil, repeats: true)
            }
        })
    }
    
    func sendImage(sender:AnyObject){
        
        if let windowNum = findwindowID(IOSSimulatorIdentifier, windowName42MM){

            let image = snapWindow(windowNum)
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> Void in
                let bitMap = NSBitmapImageRep(CGImage: image)
                let data = bitMap.representationUsingType(NSBitmapImageFileType.NSPNGFileType, properties:Dictionary())
                let playload = dispatch_data_create(data!.bytes,UInt(data!.length),dispatch_get_main_queue()){
                    
                }
                self.connectedChannel?.sendFrameOfType(104, tag: 0, withPayload: playload, callback: { error in
                    
                })
            })
        }
    }
    
    func ioFrameChannel(channel: PTChannel!, didReceiveFrameOfType type: UInt32, tag: UInt32, payload: PTData!) {
        
    }
    

}

