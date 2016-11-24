//
//  CircleJoystickView1.swift
//  playground
//
//  Created by Jelle Alten on 11-11-16.
//  Copyright © 2016 Wonder Workshop. All rights reserved.
//

import UIKit

class CircleJoystickView: JoystickView {

    private var _circleRadius: Float = 0.0
    let circleRectPadding: CGFloat = 10

    override func layoutSubviews() {
        super.layoutSubviews()

        // get radius for circle drawing
        let boundsInset = bounds.insetBy(dx: circleRectPadding, dy:circleRectPadding)
        _circleRadius = Float( boundsInset.size.width / CGFloat(2.0))
    }

    var power: Float {
        get {
            return getDistance(point1: dotPos, point2: self.dragCenter) / circleRadius
        }
    }

    var circleRadius: Float {
        return _circleRadius - Float(dotSize) / 2.0
    }

    override func enforceJoystickBound(_ point: CGPoint) -> CGPoint? {
        let oldPoint = point
        let v1 = oldPoint.x - dragCenter.x
        let v2 = oldPoint.y - dragCenter.y
        let length = sqrt( v1 * v1 + v2 * v2)
        let maxLength = CGFloat(circleRadius)
        if length > maxLength {
            let phi = atan2(v2, v1)
            let x = dragCenter.x + maxLength * cos(phi)
            let y = dragCenter.y + maxLength * sin(phi)
            return CGPoint(x: x, y: y)
        } else {
            return nil
        }
    }
}

extension CircleJoystickView {

    override func getX() -> Float {
        let src_min = Float(dragCenter.x) - circleRadius
        let src_max = Float(dragCenter.x) + circleRadius

        return normalizeValueToNewRange(Float(dotPos.x), src_min, src_max, 1, -1)
    }

    override func getY() -> Float {
        let src_min = Float(dragCenter.y) - circleRadius
        let src_max = Float(dragCenter.y) + circleRadius

        return normalizeValueToNewRange(Float(dotPos.y), src_min, src_max, 1, -1)
    }

}
