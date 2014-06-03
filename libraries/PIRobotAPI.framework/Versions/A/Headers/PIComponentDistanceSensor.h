//
//  PIComponentDistanceSensor.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 3/31/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

#import "PIComponent.h"

@interface PIComponentDistanceSensor : PIComponent

@property (nonatomic, readonly) PICentimeter distance;
@property (nonatomic, readonly) PICentimeter margin;

@end
