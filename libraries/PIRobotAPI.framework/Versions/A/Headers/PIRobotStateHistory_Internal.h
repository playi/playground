//
//  PIRobotStateHistory_Internal.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 5/12/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//
#import "PIRobotStateHistory.h"
#import "PIRobot_Internal.h"

@interface PIRobotStateHistory ()

@property (nonatomic, strong) NSMutableArray *states;
@property (nonatomic) NSUInteger limit;
@property (nonatomic, weak) PIRobot *robot; // needs to be weak since PIRobot holds a strong reference to this object

- (void) addState:(PIRobotState *)state;
- (PIRobotState *) pastStateAtTimeAgo:(double)seconds fromIndex:(NSUInteger)index;

@end
