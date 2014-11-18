//
//  RobotControlPanelViewController.m
//  playground
//
//  Created by Kevin Liang on 11/17/14.
//  Copyright (c) 2014 Wonder Workshop. All rights reserved.
//

#import "RobotControlPanelViewController.h"
#import "ControlLightsViewController.h"
#import "ControlEyeRingViewController.h"
#import "ControlDriveViewController.h"
#import "ControlHeadViewController.h"
#import "ControlSensorsViewController.h"

@interface RobotControlPanelViewController ()

@property (nonatomic, strong) NSArray *controlsVC;

- (void) presentRobotControlsVC:(RobotControlViewController *)vc;

@end

@implementation RobotControlPanelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ControlLightsViewController *lights = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([ControlLightsViewController class])];
    ControlEyeRingViewController *eyeRing = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([ControlEyeRingViewController class])];
    ControlDriveViewController *drive = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([ControlDriveViewController class])];
    ControlHeadViewController *head = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([ControlHeadViewController class])];
    ControlSensorsViewController *sensor = [sb instantiateViewControllerWithIdentifier:NSStringFromClass([ControlSensorsViewController class])];

    self.controlsVC = @[lights, eyeRing, drive, head, sensor];
    
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
