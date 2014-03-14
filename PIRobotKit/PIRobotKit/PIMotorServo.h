//
//  PIMotorServo.h
//  PIRobotKit
//
//  Created by Kevin Liang on 1/8/14.
//  Copyright (c) 2014 Play-i. All rights reserved.
//

#import "PIMotor.h"

/**
 `PIMotorServo` is subclass of `PIMotor` class, and it represents motors that receive commands in terms of angles (in degrees)
 */
@interface PIMotorServo : PIMotor

/**
 Angle that the motor is at, with granularity to a full degree.
 */
@property (nonatomic) NSInteger angle;

- (id) initWithAngle:(NSInteger)angle;

@end
