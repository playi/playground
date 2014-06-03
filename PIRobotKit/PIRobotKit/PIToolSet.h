//
//  PIToolSet.h
//  PIRobotKit
//
//  Created by Kevin Liang on 2/27/14.
//  Copyright (c) 2014 Play-i. All rights reserved.
//

@interface PIToolSet : NSObject

/**
 Helper functions to make it easier to verify key/values in NSDictionary.
 */
+ (BOOL) isKey:(id)key equalToExpectedKey:(NSString *)expectedKey;
+ (BOOL) isValue:(id)value equalToExpectedValueType:(Class)valueClass;

@end