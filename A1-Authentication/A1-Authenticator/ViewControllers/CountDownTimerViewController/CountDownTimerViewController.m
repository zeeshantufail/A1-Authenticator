//
//  CountDownTimerViewController.m
//  A1-Authenticator
//
//  Created by Waqar on 11/19/15.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import "CountDownTimerViewController.h"

@interface CountDownTimerViewController ()

@end

@implementation CountDownTimerViewController

@synthesize secondsLeft;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self startLockScreenAnimation];
    
    secondsLeft = 300;
    [self startCountdownTimer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)updateCounter
{
    if(secondsLeft > 0 )
    {
        secondsLeft -- ;
        hours = secondsLeft / 3600;
        minutes = (secondsLeft % 3600) / 60;
        seconds = (secondsLeft %3600) % 60;
        self.timerLabel.text = [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
    }
    else
    {
        [timer invalidate];
        seconds = 0;
        minutes = 0;

        NSString* timeNow = [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
        self.timerLabel.text= timeNow;
    }
}

-(void)startCountdownTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter) userInfo:nil repeats:YES];
}

-(void)startLockScreenAnimation
{
    self.lockImageView.image = [UIImage imageNamed:@"Locked Animation_0025.png"];
    
    NSMutableArray *animationArray = [[NSMutableArray alloc] init];
    
    for (int i=1 ; i<=25 ; i++)
    {
        [animationArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"Locked Animation_%.4d.png",i]]];
    }
    
    self.lockImageView.animationImages=animationArray;
    self.lockImageView.animationDuration= 0.8;
    self.lockImageView.animationRepeatCount = 1;
    [self.lockImageView startAnimating];
}

@end
