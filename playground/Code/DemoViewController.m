//
//  DemoViewController.m
//  Demo
//
//  Created by Kevin Liang on 5/22/14.
//  Copyright (c) 2014 Play-i. All rights reserved.
//

#import "DemoViewController.h"

@interface DemoViewController ()

// Objects used to help track the robots state.
@property (nonatomic, strong) PIRobot *robot;
@property (nonatomic, strong) PIRobotManager *robotManager;
@property (nonatomic, strong) PICommandSequence *mainAnimation;
@property (nonatomic, strong) PICommandSequence *secondaryAnimation;
@property (nonatomic, strong) NSDictionary *mainAnimationResult;

// Scalar values used to help track the robots state.
@property (atomic) PIVelocity leftWheelVelocity;
@property (atomic) PIVelocity rightWheelVelocity;

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
    
    // load main animation from file
    self.mainAnimation = [PICommandSequence sequenceFromFileInBundle:MAIN_ANIMATION_FILE fileType:@"json"];
    
    // create second animation programmatically
    self.secondaryAnimation = [PICommandSequence new];
    PICommand *eyeBitmapCmd = [PICommand new];
    PIComponentEyeRing *eyeBitmap = [PIComponentEyeRing new];
    [eyeBitmap setLEDValue:YES atIndex:1];
    [eyeBitmap setLEDValue:YES atIndex:6];
    [eyeBitmapCmd setEyeRing:eyeBitmap];
    [self.secondaryAnimation addCommand:eyeBitmapCmd withDuration:2.0];
    PICommand *eyeOffCmd = [PICommand new];
    PIComponentEyeRing *eyeOff = [PIComponentEyeRing new];
    eyeOff.animationIndex = EYEANIM_NONE;
    [eyeOffCmd setEyeRing:eyeOff];
    [self.secondaryAnimation addCommand:eyeOffCmd withDuration:2.0];
    
    self.playPauseMainSequence.enabled = NO;
    
    self.leftWheelVelocity = (PIVelocity)0.0;
    self.rightWheelVelocity = (PIVelocity)0.0;
}

#pragma mark - user interactions
- (IBAction) connectionStatusAction:(id)sender
{
    if (!self.robot || (self.robot.connectionState != CONNECTED)) {
        [self.robotManager scanForPIRobots:1.0];
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

- (IBAction) sendCommand_RotateHead:(id)sender
{
    PIAngle randomPanAngle = -100 + rand() % (100+100); // random angle from [-100, 100]
    PICommand *cmd = [PICommand new];
    [cmd setHeadPan:[[PIComponentMotorServo alloc] initWithAngle:randomPanAngle]];
    [self.robot sendRobotCommand:cmd];
}

- (IBAction) sendCommand_MatchLights:(id)sender
{

    // random light values from 0 to 255 for the light brightness.
    unsigned char randomRed   = rand() % 256;
    unsigned char randomGreen = rand() % 256;
    unsigned char randomBlue  = rand() % 256;
    unsigned char randomBrightness = rand() % 256;
    
    PIComponentLightRGB *randomRGB = [[PIComponentLightRGB alloc]
                                      initWithRed:randomRed
                                      green:randomGreen
                                      blue:randomBlue];
    
    PIComponentLightLED *randomLED = [[PIComponentLightLED alloc]
                                      initWithBrightness:randomBrightness];
    
    // There are four separate commands for each of Bo's lights.
    // Each command is created and sent to the robot in quick seccession.
    PICommand *cmd1 = [PICommand new];
    [cmd1 setChestLight:randomRGB];
    [self.robot sendRobotCommand:cmd1];
    
    PICommand *cmd2 = [PICommand new];
    [cmd2 setLeftEarLight:randomRGB];
    [self.robot sendRobotCommand:cmd2];
    
    PICommand *cmd3 = [PICommand new];
    [cmd3 setRightEarLight:randomRGB];
    [self.robot sendRobotCommand:cmd3];
    
    PICommand *cmd4 = [PICommand new];
    [cmd4 setTailLight:randomLED];
    [self.robot sendRobotCommand:cmd4];
}


- (IBAction) sendCommand_TwinkleLights:(id)sender
{
    // There are four separate commands for each of Bo's lights.
    // Each of the commands is created and sent to the robot.
    // This time the lights are more random.  more inline code used here.
    PICommand *cmd1 = [PICommand new];
    [cmd1 setChestLight:[[PIComponentLightRGB alloc]
                         initWithRed: rand()%256
                         green: rand()%256
                         blue: rand()%256]];
    [self.robot sendRobotCommand:cmd1];
    
    PICommand *cmd2 = [PICommand new];
    [cmd2 setLeftEarLight:[[PIComponentLightRGB alloc]
                           initWithRed: rand()%256
                           green: rand()%256
                           blue: rand()%256]];
    [self.robot sendRobotCommand:cmd2];
    
    PICommand *cmd3 = [PICommand new];
    [cmd3 setRightEarLight:[[PIComponentLightRGB alloc]
                            initWithRed: rand()%256
                            green: rand()%256
                            blue: rand()%256]];
    
    [self.robot sendRobotCommand:cmd3];
    
    PICommand *cmd4 = [PICommand new];
    [cmd4 setTailLight:[[PIComponentLightLED alloc]
                         initWithBrightness: rand()%256]];
    [self.robot sendRobotCommand:cmd4];
}


// The wheels speed are already set.  Just send the command.
- (IBAction) sendCommand_wheels:(id)sender
{
    PIComponentMotorWheel *left = [PIComponentMotorWheel new];
    [left initWithVelocity:self.leftWheelVelocity];
    
    PIComponentMotorWheel *right = [PIComponentMotorWheel new];
    [right initWithVelocity:self.rightWheelVelocity];
    
    PICommand *cmd1 = [PICommand new];
    [cmd1 setMotorLeft:left right:right];
    
    [self.robot sendRobotCommand:cmd1];
}

- (IBAction) sendCommand_leftWheelForward:(id)sender
{
    self.leftWheelVelocity += 5.0;
    [self sendCommand_wheels:sender];
}

- (IBAction) sendCommand_rightWheelForward:(id)sender
{
    self.rightWheelVelocity += 5.0;
    [self sendCommand_wheels:sender];
}

- (IBAction) sendCommand_leftWheelBack:(id)sender
{
    self.leftWheelVelocity -= 5.0;
    [self sendCommand_wheels:sender];
}

- (IBAction) sendCommand_rightWheelBack:(id)sender
{
    self.rightWheelVelocity -= 5.0;
    [self sendCommand_wheels:sender];
}

- (IBAction) sendCommand_wheelsStop:(id)sender
{
    self.rightWheelVelocity = 0.0;
    self.leftWheelVelocity  = 0.0;
    [self sendCommand_wheels:sender];
}



// --------------------------------------------------------------------------------------

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
    [self.robot sendRobotCommand:[PICommandToolbelt moveStop]];
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
