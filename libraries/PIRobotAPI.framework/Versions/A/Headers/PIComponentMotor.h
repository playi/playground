//
//  PIComponentMotor.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 3/28/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

#import "PIComponent.h"

@interface PIComponentMotor : PIComponent

@property (nonatomic) PIVelocity velocity;

- (id) initWithVelocity:(PIVelocity)velocity;

@end
