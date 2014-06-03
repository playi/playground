//
//  PIRobotState.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 3/31/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

#import "PIComponentsContainer.h"

@interface PIRobotState : PIComponentsContainer

@property (nonatomic, readonly) NSDate *timestamp;

- (NSTimeInterval) timeIntervalSinceState:(PIRobotState *)anotherState;

@end
