//
//  WWRobot.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 3/31/14.
//  Copyright (c) 2014 Wonder Workshop inc. (https://www.makewonder.com/) All rights reserved.
//

#import "WWEventDataSource.h"

typedef enum {
    ROBOT_CONNECTION_UNKNOWN = 900, // transient state
    ROBOT_CONNECTION_LOST, // seen before, but is not associated at the moment
    ROBOT_CONNECTION_DISCOVERED, // ready to be connected
    ROBOT_CONNECTION_CONNECTING, // trying to establish connection with robot
    ROBOT_CONNECTION_CONNECTED, // ready to take action, now the robot is in user control
    ROBOT_CONNECTION_DISCONNECTING, // waiting for sent commands to reach the robot
} WWRobotConnectionState;

@class WWRobotManager, WWCommandSetSequence, WWCommandSet, WWSensorSet, WWCommandSetSequenceExecution, WWComponentSet, WWSensorHistory;
@protocol WWRobotDelegate;


/**
 *  `WWRobot` is a subclass of `WWEventDataSource` object; it has a 1-to-1 direct
 *  mapping to a physical Wonder Workshop robot.  
 *
 *  Caller can execute robot commands (via `WWCommandSet`) and analyze robot state data 
 *  (via `WWSensorSet`) to control robots as desired.
 */
@interface WWRobot : WWEventDataSource

/**
 *  The delegate object to interact with robot.
 */
@property (nonatomic, weak) id<WWRobotDelegate> delegate;

/**
 *  Returns the human-readable name of the robot (read-only).
 */
@property (nonatomic, readonly) NSString *name;

/**
 *  Returns the entire history of received `WWSensor` objects.
 */
@property (nonatomic, readonly) WWSensorHistory *history;

/**
 *  Returns the personality color of this robot (read-only).
 */
@property (nonatomic, readonly) WWPersonalityColorIndex personalityColorIndex;

/**
 *  Returns the type of this robot (read-only).
 */
@property (nonatomic, readonly) WWRobotType robotType;

/**
 *  Returns the connection status of this robot (read-only).
 */
@property (nonatomic, readonly) WWRobotConnectionState connectionState;

/**
 *  Returns the unique identifier of this robot (read-only).
 */
@property (nonatomic, readonly) NSString *uuId;

/**
 *  Returns the factory serial number of this robot (read-only).
 */
@property (nonatomic, strong, readonly) NSString *serialNumber;

/**
 *  Returns the firmware version that is currently running on this robot (read-only).
 */
@property (nonatomic, strong, readonly) NSString *firmwareVersion;

/**
 *  Returns the signal strength of this robot (read-only).
 */
@property (nonatomic, strong, readonly) NSNumber *signalStrength;


/**---------------------------------------------------------------------------------------
 *  @name Querying robot
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  Returns true if robot has not been properly configured by the Wonder Workshop Go app.
 *
 *  @return Returns true if unconfigured, false otherwise.
 */
- (BOOL) isUnconfigured;

/**
 *  Returns true if robot is connected and ready to receive commands (and currently 
 *  emitting sensor).  
 *
 *  Robot is connected if connectionState == ROBOT_CONNECTION_CONNECTED, false otherwise.
 *
 *  @return Returns true if connected, false otherwise.
 */
- (BOOL) isConnected;

/**
 *  Returns true if this robot is the same as the provided robot.
 *
 *  Comparison is done using [uuId isEqualToString:].
 *
 *  @param robot The robot with which to be compared.
 *
 *  @return Returns true if this robot is the same as the specified robot.
 */
- (BOOL) isEqualToRobot:(WWRobot *)robot;


/**---------------------------------------------------------------------------------------
 *  @name Sending commands
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  Sends the given `WWCommandSet` to the physical robot to be executed. 
 * 
 *  The given command may not be sent immediately, but will be sent between now and 50ms in the future.  If sendRobotCommandSet: is called multiple times immediately, the
 *  `WWRobot` might aggregate the commands together and send it as a single command set. If
 *  there are collisions during command aggregation, the latest command will
 *  override earlier commands.
 *
 *  @param command The desired command set to send to the robot.
 */
- (void) sendRobotCommandSet:(WWCommandSet *)command;


/**---------------------------------------------------------------------------------------
 *  @name Modifying robot
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  Power cycles the physical robot, and clear any queued commands.
 */
- (void) reboot;

/**
 *  Resets the robot to its initial state.
 *
 *  Initial state means:
 *  - Lights will reflect its personality color.
 *  - All movements are stopped.
 *  - Head faces center and is levelled.
 *  - The eye blinks.
 */
- (void) resetState;

@end




/**
 *  The `WWRobotDelegate` protocol defines the methods that a delegate of a `WWRobot`
 *  object must adopt.  The optional methods of the protocol allows the delegate to respond
 *  to the current state of the physical robot.
 */
@protocol WWRobotDelegate <NSObject>

@optional
/**
 *  Invoked when 1+ `WWEvent` was triggered for the last `WWSensor` received.
 *
 *  @param robot  The robot that the event(s) triggered on.
 *  @param events The set of events that were triggered.
 */
- (void) robot:(WWRobot *)robot eventsTriggered:(NSArray *)events;

/**
 *  Invoked when new `WWSensorSet` data is received.
 *
 *  @param robot The robot from which the sensor data came.
 *  @param state The set of sensor data that was received from the robot.
 */
- (void) robot:(WWRobot *)robot didReceiveRobotState:(WWSensorSet *)state;

@end
