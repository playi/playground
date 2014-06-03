//
//  PICommand+Emotion.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 5/8/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

#import "PICommand.h"

@interface PICommand (Emotion)

- (void) setLeftEarColorRed:(PIBrightness)red green:(PIBrightness)green blue:(PIBrightness)blue;
- (void) setRightEarColorRed:(PIBrightness)red green:(PIBrightness)green blue:(PIBrightness)blue;
- (void) setChestColorRed:(PIBrightness)red green:(PIBrightness)green blue:(PIBrightness)blue;
- (void) setTailBrightness:(PIBrightness)red;
- (void) playSound:(PISoundTrackIndex)index;
- (void) playEyeAnimation:(PIEyeAnimationIndex)index;

@end
