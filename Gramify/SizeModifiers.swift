//
//  SizeModifiers.swift
//  Gramify
//
//  Created by Isaac Akalanne on 12/05/2020.
//  Copyright © 2020 Believe And Succeed Apps. All rights reserved.
//

import Foundation
import UIKit

extension CGSize {
    
    func sizeRatio() -> CGFloat {
        return self.width / self.height
    }
    
}

func getAspectFitCGRect(ofImage image : UIImage, inView view : UIView) -> CGRect {
    
    let frameSize = view.frame.size
    let imageSize = image.size
    
    let newRect = createNewRect(forImageSize: imageSize, inFrameSize: frameSize)
    
    return newRect
}

func createNewRect(forImageSize imageSize : CGSize, inFrameSize frameSize : CGSize) -> CGRect {
    
    let scaleFactor = getScaleFactor(frameSize: frameSize, imageSize: imageSize)
    
    let newSize = getScaledSize(originalSize: imageSize, withScaleFactor: scaleFactor)
    let newOrigin = getOrigin(forImageSize: newSize, inFrameSize: frameSize)
    
    let newRect = CGRect(origin: newOrigin, size: newSize)
    
    return newRect
}

func isAspectFitVertical(frameSize : CGSize, imageSize : CGSize) -> Bool {
    
    let viewRatio = frameSize.sizeRatio()
    let imageRatio = imageSize.sizeRatio()
    
    if viewRatio > imageRatio {
        return true
    } else {
        return false
    }
    
}

func getScaledSize(originalSize size : CGSize, withScaleFactor scaleFactor : CGFloat) -> CGSize {
    var scaledSize = CGSize()
    scaledSize.width = size.width / scaleFactor
    scaledSize.height = size.height / scaleFactor
    return scaledSize
}

func getScaleFactor(frameSize : CGSize, imageSize : CGSize) -> CGFloat {
    
    var scaleFactor : CGFloat = 0
    let isFitVertical = isAspectFitVertical(frameSize: frameSize, imageSize: imageSize)
    
    if isFitVertical {
        scaleFactor = imageSize.height / frameSize.height
    } else {
        scaleFactor = imageSize.width / frameSize.width
    }
    
    return scaleFactor
}

func getOrigin(forImageSize imageSize : CGSize, inFrameSize frameSize : CGSize) -> CGPoint {
    
    var origin = CGPoint(x: 0, y: 0)
    
    let isFitVertical = isAspectFitVertical(frameSize: frameSize, imageSize: imageSize)
    
    if isFitVertical {
        origin.x = (frameSize.width - imageSize.width) / 2
    } else {
        origin.y = (frameSize.height - imageSize.height) / 2
    }
    
    return origin
    
}

