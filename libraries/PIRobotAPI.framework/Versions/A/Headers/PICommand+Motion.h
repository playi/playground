//
//  PICommand+Motion.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 5/8/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

#import "PICommand.h"

@interface PICommand (Motion)

- (void) setMoveStop;
- (void) setMoveLeftWheelSpeed:(PIVelocity)leftSpeed RightWheelSpeed:(PIVelocity)rightSpeed;
- (void) setBodyRotateAngle:(PIAngle)angle;
- (void) setHeadTiltAngle:(PIAngle)angle;
- (void) setHeadPanAngle:(PIAngle)angle;
- (void) setHeadTiltAngle:(PIAngle)tilt panAngle:(PIAngle)pan;

@end
