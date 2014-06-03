//
//  PIWheelMotorComponent.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 3/26/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

#import "PIComponentMotor.h"

@interface PIComponentMotorWheel : PIComponentMotor

@property (nonatomic, readonly) PICentimeter encoderDistance;

+ (PIComponentMotorWheel *) stopComponent;

- (PIVelocity) velocityDelta:(PIComponentMotorWheel *)otherWheel;
- (PICentimeter) encoderDistanceDelta:(PIComponentMotorWheel *)otherWheel;

@end
