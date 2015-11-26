//
//  PasscodeHelper.m
//  A1-Authenticator
//
//  Created by Zeeshan Tufail on 12/11/2015.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import "PasscodeHelper.h"
#import "KeyboardViewController.h"
#import "AppSettings.h"
#import "AppHelper.h"
#import "ThankYouViewController.h"

@implementation MessageContent

@end

@implementation PasscodeScreenState

@end

@implementation PasscodeHelper
{
    id screenState[6][4];
}

-(void)loadContent{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecameActive) name:@"ApplicationDidBecameActive" object:nil];
    
    self.passcodeScreenState = [[PasscodeScreenState alloc] init];
    
    /*
     Loading pin messages
     0: Set your pin from welcome screen
     1: Enter your pin
     2: Set your pin from setting screen
     3: Change your pin
     4: Set Touch ID
     5: Enter Touch ID
     */
    
    MessageContent * mc = [[MessageContent alloc] init];
    //Set your pin from welcome screen
    mc.headerText = @"Set your PIN";
    mc.subHeaderText = @"Please enter a 4 digit PIN";
    mc.errorText = @"";
    
    screenState[0][0] = mc;
    
    mc = [[MessageContent alloc] init];
    //Set your pin 2nd screen from welcome screen
    mc.headerText = @"Set your PIN";
    mc.subHeaderText = @"Confirm your 4 digit PIN";
    mc.errorText = @"PINs don't match, please try again.";
    
    screenState[0][1] = mc;
    
    mc = [[MessageContent alloc] init];
    //Enter your pin
    mc.headerText = @"Hi Jhon";
    mc.subHeaderText = @"Please enter your PIN";
    mc.errorText = @"Pin not recognized, please try again";
    
    screenState[1][0] = mc;
    
    mc = [[MessageContent alloc] init];
    //Set your pin from settings screen
    mc.headerText = @"Set your PIN";
    mc.subHeaderText = @"Please enter a 4 digit PIN";
    mc.errorText = @"";
    
    screenState[2][0] = mc;
    
    mc = [[MessageContent alloc] init];
    //Set your pin confirm from settings screen
    mc.headerText = @"Set your PIN";
    mc.subHeaderText = @"Please confirm your PIN";
    mc.errorText = @"PINs don't match, please try again.";
    
    screenState[2][1] = mc;
    
    mc = [[MessageContent alloc] init];
    //Change your pin from settings screen
    mc.headerText = @"Enter your old PIN";
    mc.subHeaderText = @"Please enter a 4 digit PIN";
    mc.errorText = @"Wrong Pin entered";
    screenState[3][0] = mc;
    
    mc = [[MessageContent alloc] init];
    //Change your pin from settings screen
    mc.headerText = @"Enter your new PIN";
    mc.subHeaderText = @"Please enter a 4 digit PIN";
    mc.errorText = @"New PIN cannot be same";
    
    screenState[3][1] = mc;
    
    mc = [[MessageContent alloc] init];
    //Change your pin from settings screen
    mc.headerText = @"Confirm your new PIN";
    mc.subHeaderText = @"Enter your 4 digit PIN again";
    mc.errorText = @"PINs don't match, please try again.";
    
    screenState[3][2] = mc;
    
    mc = [[MessageContent alloc] init];
    //Set Touch ID from welcome screen
    mc.headerText = @"Touch ID";
    mc.subHeaderText = @"Please confirm your Touch ID";
    mc.errorText = @"";
    
    screenState[4][0] = mc;
    
    mc = [[MessageContent alloc] init];
    //Authenticate with Touch ID
    mc.headerText = @"Hi John";
    mc.subHeaderText = @"Please authenticate your Touch ID";
    mc.errorText = @"";
    
    screenState[5][0] = mc; //first screen with touch alert
    screenState[5][3] = mc; //first screen without touch alert
    
    
}

