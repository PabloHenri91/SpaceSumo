//
//  HangarScene.swift
//  SpaceGame
//
//  Created by Pablo Henrique Bertaco on 10/31/15.
//  Copyright © 2015 Pablo Henrique Bertaco. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    
    static func distance(a:CGPoint, _ b:CGPoint) -> CGFloat {
        let dx = (a.x - b.x)
        let dy = (a.y - b.y)
        return sqrt((dx * dx) + (dy * dy))
    }
    
    static func distanceSquared(a:CGPoint, _ b:CGPoint) -> CGFloat {
        let dx = (a.x - b.x)
        let dy = (a.y - b.y)
        return (dx * dx) + (dy * dy)
    }
}

public extension Int {
    /**
     Returns a random integer between 0 and n-1.
     */
    public static func random(n: Int) -> Int {
        return Int(arc4random_uniform(UInt32(n)))
    }
    /**
     Create a random num Int
     - parameter lower: number Int
     - parameter upper: number Int
     :return: random number Int
     */
    public static func random(min min: Int, max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max - min + 1))) + min
    }
    
    /**
     Create a random num Int
     - parameter lower: number CGFloat
     - parameter upper: number CGFloat
     :return: random number Int
     */
    public static func random(min min: CGFloat, max: CGFloat) -> Int {
        return Int(arc4random_uniform(UInt32(max - min + 1))) + Int(min)
    }
}

public extension Double {
    /**
     Returns a random floating point number between 0.0 and 1.0, inclusive.
     */
    public static func random() -> Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }
    
    /**
     Create a random num Double
     - parameter lower: number Double
     - parameter upper: number Double
     :return: random number Double
     */
    public static func random(min min: Double, max: Double) -> Double {
        return Double.random() * (max - min) + min
    }
}

public extension Float {
    /**
     Returns a random floating point number between 0.0 and 1.0, inclusive.
     */
    public static func random() -> Float {
        return Float(arc4random()) / 0xFFFFFFFF
    }
    /**
     Create a random num Float
     - parameter lower: number Float
     - parameter upper: number Float
     :return: random number Float
     */
    public static func random(min min: Float, max: Float) -> Float {
        return Float.random() * (max - min) + min
    }
}

public extension CGFloat {
    /**
     Returns a random floating point number between 0.0 and 1.0, inclusive.
     */
    public static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    public static func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random() * (max - min) + min
    }
}
