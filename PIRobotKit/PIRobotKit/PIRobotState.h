//
//  PIRobotState.h
//  PIRobotKit
//
//  Created by Kevin Liang on 1/7/14.
//  Copyright (c) 2014 Play-i. All rights reserved.
//
#import "PIObject.h"

@class PIComponentValues;

/**
 `PIRobotState` class is a wrapper class on top of PIComponentValues that represents the actual state of the object with combined sensor/actuator outputs.  Caller can leverage this information to trigger any custom events.
 */
@interface PIRobotState : PIObject

/**
 The system timestamp (in seconds) when this state is recorded.
 */
@property (nonatomic, readonly) double systemTimestamp;

/**
 The actual PIComponent values for this state, which will include actuator and sensor values.
 */
@property (nonatomic, strong) PIComponentValues *componentValues;

/**
 Copies output component values from PIComponentValues into itself, which can be deeply nested as determined by the PIComponent object themselves.
 
 @param states The output PIComponentValues values to copy from.
 */
- (void) copyFromComponentValues:(PIComponentValues *)values;

@end
