//
//  ControlEyeRingViewController.m
//  playground
//
//  Created by Kevin Liang on 11/17/14.
//  Copyright (c) 2014 Wonder Workshop. All rights reserved.
//

#import "ControlEyeRingViewController.h"

@interface ControlEyeRingViewController ()

@property (nonatomic) BOOL eyeShowInProgress;
@property (nonatomic, strong) NSTimer *eyeShowTimer;
@property (nonatomic) NSUInteger eyeShowValueState;

- (void) eyeShowTimerValues:(NSTimer *)timer;

@end

@implementation ControlEyeRingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setEyeRing:(id)sender {
    NSArray *eyeBitmap = @[[NSNumber numberWithBool:self.eye0Switch.on],
                           [NSNumber numberWithBool:self.eye1Switch.on],
                           [NSNumber numberWithBool:self.eye2Switch.on],
                           [NSNumber numberWithBool:self.eye3Switch.on],
                           [NSNumber numberWithBool:self.eye4Switch.on],
                           [NSNumber numberWithBool:self.eye5Switch.on],
                           [NSNumber numberWithBool:self.eye6Switch.on],
                           [NSNumber numberWithBool:self.eye7Switch.on],
                           [NSNumber numberWithBool:self.eye8Switch.on],
                           [NSNumber numberWithBool:self.eye9Switch.on],
                           [NSNumber numberWithBool:self.eye10Switch.on],
                           [NSNumber numberWithBool:self.eye11Switch.on]];
    
    WWCommandSet *cmd = [WWCommandSet new];
    WWCommandEyeRing *eyeRing = [[WWCommandEyeRing alloc] initWithBitmap:eyeBitmap];
    eyeRing.brightness = self.eyeBrightnessSlider.value;
    [cmd setEyeRing:eyeRing];
    [self sendCommandSetToRobots:cmd];
}

- (IBAction)toggleEyeShow:(id)sender {
    if (self.eyeShowInProgress) {
        self.eyeShowInProgress = NO;
        [self.eyeShowTimer invalidate];
        [self.eyeShowButton setTitle:@"Start eye show" forState:UIControlStateNormal];
    }
    else {
        self.eyeShowInProgress = YES;
        self.eyeShowTimer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(eyeShowTimerValues:) userInfo:nil repeats:YES];
        [self.eyeShowTimer fire];
        [self.eyeShowButton setTitle:@"Stop eye show" forState:UIControlStateNormal];
    }
}

- (void) eyeShowTimerValues:(NSTimer *)timer {
    self.eyeShowValueState = (self.eyeShowValueState+1) % 12; // rotate
    
    self.eye0Switch.on = ((0 + self.eyeShowValueState) % 2) == 0;
    self.eye1Switch.on = ((1 + self.eyeShowValueState) % 2) == 0;
    self.eye2Switch.on = ((2 + self.eyeShowValueState) % 2) == 0;
    self.eye3Switch.on = ((3 + self.eyeShowValueState) % 2) == 0;
    self.eye4Switch.on = ((4 + self.eyeShowValueState) % 2) == 0;
    self.eye5Switch.on = ((5 + self.eyeShowValueState) % 2) == 0;
    self.eye6Switch.on = ((6 + self.eyeShowValueState) % 2) == 0;
    self.eye7Switch.on = ((7 + self.eyeShowValueState) % 2) == 0;
    self.eye8Switch.on = ((8 + self.eyeShowValueState) % 2) == 0;
    self.eye9Switch.on = ((9 + self.eyeShowValueState) % 2) == 0;
    self.eye10Switch.on = ((10 + self.eyeShowValueState) % 2) == 0;
    self.eye11Switch.on = ((11 + self.eyeShowValueState) % 2) == 0;
    
    self.eyeBrightnessSlider.value = (double)self.eyeShowValueState / 11.0f;
    
    [self setEyeRing:nil];
}

- (IBAction)runEyeAnimation:(id)sender {
    WWCommandSet *cmd = [WWCommandSet new];
    WWCommandEyeRing* eye = [[WWCommandEyeRing alloc] initWithAnimation:WW_EYEANIM_FULL_BLINK];
    [cmd setEyeRing:eye];
    [self sendCommandSetToRobots:cmd];
}
@end
