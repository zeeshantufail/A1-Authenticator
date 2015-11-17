//
//  BeginViewController.h
//  A1-Authenticator
//
//  Created by Waqar on 11/3/15.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRCodeScanViewController.h"

@interface BeginViewController : UIViewController <QRCodeScanDelegate>

@property (weak, nonatomic) IBOutlet UIView     * videoView;
@property (weak, nonatomic) IBOutlet UIView     * mainContainer;
@property (weak, nonatomic) IBOutlet UITextView * headingTextView;
@property (weak, nonatomic) IBOutlet UITextView * subHeadingTextView;
@property (weak, nonatomic) IBOutlet UIButton   * qryptoLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton   * oneTimePasscodeBtn;

@end
