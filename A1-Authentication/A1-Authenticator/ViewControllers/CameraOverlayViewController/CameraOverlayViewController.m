//
//  CameraOverlayViewController.m
//  A1-Authenticator
//
//  Created by Waqar on 11/4/15.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import "CameraOverlayViewController.h"



#import "ThankYouViewController.h"
#import "NotificationViewController.h"
#import "AppHelper.h"


@interface CameraOverlayViewController ()

@end

@implementation CameraOverlayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleAndScanType];
    
    
}

-(void) setTitleAndScanType
{
    if ([self.scanType isEqualToString:@"OneTime"])
    {
        self.scanTypeTitleLabel.text = @"Passcode Set-Up";
    }
    else
    {
        [self.qrDoesntScanBtn setHidden:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)crossBtnPressed:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[AppHelper getStoryboardName] bundle:nil];
    NotificationViewController *notificationViewController = [storyboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
    [self presentViewController:notificationViewController animated:YES completion:nil];
    
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ThankYouViewController *thankYouViewController = [storyboard instantiateViewControllerWithIdentifier:@"ThankYouViewController"];
//    [self presentViewController:thankYouViewController animated:YES completion:nil];
    
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)crossBtnTouchDown:(id)sender
{
    [sender setBackgroundImage:[UIImage imageNamed:@"X_OFF@2x.png"] forState:UIControlStateNormal];
}

@end
