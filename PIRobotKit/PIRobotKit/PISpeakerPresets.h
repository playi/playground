//
//  PISpeakerPresets.h
//  PIRobotKit
//
//  Created by Kevin Liang on 1/8/14.
//  Copyright (c) 2014 Play-i. All rights reserved.
//

#import "PISound.h"

/**
 `PISpeakerPresets` is subclass of `PISound` class, and it is an output component class that dictates what sounds to play from the robot speaker.
 */
@interface PISpeakerPresets : PISound

/**
 Preset soundtrack index to play
 */
@property (nonatomic) PIValueIndex index;

- (void) initWithSoundTrack:(PIValueIndex)index volume:(PIValueIndex)volume;

@end
