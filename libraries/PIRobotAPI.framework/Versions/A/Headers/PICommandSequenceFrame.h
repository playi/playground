//
//  PICommandSequenceExecutionFrame.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 4/7/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

#import "PIObject.h"

@class PICommand;

@interface PICommandSequenceFrame : PIObject

@property (nonatomic, strong) PICommand *command;
@property (nonatomic) double duration;

@end
