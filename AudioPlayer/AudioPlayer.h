//
//  AudioPlayer.h
//  Share
//
//  Created by Lin Zhang on 11-4-26.
//  Copyright 2011年 www.eoemobile.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AudioButton;
@class AudioStreamer;

@interface AudioPlayer : NSObject

@property (nonatomic, strong) AudioStreamer *streamer;
@property (nonatomic, strong) AudioButton *button;
@property (nonatomic, copy) NSString *url;

- (void)play;
- (void)playWithURL:(NSString *)aURL;
- (void)stop;
- (BOOL)isProcessing;

@end
