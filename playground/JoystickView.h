//
//  JoystickView.h
//  RobotControl
//
//  Created by igor on 2/24/14.
//  Copyright (c) 2014 igor. All rights reserved.
//

@protocol JoystickDelegate <NSObject>
@optional
- (void) onJoystickMoved:(id)sender;
- (void) onJoystickReleased:(id)sender;
- (CGRect) joystickBounds;
@end

@interface JoystickView : UIView

@property (nonatomic) float power; /* 0-1 multiplier, which is a relative joystick dot distance from the center */
@property (nonatomic, weak) IBOutlet id<JoystickDelegate> joystickDelegate;

- (float) angle; /* get angle [0-360] */

- (void) enforceJoystickBound:(CGPoint *)point;

@end
