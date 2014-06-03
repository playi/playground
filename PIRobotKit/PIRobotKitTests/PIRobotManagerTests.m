//
//  PIRobotKitTests.m
//  PIRobotKitTests
//
//  Created by Kevin Liang on 12/18/13.
//  Copyright (c) 2013 Play-i. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "PIRobotManager.h"
#import "PIRobot.h"

// re-declare private entities of the manager to be mocked
@interface PIRobotManager ()

@property (nonatomic, strong) NSMutableArray *robots;
@property (retain) CBCentralManager *bluetoothLEManager;

- (void) _scanForPIRobots:(NSTimer *)timer;
- (PIRobot *) _robotFromPeripheral:(CBPeripheral *)peripheral;

@end

// start of the unit tests
@interface PIRobotManagerTests : XCTestCase

@end

@implementation PIRobotManagerTests {
    PIRobotManager *_manager;
    id _bleManagerMock;
    id _managerDelegate;
    id _knownRobots;
}

- (void)setUp
{
    [super setUp];
    
    _managerDelegate = [OCMockObject mockForProtocol:@protocol(PIRobotManagerDelegate)];
    _manager = [[PIRobotManager alloc] init];
    // setup property mocks
    _bleManagerMock = [OCMockObject partialMockForObject:_manager.bluetoothLEManager];
    
    _manager.bluetoothLEManager = (CBCentralManager *)_bleManagerMock;
    _manager.delegate = _managerDelegate;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - CBCentralManagerDelegate
- (void)testDidDiscoverPeripheral
{
    id peripheralMock = [OCMockObject niceMockForClass:[CBPeripheral class]];

    [[_bleManagerMock expect] stopScan];  // pause scan
    [[_bleManagerMock expect] connectPeripheral:peripheralMock options: @{CBConnectPeripheralOptionNotifyOnDisconnectionKey: [NSNumber numberWithBool:YES]}]; // connect
    [[_managerDelegate expect] manager:_manager didDiscoverRobot:[OCMArg checkWithBlock:^BOOL(id value){
        if([value isKindOfClass:[PIRobot class]]) // set robot correctly
        {
            PIRobot *robot = (PIRobot *)value;
            return [robot hasPeripheral:peripheralMock] && (robot.connectionState == DISCOVERED);
        }
        return NO;
    }]];
    
    [_manager centralManager:_bleManagerMock didDiscoverPeripheral:peripheralMock advertisementData:nil RSSI:nil];
    
    [_bleManagerMock verify];
    [_managerDelegate verify];
}

- (void) testDidConnectPeripheral
{
    [[_bleManagerMock expect] stopScan];  // pause scan
    id peripheralMock = [OCMockObject niceMockForClass:[CBPeripheral class]];
    [[peripheralMock expect] discoverServices:[OCMArg any]]; // discover peripheral services
    
    [_manager centralManager:_bleManagerMock didConnectPeripheral:peripheralMock];
    
    [_bleManagerMock verify];
    [peripheralMock verify];
}

- (void) testDidDisconnectPeripheral
{
    id peripheralMock = [OCMockObject niceMockForClass:[CBPeripheral class]];
    [[_managerDelegate expect] manager:_manager didDisconnectWithRobot:[OCMArg checkWithBlock:^BOOL(id value){
        if([value isKindOfClass:[PIRobot class]]) // set robot correctly
        {
            PIRobot *robot = (PIRobot *)value;
            return [robot hasPeripheral:peripheralMock] && (robot.connectionState == IDLE);
        }
        return NO;
    }] error:[OCMArg any]]; //todo: check for errors?
    
    // todo: need to fill in the errors
    [_manager centralManager:_bleManagerMock didDisconnectPeripheral:peripheralMock error:nil];
    
    [_managerDelegate verify];
}

- (void) testDidFailToConnectPeripheral
{
    id peripheralMock = [OCMockObject niceMockForClass:[CBPeripheral class]];
    [[_managerDelegate expect] manager:_manager didFailToConnectWithRobot:[OCMArg checkWithBlock:^BOOL(id value){
        if([value isKindOfClass:[PIRobot class]]) // set robot correctly
        {
            PIRobot *robot = (PIRobot *)value;
            return [robot hasPeripheral:peripheralMock];
        }
        return NO;
    }] error:[OCMArg any]]; // todo: need to check for specific errors
    
    // todo: need to fill in the errors
    [_manager centralManager:_bleManagerMock didFailToConnectPeripheral:peripheralMock error:nil];
    
    [_managerDelegate verify];
}

- (void) testRobotFromPeripheralNew
{
    NSString *robotName = @"hello world!";
    id peripheralMock = [OCMockObject niceMockForClass:[CBPeripheral class]];
    [[[peripheralMock stub] andReturn:robotName] name];
    
    PIRobot *robot = [_manager _robotFromPeripheral:peripheralMock];
    
    XCTAssertNotNil(robot, @"new robot not created!");
    XCTAssertTrue([_manager.robots count] == 1, @"stored robot in known state!");
    XCTAssertTrue([_manager.robots containsObject:robot], @"new robot not stored in known state");
    XCTAssertEqualObjects(robot.name, robotName, @"robot name not set correctly!");
}

- (void) testRobotFromPeripheralAlreadyKnown
{
    id peripheralMock = [OCMockObject niceMockForClass:[CBPeripheral class]];
    id robotMock = [OCMockObject mockForClass:[PIRobot class]];
    [[[robotMock stub] andReturnValue:OCMOCK_VALUE((BOOL)YES)] hasPeripheral:peripheralMock];
    [_manager.robots addObject:robotMock];
    
    PIRobot *robot = [_manager _robotFromPeripheral:peripheralMock];
    
    XCTAssertNotNil(robot, @"new robot not retrieved!");
    XCTAssertTrue([_manager.robots count] == 1, @"new robot added");
    XCTAssertEqualObjects(robot, robotMock, @"robot name not set correctly!");
}

#pragma mark - Scan for robots
- (void)testOneTimeScanForPIRobots
{
    float timer = 0;
    [self setupBluetoothManager:CBCentralManagerStatePoweredOn];
    
    id timerMock = [OCMockObject niceMockForClass:[NSTimer class]];
    [[timerMock reject] scheduledTimerWithTimeInterval:timer target:_manager selector:[OCMArg anySelector] userInfo:nil repeats:YES]; // make sure timer is not called
    [[_bleManagerMock expect] scanForPeripheralsWithServices:[OCMArg any] options:[OCMArg any]]; // 1-time scan
    
    [_manager scanForPIRobots:timer];
    
    [_bleManagerMock verify];
    [timerMock verify];
}

- (void)testPeriodicScanForPIRobots
{
    float timer = 2.0;
    [self setupBluetoothManager:CBCentralManagerStatePoweredOn];
    
    id timerMock = [OCMockObject niceMockForClass:[NSTimer class]]; // mock the class
    [[timerMock expect] scheduledTimerWithTimeInterval:timer target:_manager selector:[OCMArg anySelector] userInfo:nil repeats:YES]; // timer is called
    
    [_manager scanForPIRobots:timer];
    
    [timerMock verify];
}

- (void)testScanForPIRobotsErrorInputs
{
    float timer = -1.1;
    [self setupBluetoothManager:CBCentralManagerStatePoweredOn];
    
    id timerMock = [OCMockObject niceMockForClass:[NSTimer class]]; // mock the class
    [[timerMock reject] scheduledTimerWithTimeInterval:timer target:_manager selector:[OCMArg anySelector] userInfo:nil repeats:YES]; // timer is not called
    [[_bleManagerMock expect] scanForPeripheralsWithServices:[OCMArg any] options:[OCMArg any]]; // 1-time scan still
    
    [_manager scanForPIRobots:timer];
    
    [_bleManagerMock verify];
    [timerMock verify];
    
}

#pragma mark - error scenarios
- (void) testBluetoothNotAvailable
{
    
}

- (void) testBluetoothIsTurnedOff
{
    
}

#pragma mark - helper functions
- (void) setupBluetoothManager:(CBCentralManagerState)value
{
    [(CBCentralManager *)[[_bleManagerMock stub] andReturnValue:OCMOCK_VALUE(value)] state];
}

@end
