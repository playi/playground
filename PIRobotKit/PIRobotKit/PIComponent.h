//
//  PIComponent.h
//  PIRobotKit
//
//  Created by Kevin Liang on 1/8/14.
//  Copyright (c) 2014 Play-i. All rights reserved.
//

#import "PIObject.h"

/**
 Index keys for subclasses of PIComponents to map raw data to its actual values.  These keys only apply to certain PIComponent subclasses (e.g. gBlueKey is only used by PILightRGB class while gGreenKey is used by PILightRG and PILightRGB).
 */
extern NSString *const gBrightnessKey;
extern NSString *const gLEDIndexKey;
extern NSString *const gVelocityKey;
extern NSString *const gAngleKey;
extern NSString *const gRedKey;
extern NSString *const gGreenKey;
extern NSString *const gBlueKey;

/**
 `PIComponent` class is the parent class that all the specific component classes inherits off of.  This is useful when dealing with container classes such as `PIComponentValues` that expects a `PIComponent` object, but the components may have different types (e.g. `PILightRGB` vs. `PIEye`).
 
 Any shareable functions and interfaces are also defined in this class as well.
 */
@interface PIComponent : PIObject

/**
 Should be override by child classes, this method will be used to parse raw data to seed the component.  If a child class does not support this method, an exception is thrown.
 
 @param data Raw data to set the component values with
 */
- (void) parseData:(NSDictionary *)data;

@end
