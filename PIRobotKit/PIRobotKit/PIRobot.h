//
//  PIRobot.h
//  PIRobotKit
//
//  Created by Kevin Liang on 12/18/13.
//  Copyright (c) 2013 Play-i. All rights reserved.
//

#import <CoreBluetooth/CBPeripheral.h>
#import "PIObject.h"
#import "PIComponentValues.h"
#import "PICommandSequence.h"
#import "PIEvent.h"

// c-lib
#import "PIBotInterface.h"

typedef enum
{
    TYPE_BO = 1,
    TYPE_YANA
} PIRobotType;

typedef enum
{
    DISCOVERED = 1,
    CONNECTED,
    IDLE
} PIRobotConnectionType;



@class PICommand, PIEvent, PIError, PIRobotState, PIRobotManager;
@protocol PIRobotDelegate;

/**
 `PIRobot` class handles the actual command/events communication to/from the physical robot, respectively.  While most of the logic is in this class, `PIRobot` relies on the derived classes to handle robot type specific logic. 
 */
@interface PIRobot : PIObject <PIEventDataSource>

/** 
 Unique ID for this given robot.
 */
@property (nonatomic, strong) NSString *uuId;

/**
 Assigned named for this robot, which can be default or custom set by users.
 */

@property (nonatomic, strong) NSString *name;
/**
 Specifies the connection state for this robot.  The connection state is managed by PIRobotManager.
 */
@property (nonatomic) PIRobotConnectionType connectionState;

/**
 Specified buffer limit that this PIRobot will record.  
 */
@property (nonatomic) NSUInteger stateHistoryBufferLimit;

/**
 The corresponding Bluetooth peripheral for this robot.  This is used internally.
 */
@property (nonatomic, strong) CBPeripheral *peripheral;

/**
 PIRobotDelegate, which handles various callbacks.
 */
@property (nonatomic, weak) id<PIRobotDelegate> delegate;

/**
 Instatiates this PIRobot with manager and peripheral. This is also for internal use and API user should not need call this explicitly.
 
 @param manager PIRobotManager singleton class
 @param peripheral The corresponding peripheral object
 @return an instance of PIRobot.
 */
- (id) initWithManager:(PIRobotManager *)manager peripheral:(CBPeripheral *)peripheral;

/**
 Used internally, this method returns true if the given peripheral is the same as this PIRobot's peripheral, false otherwise.
 */
- (BOOL) hasPeripheral:(CBPeripheral *)peripheral;

/**
 The default service UUID that Play-i uses.
 */
+ (CBUUID *) serviceUUID;

# pragma mark - command sequence management
/**
 Start executing on the given command sequence with the given options.  If the sequence is already being executed, this will be a no-op.  Once the sequence has finished, delegate callback will be called.
 
 @see -robot:didStopExecutingCommandSequence:withResults
 @param sequence The PICommandSequence to be executed
 @param options The options to go along with executing the sequence
 */
- (void) executeCommandSequence:(PICommandSequence *)sequence withOptions:(NSDictionary *)options;

/**
 Stop executing the given command sequence.  The result of the sequence will be returned as a delegate callback.  If the given sequence isn't being executed currently, this will be a no-op.
 
 @see -robot:didStopExecutingCommandSequence:withResults
 @param sequence The PICommandSequence to be stopped
 */
- (void) stopCommandSequence:(PICommandSequence *)sequence;

/**
 Returns the executing result for the given executing sequence.  If the given sequence is not being executed currently, an empty NSDictionary is returned.
 
 @param sequence The PICommandSequence that is currently being executed
 @return Current processing results for the given sequence
 */
- (NSDictionary *) commandSequenceResults:(PICommandSequence *)sequence;

/**
 Returns all the PICommandSequences currently being executed, or empty array otherwise.
 */
- (NSArray *) allExecutingCommandSequences;

/**
 Sets the desired component values immediately.  No callback will be fired.  This method is mainly used to quickly put the robot in a desired state until state is changed again. 
 
 @param states The desired output states for the robot as specified by PIComponentValues
 */
- (void) sendRobotCommand:(PIComponentValues *)command;

#pragma mark - override by child class
/**
 Overriden by child class to see if the given component is valid for the specific robot type.  This is an internal method.
 */
- (BOOL) validCommandComponentIndex:(PIBotComponentIndex)index;

/**
 description specific to robot type.  This will be overriden by child class and is an internal method.
 */
- (PIBotDescription_t *) serializedDescription;

@end

/**
 `PIRobotDelegate` handles all the command/event execution callbacks as needed.  
 */
@protocol PIRobotDelegate <NSObject>

@optional
/** 
 Triggered when a PICommandSequence has been completed, or stopped by the caller.  At this time, all the events associated with this sequence will be removed automatically from the event listening queue as well.   Any errors will be returned by PIError.
 
 @see -stopCommanSequence
 @see -executeCommandSequence:withOptions
 @param robot This robot
 @param sequence The PICommandSequence that has finished or stopped by the caller
 @param results The final execution result for the PICommandSequence 
 */
- (void) robot:(PIRobot *)robot didStopExecutingCommandSequence:(PICommandSequence *)sequence withResults:(NSDictionary *)results;

/**
 Triggered when ANY of the registered events are satisified (as defined by PIEvent's shouldAlert block) when robot has received a new PIRobotState.  In the case that multiple events are satisfied at the same time, all events will be returned and it is up to the delegate to decide what to do.
 
 @see -PIEvent
 @param robot This robot
 @param events All the events that have been triggered
 */
- (void) robot:(PIRobot *)robot eventsTriggered:(NSArray *)events;

/**
 Triggered when ANY of the system level events are triggered (e.g. battery dead, connection lost, firmware crash)
 
 @param robot This robot
 @param events All the system events that have been triggered
 */
- (void) robot:(PIRobot *)robot systemEventsTriggered:(NSArray *)events;

@end
