//
//  ControlLightsViewController.h
//  playground
//
//  Created by Kevin Liang on 11/17/14.
//  Copyright (c) 2014 Wonder Workshop. All rights reserved.
//

#import "RobotControlViewController.h"

@interface ControlLightsViewController : RobotControlViewController

@property (weak, nonatomic) IBOutlet UISlider *leftEarRSlider;
@property (weak, nonatomic) IBOutlet UISlider *leftEarGSlider;
@property (weak, nonatomic) IBOutlet UISlider *leftEarBSlider;

@property (weak, nonatomic) IBOutlet UISlider *chestRSlider;
@property (weak, nonatomic) IBOutlet UISlider *chestGSlider;
@property (weak, nonatomic) IBOutlet UISlider *chestBSlider;

@property (weak, nonatomic) IBOutlet UISlider *rightEarRSlider;
@property (weak, nonatomic) IBOutlet UISlider *rightEarGSlider;
@property (weak, nonatomic) IBOutlet UISlider *rightEarBSlider;

@property (weak, nonatomic) IBOutlet UISlider *mainButtonMonoSlider;

@property (weak, nonatomic) IBOutlet UISlider *backMonoSlider;

@property (weak, nonatomic) IBOutlet UIButton *lightShowButton;

- (IBAction)setRGBLights:(id)sender;
- (IBAction)toggleLightShow:(id)sender;

@end
