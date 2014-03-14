//
//  PIDistanceSensor.h
//  PIRobotKit
//
//  Created by Kevin Liang on 1/8/14.
//  Copyright (c) 2014 Play-i. All rights reserved.
//

#import "PIComponent.h"

/**
 `PIDistanceSensor` is subclass of `PIComponent` class, and it is a sensor input class that is used to detect if an object is within its view detection range.
 */
@interface PIDistanceSensor : PIComponent

/**
 Refers to the estimated distance (in cm) of the object that has been detected.  If no object has been detected, value would be less than 0.
 */
@property (nonatomic, readonly) PIBotCentimeters_t distance;

/**
 Refers to the confidence level of the distance of the object that has been detected.  This values gives a bounded range (distance +/- margin) of the actual distance of the object.
 */
@property (nonatomic, readonly) PIBotCentimeters_t margin;

@end
