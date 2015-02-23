//
//  JoystickView.m
//  RobotControl
//
//  Created by igor on 2/24/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import "JoystickView.h"

#define TIMER_RETURN_UPDATE_RATE 30.0 // delegates calls update rate ( affects robot update state )


@interface JoystickView ()

@property (nonatomic, strong) NSTimer *returnTimer;
@property (nonatomic) float currentReturnRatio;
@property (nonatomic) float returnTime;

@end

@implementation JoystickView
#define DRIVE_DRAGGER_IMAGE @"RC_drive_joystick"
#define HEAD_DRAGGER_IMAGE @"RC_head_joystick"

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self commonInit];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void) commonInit
{
    self.contentMode = UIViewContentModeScaleAspectFit;
    self.autoresizingMask = 0;
    self.userInteractionEnabled = YES;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    _center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    _dotPos = _center;
    [self updateDraggerPosition];
}

#pragma mark Joystick Layout
- (void) updateDraggerImage
{
    NSString *imgName;
    if (self.type == DRIVE_JOYSTICK) {
        imgName = DRIVE_DRAGGER_IMAGE;
    } else {
        imgName = HEAD_DRAGGER_IMAGE;
    }
    
    UIImage *img = [UIImage imageNamed:imgName];
    self.draggerImgView = [[UIImageView alloc] initWithImage:img];
    self.draggerImgView.frame = CGRectMake(0, 0, DOTSIZE, DOTSIZE);
    self.draggerImgView.center = self.dotPos;
    
    [self addSubview:self.draggerImgView];
}

// forbid the joystick dot going out of circle
- (void) enforceJoystickBound:(CGPoint *)point
{
    // clamp
    if ([_joystickDelegate respondsToSelector:@selector(joystickBounds)]) {
        CGRect bounds = [_joystickDelegate joystickBounds];
        point->x = clamp(point->x, bounds.origin.x, bounds.size.width);
        point->y = clamp(point->y, bounds.origin.y, bounds.size.height);
    }
    return;
}

#pragma mark Handle touches

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.returnTimer invalidate];
    self.currentReturnRatio = 0;
    [self.draggerImgView.layer removeAllAnimations];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    BOOL shouldReturnSoflty = [self.joystickDelegate respondsToSelector:@selector(joystickSoftReturnDuration)];
    
    if (shouldReturnSoflty) {
        if ([self.joystickDelegate respondsToSelector:@selector(onJoystickSoftReleased)]) {
            [self.joystickDelegate onJoystickSoftReleased];
        }
        [self returnJoystickToCenter];
    } else {
        [self returnNow];
        [self.joystickDelegate onJoystickReleased];
    }
}

- (void) returnNow
{
    if (self.returnTimer) {
        [self.returnTimer invalidate];
        self.returnTimer = nil;
    }
    
    self.dotPos = _center;
    [self updateDraggerPosition];
}

- (void) returnJoystickToCenter
{
    float dist = getDistance(_center, _dotPos);
    if (dist < 0.1) {
        [self returnNow];
        return;
    }
    
    self.returnTime = [self.joystickDelegate joystickSoftReturnDuration];
    self.returnTime *= dist / CGRectGetWidth(self.bounds);
    
    // timer will update robot with new joystick values while is being animated
    self.returnTimer = [NSTimer scheduledTimerWithTimeInterval:(self.returnTime / TIMER_RETURN_UPDATE_RATE) target:self selector:@selector(updateReturnJoystick) userInfo:nil repeats:YES];

    // animate soft return
    [UIView animateWithDuration:self.returnTime animations:^{
        self.draggerImgView.center = _center;
    }];
}

- (void) updateReturnJoystick
{
    if (_currentReturnRatio >= 1) {
        self.dotPos = _center;
    
        // means we have returned it to the center
        if ([_joystickDelegate respondsToSelector:@selector(onJoystickReleased)]) {
            [_joystickDelegate onJoystickReleased];
        }
        // clean
        [self.returnTimer invalidate];
        self.returnTimer = nil;
        _currentReturnRatio = 0;
    } else {
        _currentReturnRatio += (self.returnTime / TIMER_RETURN_UPDATE_RATE);
        
        if ([_joystickDelegate respondsToSelector:@selector(onJoystickMoved)]) {
            [_joystickDelegate onJoystickMoved];
        }
        
        self.dotPos = lerpPoints(_dotPos, _center, _currentReturnRatio * 0.4);
    }
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint newPos = [[touches anyObject] locationInView: self];
    [self enforceJoystickBound:&newPos];
    
    self.dotPos = newPos;
    [self updateDraggerPosition];
}

- (void) setDotPos:(CGPoint)dotPos
{
    _dotPos = dotPos;
    if ([_joystickDelegate respondsToSelector:@selector(onJoystickMoved)]) {
        [_joystickDelegate onJoystickMoved];
    }
}

-(void) updateDraggerPosition
{
    self.draggerImgView.center = _dotPos;
}

#pragma mark Joystick getters and setters

// methods to be over-written
- (float) getX
{
    return 0;
}

- (float) getY
{
    return 0;
}


@end
