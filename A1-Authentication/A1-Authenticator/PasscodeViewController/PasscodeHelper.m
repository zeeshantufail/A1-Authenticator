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

@implementation MessageContent

@end

@implementation PasscodeScreenState

@end

@implementation PasscodeHelper
{
    id screenState[6][3];
}

-(void)loadContent{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecameActive) name:@"ApplicationDidBecameActive" object:nil];
    
    self.passcodeScreenState = [[PasscodeScreenState alloc] init];
    
    MessageContent * mc = [[MessageContent alloc] init];
    //Set your pin from welcome screen
    mc.headerText = @"Set your PIN";
    mc.subHeaderText = @"Please enter a 4 digit PIN";
    mc.errorText = @"";
    
    screenState[0][0] = mc;
    
    mc = [[MessageContent alloc] init];
    //Set your pin 2nd screen from welcome screen
    mc.headerText = @"Set your PIN";
    mc.subHeaderText = @"Please confirm your PIN";
    mc.errorText = @"PIN did not match";
    
    screenState[0][1] = mc;
    
    mc = [[MessageContent alloc] init];
    //Enter your pin
    mc.headerText = @"Enter your PIN";
    mc.subHeaderText = @"Please enter a 4 digit PIN";
    mc.errorText = @"Wrong pin entered";
    
    screenState[1][0] = mc;
    
    mc = [[MessageContent alloc] init];
    //Set your pin from settings screen
    mc.headerText = @"Set your PIN";
    mc.subHeaderText = @"Please enter a 4 digit PIN";
    mc.errorText = @"";
    
    screenState[2][0] = mc;
    
    mc = [[MessageContent alloc] init];
    //Set your pin from settings screen
    mc.headerText = @"Set your PIN";
    mc.subHeaderText = @"Please enter a 4 digit PIN";
    mc.errorText = @"";
    
    screenState[2][1] = mc;
    
    mc = [[MessageContent alloc] init];
    //Set your pin confirm from settings screen
    mc.headerText = @"Set your PIN";
    mc.subHeaderText = @"Please confirm your PIN";
    mc.errorText = @"";
    
    screenState[3][0] = mc;
    
    mc = [[MessageContent alloc] init];
    //Change your pin from settings screen
    mc.headerText = @"Enter your old PIN";
    mc.subHeaderText = @"Please enter a 4 digit PIN";
    mc.errorText = @"";
    
    screenState[3][1] = mc;
    
    mc = [[MessageContent alloc] init];
    //Change your pin from settings screen
    mc.headerText = @"Set your new PIN";
    mc.subHeaderText = @"Please enter a 4 digit PIN";
    mc.errorText = @"";
    
    screenState[3][2] = mc;
    
    mc = [[MessageContent alloc] init];
    //Change your pin from settings screen
    mc.headerText = @"Touch ID";
    mc.subHeaderText = @"Please confirm your Touch ID";
    mc.errorText = @"";
    
    screenState[4][0] = mc;
    
    mc = [[MessageContent alloc] init];
    //Change your pin from settings screen
    mc.headerText = @"Touch ID";
    mc.subHeaderText = @"Please authenticate your Touch ID";
    mc.errorText = @"";
    
    screenState[5][0] = mc;
    
    
}

-(void)authenticationCanceled{
    
    switch (self.passcodeScreenState.screenType) {
        case 0:
            
            [_keyboardViewController.navigationController popViewControllerAnimated:YES];

            break;
            
        case 1:
            
            break;
            
        case 2:
            
            break;
            
        case 3:
            
            break;
        case 4:
            
            [_keyboardViewController.view removeFromSuperview];
            [_keyboardViewController removeFromParentViewController];
            break;
            
        default:
            break;
    }
}

