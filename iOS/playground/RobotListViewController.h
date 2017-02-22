//
//  RobotListViewController.h
//  playground
//
//  Created by Kevin Liang on 11/17/14.
//  Copyright (c) 2014 Wonder Workshop. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RobotControlPanelViewController;

@interface RobotListViewController : UITableViewController<WWRobotManagerObserver>

@property (strong, nonatomic) RobotControlPanelViewController *controlPanelViewController;
@property (nonatomic, strong) WWRobotManager *manager;

@property (weak, nonatomic) IBOutlet UIButton *buttonBackToControls;


@end

