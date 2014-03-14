//
//  PIDistancePairSensor.h
//  PIRobotKit
//
//  Created by Kevin Liang on 2/10/14.
//  Copyright (c) 2014 Play-i. All rights reserved.
//

#import "PIDistanceSensor.h"

/**
 `PIAxisSensor` is subclass of `PIDistanceSensor` class, and it is a sensor input class to represent each sensor that is used as a pair. This is most evident in Bo's front distance sensors, since both are paired to work with each other to provide information on detecting whether the object in front is to the left, center, or right of the robot.
 */
@interface PIDistancePairSensor : PIDistanceSensor

/**
 Refers to the "other" sensor's estimated distance (in cm) of the object that has been detected.  If no object has been detected, value would be less than 0.
 */
@property (nonatomic, readonly) PIDistance secondaryDistance;

/**
 Refers to the "other" sensor's confidence level of the distance of the object that has been detected.  This values gives a bounded range (distance +/- margin) of the actual distance of the object.
 */
@property (nonatomic, readonly) PIDistance secondaryMargin;

@end
