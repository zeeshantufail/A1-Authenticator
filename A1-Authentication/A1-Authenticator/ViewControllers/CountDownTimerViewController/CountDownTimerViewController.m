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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self startLockScreenAnimation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
