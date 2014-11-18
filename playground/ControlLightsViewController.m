//
//  ControlLightsViewController.m
//  playground
//
//  Created by Kevin Liang on 11/17/14.
//  Copyright (c) 2014 Wonder Workshop. All rights reserved.
//

#import "ControlLightsViewController.h"

@interface ControlLightsViewController ()

@property (nonatomic) BOOL lightShowInProgress;
@property (nonatomic, strong) NSTimer *lightShowTimer;
@property (nonatomic) NSUInteger lightShowValueState;

- (void) lightShowTimerValues:(NSTimer *)timer;

@end

@implementation ControlLightsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setRGBLights:(id)sender {
    WWCommandSet *cmd = [WWCommandSet new];
    [cmd setLeftEarLight:[[WWCommandLightRGB alloc] initWithRed:self.leftEarRSlider.value green:self.leftEarGSlider.value blue:self.leftEarBSlider.value]];
    
    [cmd setRightEarLight:[[WWCommandLightRGB alloc] initWithRed:self.rightEarRSlider.value green:self.rightEarGSlider.value blue:self.rightEarBSlider.value]];
    
    [cmd setChestLight:[[WWCommandLightRGB alloc] initWithRed:self.chestRSlider.value green:self.chestGSlider.value blue:self.chestBSlider.value]];
    [cmd setEyeLight:[[WWCommandLightRGB alloc] initWithRed:self.chestRSlider.value green:self.chestGSlider.value blue:self.chestBSlider.value]];
    
    [cmd setMainButtonLight:[[WWCommandLightMono alloc] initWithBrightness:self.mainButtonMonoSlider.value]];
    
    [cmd setTailLight:[[WWCommandLightMono alloc] initWithBrightness:self.backMonoSlider.value]];
    
    [self sendCommandSetToRobots:cmd];
}

- (IBAction)toggleLightShow:(id)sender {
    if (self.lightShowInProgress) {
        self.lightShowInProgress = NO;
        [self.lightShowTimer invalidate];
        [self.lightShowButton setTitle:@"Start light show" forState:UIControlStateNormal];
    }
    else {
        self.lightShowInProgress = YES;
        self.lightShowTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(lightShowTimerValues:) userInfo:nil repeats:YES];
        [self.lightShowTimer fire];
        [self.lightShowButton setTitle:@"Stop light show" forState:UIControlStateNormal];
    }
}

- (void) lightShowTimerValues:(NSTimer *)timer {
    double r, g, b, mono;
    
    self.lightShowValueState = (self.lightShowValueState+1) % 4; // rotate
    switch (self.lightShowValueState) {
        case 0:
            r = 1.0; g = 0; b = 0; mono = 1.0;
            break;
        case 1:
            r = 0; g = 1.0; b = 0; mono = 0.5;
            break;
        case 2:
            r = 0; g = 0; b = 1.0; mono = 0;
            break;
        case 3:
            r = 0.5; g = 0.5; b = 0.5; mono = 0.75;
            break;
        default:
            r = 0; g = 0; b = 0; mono = 0;
            break;
    }
    
    self.leftEarRSlider.value = r;
    self.leftEarGSlider.value = g;
    self.leftEarBSlider.value = b;
    self.rightEarRSlider.value = r;
    self.rightEarGSlider.value = g;
    self.rightEarBSlider.value = b;
    self.chestRSlider.value = r;
    self.chestGSlider.value = g;
    self.chestBSlider.value = b;
    self.mainButtonMonoSlider.value = mono;
    self.backMonoSlider.value = mono;
    
    [self setRGBLights:nil];
}

@end
