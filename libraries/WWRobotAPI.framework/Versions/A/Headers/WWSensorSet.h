//
//  WWSensorSet.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 3/31/14.
//  Copyright (c) 2014 Wonder Workshop inc. (https://www.makewonder.com/) All rights reserved.
//

#import "WWComponentSet.h"

@class WWSensor;

/**
 *  `WWSensorSet` is a subclass of `WWComponentSet` with strict type-checking and convenience
 *  methods to handle `WWSensor` objects.
 */
@interface WWSensorSet : WWComponentSet

/**
 *  Returns the timestamp of when this sensor set data was received from the robot (read-only).
 */
@property (nonatomic, readonly) NSDate *timestamp;


/**---------------------------------------------------------------------------------------
 *  @name Querying sensor set
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  Returns the time delta between this `WWSensorSet` object and anotherState object.
 *
 *  @param anotherState The `WWSensorSet` object to with which to compare the timestamp.
 *
 *  @return The time delta as represented by NSTimeInterval.
 */
- (NSTimeInterval) timeIntervalSinceState:(WWSensorSet *)anotherState;

/**
 *  Returns the `WWSensor` object associated with the WWComponentId mapping.
 *
 *  If the mapping does not exist, null is returned.
 *
 *  @param key The NSNumber representation of the WWComponentId.
 *
 *  @return The associated `WWSensor` object in the mapping.
 */
- (WWSensor *) sensorForKey:(id)key;

@end
