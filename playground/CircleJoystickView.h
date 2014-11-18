//
//  CircleJoystickView.h
//  WonderWorkshop
//
//  Created by igor on 9/17/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

#import "JoystickView.h"

@interface CircleJoystickView : JoystickView

- (float) angle; /* get angle [0-360] */
@property (nonatomic) float power; /* 0-1 multiplier, which is a relative joystick dot distance from the center */

@end
