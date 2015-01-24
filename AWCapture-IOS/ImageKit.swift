//
//  ImageKit.swift
//  AppleWatchSimulator
//
//  Created by nan.tang on 15/1/20.
//
//

import Foundation
import UIKit

public extension UIImage {
    func imageFromRect(rect:CGRect) -> (UIImage?) {
        let subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect)
        let bound       = CGRectMake(0, 0,CGFloat(CGImageGetWidth(subImageRef)),CGFloat(CGImageGetHeight(subImageRef)))
        UIGraphicsBeginImageContext(bound.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextDrawImage(context, bound, subImageRef)
        let smallImage = UIImage(CGImage: subImageRef)
        UIGraphicsEndImageContext()
        return smallImage
    }
}
