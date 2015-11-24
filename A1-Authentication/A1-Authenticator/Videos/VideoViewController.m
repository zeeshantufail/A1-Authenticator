//
//  VideoViewController.m
//  A1-Authenticator
//
//  Created by Waqar on 11/3/15.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import "VideoViewController.h"
#import <MediaPlayer/MPMoviePlayerController.h>
//#import "TouchIDAuthentication.h"
#import "VideoPlayerViewController.h"

@interface VideoViewController ()
{
    UIDeviceOrientation prevOrientation;
    
    NSTimeInterval playerTime;
}
@end

static VideoPlayerViewController *landPlayer;
static VideoPlayerViewController *portPlayer;

@implementation VideoViewController
@synthesize player;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationBecameActive) name:@"applicationBecameActive" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationResignActive) name:@"applicationResignActive" object:nil];
   
    playerTime = 0.0;
    NSURL *url;
    
    if (!landPlayer)
    {
        url = [[NSBundle mainBundle] URLForResource:@"BKG_320x568" withExtension:@"m4v"];
        
        VideoPlayerViewController *player2 = [[VideoPlayerViewController alloc] init];
        player2.URL = url;
  
        [self.video_PlayerView addSubview:player2.view];
        landPlayer = player2;
        
    }
    else{
        [landPlayer.view removeFromSuperview];
        [self.video_PlayerView addSubview:landPlayer.view];
        [landPlayer.player play];

    }
    if(!portPlayer)
    {
        url = [[NSBundle mainBundle] URLForResource:@"BKG_320x568" withExtension:@"m4v"];
        
        VideoPlayerViewController *player3 = [[VideoPlayerViewController alloc] init];
        player3.URL = url;
        //player3.view.frame = CGRectMake(0, 0, 768, 1024);
        [self.video_PlayerView addSubview:player3.view];
        portPlayer = player3;
    }
    else{
        [portPlayer.view removeFromSuperview];
        [self.video_PlayerView addSubview:portPlayer.view];
        [portPlayer.player play];
    }
    
    landPlayer.view.frame = [[UIScreen mainScreen] bounds];
    portPlayer.view.frame = [[UIScreen mainScreen] bounds];
    
    //By W
//    [UIView animateWithDuration:0.3 delay:1 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
//        [self.pireanBlueLayout setAlpha:0];
//    } completion:nil
//     ];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    // By W
//    if([TouchIDAuthentication touchIDStatus] == 0)
//    {
//        [self setVideoLayout];
//        [self viewWillLayoutSubviews];
    //    }
    [portPlayer.player play];
    [landPlayer.player play];
}

-(void)viewDidAppear:(BOOL)animated{
}


- (void)setVideoLayout{
    return;
    //UIView *pireanBlue = [self.view viewWithTag:30];
    //[pireanBlue setAlpha:1];
    [UIView animateWithDuration: 0.0
                          delay: 0.0
                        options: UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionBeginFromCurrentState
                     animations: ^{
                         
                         //self.pireanBlueLayout.alpha = 1; // By W
                         self.video_PlayerView.alpha = 0;
                     }
                     completion: ^(BOOL finished){
                         
                     }];
    if (player) {
        playerTime = player.currentPlaybackTime;
    }
    [player.view removeFromSuperview];//[[UIDevice currentDevice] orientation];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playBackGroundVideo) object:nil];
    [self performSelector:@selector(playBackGroundVideo) withObject:nil afterDelay:0.5];
    
}

-(void)viewWillLayoutSubviews
{
    //[self deviceOrientationDidChange];
    //UIImageView *gradientImage = (UIImageView *)[self.view viewWithTag:50];
    //gradientImage.frame = self.view.frame;
//    landPlayer.view.frame = self.view.frame;
//    portPlayer.view.frame = self.view.frame;
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchVideo) object:nil];
//    [self performSelector:@selector(switchVideo) withObject:nil afterDelay:0];
    
}

-(void)switchVideo
{
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
    {
        [landPlayer.view setHidden:NO];
        [portPlayer.view setHidden:YES];
        //[gradientImage setImage:[UIImage imageNamed:@"Video_gradient_landscape.png"]];
    }
    else
    {
        [portPlayer.view setHidden:NO];
        [landPlayer.view setHidden:YES];
        //[gradientImage setImage:[UIImage imageNamed:@"Video_gradient_portrait.png"]];
    }
}

