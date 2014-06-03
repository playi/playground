//
//  PIComponentMotorServo.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 3/31/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

#import "PIComponentMotor.h"

@interface PIComponentMotorServo : PIComponentMotor

@property (nonatomic) PIAngle angle;

- (id) initWithAngle:(PIAngle)angle;

@end
