//
//  SGPlayViewController.m
//  demo-ios
//
//  Created by Single on 2017/3/15.
//  Copyright © 2017年 single. All rights reserved.
//

#import "SGPlayViewController.h"

@interface SGPlayViewController ()

@property (nonatomic, assign) BOOL seeking;
@property (nonatomic, strong) SGPlayer *player;

@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UISlider *progressSilder;

@end

@implementation SGPlayViewController {
    UIActivityIndicatorView *activityIndicator;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.player = [[SGPlayer alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoChanged:) name:SGPlayerDidChangeInfoNotification object:self.player];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __weak SGPlayViewController * weakSelf = self;
    self.player.readyHandler = ^(SGPlayer * _Nonnull player) {
        [weakSelf prepareDone:player];
    };
    self.stateLabel.text = @"Preparing";
    
    self.player.videoRenderer.view = self.view;
    self.player.videoRenderer.displayMode = self.videoItem.displayMode;
    [self.player replaceWithAsset:self.videoItem.asset];
    [self.player play];
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [activityIndicator setCenter:self.view.center];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.player stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    NSLog(@"Memory NOT ENOUGH!!!");
}

#pragma mark - SGPlayer Notifications

- (void)infoChanged:(NSNotification *)notification
{
    SGTimeInfo time = [SGPlayer timeInfoFromUserInfo:notification.userInfo];
    SGStateInfo state = [SGPlayer stateInfoFromUserInfo:notification.userInfo];
    SGInfoAction action = [SGPlayer infoActionFromUserInfo:notification.userInfo];
    if (action & SGInfoActionTime) {
        if (action & SGInfoActionTimePlayback && !(state.playback & SGPlaybackStateSeeking) && !self.seeking && !self.progressSilder.isTracking) {
            self.progressSilder.value = CMTimeGetSeconds(time.playback) / CMTimeGetSeconds(time.duration);
            self.currentTimeLabel.text = [self timeStringFromSeconds:CMTimeGetSeconds(time.playback)];
        }
        if (action & SGInfoActionTimeDuration) {
            self.durationLabel.text = [self timeStringFromSeconds:CMTimeGetSeconds(time.duration)];
        }
    }
    
    if (state.loading & SGLoadingStateStalled) {
        [activityIndicator startAnimating];
    }
    
    if (action & SGInfoActionState && state.player & SGPlayerStateReady) {
        if (state.playback & SGPlaybackStateFinished) {
            self.stateLabel.text = @"Finished";
        } else if (state.playback & SGPlaybackStatePlaying) {
            self.stateLabel.text = @"Playing";
            [activityIndicator stopAnimating];
        } else {
            self.stateLabel.text = @"Paused";
        }
    }
    
    NSLog(@"Action: %@; State: %@", [self stringOfAction: action], [self stringOfState: state]);
}

#pragma Utils

- (NSString *)stringOfAction: (SGInfoAction)action {
    NSDictionary *stateStrings = @{
       @(SGInfoActionNone) : @"SGInfoActionNone",
       @(SGInfoActionTime) : @"SGInfoActionTime",
       @(SGInfoActionTimeCached) : @"SGInfoActionTimeCached",
       @(SGInfoActionStatePlayer) : @"SGInfoActionStatePlayer",
       @(SGInfoActionStateLoading) : @"SGInfoActionStateLoading",
       @(SGInfoActionTimeDuration) : @"SGInfoActionTimeDuration",
       @(SGInfoActionTimePlayback) : @"SGInfoActionTimePlayback",
      };
    return [stateStrings objectForKey:@(action)] ? : @"Unknown";
}

- (NSString *)stringOfState: (SGStateInfo)state {
    NSDictionary *stateStrings = @{
     @(SGPlayerStateNone) : @"SGPlayerStateNone",
     @(SGPlayerStateReady) : @"SGPlayerStateReady",
     @(SGPlayerStateFailed) : @"SGPlayerStateFailed",
     @(SGPlayerStatePreparing) : @"SGPlayerStatePreparing",
    };
    
    NSString *player = [stateStrings objectForKey:@(state.player)] ? : @"Unknown";
    
    stateStrings = @{
     @(SGLoadingStateNone) : @"SGLoadingStateNone",
     @(SGLoadingStateStalled) : @"SGLoadingStateStalled",
     @(SGLoadingStateFinished) : @"SGLoadingStateFinished",
     @(SGLoadingStatePlaybale) : @"SGLoadingStatePlaybale",
    };
    
    NSString *loading = [stateStrings objectForKey:@(state.loading)] ? : @"Unknown";
    
    stateStrings = @{
     @(SGPlaybackStateNone) : @"SGPlaybackStateNone",
     @(SGPlaybackStatePlaying) : @"SGPlaybackStatePlaying",
     @(SGPlaybackStateSeeking) : @"SGPlaybackStateSeeking",
     @(SGPlaybackStateFinished) : @"SGPlaybackStateFinished",
    };
    
    NSString *playBack = [stateStrings objectForKey:@(state.playback)] ? : @"Unknown";
    
    return [NSString stringWithFormat:@"%@/%@/%@", player, loading, playBack];
}

#pragma mark - Actions

- (void)prepareDone:(SGPlayer *)player
{
    // Becasuse this method will be call by background thread,
    // so UI updating must be used by main thread block.
    // self.stateLabel.text = @"Ready";
    
    NSLog(@"ready for play");
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)play:(id)sender
{
    [self.player play];
}

- (IBAction)pause:(id)sender
{
    [self.player pause];
}

- (IBAction)progressTouchUp:(id)sender
{
    CMTime time = CMTimeMultiplyByFloat64(self.player.currentItem.duration, self.progressSilder.value);
    if (!CMTIME_IS_NUMERIC(time)) {
        time = kCMTimeZero;
    }
    self.seeking = YES;
    [self.player seekToTime:time result:^(CMTime time, NSError *error) {
        self.seeking = NO;
    }];
}

#pragma mark - Tools

- (NSString *)timeStringFromSeconds:(CGFloat)seconds
{
    return [NSString stringWithFormat:@"%ld:%.2ld", (long)seconds / 60, (long)seconds % 60];
}

@end
