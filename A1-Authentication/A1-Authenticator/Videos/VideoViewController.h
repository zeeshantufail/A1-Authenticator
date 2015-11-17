//
//  VideoViewController.h
//  A1-Authenticator
//
//  Created by Waqar on 11/3/15.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXBlurView.h"
#import <MediaPlayer/MPMoviePlayerController.h>
#import "VideoPlayerViewController.h"

@interface VideoViewController : UIViewController

@property (retain, nonatomic) MPMoviePlayerController *player;

//@property (retain, nonatomic) VideoPlayerViewController *landPlayer;
//@property (retain, nonatomic) VideoPlayerViewController *portPlayer;

-(void)playMovie;

@property (retain, nonatomic) IBOutlet UIView *video_PlayerView;

+(VideoPlayerViewController* )landPlayer;
+(VideoPlayerViewController* )portPlayer;

@end
