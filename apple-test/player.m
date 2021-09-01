#include "player.h"

@implementation MyPlayer

- (MyPlayer*)init:(NSView*)view
{
    self = [super init];
    if (self != nil)
    {
        videoPlayer = nil;
        
        videoView = [[NSView alloc] init];
        
        [videoView setWantsLayer:YES];
        //[videoView.layer setBackgroundColor:[[NSColor clearColor] CGColor]];
        [videoView setFrame:[view bounds]];
        
        [view addSubview:videoView];
    }
    return self;
}

- (void)dealloc
{
    [videoView removeFromSuperview];
    videoView = nil;
    videoPlayer = nil;
}

- (void)play:(const char*)path
{
    videoPlayer = [[AVPlayer alloc] init];
    
    NSURL* url = [NSURL fileURLWithPath:[NSString stringWithCString:path encoding:NSASCIIStringEncoding]];

    NSString * mimeType = @"video/mp4";
    AVURLAsset * asset = [[AVURLAsset alloc] initWithURL:url options:@{@"AVURLAssetOutOfBandMIMETypeKey": mimeType}];
    NSArray* assetKeysToLoadAndTest = [NSArray arrayWithObjects:@"playable", @"tracks", @"duration", nil];
    [asset loadValuesAsynchronouslyForKeys:assetKeysToLoadAndTest
                         completionHandler:^(void) {
                             dispatch_async(dispatch_get_main_queue(), ^(void) {
                                 [self onAssetLoaded:asset withKeys:assetKeysToLoadAndTest];
                             });
                         }];
}

- (void)onAssetLoaded:(AVAsset*)asset withKeys:(NSArray*)keys
{
    for (NSString* key in keys)
    {
        NSError* error = nil;
        if ([asset statusOfValueForKey:key error:&error] == AVKeyValueStatusFailed)
        {
            @throw[NSException exceptionWithName:@"Movie loading failed" reason:@"Unable to load keys" userInfo:nil];
        }
    }
    if (![asset isPlayable] || [asset hasProtectedContent])
    {
        @throw[NSException exceptionWithName:@"Movie loading failed" reason:@"Not playable" userInfo:nil];
    }
    if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] == 0)
    {
        @throw[NSException exceptionWithName:@"Movie loading failed" reason:@"Not a video" userInfo:nil];
    }

    AVPlayerLayer* newPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:videoPlayer];

    [newPlayerLayer setAutoresizingMask:kCALayerWidthSizable | kCALayerHeightSizable];
    [newPlayerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [newPlayerLayer setFrame:[videoView bounds]];
    
    [videoView.layer addSublayer:newPlayerLayer];
    
    AVPlayerItem* playerItem = [AVPlayerItem playerItemWithAsset:asset];
    
    [videoPlayer replaceCurrentItemWithPlayerItem:playerItem];
    [videoPlayer play];
}

- (void)resize:(NSRect)rect
{
    [videoView setFrame:rect];
}

@end
