//
//  PIEvent.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 3/31/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

#import "PIObject.h"

@class PIEvent, PIRobotStateHistory;

typedef BOOL(^PIEventAlertBlock)(PIEvent *event, PIRobotStateHistory *history);

@interface PIEvent : PIObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSMutableDictionary *information;
@property (copy) PIEventAlertBlock shouldAlertBlock;

@property (nonatomic, readonly) NSDate *timestamp;
@property (nonatomic, readonly) BOOL isActive;

- (id) initWithShouldAlertBlock:(PIEventAlertBlock)block;
- (id) initWithShouldAlertBlock:(PIEventAlertBlock)block identifier:(NSString *)identifier;

- (BOOL) hasIdentifier:(NSString *)identifier;

@end
