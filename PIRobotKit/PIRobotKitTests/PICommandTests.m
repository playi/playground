//
//  PICommandTests.m
//  PIRobotKit
//
//  Created by Kevin Liang on 1/27/14.
//  Copyright (c) 2014 Play-i. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "PICommand.h"
#import "PIComponent.h"

@interface PICommand ()

@property (nonatomic, strong) NSMutableDictionary *stateValues;

- (NSString *)_keyFromIndex:(PIBotComponentIndex)index;

@end

@interface PICommandTests : XCTestCase

@end

@implementation PICommandTests{
    id _componentMock;
    PICommand *_command;
    PIBotComponentIndex _componentIndex;
}

- (void)setUp
{
    [super setUp];
    _componentMock = [OCMockObject mockForClass:[PIComponent class]];
    _command = [[PICommand alloc] init];
    _componentIndex = PIBOT_LEFT_MOTOR;
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void) testDifferentFromPIRobotState
{
    // todo: fill this in
}

- (void) testExpired
{
    // todo: fill this in
}

- (void) testExpiredWhenNotExpired
{
    // todo: fill this in
}

- (void) testExpiredWithNoExpirationTime
{
    // todo: fill this in
}

- (void) testSetDuration
{
    float desiredDuration = 2.3;
    PICommand *cmd = [PICommand new];
    cmd.duration = desiredDuration;
    XCTAssertTrue(cmd.duration == desiredDuration, @"cannot set duration correctly");
}

- (void) testSetDurationToNegativeIsNoOp
{
    float desiredDuration = -2.3;
    PICommand *cmd = [PICommand new];
    cmd.duration = desiredDuration;
    XCTAssertTrue(cmd.duration == 0, @"can set duration to negative value");
}

- (void) testInitWithDuration
{
    float desiredDuration = 2.3;
    PICommand *cmd = [[PICommand alloc] initWithDuration:desiredDuration];
    
    XCTAssertTrue(cmd.duration == desiredDuration, @"cannot set duration correctly");
    XCTAssertTrue(cmd.type == DESIRED_STATE, @"wrong type instantiated by init method");
    XCTAssertNotNil(cmd.stateValues, @"state values container should be initialized");
    XCTAssertTrue([cmd.stateValues count] == 0, @"state values should be empty");
    XCTAssertTrue(cmd.timestamp == 0, @"timestamp should not be initialized");
}

@end
