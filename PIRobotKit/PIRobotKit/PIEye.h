//
//  PIEye.h
//  PIRobotKit
//
//  Created by Kevin Liang on 2/10/14.
//  Copyright (c) 2014 Play-i. All rights reserved.
//

#import "PILight.h"

typedef enum {
    EYE_LED_OFF = 0,
    EYE_LED_ON,
    EYE_LED_UNKNOWN = 99
} PIEyeLEDState;

/**
 `PIEye` is subclass of `PILight` class, and it is an output class to express eye animations. Currently there are 12 LEDs for the eye, arranged in clock-wise fashion.  Thus the LED index would look like:
 
           0
    11            1
 
 10                  2
 
9                     3
 
  8                  4
 
    7             5
           6
 
 */
@interface PIEye : PILight

/** 
 Pre-defined animations that can be used.  todo: sequence index to be an enum set later on.
 */
@property (nonatomic) PIValueIndex animationIndex;

/**
 Set the individual LED light within the eye.  This will be over-written by child classes.
 
 @param state Set the state of the LED to
 @param index The specific LED index to set the state to
 */
- (void) setLEDState:(PIEyeLEDState)state atIndex:(PIValueIndex)index;

/**
 Fetch the current state of the LED.
 
 @param index The specific LED index in question
 @return state of the specific LED
 */
- (PIEyeLEDState) LEDStateAtIndex:(PIValueIndex)index;

/**
 Returns an array of the LED states, where the length of the array is the total number of LEDs, and the LED index will correspond to the object index for the array.
 */
- (NSArray *) ledStates;

/**
 Returns the number of LEDs in this eye
 */
- (NSUInteger) ledCount;

- (id) initWithLEDStates:(NSArray *)ledStates;

@end
