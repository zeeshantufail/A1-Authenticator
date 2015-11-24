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
{
    
    NSMutableArray *images;
}
@end

@implementation ResetAppViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    images = [NSMutableArray new];
    
    for (int c = 1; c < 32; c++) {
        [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"button_animation/%d", c]]];
    }
    
    [self addTapGesture];
}


-(void)viewDidAppear:(BOOL)animated{
    self.checkingBtnAnime.animationImages = images;
    self.checkingBtnAnime.animationDuration = 1.2;
    [self.checkingBtnAnime startAnimating];
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
