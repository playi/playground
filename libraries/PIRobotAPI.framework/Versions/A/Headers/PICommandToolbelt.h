//
//  PICommandToolbelt.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 5/15/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

@class PICommand;

@interface PICommandToolbelt : NSObject

// composite command for movements
+ (PICommand *) moveStop;
+ (PICommand *) moveRotate:(PIAngle)angle;

@end
