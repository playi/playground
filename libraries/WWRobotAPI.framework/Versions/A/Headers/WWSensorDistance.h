//
//  WWSensorDistance.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 3/31/14.
//  Copyright (c) 2014 Wonder Workshop inc. (https://www.makewonder.com/) All rights reserved.
//

#import "WWSensor.h"

/**
 *  The `WWSensorDistance` object provides estimated distance data from `WWRobot` (read-only).  
 *
 *  Distance data is calculated based on the reflectance of the IR sensors on the robot, so it is heavily based on 
 *  the environment visibility (e.g. dimmed room) and object reflectance (e.g. white vs. black).
 */
@interface WWSensorDistance : WWSensor

/**
 *  Returns calculated distance (in CM), using proprietary algorithm.
 */
@property (nonatomic, readonly) double distance; 

@end
