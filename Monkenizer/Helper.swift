//
//  Helper.swift
//  Monkenizer
//
//  Created by Ko Kyaw on 28/11/2021.
//

import UIKit

extension UIViewController {
    
    public func convertUnitToPoint(originalImgRect: CGRect, targetRect: CGRect) -> CGRect {
        var pointRect = targetRect
        
        pointRect.origin.x = originalImgRect.origin.x + (targetRect.origin.x * originalImgRect.size.width)
        pointRect.origin.y = originalImgRect.origin.y + (1 - targetRect.origin.y - targetRect.height) * originalImgRect.size.height
        pointRect.size.width *= originalImgRect.size.width
        pointRect.size.height *= originalImgRect.size.height
        
        return pointRect
    }
    
    public func determineScale(cgImage: CGImage, imageViewFrame: CGRect) -> CGRect {
        let originalWidth = CGFloat(cgImage.width)
        let originalHeight = CGFloat(cgImage.height)
        
        let imageFrame = imageViewFrame
        let widthRatio = originalWidth / imageFrame.width
        let heightRatio = originalHeight / imageFrame.height
        
        let scaleRatio = max(widthRatio, heightRatio)
        
        let scaledImageWidth = originalWidth / scaleRatio
        let scaledImageHeight = originalHeight / scaleRatio
        
        let scaledImageX = (imageFrame.width - scaledImageWidth) / 2
        let scaledImageY = (imageFrame.height - scaledImageHeight) / 2
        
        return CGRect(x: scaledImageX, y: scaledImageY, width: scaledImageWidth, height: scaledImageHeight)
    }
}

extension CGImagePropertyOrientation {
    init(_ orientation: UIImage.Orientation) {
        switch orientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        default: self = .up
        }
    }
}
