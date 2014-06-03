//
//  PIComponentSpeaker.h
//  APIObjectiveC
//
//  Created by Kevin Liang on 3/31/14.
//  Copyright (c) 2014 play-i. All rights reserved.
//

#import "PIComponent.h"

@interface PIComponentSpeaker : PIComponent

@property (nonatomic) PIVolume volume;
@property (nonatomic) PISoundTrackIndex soundTrack;
@property (nonatomic) PIUInteger loops;

- (id) initWithSoundTrack:(PISoundTrackIndex)soundTrack volume:(PIUInteger)volume loops:(PIUInteger)loops;
- (id) initWithSoundTrack:(PISoundTrackIndex)soundTrack volume:(PIUInteger)volume;
- (id) initWithSoundTrack:(PISoundTrackIndex)soundTrack;

@end
