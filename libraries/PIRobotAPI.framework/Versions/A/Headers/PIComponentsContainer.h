//
//  PIComponentsContainer.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 3/26/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

#import "PIComponent.h"

@interface PIComponentsContainer : PIObject

#pragma mark - container copy helper functions
- (PIComponentsContainer *)cloneCopy;
- (BOOL) isSubsetOf:(PIComponentsContainer *)otherContainer;
+ (PIComponentsContainer *) mergeContainer:(PIComponentsContainer *)firstContainer withContainer:(PIComponentsContainer *)secondContainer;
- (void) copyFromContainer:(PIComponentsContainer *)otherContainer;

#pragma mark - container operation functions
+ (id) indexToKey:(PIComponentId)index;
- (PIComponent *)componentFromIndex:(PIComponentId)index;
// todo: refactor PIComponentContainer to adhere to fast enumeration so then we do not need this method for iteration
- (PIComponent *)componentFromKey:(id)key;
- (BOOL) empty;
- (NSArray *)allKeys;
- (NSUInteger) count;

@end
