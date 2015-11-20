//
//  ResetAppViewController.m
//  A1-Authenticator
//
//  Created by Waqar on 11/9/15.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import "ResetAppViewController.h"
#import "SWRevealViewController.h"
#import "AppSettings.h"

@interface ResetAppViewController ()

@end

@implementation ResetAppViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    
    [self addTapGesture];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)addTapGesture
{
    SWRevealViewController *revealController = [self revealViewController];
    UITapGestureRecognizer *tap = [revealController tapGestureRecognizer];
    
    [self.view addGestureRecognizer:tap];
}

- (IBAction)settingsBtnPressed:(id)sender
{
    [self.revealViewController revealToggle:sender];
}

- (IBAction)resetButtonAction:(id)sender
{
    [[AppSettings sharedAppSettings] resetApplication];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSelector:@selector(exitApp) withObject:nil afterDelay:0.5];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    if (buttonIndex == 1) {
    //        [[AppSettings sharedAppSettings] resetApplication];
    //        [[NSUserDefaults standardUserDefaults] synchronize];
    //        [self performSelector:@selector(exitApp) withObject:nil afterDelay:0.5];
    //    }
}

-(void)exitApp
{
    exit(0);
}

@end
