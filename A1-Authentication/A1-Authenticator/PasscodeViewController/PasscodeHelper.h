//
//  PasscodeHelper.h
//  A1-Authenticator
//
//  Created by Zeeshan Tufail on 12/11/2015.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchIDAuthentication.h"

@interface PasscodeScreenState : NSObject

@property (nonatomic) int screenType;
@property (nonatomic) int screenNumber;
@property BOOL dismiss;
@property (nonatomic) BOOL error;


@end

@interface MessageContent : NSObject
@property (nonatomic) NSString *headerText;
@property (nonatomic) NSString *subHeaderText;
@property (nonatomic) NSString *errorText;
@end

@class KeyboardViewController;
@interface PasscodeHelper : NSObject<TouchIDAuthenticationDelegate>
{
    KeyboardViewController * _keyboardViewController;
}

@property (nonatomic) PasscodeScreenState * passcodeScreenState;
@property (nonatomic) NSString *passCode;

-(void)passcodeEntered:(NSString *)passcode;
-(void)loadContent;
-(int)wrongPinEnteredCount;
-(void)setWrongPinEnteredCount:(int)count;
-(void)resetWrongPinEnteredCount;
-(void)updatePINScreen:(KeyboardViewController *)keyBoardController;
-(void)authenticationCanceled;
@end
