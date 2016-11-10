//
//  CircleJoystickView.m
//  WonderWorkshop
//
//  Created by igor on 9/17/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

#import "CircleJoystickView.h"

#define STROKECOLOR CUSTOMBLUECOLOR
#define STROKEWIDTH 5.0f
#define CIRCLE_RECT_PADDING 10
#define BACKCOLOR [UIColor whiteColor].CGColor

float getDistance(CGPoint p1, CGPoint p2);

@implementation CircleJoystickView
{
    float _circleRadius;
}

// once upon a time we will get assets for joystick and remove this
- (void) drawRect:(CGRect)rect
{
    

    [super drawRect:rect];
}


- (void) layoutSubviews
{
    [super layoutSubviews];
    
    // get radius for circle drawing
    _circleRadius = CGRectInset(self.bounds, CIRCLE_RECT_PADDING, CIRCLE_RECT_PADDING).size.width / 2;
}

- (float) power
{
    return getDistance(self.dotPos, _center) / [self circleRadius];
}

- (float) circleRadius
{
    return _circleRadius - DOTSIZE / 2;
}

- (void) enforceJoystickBound:(CGPoint *)point
{
    [super enforceJoystickBound:point];
    
    float v1 = point->x - _center.x;
    float v2 = point->y - _center.y;
    
    float lenght = sqrt( v1 * v1 + v2 * v2 );
    
    float maxLength = [self circleRadius];
    
    if (lenght >= maxLength) {
        float phi = atan2(v2, v1);
        
        float x = _center.x + maxLength * cos(phi);
        float y = _center.y + maxLength * sin(phi);
        
        //       NSLog(@"new pos %@, corrected %.1f : %.1f", NSStringFromCGPoint(*p1), x, y);
        
        point->x = x;
        point->y = y;
    }
    
}

- (float) getX
{
    float src_min = _center.x - [self circleRadius];
    float src_max = _center.x + [self circleRadius];
    
    return normalizeValueToNewRange(self.dotPos.x, src_min, src_max, 1, - 1);
}

- (float) getY
{
    float src_min = _center.y - [self circleRadius];
    float src_max = _center.y + [self circleRadius];
    
    return normalizeValueToNewRange(self.dotPos.y, src_min, src_max, 1, - 1);
}



@end
