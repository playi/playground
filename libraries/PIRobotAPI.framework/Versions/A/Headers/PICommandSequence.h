//
//  PICommandSequence.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 3/31/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

#import "PIEventDataSource.h"

extern NSString *const gDataPayloadKey;
extern NSString *const gDurationKey;
extern NSString *const gComponentsKey;

@class PICommand, PICommandSequenceFrame;

@interface PICommandSequence : PIEventDataSource

+ (PICommandSequence *) sequenceFromFile:(NSString *)fileName;
+ (PICommandSequence *) sequenceFromFileInBundle:(NSString *)relativeName fileType:(NSString *)type;

- (BOOL) parseData:(NSDictionary *)data;
- (void) addCommand:(PICommand *)command withDuration:(double)duration;
- (void) addFrame:(PICommandSequenceFrame *)frame;
- (PICommandSequenceFrame *) frameAtIndex:(NSUInteger)index;
- (void) removeFrameAtIndex:(NSUInteger)index;
- (NSArray *) frames;
- (NSUInteger)count;
- (double) duration;

@end
