//
//  PeerTalkProtocol.swift
//  AppleWatchSimulator
//
//  Created by nan.tang on 15/1/20.
//
//

import Foundation

public let IPv4PortNumber:Int32 = 2345
public enum frameType:UInt32{
    case FrameTypeDeviceInfo  = 100
    case FrameTypeTextMessage = 101
    case FrameTypePing        = 102
    case FrameTypePong        = 103
    case FrameTypeImage       = 104
}