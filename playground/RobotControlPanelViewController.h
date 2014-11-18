//
//  RobotControlPanelViewController.h
//  playground
//
//  Created by Kevin Liang on 11/17/14.
//  Copyright (c) 2014 Wonder Workshop. All rights reserved.
//

@class RobotControlViewController;

@interface RobotControlPanelViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *controlsSelector;
@property (weak, nonatomic) IBOutlet UIView *controlsView;
@property (nonatomic, strong) RobotControlViewController *activeControlVC;

- (IBAction)switchControls:(id)sender;

@end

