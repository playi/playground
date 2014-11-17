//
//  WWCommandToolbelt.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 5/15/14.
//  Copyright (c) 2014 Wonder Workshop inc. (https://www.makewonder.com/) All rights reserved.
//

@class WWCommandSet;

/**
 *  Convenience class to generate `WWCommandSet`.
 */
@interface WWCommandToolbelt : NSObject

/**---------------------------------------------------------------------------------------
 *  @name Robot movement
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  Initializes a `WWCommandSet` object that stops all `WWRobot` movement.
 *
 *  @return a `WWCommandSet` instance.
 */
+ (WWCommandSet *) moveStop;



/**---------------------------------------------------------------------------------------
 *  @name Robot lights
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  Initializes a `WWCommandSet` object that turns off all lights for a `WWRobot`.
 *
 *  @return a `WWCommandSet` instance.
 */
+ (WWCommandSet *) lightsOff;



/**---------------------------------------------------------------------------------------
 *  @name Robot sounds
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  Initializes a `WWCommandSet` object that stops the current sound for a `WWRobot`.
 *
 *  @return a `WWCommandSet` instance.
 */
+ (WWCommandSet *) stopSound;

@end
