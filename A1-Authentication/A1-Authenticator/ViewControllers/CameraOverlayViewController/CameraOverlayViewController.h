//
//  CameraOverlayViewController.h
//  A1-Authenticator
//
//  Created by Waqar on 11/4/15.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraOverlayViewController : UIViewController

@property (strong, nonatomic) NSString          * scanType;
@property (weak, nonatomic) IBOutlet UIView     * mainContainerView;
@property (weak, nonatomic) IBOutlet UILabel    * scanTypeTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton   * crossBtn;

@property (weak, nonatomic) IBOutlet UIButton   * qrDoesntScanBtn;


- (IBAction)crossBtnPressed:(id)sender;
- (IBAction)crossBtnTouchDown:(id)sender;

@end
