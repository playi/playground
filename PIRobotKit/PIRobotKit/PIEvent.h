//
//  PIEvent.h
//  PIRobotKit
//
//  Created by Kevin Liang on 1/8/14.
//  Copyright (c) 2014 Play-i. All rights reserved.
//

#import "PIObject.h"

extern NSString *const PIShakeEventId;

typedef BOOL(^PIEventAlertBlock)(NSArray *robotStateHistory);

@class PICommand, PICommandSequence;

/** 
 `PIEvent` class represents a single event that can be triggered.  
 */
@interface PIEvent : PIObject

/**
 Main logic to determine if this event is satisfied or not.  The return value will determine whether a callback will be triggered for `PIRobotDelegate`.  If this block is not provided, then this event is essentially a no-op.
 */
@property (copy)PIEventAlertBlock shouldAlertBlock;

/**
 a string identifier that is used to make identification easier.
 */
@property (nonatomic, strong) NSString *identifier;

- (id) initWithIdentifier:(NSString *)identifier shouldAlertBlock:(PIEventAlertBlock)block;

/**
 Helper functions for generic, popular events.
 */
+ (PIEvent *) clapEvent;
+ (PIEvent *) shakeEvent;
+ (PIEvent *) motorBlockedEvent;

@end


/**
 `PIEventDataSource` protocol defines the methods that should be implemented by objects where PIEvent is tied to its execution scope.
 */
@protocol PIEventDataSource <NSObject>

/**
 Adds an event to listen to.  If event already exists, this will be a no-op.
 
 @param event Event to be notified on receiving PIRobotState data.
 */
- (void) addEvent:(PIEvent *)event;

/**
 Removes the given event from listening queue.  If event isn't registered to begin with, this will be a no-op.
 
 @param event Event to be removed from on receiving PIRobotState data.
 */
- (void) removeEvent:(PIEvent *)event;

/**
 Removes the given event from listening queue.  If event isn't registered to begin with, this will be a no-op.
 
 @param event Event to be removed from on receiving PIRobotState data.
 */
- (void) removeEventByIdentifier:(NSString *)identifier;

/**
 Returns an array of all the events that is currently registered for this robot, or an empty array if there are no registered events.
 */
- (NSArray *) allEvents;

@end