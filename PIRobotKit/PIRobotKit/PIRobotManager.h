//
//  PIRobotManager.h
//  PIRobotKit
//
//  Created by Kevin Liang on 12/18/13.
//  Copyright (c) 2013 Play-i. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

typedef enum {
    PIRobotManagerStateUnknown = 0,
    PIRobotManagerStateResetting,
    PIRobotManagerStateUnsupported,
    PIRobotManagerStateUnauthorized,
    PIRobotManagerStatePoweredOff,
    PIRobotManagerStatePoweredOn
} PIRobotManagerState;

@class PIError, PIRobot;
@protocol PIRobotManagerDelegate;

/**
 `PIRobotManager` class manages the discovery and connection logic to the individual robots.  This class works asychronously using delegate pattern where the caller will handle the response back from the original calls.
 */
@interface PIRobotManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

/**
 State of the manager.
 */
@property (nonatomic, readonly) PIRobotManagerState state;
/**
 Delegate that will be responsible for handling the logic after discovery/connection/disconnect calls.
 */
@property (nonatomic, weak) id<PIRobotManagerDelegate> delegate;

/**
 Each app should only need one PIRobotManager.  This is the singleton class method that will return either a cached or new version of PIRobotManager.
 */
+ (PIRobotManager *)manager; // singleton, only 1 manager per app

/**
 Performs periodic scan for PIRobots within the vincinity, as specified by timer.  If timer <= 0, then a one time scan is performed. 
 
 @param timer Time (in seconds) that the manager will scan for new robots.
 */
- (void) scanForPIRobots:(float)timer;

/**
 Instructs PIRobotManager to stop scanning for robots.  This is a no-op if no periodic scans were performed initially.
 */
- (void) stopScan;

/**
 Will attempt to connect with the desired robot.  If PIRobot is already connected, this method is a no-op.  
 
 @param robot The robot to establish the connection with.
 */
- (void) connectRobot:(PIRobot *)robot;

/** 
 Disconnect with the desired robot.  If the robot is not connected currently, this method is a no-op.
 
 @param robot The robot to disconnect from.
 */
- (void) disconnectRobot:(PIRobot *)robot;

@end

/**
 `PIRobotManagerDelegate` will handle the async callback from invoked methods in `PIRobotManager`.  
 */
@protocol PIRobotManagerDelegate <NSObject>

/**
 Invoked when connection is newly established with the robot.  If Robot is already connected, this method will not be triggered.
 
 @param manager The PIRobotManager singleton instance
 @param robot The PIRobot that was connected to
 */
- (void) manager:(PIRobotManager *)manager didConnectWithRobot:(PIRobot *)robot;

/**
 Invoked when a robot has been discovered.  If a robot has already been discovered, then this method will not be triggered.
 
 @param manager The PIRobotManager singleton instance
 @param robot The PIRobot that was discovered
 */
- (void) manager:(PIRobotManager *)manager didDiscoverRobot:(PIRobot *)robot;

/**
 Triggered when state of the PIRobotManager has been changed.  This can range from connection channel being disabled or any catastraphic error.
 
 @param manager The PIRobotManager singleton instance
 @param oldState The last state this manager was in
 @param newState The new state this manager is now in
 */
- (void) manager:(PIRobotManager *)manager stateDidChange:(PIRobotManagerState)oldState toState:(PIRobotManagerState)newState;

@optional
/**
 Invoked when a robot has been disconnected.  If no connection exists with the robot previously, this method will not be triggered.
 
 @param manager The PIRobotManager singleton instance
 @param robot The PIRobot that was disconnected
 */
- (void) manager:(PIRobotManager *)manager didDisconnectWithRobot:(PIRobot *)robot error:(PIError *)error;

/**
 Invoked when fail to establish connection with the robot.
 
 @param manager The PIRobotManager singleton instance
 @param robot The PIRobot that was connected unsuccessfully with
 @param error The specific error that occured when trying to establish connection
 */
- (void) manager:(PIRobotManager *)manager didFailToConnectWithRobot:(PIRobot *)robot error:(PIError *)error;

@end