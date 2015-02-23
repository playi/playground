//
//  RobotControlViewController.h
//  playground
//
//  Created by Kevin Liang on 11/17/14.
//  Copyright (c) 2014 Wonder Workshop. All rights reserved.
//

@interface RobotControlViewController : UIViewController <WWRobotDelegate>

@property (nonatomic, strong) NSArray *connectedRobots;

- (void) refreshConnectedRobots;
- (void) sendCommandSetToRobots:(WWCommandSet *)cmd;

@end
