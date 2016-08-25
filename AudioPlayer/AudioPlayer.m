//
//  AudioPlayer.m
//  Share
//
//  Created by Lin Zhang on 11-4-26.
//  Copyright 2011年 www.eoemobile.com. All rights reserved.
//

#import "AudioPlayer.h"
#import "AudioButton.h"
#import "AudioStreamer.h"

@implementation AudioPlayer {
    NSTimer *timer;
}

- (BOOL)isProcessing
{
    return [_streamer isPlaying] || [_streamer isWaiting] || [_streamer isFinishing] ;
}

- (void)play
{        
    if (!_streamer) {
        
        self.streamer = [[AudioStreamer alloc] initWithURL:[NSURL URLWithString:self.url]];
        
        // set up display updater
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                    [self methodSignatureForSelector:@selector(updateProgress)]];    
        [invocation setSelector:@selector(updateProgress)];
        [invocation setTarget:self];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                             invocation:invocation 
                                                repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
        // register the streamer on notification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playbackStateChanged:)
                                                     name:ASStatusChangedNotification
                                                   object:_streamer];
    }
    
    if ([_streamer isPlaying]) {
        [_streamer pause];
    } else {
        [_streamer start];
    }
}

- (void)playWithURL:(NSString *)aURL {
    if (!_streamer) {
        
        self.streamer = [[AudioStreamer alloc] init];
        
        // set up display updater
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                    [self methodSignatureForSelector:@selector(updateProgress)]];
        [invocation setSelector:@selector(updateProgress)];
        [invocation setTarget:self];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                             invocation:invocation
                                                repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
        // register the streamer on notification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playbackStateChanged:)
                                                     name:ASStatusChangedNotification
                                                   object:_streamer];
    }
    
    if ([_streamer isPlaying]) {
        [_streamer pause];
    } else {
        _streamer.url = [NSURL URLWithString:aURL];
        [_streamer start];
    }
}

- (void)stop
{    
    [_button setProgress:0];
    [_button stopSpin];

    _button.image = [UIImage imageNamed:playImage];
    _button = nil; // 避免播放器的闪烁问题
    
    // release streamer
	if (_streamer)
	{        
		[_streamer stop];
		_streamer = nil;
        
        // remove notification observer for streamer
		[[NSNotificationCenter defaultCenter] removeObserver:self 
                                                        name:ASStatusChangedNotification
                                                      object:_streamer];
	}
}

- (void)updateProgress
{
    if (_streamer.progress <= _streamer.duration ) {
        [_button setProgress:_streamer.progress/_streamer.duration];
    } else {
        [_button setProgress:0.0f];
    }
}


/*
 *  observe the notification listener when loading an audio
 */
- (void)playbackStateChanged:(NSNotification *)notification
{
	if ([_streamer isWaiting])
	{
        _button.image = [UIImage imageNamed:stopImage];
        [_button startSpin];
    } else if ([_streamer isIdle]) {
        _button.image = [UIImage imageNamed:playImage];
		[self stop];		
	} else if ([_streamer isPaused]) {
        _button.image = [UIImage imageNamed:playImage];
        [_button stopSpin];
        [_button setColourR:0.0 G:0.0 B:0.0 A:0.0];
    } else if ([_streamer isPlaying] || [_streamer isFinishing]) {
        _button.image = [UIImage imageNamed:stopImage];
        [_button stopSpin];
	} else {
        
    }
    
    [_button setNeedsLayout];
    [_button setNeedsDisplay];
}


@end
