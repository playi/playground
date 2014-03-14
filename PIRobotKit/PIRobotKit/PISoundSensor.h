//
//  PISoundSensor.h
//  PIRobotKit
//
//  Created by Kevin Liang on 1/8/14.
//  Copyright (c) 2014 Play-i. All rights reserved.
//

#import "PISound.h"

/**
 `PISoundSensor` is subclass of `PISound` class, and it is a sensor input class that can be used to represent sounds detected from the physical robot.
 */
@interface PISoundSensor : PISound

/**
 Pre-defined sound event index that is detected from the robot.
 */
@property (nonatomic) NSUInteger index;

/**
 Location where the sound originated from (same angular coordinates as PIMotorServo), range from [-179, 180]
 */
@property (nonatomic) NSInteger angle;

@end
