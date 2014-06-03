//
//  PISound.h
//  PIRobotKit
//
//  Created by Kevin Liang on 2/10/14.
//  Copyright (c) 2014 Play-i. All rights reserved.
//

#import "PIComponent.h"

/**
 `PISound` is subclass of `PIComponent` class, and it is an ABSTRACT class that all sound sensor inputs will inherit from.
 */
@interface PISound : PIComponent

/**
 the volumen index for the sound.  Mute = 0.
 */
@property (nonatomic) PIValueIndex volume;

@end
