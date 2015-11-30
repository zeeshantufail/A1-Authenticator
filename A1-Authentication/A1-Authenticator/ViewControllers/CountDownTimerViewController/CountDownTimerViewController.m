//
//  CountDownTimerViewController.m
//  A1-Authenticator
//
//  Created by Waqar on 11/19/15.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import "CountDownTimerViewController.h"
#import "PasscodeHelper.h"
#import "AppSettings.h"
#import "AppHelper.h"
#import "ResetAppViewController.h"

@interface CountDownTimerViewController ()
{
}

@end

@implementation CountDownTimerViewController

@synthesize secondsLeft;

double timerCount = -1;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self startLockScreenAnimation];

    secondsLeft = 0;
    timerCount = [[AppSettings sharedAppSettings] lockScreenTimerCount];
    NSLog(@"%f %f %f", [[NSDate date] timeIntervalSince1970], timerCount, [[AppSettings sharedAppSettings] lockScreenTimerCount]);
    secondsLeft = timerCount - [[NSDate date] timeIntervalSince1970];
    [self updateCounter];
    [self startCountdownTimer];
    
    [self updateCounter];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)updateCounter
{
    if(secondsLeft > 0 )
    {
        secondsLeft = timerCount - [[NSDate date] timeIntervalSince1970];
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
        
        [self dismissLockScreen];
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

-(void)dismissLockScreen{
    
    if ([[AppSettings sharedAppSettings] passCodeFailCount] >= 9) {
        [self resetApp];
        return;
    }
    
    if ([AppHelper shouldChellangeAuthentication]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)resetApp
{
    [[AppSettings sharedAppSettings] resetApplication];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSelector:@selector(exitApp) withObject:nil afterDelay:0.5];
}

-(void)exitApp
{
    exit(0);
}

@end
