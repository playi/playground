//
//  ControlHeadViewController.m
//  playground
//
//  Created by igor on 11/18/14.
//  Copyright (c) 2014 Wonder Workshop. All rights reserved.
//

#import "ControlHeadViewController.h"


@interface ControlHeadViewController ()

@end

@implementation ControlHeadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction) onMiddleBtnTouch:(id)sender {
    [self updateRobotHeadWithPan:0 andTilt:0];
}

- (IBAction) onTopBtnTouch:(id)sender {
    [self updateRobotHeadWithPan:0 andTilt:-15];
}

- (IBAction) onBottomBtnTouch:(id)sender {
    [self updateRobotHeadWithPan:0 andTilt:10];
}

- (IBAction) onLeftBtnTouch:(id)sender {
    [self updateRobotHeadWithPan:-90 andTilt:0];
}

- (IBAction) onRightBtnTouch:(id)sender {
    [self updateRobotHeadWithPan:90 andTilt:0];
}

- (void) updateRobotHeadWithPan:(float)panDegree andTilt:(float)tiltDegree
{
    WWCommandSet *command = [WWCommandSet new];
    WWCommandHeadPosition *tilt = [[WWCommandHeadPosition alloc] initWithDegree:tiltDegree];
    WWCommandHeadPosition *pan = [[WWCommandHeadPosition alloc] initWithDegree:panDegree];
    [command setHeadPositionTilt:tilt pan:pan];
    
    [self sendCommandSetToRobots:command];
}


@end
