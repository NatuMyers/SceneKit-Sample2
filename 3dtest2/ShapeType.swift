//
//  ShapeType.swift
//  3dtest2
//
//  Created by NatuMyers on 2016-09-30.
//  Copyright © 2016 NatuMyers. All rights reserved.
//

import Foundation

// 1 You create a new public enum ShapeType that enumerates the various shapes.
public enum ShapeType:Int {
    
    case Box = 0
    case Sphere
    case Pyramid
    case Torus
    case Capsule
    case Cylinder
    case Cone
    case Tube
    
    // 2 You also define a static method random() that generates a random ShapeType. This feature will come in handy later on in your game.
    static func random() -> ShapeType {
        let maxValue = Tube.rawValue
        let rand = arc4random_uniform(UInt32(maxValue+1))
        return ShapeType(rawValue: Int(rand))!
    }
}