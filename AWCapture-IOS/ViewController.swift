//
//  ViewController.swift
//  AWCapture-IOS
//
//  Created by nan.tang on 15/1/20.
//
//

import UIKit

class ViewController: UIViewController,PTChannelDelegate {

    @IBOutlet weak var watchBackgroundView: UIImageView!
    @IBOutlet weak var watchView: UIImageView!
    
    var serverChannel:PTChannel?
    var peerChannel:PTChannel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        watchView.layer.cornerRadius = 2.0
        watchView.clipsToBounds      = true
        
        var channel = PTChannel(delegate: self)
        channel.listenOnPort(in_port_t(IPv4PortNumber)){ (error:NSError!) -> Void in
            if let error = error {
                println("Listen Failed!")
            }
            else{
                self.serverChannel = channel
                println("Listen success")
            }
        }
    }
    
    override func finalize() {
        super.finalize()
        if let channel = serverChannel {
            channel.close()
            serverChannel = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ioFrameChannel(channel: PTChannel!, didReceiveFrameOfType type: UInt32, tag: UInt32, payload: PTData!) {
        if type == frameType.FrameTypeImage.rawValue {
            
            if let playLoad = payload {
                let imageData   = NSData(bytes:playLoad.data, length:Int(playLoad.length))
                let image       = UIImage(data: imageData)
                watchView.image = image?.imageFromRect(CGRectMake(0, 44, 624, 780))
            }
            
        }
    }
    
    func ioFrameChannel(channel: PTChannel!, didAcceptConnection otherChannel: PTChannel!, fromAddress address: PTAddress!) {
        if let channel = peerChannel {
            channel.cancel()
        }
        peerChannel = otherChannel
        peerChannel?.userInfo = address
        println("Accept connection: \(address)")
    }
    
    func ioFrameChannel(channel: PTChannel!, didEndWithError error: NSError!) {
        println("End With Error: \(error)")
    }


}

