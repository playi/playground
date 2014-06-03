//
//  PIComponentEyeRing.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 3/31/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

#import "PIComponent.h"

@interface PIComponentEyeRing : PIComponent

@property (nonatomic) PIEyeAnimationIndex animationIndex;
@property (nonatomic) PIBrightness brightness;
@property (nonatomic) PIUInteger animationSpeed;
@property (nonatomic) PIUInteger loops;
@property (nonatomic, readwrite) NSArray *ledBitmap;

- (NSUInteger) ledCount;
- (void) setLEDValue:(BOOL)on atIndex:(NSUInteger)index;
- (BOOL) LEDValueAtIndex:(NSUInteger)index;
- (void) setAllBitmap:(BOOL)on;

@end
