//
//  ThankYouViewController.h
//  A1-Authenticator
//
//  Created by Waqar on 11/5/15.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThankYouViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView * upperColorImageView;
@property (weak, nonatomic) IBOutlet UIImageView * profileImageView;
@property (weak, nonatomic) IBOutlet UILabel     * nameLbl;
@property (weak, nonatomic) IBOutlet UILabel     * designationLbl;
@property (weak, nonatomic) IBOutlet UITextView  * pairedTitle;
@property (weak, nonatomic) IBOutlet UITextView  * questionTextView;
@property (weak, nonatomic) IBOutlet UIButton    * touchIDBtn;
@property (weak, nonatomic) IBOutlet UIButton    * securePINBtn;

@property (weak, nonatomic) IBOutlet UITextView  * detail1TextView;
@property (weak, nonatomic) IBOutlet UITextView  * detail2TextView;
@property (weak, nonatomic) IBOutlet UIView *pinButtonContainer;
@property (weak, nonatomic) IBOutlet UIView *thankyouLowerContentView;

@property (weak, nonatomic) IBOutlet UIView      * textsContainerView;


- (IBAction)touchIDBtnPressed:(id)sender;
//- (IBAction)securePINBtnPressed:(id)sender;


@end
