//
//  PICommandSequenceStep.h
//  PIRobotKit
//
//  Created by Kevin Liang on 1/9/14.
//  Copyright (c) 2014 Play-i. All rights reserved.
//
#import "PIObject.h"

/**
 Index key to denote the duration for a given PIComponentValues raw data (specified by gComponentsKey)
 */
extern NSString *const gDurationKey;

/**
 Index key to denote the raw data (NSDictionary) to be mapped to PIComponentValues
 */
extern NSString *const gComponentsKey;

@class PIComponentValues;

/**
 `PICommandSequenceStep` class is essentially a wrapper class on top of PIComponentValues and is used in conjunction with `PICommandSequence` class to describe a robot animation sequence.  This class cannot be executed by itself without being a part of the `PICommandSequence` class.
 */
@interface PICommandSequenceStep : PIObject

/**
 The length of the state of this step, expressed in seconds. 
 */
@property (nonatomic) double duration;

/**
 The desire state of the robot for this given step.  Caller can only specify output component values for the robot.  
 */
@property (nonatomic, strong) PIComponentValues *componentStates;

/**
 Class initializer that will instantiate a PICommandSequenceStep object populated with the given raw data, parsed by the specific parser version.  The raw data will be mapped to PIComponentState equivalent.
 
 @param data Raw data to be parsed, which has the following form: NSDictionary{gDurationKey => <durationInSeconds>, gComponentsKey => NSDictionary[componentsRawData]}
 @param version The version of the parser that will be used to parse data passed in
 
 @return PICommandSequenceStep if parsed successfully, or NULL otherwise.
 */
+ (PICommandSequenceStep *) commandSequenceStepWithData:(NSDictionary *)data version:(NSString *)version;

/**
 Parses raw data with the defined parsing version to seed the values for this class.
 
 @param data Raw data to be parsed, which has the following form: NSDictionary{gDurationKey => <durationInSeconds>, gComponentsKey => NSDictionary[componentsRawData]}
 @param version The version of the parser that will be used to parse data passed in
 
 @return YES if parsed successfully, NO otherwise.
 */
- (BOOL) parseData:(NSDictionary *)data withVersion:(NSString *)version;

- (id) initWithCommand:(PIComponentValues *)command duration:(double) duration;
@end
