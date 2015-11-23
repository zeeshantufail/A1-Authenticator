//
//  CountDownTimerViewController.h
//  A1-Authenticator
//
//  Created by Waqar on 11/19/15.
//  Copyright © 2015 Pirean LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardViewController.h"

@interface CountDownTimerViewController : UIViewController
{
    NSTimer *timer;
    int hours, minutes, seconds;
}

@property (assign,nonatomic) int                    secondsLeft;
@property (weak, nonatomic)  IBOutlet UIImageView * lockImageView;
@property (weak, nonatomic)  IBOutlet UILabel     * timerLabel;
@property (nonatomic) KeyboardViewController *keyboardViewController;
@property BOOL shouldChellangeAuthentication;

@end
