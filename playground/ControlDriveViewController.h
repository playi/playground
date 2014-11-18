//
//  ControlDriveViewController.h
//  playground
//
//  Created by Kevin Liang on 11/17/14.
//  Copyright (c) 2014 Wonder Workshop. All rights reserved.
//

#import "RobotControlViewController.h"
#import "CircleJoystickView.h"

@interface ControlDriveViewController : RobotControlViewController <JoystickDelegate>

@property (nonatomic, weak) IBOutlet CircleJoystickView *joystick;

@end