-(void)authenticationCanceled{
    
    switch (self.passcodeScreenState.screenType) {
        case 0:
            
            [_keyboardViewController.navigationController popViewControllerAnimated:YES];

            break;
            
        case 1:
            break;
            
        case 2:
            [_keyboardViewController.revealViewController revealToggle:nil];
            break;
            
        case 3:
            [_keyboardViewController.revealViewController revealToggle:nil];
            break;
        case 4:
            
            [((ThankYouViewController *)(_keyboardViewController.parentViewController)).thankyouLowerContentView setHidden:NO];
            [_keyboardViewController.view removeFromSuperview];
            [_keyboardViewController removeFromParentViewController];
            break;
        case 5:
            break;
            
        default:
            break;
    }
    
    [self resetPinScreen];
}

-(BOOL)passcodeDismissOnSuccess:(NSString *)passcode{
    if (self.passCode.length > 0 && [self.passCode isEqualToString:passcode]) {
        self.passcodeScreenState.dismiss = true;
        [_keyboardViewController runPositiveAnime];
        [self performSelector:@selector(updatePINScreen:) withObject:_keyboardViewController afterDelay:0.7];
        [[AppSettings sharedAppSettings] setAppPin:passcode];
        return YES;
    }
    else{
        return NO;
    }
}

-(void)authenticationFailed{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"wrongPasscodeEntered" object:_keyboardViewController];
}
-(void)authenticationWasSuccessfull{
    [[AppSettings sharedAppSettings] setPassCodeFailCount:0];
    [AppHelper setShouldChellangeAuthentication:NO];
}

-(void)passcodeEntered:(NSString *)passcode{
    switch (self.passcodeScreenState.screenType) {
        case 0:
            if (self.passcodeScreenState.screenNumber == 0) {
                self.passCode = passcode;
                self.passcodeScreenState.screenNumber = 1;
                [_keyboardViewController runPositiveAnime];
                
                [self performSelector:@selector(updatePINScreen:) withObject:_keyboardViewController afterDelay:0.7];
            }
            else{
                if(![self passcodeDismissOnSuccess:passcode])
                {
                    self.passcodeScreenState.screenNumber = 0;
                    [_keyboardViewController runNegativeAnime];
                    [_keyboardViewController.errorLabel setHidden:NO];
                    [self performSelector:@selector(updatePINScreen:) withObject:_keyboardViewController afterDelay:1];
                }
            }
            break;
            
            
        case 1:
            if([[AppSettings sharedAppSettings] checkPin:passcode] )
            {
                self.passcodeScreenState.dismiss = true;
                [_keyboardViewController runPositiveAnime];
                [self performSelector:@selector(updatePINScreen:) withObject:_keyboardViewController afterDelay:0.7];
                [self authenticationWasSuccessfull];
            }
            else{
                self.passcodeScreenState.screenNumber = 0;
                [_keyboardViewController runNegativeAnime];
                [_keyboardViewController.errorLabel setHidden:NO];
                [self performSelector:@selector(updatePINScreen:) withObject:_keyboardViewController afterDelay:1];
                [self performSelector:@selector(authenticationFailed) withObject:nil afterDelay:0.7];
            }
            break;
            
        case 2:
            if (self.passcodeScreenState.screenNumber == 0) {
                self.passCode = passcode;
                self.passcodeScreenState.screenNumber = 1;
                [_keyboardViewController runPositiveAnime];
                
                [self performSelector:@selector(updatePINScreen:) withObject:_keyboardViewController afterDelay:0.7];
            }
            else{
                if(![self passcodeDismissOnSuccess:passcode])
                {
                    self.passcodeScreenState.screenNumber = 0;
                    [_keyboardViewController runNegativeAnime];
                    [_keyboardViewController.errorLabel setHidden:NO];
                    [self performSelector:@selector(updatePINScreen:) withObject:_keyboardViewController afterDelay:1];
                }
            }
            break;
            
        case 3:
            
            if (self.passcodeScreenState.screenNumber == 0 ) {
                if ( [[AppSettings sharedAppSettings] checkPin:passcode]) {
                    
                    self.passcodeScreenState.screenNumber = 1;
                    [_keyboardViewController runPositiveAnime];
                    [self performSelector:@selector(updatePINScreen:) withObject:_keyboardViewController afterDelay:0.7];
                    [self authenticationWasSuccessfull];
                }
                else{
                    
                    self.passcodeScreenState.screenNumber = 0;
                    [_keyboardViewController runNegativeAnime];
                    [_keyboardViewController.errorLabel setHidden:NO];
                    [self performSelector:@selector(updatePINScreen:) withObject:_keyboardViewController afterDelay:1];
                    [self performSelector:@selector(authenticationFailed) withObject:nil afterDelay:0.7];
                }
                
            }
            else if(self.passcodeScreenState.screenNumber == 1){
                if ([[AppSettings sharedAppSettings] checkPin:passcode]) {
                    [_keyboardViewController runNegativeAnime];
                    [_keyboardViewController.errorLabel setHidden:NO];
                    [self performSelector:@selector(updatePINScreen:) withObject:_keyboardViewController afterDelay:1];
                }
                else
                {
                self.passCode = passcode;
                    self.passcodeScreenState.screenNumber = 2;
                    [_keyboardViewController runPositiveAnime];
                    
                    [self performSelector:@selector(updatePINScreen:) withObject:_keyboardViewController afterDelay:0.7];
                }
            }
            
            else{
                if(![self passcodeDismissOnSuccess:passcode])
                {
                    self.passcodeScreenState.screenNumber = 1;
                    [_keyboardViewController runNegativeAnime];
                    [_keyboardViewController.errorLabel setHidden:NO];
                    [self performSelector:@selector(updatePINScreen:) withObject:_keyboardViewController afterDelay:1];
                }
            }
            
            break;
        default:
            break;
    }
}

