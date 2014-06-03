//
//  PIUtility.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 3/31/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

@interface PIUtility : NSObject

+ (BOOL) isKey:(id)key equalToExpectedKey:(NSString *)expectedKey;
+ (BOOL) isValue:(id)value equalToExpectedValueType:(Class)valueClass;

@end
