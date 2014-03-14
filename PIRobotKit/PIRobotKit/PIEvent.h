//
//  PIEvent.h
//  PIRobotKit
//
//  Created by Kevin Liang on 1/8/14.
//  Copyright (c) 2014 Play-i. All rights reserved.
//

#import "PIObject.h"

@class PICommand, PICommandSequence;

/** 
 `PIEvent` class represents a single event that can be triggered.  
 */
@interface PIEvent : PIObject

/**
 Main logic to determine if this event is satisfied or not.  The return value will determine whether a callback will be triggered for `PIRobotDelegate`.  If this block is not provided, then this event is essentially a no-op.
 */
@property (nonatomic, copy) BOOL (^shouldAlertBlock)(NSArray *robotStateHistory);

/**
 a string identifier that is used to make identification easier.
 */
@property (nonatomic, strong) NSString *identifier;

- (id) initWithIdentifier:(NSString *)identifier shouldAlertBlock:(BOOL (^)(NSArray *robotStateHistory))block;

/**
 Helper functions for generic, popular events.
 */
+ (PIEvent *) clapEvent;
+ (PIEvent *) shakeEvent;
+ (PIEvent *) motorBlockedEvent;

@end
