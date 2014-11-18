//
//  JoystickView.m
//  RobotControl
//
//  Created by igor on 2/24/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "JoystickView.h"

#define CLAMP(x, low, high)  (((x) > (high)) ? (high) : (((x) < (low)) ? (low) : (x)))

#define STROKECOLOR CUSTOMBLUECOLOR
#define STROKEWIDTH 5.0f
#define CIRCLE_RECT_PADDING 10
#define BACKCOLOR [UIColor whiteColor].CGColor

// joystick dot
#define DOTCOLOR CUSTOMBLUECOLOR
#define DOTSIZE 60
#define CUSTOMBLUECOLOR [UIColor colorWithRed:70./255 green:151./255 blue:202./255 alpha:1].CGColor

@interface JoystickView ()
{
    CGPoint _dotPos;
    CGPoint _center;
    float _circleRadius;
}

- (float) getX; /* returns relative position [-1 : 1]  */
- (float) getY;
- (float) power;
- (float) circleRadius;
- (float) normalizeValue:(float)value srcMin:(float)srcMin srcMax:(float)srcMax dstMin:(float)dstMin dstMax:(float)dstMax;

@end

@implementation JoystickView

- (void) layoutSubviews {
    [super layoutSubviews];
    
    _center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    _dotPos = _center;
    _circleRadius = CGRectInset(self.bounds, CIRCLE_RECT_PADDING, CIRCLE_RECT_PADDING).size.width / 2;
}
- (float) angle
{
    CGPoint center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    CGPoint p1 = _dotPos;
    CGPoint p0 = center;
    
    CGPoint vector = CGPointMake(p1.x - p0.x, p1.y - p0.y);
    
    float theta_rad = atan2(vector.y,vector.x);
    
    theta_rad += M_PI / 2.0;
    
    float theta_deg = (theta_rad / M_PI * 180);
    
    theta_deg += (theta_rad > 0 ? 0 : 360);
    
    
    return theta_deg;
}

#pragma mark Joystick Layout

- (void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(ctx, YES);

    // draw the dot
    CGRect middleCircle;
    middleCircle.origin.x = _dotPos.x - DOTSIZE / 2;
    middleCircle.origin.y = _dotPos.y - DOTSIZE / 2;
    middleCircle.size.width = DOTSIZE;
    middleCircle.size.height = DOTSIZE;
    
    CGContextSetFillColorWithColor(ctx, DOTCOLOR);
    CGContextSetLineWidth(ctx, 1.0);
    CGContextFillEllipseInRect(ctx, middleCircle);
}

- (float) power
{
    return hypotf(_dotPos.x - _center.x, _dotPos.y - _center.y) / [self circleRadius];
}

- (float) circleRadius
{
    return _circleRadius - DOTSIZE / 2;
}

- (float) normalizeValue:(float)value srcMin:(float)srcMin srcMax:(float)srcMax dstMin:(float)dstMin dstMax:(float)dstMax {
    return ( value - srcMin ) / ( srcMax - srcMin ) * ( dstMax - dstMin ) + dstMin;
}

- (void) enforceJoystickBound:(CGPoint *)point
{
    // clamp
    if ([_joystickDelegate respondsToSelector:@selector(joystickBounds)]) {
        CGRect bounds = [_joystickDelegate joystickBounds];
        point->x = CLAMP(point->x, bounds.origin.x, bounds.size.width);
        point->y = CLAMP(point->y, bounds.origin.y, bounds.size.height);
    }
    return;
}

- (float) getX {
    float src_min = _center.x - [self circleRadius];
    float src_max = _center.x + [self circleRadius];
    
    return [self normalizeValue:_dotPos.x srcMin:src_min srcMax:src_max dstMin:1 dstMax:-1];
}

- (float) getY {
    float src_min = _center.y - [self circleRadius];
    float src_max = _center.y + [self circleRadius];
    
    return [self normalizeValue:_dotPos.y srcMin:src_min srcMax:src_max dstMin:1 dstMax:-1];
}


#pragma mark Hadle touches

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _dotPos = _center;
    [self setNeedsDisplay];
    if ([_joystickDelegate respondsToSelector:@selector(onJoystickReleased:)]) {
        [_joystickDelegate onJoystickReleased:self];
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint newPos = [[touches anyObject] locationInView: self];
    [self enforceJoystickBound:&newPos];
    
    _dotPos = newPos;
    [self setNeedsDisplay];
    if ([_joystickDelegate respondsToSelector:@selector(onJoystickMoved:)]) {
        [_joystickDelegate onJoystickMoved:self];
    }
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self commonInit];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void) commonInit {
    self.contentMode = UIViewContentModeScaleAspectFit;
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
}



@end
