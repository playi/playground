//
//  PIComponentSoundSensor.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 3/31/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

#import "PIComponent.h"

@interface PIComponentSoundSensor : PIComponent

@property (nonatomic, readonly) PIVolume volume;
@property (nonatomic, readonly) PIAngle direction;
@property (nonatomic, readonly) PISoundEventIndex event;

@end
