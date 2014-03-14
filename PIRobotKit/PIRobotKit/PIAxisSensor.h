//
//  PIAxisSensor.h
//  PIRobotKit
//
//  Created by Kevin Liang on 1/8/14.
//  Copyright (c) 2014 Play-i. All rights reserved.
//

#import "PIComponent.h"

/**
 `PIAxisSensor` is subclass of `PIComponent` class, and it is a sensor input class that can be used to represent either accelerometer or gyroscope data.  The raw data is expressed in G-force values.
 */
@interface PIAxisSensor : PIComponent

/**
 X-axis value.
 */
@property (nonatomic, readonly) double x;

/**
 Y-axis value.
 */
@property (nonatomic, readonly) double y;

/**
 Z-axis value.
 */
@property (nonatomic, readonly) double z;

@end
