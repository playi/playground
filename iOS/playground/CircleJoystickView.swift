//
//  CircleJoystickView1.swift
//  playground
//
//  Created by Jelle Alten on 11-11-16.
//  Copyright © 2016 Wonder Workshop. All rights reserved.
//

import UIKit

class CircleJoystickView: JoystickView {
    
    private var _circleRadius : Float = 0.0
    let CIRCLE_RECT_PADDING : CGFloat = 10

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // get radius for circle drawing
        _circleRadius = Float( bounds.insetBy(dx: CIRCLE_RECT_PADDING, dy:CIRCLE_RECT_PADDING).size.width / CGFloat(2.0))
    }
    
    var power : Float {
        get {
            return getDistance(p1: dotPos, p2: self._center) / circleRadius
        }
    }
    
    var circleRadius: Float {
        return _circleRadius - Float(DOTSIZE) / 2.0
    }

    
    override func enforceJoystickBound(_ point: CGPoint) -> CGPoint? {
        let oldPoint = point
        let v1 = oldPoint.x - _center.x
        let v2 = oldPoint.y - _center.y
        let length = sqrt( v1 * v1 + v2 * v2)
        let maxLength = CGFloat(circleRadius)
        if length > maxLength {
            let phi = atan2(v2, v1)
            let x = _center.x + maxLength * cos(phi)
            let y = _center.y + maxLength * sin(phi)
            return CGPoint(x: x, y: y)
        } else {
            return nil
        }
    }
}

extension CircleJoystickView {

    override func getX() -> Float {
        let src_min = Float(_center.x) - circleRadius
        let src_max = Float(_center.x) + circleRadius
        
        return normalizeValueToNewRange(Float(dotPos.x), src_min, src_max, 1, -1)
    }
    
    override func getY() -> Float {
        let src_min = Float(_center.y) - circleRadius
        let src_max = Float(_center.y) + circleRadius
        
        return normalizeValueToNewRange(Float(dotPos.y), src_min, src_max, 1, -1)
    }

    
}
