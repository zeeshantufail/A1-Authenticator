//
//  KeyboardViewController.h
//  Mobile IAM
//
//  Created by Zeeshan Tufail on 20/02/2015.
//  Copyright (c) 2015 Intagleo Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"


@protocol KeyboardViewControllerDelegate <NSObject>

-(void)pinEntered:(NSString *)pin;
-(void)pinCanceled;

@end

@class PasscodeHelper, VideoViewController;
@interface KeyboardViewController : UIViewController
{
    UIImageView *buttonBackgroundImageView;
    IBOutlet UIImageView *dotsView;
}

@property (weak, nonatomic) IBOutlet UIButton *settingsBtnOutlet;
@property (nonatomic) PasscodeHelper * passcodeHelper;
@property (weak, nonatomic) IBOutlet UITextView *errorLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UITextView *subHeaderLabel;
@property (nonatomic) id<KeyboardViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *videoViewContainer;
@property (weak, nonatomic) IBOutlet UIView *mainContainerView;

@property (retain, nonatomic) IBOutlet UIView *keyPadView;
@property (retain, nonatomic) IBOutlet UIButton *deleteButtonOutlet;
@property (retain, nonatomic) IBOutlet UIView *keypadAndCirclesContainer;
- (IBAction)buttonCancelAction:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *buttonCancel;
@property (nonatomic) VideoViewController *videoViewController;
- (IBAction)settingBtnPressed:(id)sender;

- (IBAction)keyPressed:(id)sender;
- (IBAction)buttonTouchDown:(id)sender;
- (IBAction)deletePressed:(id)sender;
-(void)runPositiveAnime;
-(void)runNegativeAnime;
- (void)clearAlldata;
@end
