//
//  PIRobot.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 3/31/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <CoreBluetooth/CBPeripheral.h>
#elif TARGET_OS_MAC
#error TODO: deal with mac CB peripheral
#endif

#import "PIDefinitions.h"
#import "PIEventDataSource.h"
#import "PIComponent.h"

#define PIRobotTypeIndex @"PIRobotTypeIndex"

typedef enum
{
    DISCOVERED = 1,
    CONNECTED,
    IDLE
} PIRobotConnectionType;

@class PIRobotManager, PICommandSequence, PICommand, PIRobotState, PICommandSequenceExecution, PIComponentsContainer, PIRobotStateHistory;
@protocol PIRobotDelegate;


@interface PIRobot : PIEventDataSource <CBPeripheralDelegate>

@property (nonatomic, readonly) NSString *uuId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) PIRobotStateHistory *history;
@property (nonatomic) PIRobotConnectionType connectionState;
@property (nonatomic, weak) id<PIRobotDelegate> delegate;

# pragma mark - sending commands
- (void) executeCommandSequence:(PICommandSequence *)sequence withOptions:(NSDictionary *)options;
- (void) stopCommandSequence:(PICommandSequence *)sequence;
- (NSDictionary *) commandSequenceResults:(PICommandSequence *)sequence;
- (NSArray *) allExecutingCommandSequences;
- (BOOL) isExecutingCommandSequence:(PICommandSequence *)sequence;
- (void) sendRobotCommand:(PICommand *)command;

#pragma mark - overriden by child class
- (BOOL) validCommandComponentIndex:(PIComponentId)index;

@end


@protocol PIRobotDelegate <NSObject>

@optional
- (void) robot:(PIRobot *)robot didStopExecutingCommandSequence:(PICommandSequence *)sequence withResults:(NSDictionary *)results;
- (void) robot:(PIRobot *)robot didFinishCommandSequence:(PICommandSequence *)sequence;
- (void) robot:(PIRobot *)robot eventsTriggered:(NSArray *)events;
- (void) robot:(PIRobot *)robot systemEventsTriggered:(NSArray *)events;
- (void) robot:(PIRobot *)robot didReceiveRobotState:(PIRobotState *)state;

@end

