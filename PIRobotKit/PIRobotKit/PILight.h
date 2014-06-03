//
//  PILight.h
//  PIRobotKit
//
//  Created by Kevin Liang on 1/8/14.
//  Copyright (c) 2014 Play-i. All rights reserved.
//

#import "PIComponent.h"

/**
 `PILight` is subclass of `PIComponent` class, and it is an output component class that represents simple light component with a single color brightness.
 */
@interface PILight : PIComponent

/**
 The brightness value of the light, range from 0 to 255
 */
@property (nonatomic) PIBrightness brightness;


- (id) initWithBrightness:(PIBrightness) brightness;

@end
