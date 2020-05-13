//
//  TouchModifiers.swift
//  Gramify
//
//  Created by Isaac Akalanne on 12/05/2020.
//  Copyright © 2020 Believe And Succeed Apps. All rights reserved.
//

import Foundation
import UIKit

extension CGPoint {
    
    mutating func set(withTouch touch : UITouch, inView view : UIView) {
        self = touch.location(in: touch.view)
        self.adjustPosition(inView: view)
    }
    
    mutating func adjustPosition(inView view : UIView) {
        self.x -= view.frame.origin.x
        self.y -= view.frame.origin.y
    }
    
}
