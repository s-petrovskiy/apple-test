#pragma once

#import <AVFoundation/AVFoundation.h>
#import <AppKit/AppKit.h>
#import <CoreMedia/CoreMedia.h>

@interface MyPlayer : NSObject
{
    AVPlayer* videoPlayer;
    NSView* videoView;
}

- (id)init:(NSView*)view;
- (void)resize:(NSRect)rect;
- (void)play:(const char*)path;

@end