-(void)touchIDScanned{
    self.passcodeScreenState.dismiss = true;
    [self updatePINScreen:_keyboardViewController];
}

-(void)resetPinScreen{
    if (self.passcodeScreenState.screenType != 4 && self.passcodeScreenState.screenType != 5) {
        self.passcodeScreenState.screenNumber = 0;
        self.passcodeScreenState.dismiss = false;
        [_keyboardViewController.buttonCancel setHidden:NO];
        [_keyboardViewController.settingsBtnOutlet setUserInteractionEnabled:YES];
        [self updatePINScreen:_keyboardViewController];
    }
}

-(void)updatePINScreen:(KeyboardViewController *)keyBoardController{
    _keyboardViewController = keyBoardController;
    if (self.passcodeScreenState.dismiss) {
        switch (self.passcodeScreenState.screenType) {
            case 0:
                [keyBoardController performSegueWithIdentifier: @"homeViewSegue" sender: self];
                [[AppSettings sharedAppSettings] setAppPinCreated:YES];
                [[AppSettings sharedAppSettings] setAppPinState:YES];
                [[AppSettings sharedAppSettings] setAppTouchID:NO];
                self.passcodeScreenState.screenType = -1;
                break;
            case 1:
//                [_keyboardViewController.navigationController dismissViewControllerAnimated:YES completion:nil];
                [_keyboardViewController.navigationController dismissViewControllerAnimated:YES completion:nil];
                break;
            case 2:
                [self authenticationCanceled]; //dismiss view on success
                [[AppSettings sharedAppSettings] setAppPinCreated:YES];
                [[AppSettings sharedAppSettings] setAppPinState:YES];
                [_keyboardViewController.view setUserInteractionEnabled:NO];
                [[AppSettings sharedAppSettings] setAppTouchID:NO];
                break;
            case 3:
                [self authenticationCanceled];// dissmiss view on success
                break;
            case 4:
                [keyBoardController performSegueWithIdentifier: @"homeViewSegue" sender: self];
                [[AppSettings sharedAppSettings] setAppPinState:NO];
                [[AppSettings sharedAppSettings] setAppTouchID:YES];
                self.passcodeScreenState.screenType = -1;
                break;
            case 5:
                [_keyboardViewController dismissViewControllerAnimated:YES completion:nil];
//                [[[_keyboardViewController presentingViewController] navigationController] dismissViewControllerAnimated:YES completion:nil];
                break;
            default:
                break;
        }
        
        
        if (self.passcodeScreenState.screenType != -1) {//unused object
            [self resetPinScreen];
        }
        
        return;
    }
    
    
    if (self.passcodeScreenState.screenType != 4) {
        
        MessageContent *mc = screenState[self.passcodeScreenState.screenType][self.passcodeScreenState.screenNumber];
        
        keyBoardController.headerLabel.text = mc.headerText;
        keyBoardController.subHeaderLabel.text = mc.subHeaderText;
        keyBoardController.errorLabel.text = mc.errorText;
        [keyBoardController.errorLabel setHidden:YES];
        [keyBoardController clearAlldata];
        
    }
    
    if (self.passcodeScreenState.screenType >= 4) {
        [self hideKeyboard];
    }
    
    if (self.passcodeScreenState.screenType == 4 && self.passcodeScreenState.screenNumber == 0) {
        self.passcodeScreenState.screenNumber = 1;
        TouchIDAuthentication * tia = [[TouchIDAuthentication alloc] init];
        [tia setUpAuthenticationWithMessageString:@"Place your finger on home button to confirm for Touch ID" andFallbackTitle:@""];
        tia.delegate = self;
        
    }
    else if (self.passcodeScreenState.screenType == 5 && self.passcodeScreenState.screenNumber == 0) {
        self.passcodeScreenState.screenNumber = 1;
        TouchIDAuthentication * tia = [[TouchIDAuthentication alloc] init];
        [tia setUpAuthenticationWithMessageString:@"Place your finger on home button to authenticate for Touch ID" andFallbackTitle:@""];
        tia.delegate = self;
        
    }
    else if(self.passcodeScreenState.screenType == 1){
        [_keyboardViewController.buttonCancel setHidden:YES];
        [_keyboardViewController.settingsBtnOutlet setUserInteractionEnabled:NO];
    }
    
    switch (self.passcodeScreenState.screenType) {
        case 1:
        case 0:
            [_keyboardViewController.settingsBtnOutlet setHidden:YES];
            break;
            
        default:
            break;
    }
}

