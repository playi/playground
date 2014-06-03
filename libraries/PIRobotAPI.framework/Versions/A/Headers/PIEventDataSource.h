//
//  PIEventDataSource.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 3/31/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

#import "PIObject.h"

@class PIEvent;

@interface PIEventDataSource : PIObject

@property (nonatomic, strong) NSMutableArray *events;

- (void) addEvent:(PIEvent *)event;
- (void) removeEvent:(PIEvent *)event;
- (void) removeEventWithIdentifier:(NSString *)identifier;
- (BOOL) containsEvent:(PIEvent *)event;
- (NSUInteger) count;
- (NSArray *) allEvents;

@end
