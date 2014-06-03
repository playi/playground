//
//  PIRobotStateHistory.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 5/12/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

#import "PIObject.h"
#import "PIRobotState.h"

@interface PIRobotStateHistory : PIObject

@property (nonatomic) double seconds;

- (NSUInteger) count;
- (PIRobotState *) currentState;
- (PIRobotState *) previousState;
- (PIRobotState *) pastStateAtIndex:(NSUInteger)index;
- (PIRobotState *) pastStateAtTimeAgo:(double)seconds;
- (PIRobotState *) pastStateAtTimeAgo:(double)seconds fromState:(PIRobotState *)state;

- (PIRobotType) robotType;

@end
