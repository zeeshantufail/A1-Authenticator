//
//  HomeViewController.h
//  A1-Authenticator
//
//  Created by Waqar on 11/9/15.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView * upperColorImageView;
@property (weak, nonatomic) IBOutlet UIImageView * profileImageView;
@property (weak, nonatomic) IBOutlet UIButton    * settingsBtn;
@property (weak, nonatomic) IBOutlet UILabel     * nameLbl;
@property (weak, nonatomic) IBOutlet UILabel     * designationLabel;

- (IBAction)settingsBtnPressed:(id)sender;

@end
