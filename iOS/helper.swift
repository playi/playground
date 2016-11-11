//
//  helper.swift
//  playground
//
//  Created by Jelle Alten on 11-11-16.
//  Copyright © 2016 Wonder Workshop. All rights reserved.
//

import Foundation


func clamp(_ d: CGFloat , _ min : CGFloat ,_ max : CGFloat) -> CGFloat {
    let t = d < min ? min : d;
    return t > max ? max : t;
}

func lerp(_ min: CGFloat , _ max: CGFloat,  _ T: CGFloat) -> CGFloat
{
    return min + (max - min) * T;
}

func getDistance(p1: CGPoint , p2: CGPoint) -> Float {
    return hypotf(Float(p1.x - p2.x), Float(p1.y - p2.y))
}

// translate from old coordinate system into new one
func normalizeValueToNewRange(_ value: Float, _ src_min: Float, _ src_max: Float, _ dst_min: Float, _ dst_max: Float) -> Float
{
    return ( value - src_min ) / ( src_max - src_min ) * ( dst_max - dst_min ) + dst_min
}

func lerpPoints(min: CGPoint , max: CGPoint , T:  Double) -> CGPoint
{
    let result = CGPoint(x: lerp(min.x, max.x, CGFloat(T)),
                         y: lerp(min.y, max.y, CGFloat(T)) )
    return result;
}
