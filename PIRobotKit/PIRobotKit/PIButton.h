//
//  PIButton.h
//  PIRobotKit
//
//  Created by Kevin Liang on 1/8/14.
//  Copyright (c) 2014 Play-i. All rights reserved.
//

#import "PIComponent.h"

typedef enum {
    NORMAL = 0,
    PRESSED
} PIButtonState;

/**
 `PIButton` is subclass of `PIComponent` class, and it is a sensor input class that can be used to represent a button state.
 */
@interface PIButton : PIComponent

/**
 the state of the button
 */
@property (nonatomic, readonly) PIButtonState state;

@end
