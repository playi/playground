//
//  ControlEyeRingViewController.h
//  playground
//
//  Created by Kevin Liang on 11/17/14.
//  Copyright (c) 2014 Wonder Workshop. All rights reserved.
//

#import "RobotControlViewController.h"

@interface ControlEyeRingViewController : RobotControlViewController

@property (weak, nonatomic) IBOutlet UISwitch *eye0Switch;
@property (weak, nonatomic) IBOutlet UISwitch *eye1Switch;
@property (weak, nonatomic) IBOutlet UISwitch *eye2Switch;
@property (weak, nonatomic) IBOutlet UISwitch *eye3Switch;
@property (weak, nonatomic) IBOutlet UISwitch *eye4Switch;
@property (weak, nonatomic) IBOutlet UISwitch *eye5Switch;
@property (weak, nonatomic) IBOutlet UISwitch *eye6Switch;
@property (weak, nonatomic) IBOutlet UISwitch *eye7Switch;
@property (weak, nonatomic) IBOutlet UISwitch *eye8Switch;
@property (weak, nonatomic) IBOutlet UISwitch *eye9Switch;
@property (weak, nonatomic) IBOutlet UISwitch *eye10Switch;
@property (weak, nonatomic) IBOutlet UISwitch *eye11Switch;

@property (weak, nonatomic) IBOutlet UISlider *eyeBrightnessSlider;
@property (weak, nonatomic) IBOutlet UIButton *eyeShowButton;

- (IBAction)setEyeRing:(id)sender;
- (IBAction)toggleEyeShow:(id)sender;
- (IBAction)runEyeAnimation:(id)sender;

@end
