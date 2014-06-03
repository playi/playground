//
//  PICommand.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 3/31/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

#import "PIComponentsContainer.h"

@class PIComponentMotorServo, PIComponentMotorWheel, PIComponentLightRGB, PIComponentEyeRing, PIComponentLightLED, PIComponentSpeaker;

@interface PICommand : PIComponentsContainer

#pragma mark - helper functions
- (void) setMotorLeft:(PIComponentMotorWheel *)leftWheel right:(PIComponentMotorWheel *)rightWheel;
- (void) setMotorsAllToSpeed:(PIVelocity)speed;
- (void) setHeadTilt:(PIComponentMotorServo *)tilt pan:(PIComponentMotorServo *)pan;
- (void) setEarLightLeft:(PIComponentLightRGB *)leftEar right:(PIComponentLightRGB *)rightEar;
- (void) setHeadTilt:(PIComponentMotorServo *)tilt;
- (void) setHeadPan:(PIComponentMotorServo *)pan;
- (void) setLeftEarLight:(PIComponentLightRGB *)leftEar;
- (void) setRightEarLight:(PIComponentLightRGB *)rightEar;
- (void) setEyeRing:(PIComponentEyeRing *)eye;
- (void) setChestLight:(PIComponentLightRGB *)chest;
- (void) setTailLight:(PIComponentLightLED *)tail;
- (void) setSound:(PIComponentSpeaker *)sound;

#pragma mark - parsing data structs
//+ (BOOL) isValidParsingVersion:(NSString *)version;
+ (PICommand *) commandFromData:(NSDictionary *)data;

- (void) setComponent:(PIComponent *)component forIndex:(PIComponentId)index;
- (void) setComponent:(PIComponent *)component forKey:(id)key;
- (void) removeComponentForIndex:(PIComponentId)index;

@end
