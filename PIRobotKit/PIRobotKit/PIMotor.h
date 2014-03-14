//
//  PIMotor.h
//  PIRobotKit
//
//  Created by Kevin Liang on 1/8/14.
//  Copyright (c) 2014 Play-i. All rights reserved.
//

#import "PIComponent.h"
#import "PIToolSet.h"

/**
 `PIMotor` is subclass of `PIComponent` class, and it is an ABSTRACT output class that will represent all the motor specific classes.
 */
@interface PIMotor : PIComponent

/**
 Velocity speed for the motor, expressed as centimeter/second
 */
@property (nonatomic) float speed;

- (id) initWithSpeed:(float)speed;

@end
