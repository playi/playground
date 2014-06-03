//
//  PIEvent+Distance.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 5/8/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

#import "PIEvent.h"

@interface PIEvent (Distance)

+ (PIEvent *) moveUntilDistance:(PICentimeter)distance;
+ (PIEvent *) detectObjectInFront;
+ (PIEvent *) detectObjectInBack;
+ (PIEvent *) detectObjectContact;

@end
