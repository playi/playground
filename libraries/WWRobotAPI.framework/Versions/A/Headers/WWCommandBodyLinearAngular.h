//
//  WWCommandBodyLinearAngular.h
//  APIObjectiveC
//
//  Created by Saurabh Gupta on 7/30/14.
//  Copyright (c) 2014 Wonder Workshop inc. (https://www.makewonder.com/) All rights reserved.
//

#import "WWCommand.h"

/**
 *  `WWCommandBodyLinearAngular` objects are used to instruct a `WWRobot` how to position its body
 *  in terms of linear and angular velocity, assuming that the center point is the center point of the
 *  robot.
 *
 *  @todo doc: add threshold values.
 *  @todo doc: how do I best describe linear/angular?
 */
@interface WWCommandBodyLinearAngular : WWCommand

/**
 *  Specify the linear velocity (in cm/s) for this command.
 */
@property (nonatomic) double linearVelocity;

/**
 *  Specifies the angular velocity (in radian/s) for this command.
 */
@property (nonatomic) double angularVelocity;


/**
 *  Initializes the command with specified linear and angular velocity.
 *
 *  @param linear  The linear velocity in cm/s.
 *  @param angular The angular velocity in radian/s.
 *
 *  @return Returns a newly initialized `WWCommandBodyLinearAngular`.
 */
- (id) initWithLinear:(double)linear angular:(double)angular;

@end