-(void)hideKeyboard{
    _keyboardViewController.keyPadView.hidden = YES;
    _keyboardViewController.deleteButtonOutlet.hidden = YES;
    _keyboardViewController.buttonCancel.hidden = YES;
}

-(void)touchIDErrorUserCancel:(TouchIDAuthentication *)touchID{
//    [self authenticationCanceled];
    self.passcodeScreenState.screenNumber = 2;
}

-(void)touchIDErrorSystemCancel:(TouchIDAuthentication *)touchID{
    //    [self authenticationCanceled];
    self.passcodeScreenState.screenNumber = 0;
}

-(void)touchIDSuccess:(TouchIDAuthentication *)touchID{
    //[self performSelector:@selector(touchIDScanned) withObject:nil afterDelay:1];
//    [self touchIDScanned];
    self.passcodeScreenState.dismiss = true;
}

-(void)setWrongPinEnteredCount:(int)count{
    
}

-(void)applicationDidBecameActive{
    
    if (self.passcodeScreenState.dismiss) {
        [self updatePINScreen:_keyboardViewController];
        return;
    }
    
    switch (self.passcodeScreenState.screenType) {
        case 4:
            if (self.passcodeScreenState.screenNumber != 2) {
                [self updatePINScreen:_keyboardViewController];
            }
            else
            {
                [self authenticationCanceled];
            }
            break;
        case 5:
            if (self.passcodeScreenState.screenNumber == 2) {
                [self authenticationCanceled];
            }
            else{
                self.passcodeScreenState.screenNumber = 0;
                [self updatePINScreen:_keyboardViewController];
            }
            
            break;
            
        default:
            break;
    }
}
@end
