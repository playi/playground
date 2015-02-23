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

@property (nonatomic) BOOL isWiggling;
@property (nonatomic) BOOL isNodding;
@property (nonatomic, strong) WWCommandSetSequence *wiggleAnimation;
@property (nonatomic, strong) WWCommandSetSequence *nodAnimation;

@end

@implementation ControlDriveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.joystick.type = DRIVE_JOYSTICK;
    [self.joystick updateDraggerImage];
    self.isWiggling = NO;
    self.isNodding = NO;
    
    self.wiggleAnimation = [WWCommandSetSequence sequenceFromFileInBundle:@"wiggle" fileType:@"json"];
    self.nodAnimation = [WWCommandSetSequence new];
    WWCommandSet *lookup = [WWCommandSet new];
    [lookup setHeadPositionTilt:[[WWCommandHeadPosition alloc] initWithDegree:-20]];
    WWCommandSet *lookdown = [WWCommandSet new];
    [lookdown setHeadPositionTilt:[[WWCommandHeadPosition alloc] initWithDegree:7.5]];
    [self.nodAnimation addCommandSet:lookup withDuration:0.4];
    [self.nodAnimation addCommandSet:lookdown withDuration:0.4];
    [self.nodAnimation addCommandSet:lookup withDuration:0.4];
    [self.nodAnimation addCommandSet:lookdown withDuration:0.4];
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


- (IBAction)toggleWiggle:(id)sender
{
    NSString *btnText;
    for (WWRobot *robot in self.connectedRobots) {
        if (self.isWiggling) {
            [robot stopCommandSequence:self.wiggleAnimation];
            btnText = @"Start wiggle";
        }
        else {
            // always start from the beginning of animation
            [robot executeCommandSequence:self.wiggleAnimation withOptions:nil];
            btnText = @"Stop wiggle";
        }
    }
    
    [self.toggleWiggleBtn setTitle:btnText forState:UIControlStateNormal];
    self.isWiggling = !self.isWiggling; // toggle
}

- (IBAction)executeNod:(id)sender
{
    if (!self.isNodding && !self.isWiggling) {
        for (WWRobot *robot in self.connectedRobots) {
            [robot executeCommandSequence:self.nodAnimation withOptions:nil];
        }
    }
}

- (void) robot:(WWRobot *)robot didFinishCommandSequence:(WWCommandSetSequence *)sequence
{
    if ([sequence isEqual:self.wiggleAnimation]) {
        if (self.isWiggling) {
            // continue to wiggle until user stops
            for (WWRobot *robot in self.connectedRobots) {
                [robot executeCommandSequence:self.wiggleAnimation withOptions:nil];
            }
        }
    }
    else {
        // this is a nod sequence
        self.isNodding = NO;
    }
}

- (void) robot:(WWRobot *)robot didStopExecutingCommandSequence:(WWCommandSetSequence *)sequence withResults:(NSDictionary *)results
{
    NSLog(@"wiggle sequence terminated by user.");
    for (WWRobot *robot in self.connectedRobots) {
        [robot resetState];
    }
}
@end
