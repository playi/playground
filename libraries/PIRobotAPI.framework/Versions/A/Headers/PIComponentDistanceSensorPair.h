//
//  PIComponentDistanceSensorPair.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 3/31/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

#import "PIComponentDistanceSensor.h"

@interface PIComponentDistanceSensorPair : PIComponentDistanceSensor

@property (nonatomic, readonly) PICentimeter otherDistance;
@property (nonatomic, readonly) PICentimeter otherMargin;

@end
