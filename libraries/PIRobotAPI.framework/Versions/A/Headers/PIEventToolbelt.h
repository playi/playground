//
//  PIEventToolbelt.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 5/15/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

@class PIEvent;

@interface PIEventToolbelt : NSObject

// object detection events
+ (PIEvent *) detectObjectFront:(NSNumber *)sensorLimitNumber;
+ (PIEvent *) detectObjectBack:(NSNumber *)sensorLimitNumber;

// movement related events
+ (PIEvent *) moveToDistance:(NSNumber *)distanceNumber;
+ (PIEvent *) moveDisrupt:(NSNumber *)percentNumber;
+ (PIEvent *) moveStop;

// user interaction events
+ (PIEvent *) buttonPress:(NSNumber *)indexNumber;
+ (PIEvent *) soundEvent:(NSNumber *)indexNumber;
+ (PIEvent *) orientationShake;
+ (PIEvent *) orientationPickUp;

@end
