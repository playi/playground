//
//  PIRobotStateTests.m
//  PIRobotKit
//
//  Created by Kevin Liang on 1/27/14.
//  Copyright (c) 2014 Play-i. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "PIRobotState.h"
#import "PIComponent.h"

// allow access to private member properties
@interface PIRobotState ()

@property (nonatomic, strong) NSMutableDictionary *stateValues;

- (NSNumber *)_keyFromIndex:(PIBotComponentIndex)index;

@end

@interface PIRobotStateTests : XCTestCase

@end

@implementation PIRobotStateTests {
    id _componentMock;
    PIRobotState *_state;
    PIBotComponentIndex _componentIndex;
}

- (void)setUp
{
    [super setUp];
    _componentMock = [OCMockObject mockForClass:[PIComponent class]];
    _state = [[PIRobotState alloc] init];
    _componentIndex = PIBOT_LEFT_MOTOR;
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void) testSetComponentForNewIndex
{
    [_state setComponent:_componentMock forIndex:_componentIndex];
    
    XCTAssertTrue([_state.stateValues count] == 1, @"component not inserted correctly");
    XCTAssertEqualObjects([_state.stateValues objectForKey:[_state _keyFromIndex:_componentIndex]], _componentMock, @"component not inserted at the specified index!");
}

- (void) testSetComponentForExistingIndex
{
    [_state setComponent:_componentMock forIndex:_componentIndex];
    id _newComponentMock = [OCMockObject mockForClass:[PIComponent class]];
    
    [_state setComponent:_newComponentMock forIndex:_componentIndex];
    
    XCTAssertTrue([_state.stateValues count] == 1, @"component was added on accident");
    XCTAssertEqualObjects([_state.stateValues objectForKey:[_state _keyFromIndex:_componentIndex]], _newComponentMock, @"component not inserted at the specified index!");
    
}

- (void) testSetComponentForNullIndex
{
    [_state setComponent:nil forIndex:_componentIndex];
    
    XCTAssertTrue([_state.stateValues count] == 0, @"should be a no-op");
}

- (void) testRemoveComponentForIndex
{
    [_state setComponent:_componentMock forIndex:_componentIndex];
    
    [_state removeComponentForIndex:_componentIndex];
    
    XCTAssertTrue([_state.stateValues count] == 0, @"component not deleted");
    XCTAssertNil([_state.stateValues objectForKey:[_state _keyFromIndex:_componentIndex]], @"component not deleted");
}

- (void) testRemoveComponentForNonExistingIndex
{
    [_state removeComponentForIndex:_componentIndex];
    
    XCTAssertTrue([_state.stateValues count] == 0, @"component not deleted");
    XCTAssertNil([_state.stateValues objectForKey:[_state _keyFromIndex:_componentIndex]], @"component not deleted");
}

- (void) testRemoveComponentForNotMatchingIndex
{
    PIBotComponentIndex unmatchedIndex = PIBOT_EAR_RIGHT_LIGHT;
    [_state setComponent:_componentMock forIndex:_componentIndex];
    [_state removeComponentForIndex:unmatchedIndex];
    
    XCTAssertTrue([_state.stateValues count] == 1, @"component not deleted");
    XCTAssertEqualObjects([_state.stateValues objectForKey:[_state _keyFromIndex:_componentIndex]], _componentMock, @"component not inserted at the specified index!");
}

- (void) testComponentFromIndex
{
    [_state setComponent:_componentMock forIndex:_componentIndex];
    
    PIComponent *componentFetched = [_state componentFromIndex:_componentIndex];
    
    XCTAssertEqualObjects(componentFetched, _componentMock, @"retrieved wrong component!");
}

- (void) testComponentFromWrongIndex
{
    PIBotComponentIndex unmatchedIndex = PIBOT_EAR_RIGHT_LIGHT;
    [_state setComponent:_componentMock forIndex:_componentIndex]; // seed an existing component
    
    PIComponent *componentFetched = [_state componentFromIndex:unmatchedIndex];
    
    XCTAssertNil(componentFetched, @"fetched an actual component!!");
}

- (void) testIndexFromKey
{
    PIBotComponentIndex index = PIBOT_EAR_RIGHT_LIGHT;
    NSNumber *key = [_state _keyFromIndex:index];
    PIBotComponentIndex fetchedIndex = [_state indexFromKey:key];
    XCTAssertTrue(fetchedIndex == index, @"return a valid index for null!");
}

- (void) testIndexFromUnknownKey
{
    NSNumber *unknownKey = [NSNumber numberWithInt:-1];
    PIBotComponentIndex index = [_state indexFromKey:unknownKey];
    XCTAssertTrue(index == PIBOT_UNKNOWN_INDEX, @"return a valid index for null!");
}

- (void) testIndexFromNullKey
{
    PIBotComponentIndex index = [_state indexFromKey:NULL];
    XCTAssertTrue(index == PIBOT_UNKNOWN_INDEX, @"return a valid index for null!");
}

- (void) testEmpty
{
    XCTAssertTrue([_state empty], @"initial state should be empty!");
}

- (void) testNotEmpty
{
    [_state setComponent:_componentMock forIndex:_componentIndex];
    
    XCTAssertFalse([_state empty], @"has at least 1 component");
}

- (void) testComponentsCopy
{
    [_state setComponent:_componentMock forIndex:_componentIndex];
    
    NSDictionary *componentsCopy = [_state components];
    
    XCTAssertTrue([componentsCopy count] == [_state.stateValues count], @"same number of entries");
    XCTAssertNotEqual(componentsCopy, _state.stateValues, @"pointers are pointing to different dictionaries in memory");
    for (NSNumber *key in componentsCopy)
    {
        PIComponent *componentCopy = [componentsCopy objectForKey:key];
        PIComponent *component = [_state.stateValues objectForKey:key];
        XCTAssertNotNil(componentCopy, @"values are not copied across!");
        XCTAssertEqualObjects(componentCopy, component, @"component pointers should be copied over!");
    }
}

- (void) testSameValueIfBothEmpty
{
    // todo: fill this in
}

- (void) testSameValueIfAllComponentsAreSame
{
    // todo: fill this in
}

- (void) testDifferentValuesForSameComponents
{
    // todo: fill this in
}

- (void) testDifferentValuesForUnmatchedComponentsAtoB
{
    // todo: fill this in
}

- (void) testDifferentValuesForUnmatchedComponentsBtoA
{
    // todo: fill this in
}

- (void) testDifferentFromPICommand
{
    // todo: fill this in
}

- (void) testStartDate
{
    // todo: fill this in
}

- (void) testStartDateNone
{
    // todo: fill this in    
}

- (void) testInit
{
    PIRobotState *testState = [PIRobotState new];
    
    XCTAssertTrue([testState isKindOfClass:[PIRobotState class]], @"wrong instance instantiated");
    XCTAssertTrue(testState.type == ACTUAL_STATE, @"default state is not correct");
    XCTAssertNotNil(testState.stateValues, @"state values container should be initialized");
    XCTAssertTrue([testState.stateValues count] == 0, @"state values should be empty");
    XCTAssertTrue(testState.timestamp == 0, @"timestamp should be zero");
}

@end
