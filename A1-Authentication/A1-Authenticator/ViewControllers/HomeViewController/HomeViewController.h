//
//  HomeViewController.h
//  A1-Authenticator
//
//  Created by Waqar on 11/9/15.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRCodeScanViewController.h"
#import "TimerViewController.h"
#import "GravatarLoader.h"

@interface HomeViewController : UIViewController<QRCodeScanDelegate, GravatarLoaderDelegate>

@property (weak, nonatomic) IBOutlet UIImageView * upperColorImageView;
@property (weak, nonatomic) IBOutlet UIImageView * profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView * messageImageView;
@property (weak, nonatomic) IBOutlet UIButton    * messageBtn;
@property (weak, nonatomic) IBOutlet UIButton    * settingsBtn;
@property (weak, nonatomic) IBOutlet UILabel     * nameLbl;
@property (weak, nonatomic) IBOutlet UILabel     * designationLabel;
@property (weak, nonatomic) IBOutlet UIView *homeContentView;

- (IBAction)messageBtnPressed:(id)sender;
- (IBAction)settingsBtnPressed:(id)sender;

@end
