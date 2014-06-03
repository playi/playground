//
//  PIEvent+UserAction.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 5/8/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

#import "PIEvent.h"

@interface PIEvent (UserAction)

+ (PIEvent *) buttonPressAny;
+ (PIEvent *) buttonPress:(PIComponentId)index;
+ (PIEvent *) soundDetect:(PISoundEventIndex)index;
+ (PIEvent *) orientationShaken;
+ (PIEvent *) orientationPickedUp;

@end
