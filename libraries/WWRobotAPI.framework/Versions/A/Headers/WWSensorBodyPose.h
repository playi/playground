//
//  WWSensorBodyPose.h
//  APIObjectiveC
//


#import "WWSensor.h"

@interface WWSensorBodyPose : WWSensor

@property (nonatomic, readonly) double radians;
@property (nonatomic, readonly) double x;
@property (nonatomic, readonly) double y;

@end
