//
//  SetPinViewController.h
//  A1-Authenticator
//
//  Created by Zeeshan Tufail on 12/11/2015.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardViewController.h"

@interface SetPinViewController : UIViewController<KeyboardViewControllerDelegate>

@property (nonatomic) KeyboardViewController * keyboardViewController;

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *keypadView;

@end
