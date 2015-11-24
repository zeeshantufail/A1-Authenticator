//
//  QRCodeScanViewController.h
//  A1-Authenticator
//
//  Created by Zeeshan Tufail on 04/11/2015.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ScanCodeHelper.h"
#import "AuthenticateUser.h"

@class QRCodeScanViewController;
@protocol QRCodeScanDelegate <NSObject>

-(void)authenticationFailed:(QRCodeScanViewController *)qrCodeScanViewController;
-(void)authenticationCompleted:(QRCodeScanViewController*)qrCodeScanViewController;

@optional

-(void)didScanResult:(QRCodeScanViewController *)qrCodeScanViewController;
-(void)didDismissQrScan:(QRCodeScanViewController *)qrCodeScanViewController;

@end

@interface QRCodeScanViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate, ScanCodeHelperProtocol, AuthenticateUserDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbitemStart;

@property (weak, nonatomic) IBOutlet UIImageView *scanView;
@property (nonatomic) id<QRCodeScanDelegate> delegate;

@property BOOL isTotp;

- (IBAction)startStopReading:(id)sender;
- (IBAction)crossButtonAction:(id)sender;


@end
