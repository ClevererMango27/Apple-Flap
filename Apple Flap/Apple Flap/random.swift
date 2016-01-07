//
//  random.swift
//  Apple Flap
//
//  Created by Brendon Ho on 1/6/16.
//  Copyright © 2016 VGames. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat{
    public static func random() ->CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFFF)
    }
    public static func random(min min : CGFloat, max : CGFloat) -> CGFloat{
        return CGFloat.random() * (max - min) + min
    }
}
