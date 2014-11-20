//
//  ControlDriveViewController.m
//  playground
//
//  Created by Kevin Liang on 11/17/14.
//  Copyright (c) 2014 Wonder Workshop. All rights reserved.
//

#import "ControlDriveViewController.h"

#define ROBOT_SPEED 50

@interface ControlDriveViewController ()

@end

@implementation ControlDriveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.joystick.type = DRIVE_JOYSTICK;
    [self.joystick updateDraggerImage];
}

- (WWCommandSet *) commandFromJoystick
{
    WWCommandSet *cmdToSend = [WWCommandSet new];
    
    // use linear angular!
    float joystickPower = self.joystick.power;
    double lin = [self.joystick getY] * ROBOT_SPEED;
    double ang = [self.joystick getX] * joystickPower * 3.14159 * 2.0;
    
    //NSLog(@"sending linear: %5.2f angular: %5.2f", lin, ang);
    
    // fudge factor to be tweaked
    ang *= 0.5;
    if (lin < 0) {
        ang *= -1.0;
    }
    
    WWCommandBodyLinearAngular *linAng = [[WWCommandBodyLinearAngular alloc] initWithLinear:lin
                                                                                    angular:ang];
    [cmdToSend setBodyLinearAngular:linAng];
    return cmdToSend;
}

#pragma mark - Joystick delegates

- (void) onJoystickMoved
{
    //self.directionalArrows.hidden = YES;
    WWCommandSet *cmd = [self commandFromJoystick];
    [self sendCommandSetToRobots:cmd];
}

- (void) onJoystickReleased
{
    WWCommandSet *stopCommand = [WWCommandToolbelt moveStop];
    [self sendCommandSetToRobots:stopCommand];
}


@end
