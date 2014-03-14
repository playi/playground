//
//  PIColorLightComponent.h
//  PIRobotKit
//
//  Created by Kevin Liang on 1/8/14.
//  Copyright (c) 2014 Play-i. All rights reserved.
//

#import "PIComponent.h"

/**
 `PIColorLight` is subclass of `PIComponent` class, and it is an output class to express a full spectrum color light, expressed in RGB values.
 */
@interface PIColorLight : PIComponent

/**
 The brightness value of red, range from 0 to 255
 */
@property (nonatomic) PIBrightness red;

/**
 The brightness value of green, range from 0 to 255
 */
@property (nonatomic) PIBrightness green;

/**
 The brightness value of blue, range from 0 to 255
 */
@property (nonatomic) PIBrightness blue;

- (id) initWithRed:(PIBrightness)red green:(PIBrightness)green blue:(PIBrightness)blue;

@end
