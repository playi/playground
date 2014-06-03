//
//  PIObject.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 3/28/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

/**
 Generic object class that is used to put any API specific logic that should be used by all API objects.
 */
@interface PIObject : NSObject

/**
 common setup method that child classes can override for initialize.  This method will be implicitly called by [self init].
 */
- (void) setup;

@end
