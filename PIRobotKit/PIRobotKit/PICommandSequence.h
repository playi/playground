//
//  PICommandSequence.h
//  PIRobotKit
//
//  Created by Kevin Liang on 1/8/14.
//  Copyright (c) 2014 Play-i. All rights reserved.
//

#import "PIObject.h"
#import "PICommandSequenceStep.h"

/**
 Index key that maps the raw data (NSArray of NSDictionaries) to be parsed.
 */
extern NSString *const gDataPayloadKey;


/**
 `PICommandSequence` class represents a robot animation executed over a finite amount of time.  Specifically, this class provides two major functionalities:
 1: Granular animation control: Caller will be able to describe how the robot will act at any specified time during the animation through the use of `PICommandSequenceStep` class.
 2: Sequence specific events: Caller can specify a set of events to listen to for a given sequence that will be active when the sequence is being executed.
 
 For example, this class can be used to specify the scenario of "wiggle for 4 seconds or until a clap is heard".  Caller will be able to specify the sequence as such:
 1. construct a sequential set of steps with alternating wheel speeds to define a wiggle: self.steps = [step1 => { duration = 1, leftWheelSpeed => 5, rightWheelSpeed = -5}, step2 => { duration = 1, leftWheelSpeed => -5, rightWheelSpeed = 5}, step3 => { duration = 1, leftWheelSpeed => 5, rightWheelSpeed = -5}, step4 => { duration = 1, leftWheelSpeed => -5, rightWheelSpeed = 5}]
 2. register for a clap event: [self.events addObject:clapEvent];
 
 */
@interface PICommandSequence : PIObject

/**
 A set of PICommandSequenceStep objects to be executed sequentially over the course of the animation.
 */
@property (nonatomic, strong) NSMutableArray *steps;

/**
 A set of PIEvents to listen to during the execution of this sequence.
 */
@property (nonatomic, strong) NSMutableArray *events;

/**
 Parses the raw data animation recursively to populate the steps in this sequence.  This method will override any existing PICommandSequenceSteps for this sequence.
 
 @param data Raw data to be parsed, which has the following form: NSDictionary{gParserVersionKey => <parserVersionNumber>, gDataPayloadKey => NSArray[stepsRawData]}
 
 @return YES if parsed successfully, NO otherwise
 */
- (BOOL) parseData:(NSDictionary *)data;

/**
 Calculates the number of steps for this sequence.
 
 @return total number of steps in this sequence, or 0 if there are no steps.
 */
- (NSUInteger) numSteps;

/**
 Returns an array of all the component keys that are active for this sequence.
 
 @return an array copy of all the component keys that this animation will use.  A empty array is returned if sequence is empty. 
 */
- (NSArray *) allComponents;

@end