-(BOOL)passcodeDismissOnSuccess:(NSString *)passcode{
    if (self.passCode.length > 0 && [self.passCode isEqualToString:passcode]) {
        self.passcodeScreenState.dismiss = true;
        [_keyboardViewController runPositiveAnime];
        [self performSelector:@selector(updatePINScreen:) withObject:_keyboardViewController afterDelay:0.7];
        
        
        //                    [[AppSettings sharedAppSettings] setAppPin:passcode]; //todo
        return YES;
    }
    else{
        return NO;
    }
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
                    [self performSelector:@selector(updatePINScreen:) withObject:_keyboardViewController afterDelay:0.7];
                }
            }
            break;
            
            
        case 1:
            if(![self passcodeDismissOnSuccess:passcode])
            {
                self.passcodeScreenState.screenNumber = 0;
                [_keyboardViewController runNegativeAnime];
                [_keyboardViewController.errorLabel setHidden:NO];
                [self performSelector:@selector(updatePINScreen:) withObject:_keyboardViewController afterDelay:0.7];
            }
            break;
            
        case 2:
            if (self.passcodeScreenState.screenNumber == 0) {
                if( [[AppSettings sharedAppSettings] checkPin:passcode] )
                {
                    self.passcodeScreenState.screenNumber = 1;
                    [_keyboardViewController runPositiveAnime];
                    [self performSelector:@selector(updatePINScreen:) withObject:_keyboardViewController afterDelay:0.7];
                }
                
            }
            else if(self.passcodeScreenState.screenNumber == 1){
                self.passCode = passcode;
                self.passcodeScreenState.screenNumber = 2;
                [_keyboardViewController runPositiveAnime];
                
                [self performSelector:@selector(updatePINScreen:) withObject:_keyboardViewController afterDelay:0.7];
            }
            
            else{
                if(![self passcodeDismissOnSuccess:passcode])
                {
                    self.passcodeScreenState.screenNumber = 1;
                    [_keyboardViewController runNegativeAnime];
                    [_keyboardViewController.errorLabel setHidden:NO];
                    [self performSelector:@selector(updatePINScreen:) withObject:_keyboardViewController afterDelay:0.7];
                }
            }
            break;
            
        case 3:
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
                    [self performSelector:@selector(updatePINScreen:) withObject:_keyboardViewController afterDelay:0.7];
                }
            }
            break;
            
            break;
        default:
            break;
    }
}

-(void)touchIDScanned{
    self.passcodeScreenState.dismiss = true;
    [self updatePINScreen:_keyboardViewController];
}

-(void)updatePINScreen:(KeyboardViewController *)keyBoardController{
    _keyboardViewController = keyBoardController;
    if (self.passcodeScreenState.dismiss) {
        switch (self.passcodeScreenState.screenType) {
            case 0:
                if (self.passcodeScreenState.screenNumber == 1) {
                    [keyBoardController performSegueWithIdentifier: @"homeViewSegue" sender: self];
                }
                break;
            case 1:
                
                break;
            case 2:
                break;
            case 3:
                break;
            case 4:
                [keyBoardController performSegueWithIdentifier: @"homeViewSegue" sender: self];
                break;
            default:
                break;
        }
    }
    
    MessageContent *mc = screenState[self.passcodeScreenState.screenType][self.passcodeScreenState.screenNumber];
    
    keyBoardController.headerLabel.text = mc.headerText;
    keyBoardController.subHeaderLabel.text = mc.subHeaderText;
    keyBoardController.errorLabel.text = mc.errorText;
    [keyBoardController.errorLabel setHidden:YES];
    [keyBoardController clearAlldata];
    
    
    if (self.passcodeScreenState.screenType == 4 && self.passcodeScreenState.screenNumber == 0) {
        [[keyBoardController keyPadView] setHidden:YES];
        self.passcodeScreenState.screenNumber = 1;
        TouchIDAuthentication * tia = [[TouchIDAuthentication alloc] init];
        [tia setUpAuthenticationWithMessageString:@"Place your finger on home button to scan for Touch ID" andFallbackTitle:@""];
        tia.delegate = self;
        
    }
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
            
        default:
            break;
    }
}
@end
