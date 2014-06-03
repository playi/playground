//
//  PIComponentLightRGB.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 3/31/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

#import "PIComponent.h"

@interface PIComponentLightRGB : PIComponent

@property (nonatomic) PIBrightness red;
@property (nonatomic) PIBrightness green;
@property (nonatomic) PIBrightness blue;

- (id) initWithRed:(PIBrightness)red green:(PIBrightness)green blue:(PIBrightness)blue;

@end
