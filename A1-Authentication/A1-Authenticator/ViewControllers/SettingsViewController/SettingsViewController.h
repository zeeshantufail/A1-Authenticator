//
//  SettingsViewController.h
//  A1-Authenticator
//
//  Created by Waqar on 11/9/15.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRCodeScanViewController.h"
#import "GravatarLoader.h"

@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, QRCodeScanDelegate, GravatarLoaderDelegate>

@property (weak, nonatomic) IBOutlet UIImageView * profileImageView;
@property (weak, nonatomic) IBOutlet UILabel     * nameLabel;
@property (weak, nonatomic) IBOutlet UILabel     * designationLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)touchIdAction:(id)sender;
- (IBAction)activateOtp:(id)sender;
- (IBAction)activateQR:(id)sender;

@end
