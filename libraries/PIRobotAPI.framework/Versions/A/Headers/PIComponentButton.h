//
//  PIComponentButton.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 3/31/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

#import "PIComponent.h"

@interface PIComponentButton : PIComponent

@property (nonatomic, readonly) PIButtonState state;

- (BOOL) isPressed;

@end
