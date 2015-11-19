//
//  BeginViewController.m
//  A1-Authenticator
//
//  Created by Waqar on 11/3/15.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import "BeginViewController.h"
#import "VideoViewController.h"
#import "AppHelper.h"


@interface BeginViewController ()

@end

@implementation BeginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    VideoViewController *videoViewController = [[VideoViewController alloc] initWithNibName:@"VideoViewController" bundle:nil];
    [self addChildViewController:videoViewController];
    [self.videoView addSubview:videoViewController.view];
    
    //[self setViewsForCurrentDevice];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma Mark - Helper Methods

- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqual:data2];
}

//-(void)setViewsForCurrentDevice
//{
//    [self.headingTextView setHidden:YES];
//    [self.subHeadingTextView setHidden:YES];
//    
//    UITextView *h1, *h2;
//    
//    if ([AppHelper isIphone5])
//    {
//        h1 = [[UITextView alloc] initWithFrame:CGRectMake(45 , 84, 246, 62)];
//        h2 = [[UITextView alloc] initWithFrame:CGRectMake(45 , 145, 235, 71)];
//        
//        [h1 setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
//        [h2 setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:15]];
//    }
//    if ([AppHelper isIphone6])
//    {
//        h1 = [[UITextView alloc] initWithFrame:CGRectMake(55 , 84, 260, 68)];
//        h2 = [[UITextView alloc] initWithFrame:CGRectMake(55 , 154, 265, 84)];
//        
//        [h1 setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:21]];
//        [h2 setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
//    }
//    
//    h1.text = @"What authentication type would you like to use?";
//    h2.text = @"Authenticator from Access: One gives you a choice of two types of verification*:";
//    
//    h1.textAlignment   = h2.textAlignment   = NSTextAlignmentCenter;
//    h1.textColor       = h2.textColor       = [UIColor colorWithRed:0.184 green:0.184 blue:0.184 alpha:1];
//    h1.backgroundColor = h2.backgroundColor = [UIColor clearColor];
//    
//    [self.mainContainer addSubview:h1];
//    [self.mainContainer addSubview:h2];
//}

//-(void)viewDidLayoutSubviews
//{
//    CGRect frame;
//    
//    if ([AppHelper isIphone5])
//    {
//        frame.origin.x = 70;
//        frame.origin.y = 230;
//        frame.size = self.qryptoLoginBtn.frame.size;
//        self.qryptoLoginBtn.frame = frame;
//        
//        frame.origin.x = 50;
//        frame.origin.y = 310;
//        frame.size = self.oneTimePasscodeBtn.frame.size;
//        self.oneTimePasscodeBtn.frame = frame;
//    }
//}

#pragma Mark - actions

//- (IBAction)qryptoLoginBtnPressed:(id)sender
//{
//    if([self image:[sender backgroundImageForState:UIControlStateNormal] isEqualTo:[UIImage imageNamed:@"FTU_QR_Icon_ON.png"]])
//    {
//        [sender setBackgroundImage:[UIImage imageNamed:@"FTU_QR_Icon_OFF.png"] forState:UIControlStateNormal];
//    }
//    else
//    {
//        [self.oneTimePasscodeBtn setBackgroundImage:[UIImage imageNamed:@"FTU_TOTP_Icon_OFF.png"] forState:UIControlStateNormal];
//        [sender setBackgroundImage:[UIImage imageNamed:@"FTU_QR_Icon_ON.png"] forState:UIControlStateNormal];
//        
//        CameraOverlayViewController *cameraOverlayViewController = [[CameraOverlayViewController alloc] init];
//        cameraOverlayViewController.scanType = @"QRypto";
//        [self presentViewController:cameraOverlayViewController animated:YES completion:nil];
//    }
//}
//
//- (IBAction)oneTimePasscodeBtnPressed:(id)sender
//{
//    if([self image:[sender backgroundImageForState:UIControlStateNormal] isEqualTo:[UIImage imageNamed:@"FTU_TOTP_Icon_ON.png"]])
//    {
//        [sender setBackgroundImage:[UIImage imageNamed:@"FTU_TOTP_Icon_OFF.png"] forState:UIControlStateNormal];
//    }
//    else
//    {
//        [self.qryptoLoginBtn setBackgroundImage:[UIImage imageNamed:@"FTU_QR_Icon_OFF.png"] forState:UIControlStateNormal];
//        [sender setBackgroundImage:[UIImage imageNamed:@"FTU_TOTP_Icon_ON.png"] forState:UIControlStateNormal];
//        
//        CameraOverlayViewController *cameraOverlayViewController = [[CameraOverlayViewController alloc] init];
//        cameraOverlayViewController.scanType = @"OneTime";
//        [self presentViewController:cameraOverlayViewController animated:YES completion:nil];
//    }
//}



#pragma Mark - Seague delegates

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"qryptoNavId"] || [[segue identifier] isEqualToString:@"totpNavId"])
    {
        //[[segue destinationViewController] setDelegate:self];
        UINavigationController *nav = (UINavigationController *)[segue destinationViewController];
        QRCodeScanViewController *qrview = (QRCodeScanViewController *)[nav topViewController];
        qrview.delegate = self;
    }
}


-(void)didScanResult:(QRCodeScanViewController *)result
{
    NSLog(@"Qr result : %@", result);
    
    if ([AppHelper isDeviceTouchIDSetup])
    {
        [self performSegueWithIdentifier: @"showThankyouId" sender: self];
    }
    else
    {
        [self performSegueWithIdentifier: @"showThankyouPin" sender: self];
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)didDismissQrScan:(QRCodeScanViewController *)qrCodeScanViewController{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)authenticationFailed:(QRCodeScanViewController *)qrCodeScanViewController
{
    NSLog(@"Authentication failed !");
}

@end
