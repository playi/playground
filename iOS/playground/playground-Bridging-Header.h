//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import <Foundation/Foundation.h>
#import <WWRobotAPI/WWRobotAPI.h>

#import "RobotListTableViewCell.h"
#import "JoystickView.h"

@interface WWRobotManager (shared)
+ (WWRobotManager*) sharedManager;
@end
