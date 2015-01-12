//
//  WWError.h
//  APIObjectiveC
//
//  Created by Orion Elenzil on 20140813.
//  Copyright (c) 2014 Wonder Workshop inc. (https://www.makewonder.com/) All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const WWRobotErrorDomain;
extern NSString* const WWSystemError;

typedef enum {
    WW_ERR_UNKNOWN = 0,
    WW_ERR_FAILED_SELECT,    // likely BTLE failed to connect to robot
    WW_ERR_CANCELED_SELECT,  // selection mode was canceled (eg, by selecting another robot)
    WW_ERR_FAILED_CONNECT,   // timeout or disconnect while waiting for physical access
    WW_ERR_TIMEOUT,          // generic timeout error
    WW_ERR_DISCONNECTED,     // robot is disconnected and cannot complete the action
} WWErrorCode;

@interface WWError : NSError

+ (WWError*) errorWithCode:(NSUInteger)code description:(NSString*)string underlyingError:(NSError*)underlyingError;

@end
