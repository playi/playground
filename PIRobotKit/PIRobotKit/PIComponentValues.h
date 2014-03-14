//
//  PIComponentStates.h
//  PIRobotKit
//
//  Created by Kevin Liang on 2/24/14.
//  Copyright (c) 2014 Play-i. All rights reserved.
//

#import "PIObject.h"
#import "PIComponent.h"
#import "PIToolSet.h"

/**
 Index keys used to map a PIComponent to the specific physical component for a given robot.
 For example, gComponentLeftEarLight will be used to mapped PIComponentRGB to the left ear RGB light for Bo (or Yana)'s PIComponentStates.
 */
extern NSString *const gComponentEye;
extern NSString *const gComponentLeftEarLight;
extern NSString *const gComponentRightEarLight;
extern NSString *const gComponentChestLight;
extern NSString *const gComponentTailLight;
extern NSString *const gComponentPlayLight;
extern NSString *const gComponentMainButton;
extern NSString *const gComponentButton1;
extern NSString *const gComponentButton2;
extern NSString *const gComponentButton3;
extern NSString *const gComponentLeftWheel;
extern NSString *const gComponentRightWheel;
extern NSString *const gComponentHeadTilt;
extern NSString *const gComponentHeadPan;
extern NSString *const gComponentAccelerometer;
extern NSString *const gComponentGyroscope;
extern NSString *const gComponentFrontLeftSensor;
extern NSString *const gComponentFrontRightSensor;
extern NSString *const gComponentBackSensor;
extern NSString *const gComponentSpeaker;
extern NSString *const gComponentMicrophone;

/**
 Denotes the proper parser version to be used to convert raw data in NSDictionary to the appropriate PIComponentStates.
 */
extern NSString *const gParseVersionKey;


@class PIMotorServo, PIMotorWheel, PILightRGB, PILight, PIEye;

/**
 `PIComponentStates` class contains the mapping between the specific component values (as denoted with various PIComponent subclasses) and the actual component on the robot.  This class is "robot agnostic" - that is, it can be used on any of the robot types (Bo or Yana) or any robot instances (Bo1 or Bo2).  If PIComponentStates contains values for components that are not applicable for a given robot type (e.g. left motor for Yana), the values will simply be ignored by the robot object during execution.
 */
@interface PIComponentValues : PIObject

/**
 Convenience function to stop the robot from moving.
 
 @return instance of PIComponentStates with motor speeds set to 0.
 */
+ (PIComponentStates *)stopAllMotors;

/**
 Verify if the parser version is valid for parsing raw data.
 
 @param version The parser version
 @return YES if valid, NO otherwise.
 */
+ (BOOL) isValidParsingVersion:(NSString *)version;

/** 
 Convenience method to merge two PIComponentStates together.  If there are conflicting component values (e.g. firstState and secondState both has values for left motor), then this method will take the value from the secondState object. 
 
 @param firstState A PIComponentStates object to be merged
 @param secondState A PIComponentStates object to be merged.  During conflict, this state's value will be used as tie-breaker.
 @return a new instance of PIComponentStates with the resulting merged values.
 */
+ (PIComponentStates *) mergeState:(PIComponentStates *)firstState withState:(PIComponentStates *)secondState;

/**
 Convenience functions to make it easy to set the component values.  
 */
- (void) setMotorLeft:(PIMotorWheel *)leftMotorState right:(PIMotorWheel *)rightMotorState;
- (void) setHeadTilt:(PIMotorServo *)tiltState pan:(PIMotorServo *)panState;
- (void) setEarLightLeft:(PILightRGB *)leftEarState right:(PILightRGB *)rightEarState;
- (void) setHeadTilt:(PIMotorServo *)tiltState;
- (void) setHeadPan:(PIMotorServo *)panState;
- (void) setLeftEarLight:(PILightRGB *)lightState;
- (void) setRightEarLight:(PILightRGB *)lightState;
- (void) setEye:(PIEye *)eyeState;
- (void) setChestLight:(PILightRGB *)chestState;
- (void) setTailLight:(PILight *)tailState;

/**
 Parses raw data with the defined parsing version to seed the values for this class.
 
 @param data Raw data to be parsed, which has the following form: NSDictionary{<componentIndexKey> => NSDictionary[componentRawDataValues]}
 @param version The version of the parser that will be used to parse data passed in
 
 @return YES if parsed successfully, NO otherwise.
 */
- (BOOL) parseData:(NSDictionary *)data withVersion:(NSString *)version;

/** 
 Get the corresponding PIComponent object from key.  Returns NULL if no component corresponds to the given key.
 
 @param key Index key (as defined above) 
 @return the corresponding PIComponent object for the given key. If key is not recognized or if component not found, returns NULL.
 */
- (PIComponent *)componentFromKey:(NSString *)key;

/**
 Set a component to the corresponding index key.
 
 @param component PIComponent value that corresponds to this key
 @param key Index key (as defined above)
 */
- (void) setComponent:(PIComponent *)component forKey:(NSString *)key;

/** 
 Removes the corresponding PIComponent associated with this key.  If no associated PIComponent is found, this is a no-op.
 
 @param key Index key (as defined above)
 */
- (void) removeComponentForKey:(NSString *)key;

/**
 Returns true if no corresponding key/component value pairs are found, false otherwise.
 */
- (BOOL) empty;

/**
 Returns an array of keys for this PIComponentStates.
 */
- (NSArray *) allKeys;

/**
 Returns an exact clone copy of this PIComponentStates.  
 */
- (PIComponentStates *) cloneCopy;

/**
 Returns YES if the passed in PIComponentStates satisfies both criteria when compared to this instance of PIComponentStates:
 1. state is a strict subset of key/PIComponets pairs
 2. state's PIComponent values are the same
 
 @param state The PIComponentStates to compare against
 @return YES if both conditions are satisifed above.  NO otherwise.
 */
- (BOOL) containsSameComponents:(PIComponentStates *)state;

@end
