//
//  RobotControlViewController.m
//  playground
//
//  Created by Kevin Liang on 11/17/14.
//  Copyright (c) 2014 Wonder Workshop. All rights reserved.
//

#import "RobotControlViewController.h"

@interface RobotControlViewController ()

@end

@implementation RobotControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refreshConnectedRobots];
}

- (void) refreshConnectedRobots
{
    self.connectedRobots = [[WWRobotManager manager] allConnectedRobots];
    for (WWRobot *robot in self.connectedRobots) {
        [robot addRobotObserver:self];
    }
}

- (void) sendCommandSetToRobots:(WWCommandSet *)cmd
{
    for (WWRobot *robot in self.connectedRobots) {
        [robot sendRobotCommandSet:cmd];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
