//
//  DemoViewController.h
//  Demo
//
//  Created by Kevin Liang on 5/22/14.
//  Copyright (c) 2014 Play-i. All rights reserved.
//

@interface DemoViewController : UIViewController<PIRobotManagerDelegate, PIRobotDelegate>

@property (weak, nonatomic) IBOutlet UIButton *connectionStatus;
@property (weak, nonatomic) IBOutlet UIButton *playPauseMainSequence;
@property (weak, nonatomic) IBOutlet UIButton *playSecondarySequence;
@property (weak, nonatomic) IBOutlet UIButton *singleCommand;

- (IBAction) connectionStatusAction:(id)sender;
- (IBAction) playPauseMainSequence:(id)sender;
- (IBAction) playSecondarySequence:(id)sender;
- (IBAction) sendCommand:(id)sender;

@end
