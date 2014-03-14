//
//  PIMotorWheel.h
//  PIRobotKit
//
//  Created by Kevin Liang on 2/10/14.
//  Copyright (c) 2014 Play-i. All rights reserved.
//

#import "PIMotor.h"

/**
 `PIMotorWheel` is subclass of `PIMotor` class, and it represents physical wheel motors.
 */
@interface PIMotorWheel : PIMotor

/**
 Distance travelled, represented in centimeters
 */
@property (nonatomic, readonly) double distance;

/** 
 Used to artificially increase the speed of the motors without actually changing the speed.  This is useful in scenarios where you would want to keep the speed at 5cm/s, but may want to kick up the motor speed due to surface friction.  Defaults to 1.
 */
@property (nonatomic) float velocityMultiplier;

+ (PIMotorWheel *) stopState;

@end
