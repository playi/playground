//
//  PIComponent.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 3/26/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

#import "PIObject.h"

extern NSString *const gBrightnessKey;
extern NSString *const gLEDIndexKey;
extern NSString *const gVelocityKey;
extern NSString *const gAngleKey;
extern NSString *const gRedKey;
extern NSString *const gGreenKey;
extern NSString *const gBlueKey;

@interface PIComponent : PIObject

#pragma mark - override by child objects
- (BOOL) hasValidValues;
- (void) parseData:(NSDictionary *)data;
- (BOOL) hasSameValues:(PIComponent *)otherComponent;

@end
