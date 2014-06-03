//
//  PIComponentLightLED.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 3/31/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

#import "PIComponent.h"

@interface PIComponentLightLED : PIComponent

@property (nonatomic) PIBrightness brightness;

- (id) initWithBrightness:(PIBrightness)brightness;

@end