-(void)playBackGroundVideo
{
    // NSTimeInterval time = player.currentPlaybackTime;
    
    //    if (UIInterfaceOrientationIsLandscape(prevOrientation) == UIInterfaceOrientationIsLandscape(self.interfaceOrientation) && player) {
    //        return;
    //    }
    
//    prevOrientation =  self.interfaceOrientation;
//    NSBundle *bundle = [NSBundle mainBundle];
//    NSString *moviePath;
    UIImageView *gradientImage = (UIImageView *)[self.view viewWithTag:50];
    
    gradientImage.alpha = 0;
    
    
//    if(UIInterfaceOrientationIsLandscape(prevOrientation))
//    {
//        moviePath = [bundle pathForResource:@"1024x768" ofType:@"mp4"];
//        [gradientImage setImage:[UIImage imageNamed:@"Video_gradient_landscape.png"]];
//    }
//    else
//    {
//        moviePath = [bundle pathForResource:@"768x1024" ofType:@"mp4"];
//        [gradientImage setImage:[UIImage imageNamed:@"Video_gradient_portrait.png"]];
//    }
//    
//    
//    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
//
//    player = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
//    
//    if(UIInterfaceOrientationIsLandscape(prevOrientation))
//    {
//        player.view.frame = CGRectMake(0, 0, 1024, 786);
//        gradientImage.frame = CGRectMake(0, 0, 1024, 1024);
//    }
//    else
//    {
//        player.view.frame = CGRectMake(0, 0, 786, 1024);
//        //gradientImage.frame = CGRectMake(0, 0, 768, 1024); // By W
//    }
//    
    //self.pireanBlueLayout.frame = gradientImage.frame; //By W
    
    player.controlStyle = MPMovieControlStyleNone;
    player.scalingMode = MPMovieScalingModeAspectFill;
    [player setInitialPlaybackTime:playerTime];
  
    [self.video_PlayerView addSubview:player.view];
    
    //[player play];
    [player prepareToPlay];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(movieForcePlay) object:nil];
    [self performSelector:@selector(movieForcePlay) withObject:nil afterDelay:0.5];
    //[self loadVideo];
    //[self performSelector:@selector(blurVideo) withObject:nil afterDelay:0.3];
}

-(void)movieForcePlay
{
    //UIView *gradientView = [self.view viewWithTag:50]; // By W
    
    if(player.playbackState != MPMoviePlaybackStatePlaying)
    {
        if([player isPreparedToPlay])
        {
            [player play];
        }
        else{
            [player prepareToPlay];
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(movieForcePlay) object:nil];
            [self performSelector:@selector(movieForcePlay) withObject:nil afterDelay:0.5];
            //self.pireanBlueLayout.alpha = 1; // By W
            return;
        }
        //[player pause];
    }
    
    
//By W
//    [UIView animateWithDuration:0 animations:^(void){
//        player.view.alpha = 1;
//        gradientView.alpha = 1;
//        
//    } completion:^(BOOL finished){
//        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidePireanBlueLayer) object:nil];
//        [self performSelector:@selector(hidePireanBlueLayer) withObject:nil afterDelay:0];
//        
//    }];
    
}

//By W
//-(void)hidePireanBlueLayer
//{
//    
//    if (![player isPreparedToPlay]) {
//        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hidePireanBlueLayer) object:nil];
//        [self performSelector:@selector(hidePireanBlueLayer) withObject:nil afterDelay:0.5];
//        return;
//    }
//    
//    self.videoPlayerView.alpha = 1;
//    //UIView *pireanBlue = [self.view viewWithTag:30];
//    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
//        [self.pireanBlueLayout setAlpha:0];
//    } completion:nil
//     ];
//}

-(void)playMovie
{
    if(player.playbackState != MPMoviePlaybackStatePlaying)
    {
        //        [player play];
        
        [player performSelector:@selector(play) withObject:nil afterDelay:0.5];
        //[TouchIDAuthentication setTouchIDStatus:0]; By W
    }
}
-(void)playbackFinished:(MPMoviePlayerController*) p
{
    if(player.currentPlaybackTime > 0)
    {
        player.currentPlaybackTime = 0;
        //player prepare
        [player play];
    }
    //[player performSelector:@selector(play) withObject:nil afterDelay:0.3];
}

-(void)applicationBecameActive
{
    //player.currentPlaybackTime = playerTime;
//    [player setCurrentPlaybackTime:playerTime];
        [portPlayer.player play];
    [landPlayer.player play];
    //    NSLog(@"playback time on active %f, %f", player.currentPlaybackTime, playerTime);
}

-(void)applicationResignActive
{
    playerTime = player.currentPlaybackTime;
        [player pause];
    //    NSLog(@"playback time on resign %f player time %f", player.currentPlaybackTime, playerTime);
}

//-(void)deviceOrientationDidChange
//{
//    //self.view.frame = [[UIScreen mainScreen] bounds];
//    self.view.frame = self.parentViewController.view.frame;
//    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
//    
//    if(prevOrientation != orientation && orientation <= 4)
//    {
//        //prevOrientation = orientation;
//        [self setVideoLayout];
//    }
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+(VideoPlayerViewController* )landPlayer{
    return landPlayer;
}

+(VideoPlayerViewController* )portPlayer{
    return portPlayer;
}

@end
