//
//  DemoViewController.m
//  Demo
//
//  Created by Kevin Liang on 5/22/14.
//  Copyright (c) 2014 Play-i. All rights reserved.
//

#import "DemoViewController.h"

@interface DemoViewController ()
@property (nonatomic, strong) PIRobot *robot;
@property (nonatomic, strong) PIRobotManager *robotManager;
@property (nonatomic, strong) PICommandSequence *mainAnimation;
@property (nonatomic, strong) PICommandSequence *secondaryAnimation;
@property (nonatomic, strong) NSDictionary *mainAnimationResult;

@end

@implementation DemoViewController
@synthesize connectionStatus = _connectionStatus;
@synthesize playPauseMainSequence = _playPauseMainSequence;
@synthesize playSecondarySequence = _playSecondarySequence;
@synthesize singleCommand = _singleCommand;

@synthesize robot = _robot;
@synthesize robotManager = _robotManager;
@synthesize mainAnimation = _mainAnimation;
@synthesize secondaryAnimation = _secondaryAnimation;
@synthesize mainAnimationResult = _mainAnimationResult;

#define MAIN_ANIMATION_FILE @"bo_confident_slalom"

#define SOUNDTRACK_HI 2

#pragma mark - init actions
- (void)viewDidLoad
{
    [super viewDidLoad];

    // setup robot manager
    self.robotManager = [PIRobotManager manager];
    self.robotManager.delegate = self;
    
    self.mainAnimation = [PICommandSequence sequenceFromFileInBundle:MAIN_ANIMATION_FILE fileType:@"json"];
    self.secondaryAnimation = [PICommandSequence new];
    PICommand *earsRed = [PICommand new];
    [earsRed setLeftEarLight:[[PIComponentLightRGB alloc] initWithRed:255 green:0 blue:0]];
    [earsRed setRightEarLight:[[PIComponentLightRGB alloc] initWithRed:255 green:0 blue:0]];
    [self.secondaryAnimation addCommand:earsRed withDuration:2.0];
    
    self.playPauseMainSequence.enabled = NO;
}

#pragma mark - user interactions
- (IBAction) connectionStatusAction:(id)sender
{
    if (!self.robot || (self.robot.connectionState != CONNECTED)) {
        [self.robotManager scanForPIRobots:1.0]; // scan for available robots to connect periodically (1 second)
    }
    else {
        [self.robotManager disconnectRobot:self.robot];
    }
}

- (IBAction) playPauseMainSequence:(id)sender
{
    if ([self.robot isExecutingCommandSequence:self.mainAnimation]) {
        [self.robot stopCommandSequence:self.mainAnimation];
        [self.playPauseMainSequence setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
    else {
        [self.robot executeCommandSequence:self.mainAnimation withOptions:self.mainAnimationResult];
        [self.playPauseMainSequence setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    }
}

- (IBAction) playSecondarySequence:(id)sender
{
    [self.robot executeCommandSequence:self.secondaryAnimation withOptions:nil];
}

- (IBAction) sendCommand:(id)sender
{
    PICommand *cmd = [PICommand new];
    [cmd setSound:[[PIComponentSpeaker alloc] initWithSoundTrack:SOUNDTRACK_HI]];
    [self.robot sendRobotCommand:cmd];
}

#pragma mark - PIRobotManagerDelegate
- (void) manager:(PIRobotManager *)manager didDiscoverRobot:(PIRobot *)robot
{
    NSLog(@"discovered robot: %@", robot.name);
    [manager connectRobot:robot];
}
- (void) manager:(PIRobotManager *)manager didConnectWithRobot:(PIRobot *)robot
{
    NSLog(@"connected with robot: %@", robot.name);
    self.robot = robot;
    self.robot.delegate = self;
    [self.connectionStatus setBackgroundImage:[UIImage imageNamed:@"connectionOn.png"] forState:UIControlStateNormal];
    self.playPauseMainSequence.enabled = YES;
}

- (void) manager:(PIRobotManager *)manager didDisconnectWithRobot:(PIRobot *)robot error:(NSError *)error
{
    NSLog(@"disconnected from robot: %@", robot.name);
    [self.connectionStatus setBackgroundImage:[UIImage imageNamed:@"connectionOff.png"] forState:UIControlStateNormal];
    self.playPauseMainSequence.enabled = NO;
}

- (void) manager:(PIRobotManager *)manager stateDidChange:(PIRobotManagerState)oldState toState:(PIRobotManagerState)newState
{
    NSLog(@"state changed!");
}

#pragma mark - RobotDelegate
- (void) robot:(PIRobot *)robot eventsTriggered:(NSArray *)events
{
    // no events registered
}

- (void) robot:(PIRobot *)robot didStopExecutingCommandSequence:(PICommandSequence *)sequence withResults:(NSDictionary *)results
{
    NSLog(@"sequence cancelled");
    self.mainAnimationResult = results;
}

- (void) robot:(PIRobot *)robot didFinishCommandSequence:(PICommandSequence *)sequence
{
    if (sequence == self.mainAnimation) {
        NSLog(@"main sequence completed!");
        [self.robot executeCommandSequence:self.mainAnimation withOptions:nil]; // keep looping
    }
    else {
        NSLog(@"second sequence completed");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
