//
//  PIRobotManager.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 3/31/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

#import "PIObject.h"

#if TARGET_OS_IPHONE
#import <CoreBluetooth/CoreBluetooth.h>
#elif TARGET_OS_MAC
#import <IOBluetooth/IOBluetooth.h>
#endif


typedef enum {
    PIRobotManagerStateUnknown = 0,
    PIRobotManagerStateResetting,
    PIRobotManagerStateUnsupported,
    PIRobotManagerStateUnauthorized,
    PIRobotManagerStatePoweredOff,
    PIRobotManagerStatePoweredOn
} PIRobotManagerState;

@class PIRobot;
@protocol PIRobotManagerDelegate;

@interface PIRobotManager : PIObject <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, readonly) PIRobotManagerState state;
@property (nonatomic, weak) id<PIRobotManagerDelegate> delegate;

+ (PIRobotManager *)manager; // singleton, only 1 manager per app

#pragma mark - robot discovery
- (void) scanForPIRobots:(float)timer;
- (void) stopScan;

#pragma mark - robot connect/disconnect (async)
- (void) connectRobot:(PIRobot *)robot;
- (void) disconnectRobot:(PIRobot *)robot;

@end


@protocol PIRobotManagerDelegate <NSObject>

- (void) manager:(PIRobotManager *)manager didConnectWithRobot:(PIRobot *)robot;
- (void) manager:(PIRobotManager *)manager didDiscoverRobot:(PIRobot *)robot;
- (void) manager:(PIRobotManager *)manager stateDidChange:(PIRobotManagerState)oldState toState:(PIRobotManagerState)newState;

@optional
- (void) manager:(PIRobotManager *)manager didDisconnectWithRobot:(PIRobot *)robot error:(NSError *)error;
- (void) manager:(PIRobotManager *)manager didFailToConnectWithRobot:(PIRobot *)robot error:(NSError *)error;

@end
