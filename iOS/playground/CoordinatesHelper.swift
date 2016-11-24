//
//  helper.swift
//  playground
//
//  Created by Jelle Alten on 11-11-16.
//  Copyright © 2016 Wonder Workshop. All rights reserved.
//

import Foundation
import UIKit

func clamp(_ input: CGFloat, _ min: CGFloat, _ max: CGFloat) -> CGFloat {
    let t = input < min ? min: input
    return t > max ? max: t
}

func lerp(_ min: CGFloat, _ max: CGFloat, _ dist: CGFloat) -> CGFloat {
    return min + (max - min) * dist
}

func getDistance(point1: CGPoint, point2: CGPoint) -> Float {
    return hypotf(Float(point1.x - point2.x), Float(point1.y - point2.y))
}

// translate from old coordinate system into new one
func normalizeValueToNewRange(_ value: Float,
                              _ srcMin: Float, _ srcMax: Float,
                              _ dstMin: Float, _ dstMax: Float) -> Float {
    return ( value - srcMin ) / ( srcMax - srcMin ) * ( dstMax - dstMin ) + dstMin
}

func lerpPoints(min: CGPoint, max: CGPoint, dist: Double) -> CGPoint {
    let result = CGPoint(x: lerp(min.x, max.x, CGFloat(dist)),
                         y: lerp(min.y, max.y, CGFloat(dist)) )
    return result
}
