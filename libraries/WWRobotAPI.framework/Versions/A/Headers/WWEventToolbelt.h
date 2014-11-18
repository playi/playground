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


/**
 * Initializes a `WWEvent` object which will trigger events relating to a "Slide" gesture in any one of the six cardinal directions.
 *
 * A "Slide" means the robot has moved along the specified axis and then stopped.
 *
 * The robot must be right-side-up for these to be correctly identified.
 *
 * The six cardinal directions are:
 *
 * - *Positive X* : Slide the robot forward. Default identifier is "gestureSlide +x".
 * - *Negative X* : Slide the robot backward. Default identifier is "gestureSlide -x".
 * - *Positive Y* : Slide the robot to the left. Default identifier is "gestureSlide +y".
 * - *Negative Y* : Slide the robot to the right. Default identifier is "gestureSlide -y".
 * - *Positive Z* : Slide the robot up. (aka lift the robot) Default identifier is "gestureSlide +z".
 * - *Negative Z* : Slide the robot down. (aka set the robot down)Default identifier is "gestureSlide -z".
 *
 * This `WWEvent` recognizes the five different `WWEventPhase` phases.
 *
 * | WWEventPhases                |
 * |------------------------------|
 * | WW_EVENT_GESTURE_IDLE        |
 * | WW_EVENT_GESTURE_STARTED     |
 * | WW_EVENT_GESTURE_ESTABLISHED |
 * | WW_EVENT_GESTURE_COMPLETED   |
 * | WW_EVENT_GESTURE_CANCELLED   |
 *
 * | Transition From WWEventPhase | To WWEventPhase              | On Condition                            | Comment                                                |
 * |------------------------------|------------------------------|-----------------------------------------|--------------------------------------------------------|
 * | WW_EVENT_GESTURE_IDLE        | WW_EVENT_GESTURE_STARTED     | Acceleration on axis > some threshhold  | Started moving.                                        |
 * | WW_EVENT_GESTURE_STARTED     | WW_EVENT_GESTURE_ESTABLISHED | Time in phase > some threshhold         | Time has passed w/o stopping moving.                   |
 * | WW_EVENT_GESTURE_STARTED     | WW_EVENT_GESTURE_CANCELLED   | Acceleration on axis < some threshhold  | Stopped moving before enough time passed.              |
 * | WW_EVENT_GESTURE_ESTABLISHED | WW_EVENT_GESTURE_COMPLETED   | Acceleration on axis < some threshhold  | Stopped moving after enough time passed.               |
 * | WW_EVENT_GESTURE_ESTABLISHED | WW_EVENT_GESTURE_CANCELLED   | Time in phase > some threshhold         | Too much time passed w/o stopping moving. This happens w/ the tail of the reverse gesture, ie setting the robot down.|
 * | WW_EVENT_GESTURE_COMPLETED   | WW_EVENT_GESTURE_IDLE        | Automatic                               |                                                        |
 * | WW_EVENT_GESTURE_CANCELLED   | WW_EVENT_GESTURE_IDLE        | Automatic                               |                                                        |
 *
 * By default, this `WWEvent` will be triggered only for WW_EVENT_GESTURE_COMPLETED, however you can set a custom mask using WWEvent:setPhaseSignalMask:.
 *
 * @param axisName 'x', 'y', or 'z': which axis to detect the slide along.
 *
 * @param inPositiveDirection YES or NO: whether to detect slide in the positive direction along this axis, or the negative direction.
 *
 * @return A `WWEvent` instance.
 *
 * @see WWEvent:setPhaseSignalMask:
 */
+ (WWEvent *) gestureSlideAlongAxis:(NSString*)axisName inPositiveDirection:(BOOL)positive;   // robot must be oriented vertically. see todo in .mm

/**
 * Initializes a `WWEvent` object which will trigger events relating to a "Drop" gesture.
 *
 * A "Drop" means the robot has been dropped.
 *
 * The default identifier for this event is gestureDrop.
 *
 * This `WWEvent` recognizes the five different `WWEventPhase` phases.
 *
 * | WWEventPhases                |
 * |------------------------------|
 * | WW_EVENT_GESTURE_IDLE        |
 * | WW_EVENT_GESTURE_STARTED     |
 * | WW_EVENT_GESTURE_ESTABLISHED |
 * | WW_EVENT_GESTURE_COMPLETED   |
 * | WW_EVENT_GESTURE_CANCELLED   |
 *
 * | Transition From WWEventPhase | To WWEventPhase              | On Condition                            | Comment                                                |
 * |------------------------------|------------------------------|-----------------------------------------|--------------------------------------------------------|
 * | WW_EVENT_GESTURE_IDLE        | WW_EVENT_GESTURE_STARTED     | Acceleration < some threshhold          | Started dropping.                                      |
 * | WW_EVENT_GESTURE_STARTED     | WW_EVENT_GESTURE_ESTABLISHED | Time in phase > some threshhold         | Time has passed while dropping.                        |
 * | WW_EVENT_GESTURE_STARTED     | WW_EVENT_GESTURE_CANCELLED   | Acceleration > some threshhold          | Stopped dropping before enough time passed.            |
 * | WW_EVENT_GESTURE_ESTABLISHED | WW_EVENT_GESTURE_COMPLETED   | Acceleration > some threshhold          | Stopped dropping after enough time passed.             |
 * | WW_EVENT_GESTURE_COMPLETED   | WW_EVENT_GESTURE_IDLE        | Automatic                               |                                                        |
 * | WW_EVENT_GESTURE_CANCELLED   | WW_EVENT_GESTURE_IDLE        | Automatic                               |                                                        |
 *
 * By default, this `WWEvent` will be triggered only for WW_EVENT_GESTURE_COMPLETED, however you can set a custom mask using WWEvent:setPhaseSignalMask:.
 *
 * @return A `WWEvent` instance.
 *
 * @see WWEvent:setPhaseSignalMask:
 *
 */
+ (WWEvent *) gestureDrop;


+ (WWEvent *) orientationShake;
+ (WWEvent *) orientationPitchAndRoll;
+ (WWEvent *) orientationTiltRangeMin:(NSNumber *)minAngle max:(NSNumber *)maxAngle;

@end
