//
//  WWCommandBodyLinearAngular.h
//  APIObjectiveC
//
//  Created by Saurabh Gupta on 7/30/14.
//  Copyright (c) 2014 Wonder Workshop inc. (https://www.makewonder.com/) All rights reserved.
//

#import "WWCommand.h"

/**
 *  `WWCommandBodyLinearAngular` objects instruct a `WWRobot` how to position its body
 *  in terms of linear and angular velocity, assuming that the center point is the center point of the
 *  robot.
 *
 *  Valid linear velocity values range from -100 to 100 cm/s and angular velocity values range from -8 to 8 radians/s.
 *  Wonder Workshop robots prioritize angular precision over linear precision, which helps them drive straight. So, if
 *  the command expressed max linear (100cm/s) and max angular (8rad/s) velocity, the robot will likely spin
 *  in place to achieve desired angular velocity, rather than move forward.  
 *
 *  Note: The actual speed will vary based on surface conditions (e.g., carpet speed will be slower).
 *
 * | Linear (cm/s) | Angular (radians/s) | Result                                                                                                       |
 * |---------------|---------------------|-------                                                                                                       |
 * | 50            | 0                   | Go straight forward at .5 meters per second.                                                                 |
 * | 0             | 3.14159             | Turn in-place counter-clockwise at 1/2 a revolution per second.                                              |
 * | 50            | 3.14159             | Drive in a counter-clockwise circle with circumference of one meter, taking two seconds to complete one lap. |
 *
 */
@interface WWCommandBodyLinearAngular : WWCommand

/**
 *  Specify the linear velocity (in cm/s) for this command.
 */
@property (nonatomic) double linearVelocity;

/**
 *  Specify the angular velocity (in radian/s) for this command.
 */
@property (nonatomic) double angularVelocity;


/**
 *  Initialize the command with specified linear and angular velocity.
 *
 *  @param linear  The linear velocity in cm/s.
 *  @param angular The angular velocity in radian/s.
 *
 *  @return Returns a newly initialized `WWCommandBodyLinearAngular`.
 */
- (id) initWithLinear:(double)linear angular:(double)angular;

@end
