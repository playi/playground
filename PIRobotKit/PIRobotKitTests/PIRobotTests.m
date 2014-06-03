//
//  PIRobotTests.m
//  PIRobotKit
//
//  Created by Kevin Liang on 1/24/14.
//  Copyright (c) 2014 Play-i. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "PIRobot.h"
#import "PIRobotManager.h"
#import "PIEvent.h"
#import "PICommand.h"

// re-declare private methods here for testing purposes
@interface PIRobot ()

@property (nonatomic, strong) NSMutableArray *pastStates;
@property (nonatomic, strong) NSMutableArray *pastCommands;
@property (nonatomic, strong) NSMutableArray *events;
@property (nonatomic, strong) NSMutableArray *outstandingCommands;
@property (nonatomic, strong) NSMutableDictionary *characteristics;
@property (nonatomic, strong) dispatch_queue_t processQueue;

+ (CBUUID *) _txCharacteristicUUID;
+ (CBUUID *) _rxCharacteristicUUID;

- (BOOL) _hasEvent:(PIEvent *)event;
- (PIRobotState *) _currentState;
- (NSUInteger) _bufferLimit;
- (void) _commandCompletesIn:(float)seconds;
- (void) _commandCompletionCallback;

- (NSArray *) _serialize:(PICommand *)command;
- (PIRobotState *) _deserialize:(NSData *)rawData;
- (void) _didReceiveRobotData:(NSData *)rawData;
- (PIComponent *) _componentFromData:(PIBotComponent_t *)data;

@end

@interface PIRobotTests : XCTestCase

@end

@implementation PIRobotTests{
    PIRobot *_robot;
    id _robotMock;
    id _peripheralMock;
    id _managerMock;
    id _managerDelegate;
    id _robotDelegate;
}

