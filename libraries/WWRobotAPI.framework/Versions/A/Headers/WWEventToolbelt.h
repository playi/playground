//
//  WWEventToolbelt.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 5/15/14.
//  Copyright (c) 2014 Wonder Workshop inc. (https://www.makewonder.com/) All rights reserved.
//

@class WWEvent;

/**
 *  Convenience class to generate `WWevent` objects.
 */
@interface WWEventToolbelt : NSObject

/**---------------------------------------------------------------------------------------
 *  @name Object detection
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  Initializes a `WWEvent` object that is triggered when an object's distance is less than sensorLimitNumber.
 *
 *  @param sensorLimitNumber Distance threshold (in CM) for object.
 *
 *  @return A `WWEvent` instance.
 */
+ (WWEvent *) detectObjectFront:(NSNumber *)sensorLimitNumber;

/**
 *  Initializes a `WWEvent` object that is triggered when an object's distance is less than sensorLimitNumber.
 *
 *  @param sensorLimitNumber Distance threshold (in CM) for object.
 *
 *  @return A `WWEvent` instance.
 */
+ (WWEvent *) detectObjectBack:(NSNumber *)sensorLimitNumber;

/**
 *  Initializes a `WWEvent` object that is triggered when a specific button is transitioning from normal to pressed.
 *
 *  This is analogus to "onTouchDown" event for UIButton.
 *
 *  @param indexNumber Corresponds to the WWComponentId of the button.
 *
 *  @return A `WWEvent` instance.
 */
+ (WWEvent *) buttonOnDown:(NSNumber *)indexNumber;

/**
 *  Initializes a `WWEvent` object that will be triggered when a specific button is transitioning from pressed to normal.
 *
 *  This is analogus to "onTouchUp" event for UIButton.
 *
 *  @param indexNumber Corresponds to the WWComponentId of the button.
 *
 *  @return A `WWEvent` instance.
 */
+ (WWEvent *) buttonOnUp:(NSNumber *)indexNumber;



+ (WWEvent *) gestureSlideAlongAxis:(NSString*)axisName inPositiveDirection:(BOOL)positive;   // robot must be oriented vertically. see todo in .mm
+ (WWEvent *) gestureDrop;

+ (WWEvent *) orientationShake;
+ (WWEvent *) orientationPitchAndRoll;
+ (WWEvent *) orientationTiltRangeMin:(NSNumber *)minAngle max:(NSNumber *)maxAngle;

@end
