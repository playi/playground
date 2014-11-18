//
//  RobotControlsViewController.m
//  playground
//
//  Created by Kevin Liang on 11/17/14.
//  Copyright (c) 2014 Wonder Workshop. All rights reserved.
//

#import "RobotControlsViewController.h"
#import "ControlLightsViewController.h"

@interface RobotControlsViewController ()

@property (nonatomic, strong) NSArray *controlsVC;

- (void) presentRobotControlsVC:(RobotControlViewController *)vc;

@end

#define CONTROL_LIGHTS 0
#define CONTROL_EYE_RING 1
#define CONTROL_JOYSTICK 2
#define CONTROL_SOUND 3
#define CONTROL_SENSORS 4

@implementation RobotControlsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ControlLightsViewController *lights = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([ControlLightsViewController class])];
    self.controlsVC = @[lights];
    
    [self presentRobotControlsVC:[self.controlsVC firstObject]];    
}

- (IBAction)switchControls:(id)sender {
    UISegmentedControl *control = sender;
    
    RobotControlViewController *newVC = (RobotControlViewController *)[self.controlsVC objectAtIndex:control.selectedSegmentIndex];
    [self presentRobotControlsVC:newVC];
}

- (void) presentRobotControlsVC:(RobotControlViewController *)vc
{
    if (![self.activeControlVC isEqual:vc]) {
        [self.activeControlVC.view removeFromSuperview];
        [self.activeControlVC removeFromParentViewController];
        
        self.activeControlVC = vc;
        [self addChildViewController:self.activeControlVC];
        [self.controlsView addSubview:self.activeControlVC.view];
        [self.activeControlVC didMoveToParentViewController:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WWRobotDelegate
- (void) robot:(WWRobot *)robot didReceiveRobotState:(WWSensorSet *)state {
    
}

- (void) robot:(WWRobot *)robot eventsTriggered:(NSArray *)events {
    for (WWEvent *event in events) {
    }
}

@end
