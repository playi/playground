//
//  ControlSoundViewController.m
//  playground
//
//  Created by Kevin Liang on 11/18/14.
//  Copyright (c) 2014 Wonder Workshop. All rights reserved.
//

#import "ControlSoundViewController.h"

@interface ControlSoundViewController ()

@property (nonatomic) float volume;
@property (nonatomic, strong) WWEvent *mainButtonTouchUp;
@property (nonatomic, strong) WWEvent *headPanPositionChanged;

@end

@implementation ControlSoundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.volume = (WW_VOLUME_MAX - WW_VOLUME_MUTE) / 2.0;
    self.mainButtonTouchUp = [WWEventToolbelt buttonOnUp:[NSNumber numberWithUnsignedInteger:WW_SENSOR_BUTTON_MAIN]];
    
    self.headPanPositionChanged = [[WWEvent alloc] initWithShouldAlertBlock:^BOOL(WWEvent *event, WWSensorHistory *history) {
        WWSensorHeadPosition *currHeadPan = (WWSensorHeadPosition *)[history.currentState sensorForIndex:WW_SENSOR_HEAD_POSITION_PAN];
        WWSensorHeadPosition *prevHeadPan300ms = (WWSensorHeadPosition *)[[history pastStateAtTimeAgo:0.3] sensorForIndex:WW_SENSOR_HEAD_POSITION_PAN];
        
        return fabsf(currHeadPan.radians - prevHeadPan300ms.radians) > 0.05; // allow for some errors
    } identifier:@"head"];
}

- (void) setVolume:(float)volume {
    _volume = volume;
    self.volumeSlider.value = _volume;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.volumeSlider.value = self.volume;
    
    for (WWRobot *robot in self.connectedRobots) {
        [robot addEvent:self.mainButtonTouchUp];
        [robot addEvent:self.headPanPositionChanged];
    }    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    for (WWRobot *robot in self.connectedRobots) {
        [robot removeAllEvents];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playSoundPressed:(id)sender {
    WWCommandSet *speakerCommand = [WWCommandSet new];
    WWCommandSpeaker *speaker = [[WWCommandSpeaker alloc] initWithDefaultSound:WW_SOUNDFILE_HI];
    speaker.volume = self.volume;
    [speakerCommand setSound:speaker];
    
    [self sendCommandSetToRobots:speakerCommand];
}

#pragma mark - WWRobotDelegate
- (void) robot:(WWRobot *)robot eventsTriggered:(NSArray *)events {
    
    for (WWEvent *event in events) {
        if ([self.mainButtonTouchUp isEqual:event]) {
            self.volume = (self.volume == WW_VOLUME_MUTE) ? WW_VOLUME_MAX : WW_VOLUME_MUTE;
        }
        else if ([event hasIdentifier:@"head"]) {
            WWSensorHeadPosition *headPan = (WWSensorHeadPosition *)[robot.history.currentState sensorForIndex:WW_SENSOR_HEAD_POSITION_PAN];
            self.volume = headPan.radians / -2.0f;
        }
    }
}

@end