- (void)setUp
{
    [super setUp];
    
    _managerDelegate = [OCMockObject mockForProtocol:@protocol(PIRobotManagerDelegate)];
    _robotDelegate = [OCMockObject mockForProtocol:@protocol(PIRobotDelegate)];
    _peripheralMock = [OCMockObject mockForClass:[CBPeripheral class]];
    _managerMock = [OCMockObject mockForClass:[PIRobotManager class]];
    [[[_managerMock stub] andReturn:_managerDelegate] delegate];
    
    [[_peripheralMock expect] setDelegate:[OCMArg any]];
    _robot = [[PIRobot alloc] initWithManager:_managerMock peripheral:_peripheralMock];
    _robot.delegate = _robotDelegate;
    _robotMock = [OCMockObject partialMockForObject:_robot];
    
    [_peripheralMock verify];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

#pragma mark - Event/Command interactions
- (void) testAddEventNew
{
    id event = [OCMockObject mockForClass:[PIEvent class]];
    id events = [OCMockObject mockForClass:[NSMutableArray class]];
    _robot.events = events;
    [[[events stub] andReturnValue:OCMOCK_VALUE(NSNotFound)] indexOfObject:[OCMArg any]];
    
    [[events expect] addObject:event];
    
    [_robot addEvent:event];
    
    [events verify];
}
- (void) testAddEventDuplicate
{
    id event = [OCMockObject mockForClass:[PIEvent class]];
    id events = [OCMockObject mockForClass:[NSMutableArray class]];
    _robot.events = events;
    [[[events stub] andReturnValue:OCMOCK_VALUE((NSUInteger)0)] indexOfObject:[OCMArg any]];
    
    [_robot addEvent:event];
    
    [events verify];
}
- (void) testAddEventNull
{
    id events = [OCMockObject mockForClass:[NSMutableArray class]];
    _robot.events = events;
    
    [_robot addEvent:nil];
    [events verify];
}

- (void) testRemoveEvent
{
    id event = [OCMockObject mockForClass:[PIEvent class]];
    id events = [OCMockObject mockForClass:[NSMutableArray class]];
    _robot.events = events;
    [[[events stub] andReturnValue:OCMOCK_VALUE((NSUInteger)0)] indexOfObject:[OCMArg any]];
    
    [[events expect] removeObject:event];
    
    [_robot removeEvent:event];
    
    [events verify];
}
- (void) testRemoveEventNotRegistered
{
    id event = [OCMockObject mockForClass:[PIEvent class]];
    id events = [OCMockObject mockForClass:[NSMutableArray class]];
    _robot.events = events;
    [[[events stub] andReturnValue:OCMOCK_VALUE(NSNotFound)] indexOfObject:[OCMArg any]];
    
    [_robot removeEvent:event];
    
    [events verify];
    
}
- (void) testRemoveEventNull
{
    id events = [OCMockObject mockForClass:[NSMutableArray class]];
    _robot.events = events;
    [_robot removeEvent:nil];
    [events verify];
}
- (void) testAllEvents
{
    id event = [OCMockObject mockForClass:[PIEvent class]];
    NSMutableArray *interalEvents = [NSMutableArray arrayWithObject:event];
    _robot.events = interalEvents;
    
    NSArray *copiedEvents = [_robot allEvents];
    
    XCTAssertTrue([copiedEvents count] == [interalEvents count], @"objects are not copied over correctly");
    XCTAssertTrue([[copiedEvents objectAtIndex:0] isEqual:event], @"should point to the same objects within the array");
    
}

#pragma mark - receiving data from robot and check for events
- (void) testDidReceiveReceiveRobotDataWithFullHistoryBuffer
{
    id dataMock = [OCMockObject mockForClass:[NSData class]];
    id stateMock = [OCMockObject mockForClass:[PIRobotState class]];
    NSUInteger maxBufferLimit = 2;
    [self seedRobotActualEvents:maxBufferLimit];
    [[[_robotMock stub] andReturnValue:OCMOCK_VALUE(maxBufferLimit)] _bufferLimit];
    [[[_robotMock stub] andReturn:stateMock] _deserialize:[OCMArg any]];
    
    [_robotMock _didReceiveRobotData:dataMock];
    
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    XCTAssertTrue([_robot.pastStates count] == maxBufferLimit, @"actual states does not go above limit");
    XCTAssertEqualObjects([_robot.pastStates lastObject], stateMock, @"last object is not the latest!");
    [_robotDelegate verify]; // check that delegate is not invoked
    [_robotMock verify];
}

- (void) testDidReceiveRobotDataWithNoRegisteredEvents
{
    id dataMock = [OCMockObject mockForClass:[NSData class]];
    id stateMock = [OCMockObject mockForClass:[PIRobotState class]];
    [[[_robotMock stub] andReturn:stateMock] _deserialize:[OCMArg any]];
    
    [_robotMock _didReceiveRobotData:dataMock];
    
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    XCTAssertEqualObjects([_robot.pastStates lastObject], stateMock, @"last object is not the latest!");
    [_robotDelegate verify]; // check that delegate is not invoked
    [_robotMock verify];
}

- (void) testDidReceiveRobotDataWithRegisteredEvents
{
    id dataMock = [OCMockObject mockForClass:[NSData class]];
    PIEvent *event = [[PIEvent alloc] initWithShouldAlertBlock:^BOOL(NSArray *robotStateHistory, NSArray *outstandingCommands) {
        return NO;
    }];
    [_robot.events addObject:event];
    id stateMock = [OCMockObject mockForClass:[PIRobotState class]];
    [[[_robotMock stub] andReturn:stateMock] _deserialize:[OCMArg any]];
    
    [_robotMock _didReceiveRobotData:dataMock];
    
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    XCTAssertEqualObjects([_robot.pastStates lastObject], stateMock, @"last object is not the latest!");
    [_robotDelegate verify]; // check that delegate is not invoked
    [_robotMock verify];
}
- (void) testDidReceiveRobotDataAndRaisingSingleEvent
{
    id dataMock = [OCMockObject mockForClass:[NSData class]];
    PIEvent *event1 = [[PIEvent alloc] initWithShouldAlertBlock:^BOOL(NSArray *robotStateHistory, NSArray *outstandingCommands) {
        return YES;
    }];
    PIEvent *event2 = [[PIEvent alloc] initWithShouldAlertBlock:^BOOL(NSArray *robotStateHistory, NSArray *outstandingCommands) {
        return NO;
    }];
    [_robot.events addObject:event1];
    [_robot.events addObject:event2];
    [[_robotDelegate expect] robot:_robot eventsTriggered:[OCMArg checkWithBlock:^BOOL(id obj) {
        NSArray *eventsTriggered = (NSArray *)obj;
        XCTAssertTrue([eventsTriggered count] == 1, @"wrong number of events triggered");
        XCTAssertTrue([eventsTriggered indexOfObject:event1] != NSNotFound, @"wrong event is being returned");
        return YES;
    }]];
    id stateMock = [OCMockObject mockForClass:[PIRobotState class]];
    [[[_robotMock stub] andReturn:stateMock] _deserialize:[OCMArg any]];
    
    [_robotMock _didReceiveRobotData:dataMock];
    
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    XCTAssertEqualObjects([_robot.pastStates lastObject], stateMock, @"last object is not the latest!");
    [_robotDelegate verify];
    [_robotMock verify];
}

- (void) testDidReceiveRobotDataAndRaisingMultipleEvents
{
    id dataMock = [OCMockObject mockForClass:[NSData class]];
    PIEvent *event1 = [[PIEvent alloc] initWithShouldAlertBlock:^BOOL(NSArray *robotStateHistory, NSArray *outstandingCommands) {
        return YES;
    }];
    PIEvent *event2 = [[PIEvent alloc] initWithShouldAlertBlock:^BOOL(NSArray *robotStateHistory, NSArray *outstandingCommands) {
        return NO;
    }];
    PIEvent *event3 = [[PIEvent alloc] initWithShouldAlertBlock:^BOOL(NSArray *robotStateHistory, NSArray *outstandingCommands) {
        return YES;
    }];
    [_robot.events addObject:event1];
    [_robot.events addObject:event2];
    [_robot.events addObject:event3];
    [[_robotDelegate expect] robot:_robot eventsTriggered:[OCMArg checkWithBlock:^BOOL(id obj) {
        NSArray *eventsTriggered = (NSArray *)obj;
        XCTAssertTrue([eventsTriggered count] == 2, @"wrong number of events triggered");
        XCTAssertTrue([eventsTriggered indexOfObject:event1] != NSNotFound, @"wrong event is being returned");
        XCTAssertTrue([eventsTriggered indexOfObject:event3] != NSNotFound, @"wrong event is being returned");
        return YES;
    }]];
    id stateMock = [OCMockObject mockForClass:[PIRobotState class]];
    [[[_robotMock stub] andReturn:stateMock] _deserialize:[OCMArg any]];
    
    [_robotMock _didReceiveRobotData:dataMock];
    
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    XCTAssertEqualObjects([_robot.pastStates lastObject], stateMock, @"last object is not the latest!");
    [_robotDelegate verify];
    [_robotMock verify];
}

- (void) testDidReceiveRobotDataWithEmptyEvent
{
    id dataMock = [OCMockObject mockForClass:[NSData class]];
    [[[_robotMock stub] andReturnValue:OCMOCK_VALUE(1)] _bufferLimit];
    [[[_robotMock stub] andReturn:NULL] _deserialize:[OCMArg any]];
    
    [_robotMock _didReceiveRobotData:dataMock];
    
    [_robotDelegate verify]; // check that delegate is not invoked
    [_robotMock verify];
}

#pragma mark - sending command to robot
- (void) testSendCommandNoDuration
{
    id dataMock = [OCMockObject mockForClass:[NSData class]];
    id commandMock = [OCMockObject niceMockForClass:[PICommand class]];
    [[[commandMock stub] andReturnValue:OCMOCK_VALUE(NO)] empty];
    [(PICommand *)[[commandMock stub] andReturnValue:OCMOCK_VALUE((float) 0)] duration];
    id currentStateMock = [OCMockObject mockForClass:[PIRobotState class]];
    [[[currentStateMock stub] andReturnValue:OCMOCK_VALUE(NO)] hasSameValues:[OCMArg any]];
    [[[_robotMock stub] andReturn:currentStateMock] _currentState];
    [[[_robotMock stub] andReturn:[NSArray arrayWithObject:dataMock]] _serialize:commandMock];
    
    [[[commandMock expect] ignoringNonObjectArgs] setTimestamp:0]; // timestamp param is ignored
    [[_robotDelegate expect] robot:_robot willSendCommand:commandMock];
    [[_peripheralMock expect] writeValue:[OCMArg any] forCharacteristic:[OCMArg any] type:CBCharacteristicWriteWithoutResponse];
    
    [_robotMock sendCommand:commandMock];
    
    XCTAssertTrue([_robot.outstandingCommands count] == 1, @"command not inserted in the outstanding command queue");
    XCTAssertEqualObjects([_robot.outstandingCommands firstObject], commandMock, @"objected inserted is not command!");
    [commandMock verify];
    [_peripheralMock verify];
    [_robotDelegate verify];
    [_robotMock verify];
}

- (void) testSendCommandDuration10ms
{
    float commandDuration = .01;
    id dataMock = [OCMockObject mockForClass:[NSData class]];
    id commandMock = [OCMockObject niceMockForClass:[PICommand class]];
    [[[commandMock stub] andReturnValue:OCMOCK_VALUE(NO)] empty];
    [(PICommand *)[[commandMock stub] andReturnValue:OCMOCK_VALUE((float) commandDuration)] duration];
    id currentStateMock = [OCMockObject mockForClass:[PIRobotState class]];
    [[[currentStateMock stub] andReturnValue:OCMOCK_VALUE(NO)] hasSameValues:[OCMArg any]];
    [[[_robotMock stub] andReturn:currentStateMock] _currentState];
    [[[_robotMock stub] andReturn:[NSArray arrayWithObject:dataMock]] _serialize:commandMock];
    
    [[[commandMock expect] ignoringNonObjectArgs] setTimestamp:0]; // timestamp param is ignored
    [[[_robotMock expect] ignoringNonObjectArgs] _commandCompletesIn:0]; // param is ignored
    [[_robotDelegate expect] robot:_robot willSendCommand:commandMock];
    [[_peripheralMock expect] writeValue:[OCMArg any] forCharacteristic:[OCMArg any] type:CBCharacteristicWriteWithoutResponse];
    
    [_robotMock sendCommand:commandMock];
    
    XCTAssertTrue([_robot.outstandingCommands count] == 1, @"command not inserted in the outstanding command queue");
    XCTAssertEqualObjects([_robot.outstandingCommands firstObject], commandMock, @"objected inserted is not command!");
    [commandMock verify];
    [_peripheralMock verify];
    [_robotDelegate verify];
    [_robotMock verify];
}

- (void) testSendCommandWithMultiplePackets
{
    id dataMock1 = [OCMockObject mockForClass:[NSData class]];
    id dataMock2 = [OCMockObject mockForClass:[NSData class]];
    id commandMock = [OCMockObject niceMockForClass:[PICommand class]];
    [[[commandMock stub] andReturnValue:OCMOCK_VALUE(NO)] empty];
    id currentStateMock = [OCMockObject mockForClass:[PIRobotState class]];
    [[[currentStateMock stub] andReturnValue:OCMOCK_VALUE(NO)] hasSameValues:[OCMArg any]];
    [[[_robotMock stub] andReturn:currentStateMock] _currentState];
    [[[_robotMock stub] andReturn:[NSArray arrayWithObjects:dataMock1, dataMock2, nil]] _serialize:commandMock];
    
    [[_robotDelegate expect] robot:_robot willSendCommand:commandMock];
    [[_peripheralMock expect] writeValue:dataMock1 forCharacteristic:[OCMArg any] type:CBCharacteristicWriteWithoutResponse];
    [[_peripheralMock expect] writeValue:dataMock2 forCharacteristic:[OCMArg any] type:CBCharacteristicWriteWithoutResponse];
    
    [_robotMock sendCommand:commandMock];
    
    XCTAssertTrue([_robot.outstandingCommands count] == 1, @"command not inserted in the outstanding command queue");
    XCTAssertEqualObjects([_robot.outstandingCommands firstObject], commandMock, @"objected inserted is not command!");
    [_peripheralMock verify];
    [_robotDelegate verify];
    [_robotMock verify];
}

- (void) testSendCommandIfSameAsActualState
{
    id commandMock = [OCMockObject mockForClass:[PICommand class]];
    [[[commandMock stub] andReturnValue:OCMOCK_VALUE(NO)] empty];
    id currentStateMock = [OCMockObject mockForClass:[PIRobotState class]];
    [[[currentStateMock stub] andReturnValue:OCMOCK_VALUE(YES)] hasSameValues:[OCMArg any]];
    [[[_robotMock stub] andReturn:currentStateMock] _currentState];
    
    [_robotMock sendCommand:commandMock];
    
    [_peripheralMock verify];
    [_robotMock verify];
}

- (void) testSendCommandIfEmpty
{
    id commandMock = [OCMockObject mockForClass:[PICommand class]];
    [[[commandMock stub] andReturnValue:OCMOCK_VALUE(YES)] empty];
    
    [_robot sendCommand:commandMock];
    
    [_peripheralMock verify];
}

- (void) testSendCommandSerializationFail
{
    id commandMock = [OCMockObject mockForClass:[PICommand class]];
    [[[commandMock stub] andReturnValue:OCMOCK_VALUE(NO)] empty];
    [[[_robotMock stub] andReturn:NULL] _serialize:[OCMArg any]];
    
    [_robotMock sendCommand:commandMock];
    
    [_peripheralMock verify];
}

- (void) testSendCommandIfNil
{
    [_robot sendCommand:nil];
    
    [_peripheralMock verify];
}

- (void) testSerializedDescription
{
    // todo: add test for this
}

#pragma mark - test for command completion callback
- (void) testCommandCompletionCallback
{
    id commandMock1 = [OCMockObject mockForClass:[PICommand class]];
    [[[commandMock1 stub] andReturnValue:OCMOCK_VALUE(YES)] expired];
    id commandMock2 = [OCMockObject mockForClass:[PICommand class]];
    [[[commandMock2 stub] andReturnValue:OCMOCK_VALUE(NO)] expired];
    [_robot.outstandingCommands addObject:commandMock1];
    [_robot.outstandingCommands addObject:commandMock2];
    
    [[_robotDelegate expect] robot:_robot didFinishCommands:[OCMArg checkWithBlock:^BOOL(id obj) {
        NSArray *completedCommands = (NSArray *)obj;
        XCTAssertTrue([completedCommands count] == 1, @"completed command not accurate");
        XCTAssertEqualObjects([completedCommands firstObject], commandMock1, @"command not returned to delegate");
        return YES;
    }] error:[OCMArg any]];
    
    [_robot _commandCompletionCallback];
    
    XCTAssertTrue([_robot.outstandingCommands count] == 1, @"completed command not removed from the outstanding queue");
    XCTAssertTrue([_robot.pastCommands count] == 1, @"completed command not archived correctly");
    XCTAssertEqualObjects([_robot.pastCommands firstObject], commandMock1, @"command not inserted into past queue");
    [_robotDelegate verify];
    [commandMock1 verify];
    [commandMock2 verify];
}

- (void) testCommandCompletionCallbackMultipleCommandsFinished
{
    id commandMock1 = [OCMockObject mockForClass:[PICommand class]];
    [[[commandMock1 stub] andReturnValue:OCMOCK_VALUE(YES)] expired];
    id commandMock2 = [OCMockObject mockForClass:[PICommand class]];
    [[[commandMock2 stub] andReturnValue:OCMOCK_VALUE(YES)] expired];
    [_robot.outstandingCommands addObject:commandMock1];
    [_robot.outstandingCommands addObject:commandMock2];
    
    [[_robotDelegate expect] robot:_robot didFinishCommands:[OCMArg checkWithBlock:^BOOL(id obj) {
        NSArray *completedCommands = (NSArray *)obj;
        XCTAssertTrue([completedCommands count] == 2, @"completed command not accurate");
        XCTAssertTrue([completedCommands containsObject:commandMock1], @"command1 not returned to delegate");
        XCTAssertTrue([completedCommands containsObject:commandMock2], @"command2 not returned to delegate");
        return YES;
    }] error:[OCMArg any]];
    
    [_robot _commandCompletionCallback];
    
    XCTAssertTrue([_robot.outstandingCommands count] == 0, @"completed command not removed from the outstanding queue");
    XCTAssertTrue([_robot.pastCommands count] == 2, @"completed command not archived correctly");
    XCTAssertTrue([_robot.pastCommands containsObject:commandMock1], @"command1 not inserted into past queue");
    XCTAssertTrue([_robot.pastCommands containsObject:commandMock2], @"command2 not inserted into past queue");
    [_robotDelegate verify];
    [commandMock1 verify];
    [commandMock2 verify];
}

- (void) testCommandCompletionCallbackNoCompletedCommands
{
    [_robot _commandCompletionCallback];
    
    [_robotDelegate verify];
}

# pragma mark - test for serialize/de-serialize methods
- (void) testSerialize
{
    // todo: add test for this
}

- (void) testSerializeAllocBad
{
    //id cmdAllocMock = [OCMockObject mockForClass:PIBot_cmds_alloc];
}

- (void) testDeserializeSensorData
{
    // todo: add test for this
}

- (void) testDeserializeUARTData
{
    // todo: add test for this
}

#pragma mark - CBPeripheralDelegate
- (void) testDidDiscoverServices
{
    id serviceMock = [OCMockObject mockForClass:[CBService class]];
    [(CBService *)[[serviceMock stub] andReturn:[PIRobot serviceUUID]] UUID];
    [[[_peripheralMock stub] andReturn:@[serviceMock]] services];
    
    [[_peripheralMock expect] discoverCharacteristics:[OCMArg any] forService:serviceMock];
    [[_managerDelegate expect] manager:_managerMock didConnectWithRobot:_robot];
    
    [_robot peripheral:_peripheralMock didDiscoverServices:nil];
    
    [_peripheralMock verify];
    [_managerDelegate verify];
}

- (void) testDidDiscoverCharacteristicsForService
{
    id serviceMock = [OCMockObject mockForClass:[CBService class]];
    id readCharacteristicMock = [OCMockObject mockForClass:[CBCharacteristic class]];
    [(CBCharacteristic *) [[readCharacteristicMock stub] andReturn:[PIRobot _rxCharacteristicUUID]] UUID];
    id writeCharacteristicMock = [OCMockObject mockForClass:[CBCharacteristic class]];
    [(CBCharacteristic *) [[writeCharacteristicMock stub] andReturn:[PIRobot _txCharacteristicUUID]] UUID];
    id unknownCharacteristicMock = [OCMockObject mockForClass:[CBCharacteristic class]];
    [(CBCharacteristic *) [[unknownCharacteristicMock stub] andReturn:[self unknownCBUUID]] UUID];
    [(CBService *) [[serviceMock stub] andReturn:@[readCharacteristicMock, writeCharacteristicMock, unknownCharacteristicMock]] characteristics];
    
    [[_peripheralMock expect] setNotifyValue:YES forCharacteristic:readCharacteristicMock];
    
    [_robot peripheral:_peripheralMock didDiscoverCharacteristicsForService:serviceMock error:nil];
    
    XCTAssertTrue([_robot.characteristics count] == 2, @"insert known characteristics only");
    XCTAssertEqualObjects([_robot.characteristics objectForKey:[PIRobot _rxCharacteristicUUID]], readCharacteristicMock, @"inserted read characteristic");
    XCTAssertEqualObjects([_robot.characteristics objectForKey:[PIRobot _txCharacteristicUUID]], writeCharacteristicMock, @"inserted read characteristic");
    [_peripheralMock verify];
}

- (void) testDidUpdateValueForCharacteristics
{
    id characteristicMock = [OCMockObject mockForClass:[CBCharacteristic class]];
    NSString* str = @"test payload";
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [(CBCharacteristic *) [[characteristicMock stub] andReturn:[PIRobot _rxCharacteristicUUID]] UUID];
    [(CBCharacteristic *) [[characteristicMock stub] andReturn:data] value];
    
    [[_robotMock expect] _didReceiveRobotData:data];
    
    [_robot peripheral:_peripheralMock didUpdateValueForCharacteristic:characteristicMock error:nil];
    
    [_robotMock verify];
}

#pragma mark - CBPeripheralDelegate error scenarios
- (void) testDidDiscoverUnknownService
{
    id unknownServiceMock = [OCMockObject mockForClass:[CBService class]];
    [(CBService *)[[unknownServiceMock stub] andReturn:[self unknownCBUUID]] UUID];
    [[[_peripheralMock stub] andReturn:@[unknownServiceMock]] services];
    
    [_robot peripheral:_peripheralMock didDiscoverServices:nil];
    
    [_peripheralMock verify];
    [_managerDelegate verify];
}

- (void) testDidDiscoverUnknownCharacteristicsForService
{
    id serviceMock = [OCMockObject mockForClass:[CBService class]];
    id unknownCharacteristicMock = [OCMockObject mockForClass:[CBCharacteristic class]];
    [(CBCharacteristic *) [[unknownCharacteristicMock stub] andReturn:[self unknownCBUUID]] UUID];
    [(CBService *) [[serviceMock stub] andReturn:@[unknownCharacteristicMock]] characteristics];
    
    [_robot peripheral:_peripheralMock didDiscoverCharacteristicsForService:serviceMock error:nil];
    
    [_peripheralMock verify];
}

#pragma mark - helper functions
- (CBUUID *) unknownCBUUID
{
    return [CBUUID UUIDWithString:@"6e400002-b5a3-f393-e0a9-e50e24e1ca9e"];
}
- (void) seedRobotActualEvents:(NSUInteger)numMockedEvents
{
    for (NSUInteger i = 0; i < numMockedEvents; i++)
    {
        [_robot.pastStates addObject:[OCMockObject mockForClass:[PIRobotState class]]];
    }
    XCTAssertTrue([_robot.pastStates count] == numMockedEvents, @"not seeding actual events correctly");
}

@end
