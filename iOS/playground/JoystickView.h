//
//  JoystickView.h
//  RobotControl
//
//  Created by igor on 2/24/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

#import <UIKit/UIKit.h>

// joystick dot
#define DOTSIZE 90
#define DOTSIZE_HALF (DOTSIZE / 2)

typedef enum {
    DRIVE_JOYSTICK,
    HEAD_JOYSTICK
} JoystickType;


@protocol JoystickDelegate <NSObject>
@optional
- (void) onJoystickMoved;
- (void) onJoystickSoftReleased;
- (void) onJoystickReleased;
- (CGRect) joystickBounds;
- (float) joystickSoftReturnDuration; // max time for "return center" method which is called after user releases joystick
@end

@interface JoystickView : UIView
{
    CGPoint _center;
}

@property (nonatomic, weak) IBOutlet id<JoystickDelegate> joystickDelegate;
@property (nonatomic) CGPoint dotPos;
@property (nonatomic, strong) UIImageView *draggerImgView;
@property (nonatomic, assign) JoystickType type;
- (float) getX; /* returns relative position [-1 : 1]  */
- (float) getY;

- (void) enforceJoystickBound:(CGPoint *)point;
- (void) updateDraggerImage;
- (void) returnNow;

@end


// help methods

static inline double clamp(double d, double min, double max) {
    const double t = d < min ? min : d;
    return t > max ? max : t;
}

static inline double lerp(double min, double max, double T)
{
    return min + (max - min) * T;
}

static inline float getDistance(CGPoint p1, CGPoint p2)
{
    return hypotf(p1.x - p2.x, p1.y - p2.y);
}

// translate from old coordinate system into new one
static inline float normalizeValueToNewRange(float value, float src_min, float src_max, float dst_min, float dst_max)
{
    return ( value - src_min ) / ( src_max - src_min ) * ( dst_max - dst_min ) + dst_min;
}

static inline CGPoint lerpPoints(CGPoint min, CGPoint max, double T)
{
    CGPoint result;
    result.x = lerp(min.x, max.x, T);
    result.y = lerp(min.y, max.y, T);
    return result;
}

