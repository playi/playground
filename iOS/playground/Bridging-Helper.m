//
//  Bridging-Helper.m
//  playground
//
//  Created by Jelle Alten on 09-11-16.
//  Copyright © 2016 Wonder Workshop. All rights reserved.
//

#import <WWRobotAPI/WWRobotAPI.h>

@implementation WWRobotManager (shared)
+ (WWRobotManager*) sharedManager {
    return [WWRobotManager manager];
}
@end
